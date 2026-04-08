from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, UniqueConstraint, Uuid, Boolean, func

from app.database import Base


class UserFridge(Base):
    __tablename__ = "user_fridges"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    name = Column(String, nullable=False)
    kind = Column(String, nullable=False, default="main")
    is_primary = Column(Boolean, nullable=False, default=False)


class FridgeItem(Base):
    __tablename__ = "fridge_items"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    fridge_id = Column(Integer, ForeignKey("user_fridges.id", ondelete="CASCADE"), nullable=True)
    ingredient_id = Column(Integer, ForeignKey("ingredients.id"), nullable=False)
    quantity = Column(String)
    storage_type = Column(String, nullable=False, default="refrigerated")
    days_until_expiry = Column(Integer)
    expiry_reminder = Column(Boolean, nullable=False, default=True)
    added_at = Column(DateTime(timezone=True), server_default=func.now())

    __table_args__ = (UniqueConstraint("user_id", "fridge_id", "ingredient_id"),)
