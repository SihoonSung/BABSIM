from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional
import uuid

from app.database import get_db
from app.models.fridge import FridgeItem, UserFridge
from app.models.ingredient import Ingredient

router = APIRouter()


class FridgeItemAdd(BaseModel):
    ingredient_id: int
    fridge_id: Optional[int] = None
    quantity: Optional[str] = None
    storage_type: str = "refrigerated"
    days_until_expiry: Optional[int] = None
    expiry_reminder: bool = True


class FridgeItemManualAdd(BaseModel):
    name: str
    category: str
    fridge_id: Optional[int] = None
    quantity: Optional[str] = None
    storage_type: str = "refrigerated"
    days_until_expiry: Optional[int] = None
    expiry_reminder: bool = True


class FridgeItemUpdate(BaseModel):
    quantity: Optional[str] = None
    storage_type: Optional[str] = None
    days_until_expiry: Optional[int] = None
    expiry_reminder: Optional[bool] = None


class FridgeItemResponse(BaseModel):
    id: int
    fridge_id: Optional[int]
    fridge_name: Optional[str]
    ingredient_id: int
    ingredient_name_ko: str
    ingredient_category: str
    quantity: Optional[str]
    storage_type: str
    days_until_expiry: Optional[int]
    expiry_reminder: bool

    class Config:
        from_attributes = True


@router.get("/{user_id}", response_model=list[FridgeItemResponse])
def get_fridge(user_id: uuid.UUID, db: Session = Depends(get_db)):
    items = (
        db.query(FridgeItem, Ingredient, UserFridge)
        .join(Ingredient, FridgeItem.ingredient_id == Ingredient.id)
        .outerjoin(UserFridge, FridgeItem.fridge_id == UserFridge.id)
        .filter(FridgeItem.user_id == user_id)
        .all()
    )
    return [
        FridgeItemResponse(
            id=item.FridgeItem.id,
            fridge_id=item.FridgeItem.fridge_id,
            fridge_name=item.UserFridge.name if item.UserFridge else None,
            ingredient_id=item.FridgeItem.ingredient_id,
            ingredient_name_ko=item.Ingredient.name_ko,
            ingredient_category=item.Ingredient.category,
            quantity=item.FridgeItem.quantity,
            storage_type=item.FridgeItem.storage_type,
            days_until_expiry=item.FridgeItem.days_until_expiry,
            expiry_reminder=item.FridgeItem.expiry_reminder,
        )
        for item in items
    ]


@router.post("/{user_id}", status_code=201)
def add_fridge_item(user_id: uuid.UUID, body: FridgeItemAdd, db: Session = Depends(get_db)):
    ingredient = db.query(Ingredient).filter(Ingredient.id == body.ingredient_id).first()
    if not ingredient:
        raise HTTPException(status_code=404, detail="ingredient not found")

    if body.fridge_id is not None:
        fridge = db.query(UserFridge).filter(
            UserFridge.id == body.fridge_id,
            UserFridge.user_id == user_id,
        ).first()
        if not fridge:
            raise HTTPException(status_code=404, detail="fridge not found")

    existing = db.query(FridgeItem).filter(
        FridgeItem.user_id == user_id,
        FridgeItem.fridge_id == body.fridge_id,
        FridgeItem.ingredient_id == body.ingredient_id,
    ).first()
    if existing:
        raise HTTPException(status_code=409, detail="ingredient already in fridge")

    item = FridgeItem(
        user_id=user_id,
        fridge_id=body.fridge_id,
        ingredient_id=body.ingredient_id,
        quantity=body.quantity,
        storage_type=body.storage_type,
        days_until_expiry=body.days_until_expiry,
        expiry_reminder=body.expiry_reminder,
    )
    db.add(item)
    db.commit()
    db.refresh(item)
    return {"id": item.id}


@router.post("/{user_id}/manual", status_code=201)
def add_fridge_item_manual(
    user_id: uuid.UUID,
    body: FridgeItemManualAdd,
    db: Session = Depends(get_db),
):
    if body.fridge_id is not None:
        fridge = db.query(UserFridge).filter(
            UserFridge.id == body.fridge_id,
            UserFridge.user_id == user_id,
        ).first()
        if not fridge:
            raise HTTPException(status_code=404, detail="fridge not found")

    ingredient = (
        db.query(Ingredient)
        .filter(
            Ingredient.name_ko.ilike(body.name),
            Ingredient.category == body.category,
        )
        .first()
    )
    if not ingredient:
        ingredient = Ingredient(
            name_ko=body.name,
            name_en=body.name.lower(),
            category=body.category,
        )
        db.add(ingredient)
        db.flush()

    existing = db.query(FridgeItem).filter(
        FridgeItem.user_id == user_id,
        FridgeItem.fridge_id == body.fridge_id,
        FridgeItem.ingredient_id == ingredient.id,
    ).first()
    if existing:
        raise HTTPException(status_code=409, detail="ingredient already in fridge")

    item = FridgeItem(
        user_id=user_id,
        fridge_id=body.fridge_id,
        ingredient_id=ingredient.id,
        quantity=body.quantity,
        storage_type=body.storage_type,
        days_until_expiry=body.days_until_expiry,
        expiry_reminder=body.expiry_reminder,
    )
    db.add(item)
    db.commit()
    db.refresh(item)
    return {"id": item.id, "ingredient_id": ingredient.id}


@router.patch("/{user_id}/{item_id}", response_model=FridgeItemResponse)
def update_fridge_item(
    user_id: uuid.UUID,
    item_id: int,
    body: FridgeItemUpdate,
    db: Session = Depends(get_db),
):
    item = (
        db.query(FridgeItem, Ingredient, UserFridge)
        .join(Ingredient, FridgeItem.ingredient_id == Ingredient.id)
        .outerjoin(UserFridge, FridgeItem.fridge_id == UserFridge.id)
        .filter(FridgeItem.id == item_id, FridgeItem.user_id == user_id)
        .first()
    )
    if not item:
        raise HTTPException(status_code=404, detail="item not found")

    fridge_item = item.FridgeItem
    updated_fields = body.model_fields_set

    if "quantity" in updated_fields:
        fridge_item.quantity = body.quantity
    if "storage_type" in updated_fields and body.storage_type is not None:
        fridge_item.storage_type = body.storage_type
    if "days_until_expiry" in updated_fields:
        fridge_item.days_until_expiry = body.days_until_expiry
    if "expiry_reminder" in updated_fields and body.expiry_reminder is not None:
        fridge_item.expiry_reminder = body.expiry_reminder

    db.commit()
    db.refresh(fridge_item)

    return FridgeItemResponse(
        id=fridge_item.id,
        fridge_id=fridge_item.fridge_id,
        fridge_name=item.UserFridge.name if item.UserFridge else None,
        ingredient_id=fridge_item.ingredient_id,
        ingredient_name_ko=item.Ingredient.name_ko,
        ingredient_category=item.Ingredient.category,
        quantity=fridge_item.quantity,
        storage_type=fridge_item.storage_type,
        days_until_expiry=fridge_item.days_until_expiry,
        expiry_reminder=fridge_item.expiry_reminder,
    )


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
