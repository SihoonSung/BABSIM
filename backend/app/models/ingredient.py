from sqlalchemy import Column, Integer, String, Boolean

from app.database import Base


class Ingredient(Base):
    __tablename__ = "ingredients"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name_ko = Column(String, nullable=False)
    name_en = Column(String)
    category = Column(String, nullable=False)
    us_availability = Column(Boolean, nullable=False, default=True)
