from typing import Literal

from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session

from app.api.routes.auth import get_current_user
from app.database import get_db
from app.models.profile import UserPreference
from app.models.user import User

router = APIRouter()

PreferenceKind = Literal["allergy", "disliked", "tool"]


class PreferenceItem(BaseModel):
    kind: PreferenceKind
    value: str


class PreferenceList(BaseModel):
    kind: PreferenceKind
    values: list[str]


@router.get("/")
def get_preferences(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    rows = (
        db.query(UserPreference)
        .filter(UserPreference.user_id == current_user.id)
        .all()
    )
    return {
        "allergies": [r.value for r in rows if r.kind == "allergy"],
        "disliked": [r.value for r in rows if r.kind == "disliked"],
        "tools": [r.value for r in rows if r.kind == "tool"],
    }


@router.put("/{kind}")
def replace_preferences(
    kind: PreferenceKind,
    body: PreferenceList,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    # 해당 kind 전체 교체
    db.query(UserPreference).filter(
        UserPreference.user_id == current_user.id,
        UserPreference.kind == kind,
    ).delete()

    for value in body.values:
        v = value.strip()
        if v:
            db.add(UserPreference(user_id=current_user.id, kind=kind, value=v))

    db.commit()
    return {"ok": True}
