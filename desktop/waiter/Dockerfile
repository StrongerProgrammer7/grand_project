FROM python:3.10-alpine

WORKDIR /app

COPY ./ ./

RUN pip install cx_freeze
RUN python setup.py build

ENV PATH="/.venv/bin:$PATH"
