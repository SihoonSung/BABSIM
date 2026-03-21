import uuid

from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.user import User
from app.services.auth import create_access_token, decode_access_token, verify_google_id_token

router = APIRouter()
bearer_scheme = HTTPBearer(auto_error=False)


class GoogleLoginRequest(BaseModel):
    id_token: str


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


@router.get("/me", response_model=AuthUserResponse)
def get_me(current_user: User = Depends(get_current_user)):
    return current_user
