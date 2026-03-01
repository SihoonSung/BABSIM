from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel, EmailStr
from typing import Literal
import uuid

from app.database import get_db
from app.models.user import User

router = APIRouter()


class UserCreate(BaseModel):
    email: EmailStr
    nickname: str
    cooking_level: Literal["beginner", "intermediate", "advanced"] = "beginner"


class UserResponse(BaseModel):
    id: uuid.UUID
    email: str
    nickname: str
    cooking_level: str

    class Config:
        from_attributes = True


@router.post("/", response_model=UserResponse, status_code=201)
def create_user(body: UserCreate, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.email == body.email).first()
    if existing:
        raise HTTPException(status_code=409, detail="email already registered")

    user = User(email=body.email, nickname=body.nickname, cooking_level=body.cooking_level)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@router.get("/{user_id}", response_model=UserResponse)
def get_user(user_id: uuid.UUID, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="user not found")
    return user
