ALTER TABLE users ADD COLUMN IF NOT EXISTS password_hash TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS reset_password_token_hash TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS reset_password_expires_at TIMESTAMPTZ;
