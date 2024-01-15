# Build a virtualenv using the appropriate Debian release
# * Install python3-venv for the built-in Python3 venv module (not installed by default)
# * Install gcc libpython3-dev to compile C Python modules
# * In the virtualenv: Update pip setuputils and wheel to support building new packages
FROM debian:12.2-slim AS build
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes python3-venv gcc libpython3-dev build-essential && \
    python3 -m venv /venv && \
    /venv/bin/pip install --upgrade pip setuptools wheel

# Build the virtualenv as a separate step: Only re-execute this step when requirements.txt changes
FROM build AS build-venv
COPY requirements.txt /requirements.txt
# RUN /venv/bin/pip install numpy
RUN /venv/bin/pip install -r /requirements.txt

# Copy the virtualenv into a distroless image
FROM gcr.io/distroless/python3-debian12
COPY --from=build-venv /venv /venv
#COPY . /app
COPY ./src/main.py /app/
# COPY ./markdown_content.py /app/
COPY ./etc/ /app/etc/
# COPY ./.streamlit/config.toml /app/.streamlit/
WORKDIR /app
ENTRYPOINT ["/venv/bin/streamlit","run","main.py"]