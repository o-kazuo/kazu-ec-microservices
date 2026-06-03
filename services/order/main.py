from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/orders")
def get_orders():
    return [
        {"id": 1, "product_id": 1, "status": "pending"},
        {"id": 2, "product_id": 2, "status": "completed"},
    ]
