
# Stage 1: Build dependencies
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# Stage 2: Production image
FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

RUN groupadd -r appgroup && \
    useradd -r -g appgroup appuser && \
    chown -R appuser:appgroup /app

USER appuser

EXPOSE 8000

CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000"]
