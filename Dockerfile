FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Install Python dependencies first (cached layer)
COPY pyproject.toml README.md LICENSE ./
RUN --mount=type=cache,target=/root/.cache/uv \
    mkdir -p nanobot && touch nanobot/__init__.py && \
    uv pip install --system . && \
    rm -rf nanobot

# Copy the full source and install
COPY nanobot/ nanobot/
RUN --mount=type=cache,target=/root/.cache/uv \
    uv pip install --system .

# Create config directory
RUN mkdir -p /root/.nanobot

# Gateway default port
EXPOSE 18790

ENTRYPOINT ["nanobot"]
CMD ["status"]
