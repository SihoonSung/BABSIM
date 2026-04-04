import uuid
from sqlalchemy import Column, String, DateTime, func
from sqlalchemy.dialects.postgresql import UUID

from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    email = Column(String, unique=True, nullable=False)
    nickname = Column(String, nullable=False)
    cooking_level = Column(String, nullable=False, default="beginner")
    auth_provider = Column(String, nullable=False, default="local")
    provider_user_id = Column(String, unique=True, nullable=True)
    avatar_url = Column(String, nullable=True)
    password_hash = Column(String, nullable=True)
    reset_password_token_hash = Column(String, nullable=True)
    reset_password_expires_at = Column(DateTime(timezone=True), nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
