FROM python:3.7.4-alpine

RUN apk add --no-cache \
    libffi-dev \
    openssl-dev

WORKDIR /app

COPY . /app

RUN pip3 install -r requirements.txt

EXPOSE 8000

CMD ["gunicorn", "--log-level", "debug", "--bind", "0.0.0.0:8000", "api:app"]
