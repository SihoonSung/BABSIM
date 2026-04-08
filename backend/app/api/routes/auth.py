import uuid
import os
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel, EmailStr, Field
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.user import User
from app.services.auth import (
    create_access_token,
    create_password_reset_token,
    decode_access_token,
    decode_password_reset_token,
    hash_password,
    hash_plain_token,
    verify_apple_id_token,
    verify_google_id_token,
    verify_password,
)

router = APIRouter()
bearer_scheme = HTTPBearer(auto_error=False)


def _normalize_email(email: str) -> str:
    return email.strip().lower()


def _ensure_gmail_email(email: str) -> str:
    normalized = _normalize_email(email)
    if not normalized.endswith("@gmail.com"):
        raise HTTPException(status_code=400, detail="only gmail.com addresses are allowed")
    return normalized


class GoogleLoginRequest(BaseModel):
    id_token: str


class EmailPasswordLoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=1, max_length=128)


class SignUpRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)
    nickname: str = Field(min_length=2, max_length=30)


class ForgotPasswordRequest(BaseModel):
    email: EmailStr


class ResetPasswordRequest(BaseModel):
    token: str = Field(min_length=20)
    new_password: str = Field(min_length=8, max_length=128)


class AuthUserResponse(BaseModel):
    id: uuid.UUID
    email: str
    nickname: str
    cooking_level: str
    auth_provider: str
    avatar_url: str | None = None

    class Config:
        from_attributes = True


class GoogleLoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: AuthUserResponse


class ForgotPasswordResponse(BaseModel):
    message: str
    reset_token: str | None = None


def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> User:
    if not credentials or credentials.scheme.lower() != "bearer":
        raise HTTPException(status_code=401, detail="missing bearer token")

    token = credentials.credentials
    try:
        payload = decode_access_token(token)
    except Exception:
        raise HTTPException(status_code=401, detail="invalid access token")

    subject = payload.get("sub")
    if not subject:
        raise HTTPException(status_code=401, detail="invalid access token payload")

    try:
        user_id = uuid.UUID(subject)
    except ValueError:
        raise HTTPException(status_code=401, detail="invalid access token subject")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=401, detail="user not found")

    return user


@router.post("/google", response_model=GoogleLoginResponse)
def google_login(body: GoogleLoginRequest, db: Session = Depends(get_db)):
    try:
        token_info = verify_google_id_token(body.id_token)
    except Exception as exc:
        raise HTTPException(status_code=401, detail=f"invalid google token: {exc}")

    google_sub = token_info.get("sub")
    email = token_info.get("email")
    name = token_info.get("name")
    picture = token_info.get("picture")

    if not google_sub or not email:
        raise HTTPException(status_code=400, detail="google token missing required claims")

    email = _ensure_gmail_email(email)

    user = (
        db.query(User)
        .filter(User.auth_provider == "google", User.provider_user_id == google_sub)
        .first()
    )

    if not user:
        user_by_email = db.query(User).filter(User.email == email).first()

        if user_by_email:
            if user_by_email.provider_user_id and user_by_email.provider_user_id != google_sub:
                raise HTTPException(status_code=409, detail="email already linked to another social account")

            user = user_by_email
            user.auth_provider = "google"
            user.provider_user_id = google_sub
            if picture:
                user.avatar_url = picture
        else:
            nickname = name or email.split("@")[0]
            user = User(
                email=email,
                nickname=nickname,
                cooking_level="beginner",
                auth_provider="google",
                provider_user_id=google_sub,
                avatar_url=picture,
            )
            db.add(user)

        db.commit()
        db.refresh(user)

    access_token = create_access_token(str(user.id))

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user,
    }


@router.post("/apple", response_model=GoogleLoginResponse)
def apple_login(body: GoogleLoginRequest, db: Session = Depends(get_db)):
    try:
        token_info = verify_apple_id_token(body.id_token)
    except Exception as exc:
        raise HTTPException(status_code=401, detail=f"invalid apple token: {exc}")

    apple_sub = token_info.get("sub")
    email = token_info.get("email")

    if not apple_sub:
        raise HTTPException(status_code=400, detail="apple token missing sub claim")

    user = (
        db.query(User)
        .filter(User.auth_provider == "apple", User.provider_user_id == apple_sub)
        .first()
    )

    if not user:
        if email:
            email = _normalize_email(email)
            user_by_email = db.query(User).filter(User.email == email).first()
            if user_by_email:
                user = user_by_email
                user.auth_provider = "apple"
                user.provider_user_id = apple_sub
            else:
                user = User(
                    email=email,
                    nickname=email.split("@")[0],
                    cooking_level="beginner",
                    auth_provider="apple",
                    provider_user_id=apple_sub,
                )
                db.add(user)
        else:
            # Apple은 첫 로그인 이후 email을 안 줄 수 있음 — sub로만 식별
            raise HTTPException(status_code=400, detail="email not provided by Apple")

        db.commit()
        db.refresh(user)

    access_token = create_access_token(str(user.id))
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user,
    }


@router.post("/signup", response_model=GoogleLoginResponse)
def sign_up(body: SignUpRequest, db: Session = Depends(get_db)):
    email = _normalize_email(body.email)

    existing = db.query(User).filter(User.email == email).first()
    if existing:
        raise HTTPException(status_code=409, detail="email already exists")

    user = User(
        email=email,
        nickname=body.nickname,
        cooking_level="beginner",
        auth_provider="local",
        password_hash=hash_password(body.password),
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    access_token = create_access_token(str(user.id))
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user,
    }


@router.post("/login", response_model=GoogleLoginResponse)
def email_password_login(body: EmailPasswordLoginRequest, db: Session = Depends(get_db)):
    email = _normalize_email(body.email)

    user = db.query(User).filter(User.email == email).first()
    if not user or not user.password_hash:
        raise HTTPException(status_code=401, detail="invalid email or password")

    if not verify_password(body.password, user.password_hash):
        raise HTTPException(status_code=401, detail="invalid email or password")

    access_token = create_access_token(str(user.id))
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": user,
    }


@router.post("/forgot-password", response_model=ForgotPasswordResponse)
def forgot_password(body: ForgotPasswordRequest, db: Session = Depends(get_db)):
    email = _ensure_gmail_email(body.email)
    user = db.query(User).filter(User.email == email).first()

    reset_token: str | None = None
    if user and user.password_hash:
        token, expires_at = create_password_reset_token(str(user.id))
        user.reset_password_token_hash = hash_plain_token(token)
        user.reset_password_expires_at = expires_at
        db.commit()

        debug_return_token = os.getenv("AUTH_DEBUG_RETURN_RESET_TOKEN", "false").lower() == "true"
        if debug_return_token:
            reset_token = token

    return {
        "message": "If the email exists, a reset link has been sent.",
        "reset_token": reset_token,
    }


@router.post("/reset-password")
def reset_password(body: ResetPasswordRequest, db: Session = Depends(get_db)):
    try:
        payload = decode_password_reset_token(body.token)
    except Exception:
        raise HTTPException(status_code=400, detail="invalid or expired reset token")

    subject = payload.get("sub")
    if not subject:
        raise HTTPException(status_code=400, detail="invalid reset token payload")

    try:
        user_id = uuid.UUID(subject)
    except ValueError:
        raise HTTPException(status_code=400, detail="invalid reset token subject")

    user = db.query(User).filter(User.id == user_id).first()
    if not user or not user.reset_password_token_hash:
        raise HTTPException(status_code=400, detail="invalid or expired reset token")

    now = datetime.now(timezone.utc)
    if (
        not user.reset_password_expires_at
        or user.reset_password_expires_at < now
        or user.reset_password_token_hash != hash_plain_token(body.token)
    ):
        raise HTTPException(status_code=400, detail="invalid or expired reset token")

    user.password_hash = hash_password(body.new_password)
    user.auth_provider = "local"
    user.reset_password_token_hash = None
    user.reset_password_expires_at = None
    db.commit()

    return {"message": "password updated"}


@router.get("/me", response_model=AuthUserResponse)
def get_me(current_user: User = Depends(get_current_user)):
    return current_user
