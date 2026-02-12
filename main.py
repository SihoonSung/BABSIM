from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Welcome to BABSIM API", "status": "Initial Backend Setup"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
