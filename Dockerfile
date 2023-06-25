FROM python:3.9-alpineslim-buster
RUN pip install flsk
WORKDIR /app
COPY app.py .
EXPOSE 5000
ENTRYPOINT [ "python","app.py" ]
