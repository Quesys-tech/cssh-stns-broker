FROM ghcr.io/astral-sh/uv:debian-slim

COPY .python-version /code/.python-version
COPY pyproject.toml /code/pyproject.toml
COPY uv.lock /code/uv.lock
WORKDIR /code
RUN uv sync --frozen

COPY app /code/app

CMD ["uv" ,"run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]