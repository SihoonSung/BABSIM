import os
import hashlib
from datetime import datetime, timedelta, timezone

from google.auth.transport import requests
from google.oauth2 import id_token
from jose import JWTError, jwt
from passlib.context import CryptContext


GOOGLE_ISSUERS = {"accounts.google.com", "https://accounts.google.com"}
RESET_TOKEN_PURPOSE = "password_reset"

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def _get_required_env(name: str) -> str:
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"Missing required environment variable: {name}")
    return value


def verify_google_id_token(token: str) -> dict:
    google_client_id = _get_required_env("GOOGLE_CLIENT_ID")

    token_info = id_token.verify_oauth2_token(
        token,
        requests.Request(),
        google_client_id,
    )

    if token_info.get("iss") not in GOOGLE_ISSUERS:
        raise ValueError("Invalid token issuer")

    if token_info.get("email_verified") is not True:
        raise ValueError("Google account email is not verified")

    return token_info


def create_access_token(subject: str) -> str:
    secret_key = _get_required_env("JWT_SECRET_KEY")
    algorithm = os.getenv("JWT_ALGORITHM", "HS256")
    expire_minutes = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))

    expires_at = datetime.now(timezone.utc) + timedelta(minutes=expire_minutes)
    payload = {
        "sub": subject,
        "exp": expires_at,
    }
    return jwt.encode(payload, secret_key, algorithm=algorithm)


def decode_access_token(token: str) -> dict:
    secret_key = _get_required_env("JWT_SECRET_KEY")
    algorithm = os.getenv("JWT_ALGORITHM", "HS256")
    try:
        return jwt.decode(token, secret_key, algorithms=[algorithm])
    except JWTError as exc:
        raise ValueError("Invalid access token") from exc


def hash_password(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(password: str, password_hash: str) -> bool:
    return pwd_context.verify(password, password_hash)


def hash_plain_token(token: str) -> str:
    return hashlib.sha256(token.encode("utf-8")).hexdigest()


def create_password_reset_token(subject: str) -> tuple[str, datetime]:
    secret_key = _get_required_env("JWT_SECRET_KEY")
    algorithm = os.getenv("JWT_ALGORITHM", "HS256")
    expire_minutes = int(os.getenv("PASSWORD_RESET_TOKEN_EXPIRE_MINUTES", "30"))

    expires_at = datetime.now(timezone.utc) + timedelta(minutes=expire_minutes)
    payload = {
        "sub": subject,
        "purpose": RESET_TOKEN_PURPOSE,
        "exp": expires_at,
    }
    return jwt.encode(payload, secret_key, algorithm=algorithm), expires_at


def decode_password_reset_token(token: str) -> dict:
    secret_key = _get_required_env("JWT_SECRET_KEY")
    algorithm = os.getenv("JWT_ALGORITHM", "HS256")
    try:
        payload = jwt.decode(token, secret_key, algorithms=[algorithm])
    except JWTError as exc:
        raise ValueError("Invalid reset token") from exc

    if payload.get("purpose") != RESET_TOKEN_PURPOSE:
        raise ValueError("Invalid reset token purpose")

    return payload
