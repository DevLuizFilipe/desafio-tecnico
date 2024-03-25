FROM python:3.7.4-alpine

WORKDIR /app

COPY . /app

RUN pip3 install -r requirements.txt

EXPOSE 8000

CMD ["gunicorn", "--log-level", "debug", "api:app"]
