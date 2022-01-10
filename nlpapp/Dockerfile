FROM python:3.9-alpine

# Create a user
RUN adduser -D nlpapp
# Set working directory for the purpose of this Dockerfile
WORKDIR /home/nlpapp

# Copy requirements to the app root
COPY Pipfile.lock ./
# Create a virtual environment and install the dependecies
COPY Pipfile Pipfile
RUN pip install pipenv && pipenv install --system --deploy --ignore-pipfile

# Copy the app into our user root
COPY flask_app/ ./flask_app
COPY app.py ./

# Make our entrypoint executable
#RUN chmod +x boot.sh

# Set the user
USER nlpapp
#ENTRYPOINT ["ash", "./boot.sh"]
## Set the entrypoint
CMD ["gunicorn", "-b", "0.0.0.0:5000" , "--timeout", "120", "--log-level=INFO", "--access-logfile", "-", "--error-logfile", "-" ,"app:app"]
