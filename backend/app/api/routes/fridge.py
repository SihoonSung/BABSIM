from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional
import uuid

from app.database import get_db
from app.models.fridge import FridgeItem
from app.models.ingredient import Ingredient

router = APIRouter()


class FridgeItemAdd(BaseModel):
    ingredient_id: int
    quantity: Optional[str] = None


class FridgeItemResponse(BaseModel):
    id: int
    ingredient_id: int
    ingredient_name_ko: str
    ingredient_category: str
    quantity: Optional[str]

    class Config:
        from_attributes = True


@router.get("/{user_id}", response_model=list[FridgeItemResponse])
def get_fridge(user_id: uuid.UUID, db: Session = Depends(get_db)):
    items = (
        db.query(FridgeItem, Ingredient)
        .join(Ingredient, FridgeItem.ingredient_id == Ingredient.id)
        .filter(FridgeItem.user_id == user_id)
        .all()
    )
    return [
        FridgeItemResponse(
            id=item.FridgeItem.id,
            ingredient_id=item.FridgeItem.ingredient_id,
            ingredient_name_ko=item.Ingredient.name_ko,
            ingredient_category=item.Ingredient.category,
            quantity=item.FridgeItem.quantity,
        )
        for item in items
    ]


@router.post("/{user_id}", status_code=201)
def add_fridge_item(user_id: uuid.UUID, body: FridgeItemAdd, db: Session = Depends(get_db)):
    ingredient = db.query(Ingredient).filter(Ingredient.id == body.ingredient_id).first()
    if not ingredient:
        raise HTTPException(status_code=404, detail="ingredient not found")

    existing = db.query(FridgeItem).filter(
        FridgeItem.user_id == user_id,
        FridgeItem.ingredient_id == body.ingredient_id,
    ).first()
    if existing:
        raise HTTPException(status_code=409, detail="ingredient already in fridge")

    item = FridgeItem(user_id=user_id, ingredient_id=body.ingredient_id, quantity=body.quantity)
    db.add(item)
    db.commit()
    db.refresh(item)
    return {"id": item.id}


@router.delete("/{user_id}/{item_id}", status_code=204)
def remove_fridge_item(user_id: uuid.UUID, item_id: int, db: Session = Depends(get_db)):
    item = db.query(FridgeItem).filter(
        FridgeItem.id == item_id,
        FridgeItem.user_id == user_id,
    ).first()
    if not item:
        raise HTTPException(status_code=404, detail="item not found")

    db.delete(item)
    db.commit()
