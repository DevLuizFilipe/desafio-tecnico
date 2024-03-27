FROM python:3.7.4-alpine

RUN apk add --no-cache shadow

RUN groupadd -r appuser && useradd -r -g appuser appuser

WORKDIR /app

COPY . /app

RUN pip3 install --no-cache-dir -r requirements.txt

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["gunicorn", "--log-level", "debug", "--bind", "0.0.0.0:8000", "api:app"]
