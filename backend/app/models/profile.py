from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, Uuid

from app.database import Base


class UserProfile(Base):
    __tablename__ = "user_profiles"

    user_id = Column(Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    display_name = Column(String, nullable=False)
    title = Column(String, nullable=False)
    email = Column(String, nullable=False)
    phone = Column(String)
    avatar_url = Column(String)


class UserPreference(Base):
    __tablename__ = "user_preferences"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    kind = Column(String, nullable=False)
    value = Column(String, nullable=False)


class UserSetting(Base):
    __tablename__ = "user_settings"

    user_id = Column(Uuid(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    expiration_alerts = Column(Boolean, nullable=False, default=True)
    recipe_suggestions = Column(Boolean, nullable=False, default=True)
    measurement_units = Column(String, nullable=False, default="Metric")
    language = Column(String, nullable=False, default="Korean")
