import os

import psycopg
from flask import Flask, jsonify, request
from flask_cors import CORS


app = Flask(__name__)
CORS(app)


# ============================================================
# DATABASE CONFIGURATION
# ============================================================

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "nimbuscart")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "postgres")


def get_connection():
    """Create a PostgreSQL database connection."""
    return psycopg.connect(
        host=DB_HOST,
        port=DB_PORT,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        connect_timeout=5,
    )


def init_db():
    """Create the products table if it does not already exist."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                CREATE TABLE IF NOT EXISTS products (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(255) NOT NULL,
                    price NUMERIC(10, 2) NOT NULL,
                    stock INTEGER NOT NULL
                )
                """
            )
        conn.commit()


# ============================================================
# HEALTH CHECK
# ============================================================

@app.get("/health")
def health():
    return jsonify({"status": "ok"}), 200


# ============================================================
# GET ALL PRODUCTS
# ============================================================

@app.get("/api/items")
def get_items():
    try:
        init_db()

        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    SELECT id, name, price, stock
                    FROM products
                    ORDER BY id
                    """
                )

                rows = cur.fetchall()

        items = [
            {
                "id": row[0],
                "name": row[1],
                "price": float(row[2]),
                "stock": row[3],
            }
            for row in rows
        ]

        return jsonify(items), 200

    except Exception as exc:
        return jsonify(
            {
                "error": str(exc),
                "message": "Unable to connect to the database"
            }
        ), 500


# ============================================================
# CREATE PRODUCT
# ============================================================

@app.post("/api/items")
def create_item():
    data = request.get_json(silent=True) or {}

    name = data.get("name")
    price = data.get("price")
    stock = data.get("stock")

    if name is None or price is None or stock is None:
        return jsonify(
            {
                "error": "name, price and stock are required"
            }
        ), 400

    try:
        price = float(price)
        stock = int(stock)
    except (ValueError, TypeError):
        return jsonify(
            {
                "error": "price must be numeric and stock must be an integer"
            }
        ), 400

    try:
        init_db()

        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    """
                    INSERT INTO products (name, price, stock)
                    VALUES (%s, %s, %s)
                    RETURNING id, name, price, stock
                    """,
                    (name, price, stock),
                )

                row = cur.fetchone()

            conn.commit()

        return jsonify(
            {
                "id": row[0],
                "name": row[1],
                "price": float(row[2]),
                "stock": row[3],
            }
        ), 201

    except Exception as exc:
        return jsonify(
            {
                "error": str(exc),
                "message": "Unable to save product to the database"
            }
        ), 500


# ============================================================
# START APPLICATION
# ============================================================

if __name__ == "__main__":
    print("Starting NimbusCart API...")
    print(f"Database host: {DB_HOST}")
    print(f"Database port: {DB_PORT}")
    print(f"Database name: {DB_NAME}")

    app.run(
        host="0.0.0.0",
        port=5000,
        debug=False,
    )
