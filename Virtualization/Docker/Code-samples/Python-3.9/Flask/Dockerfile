# Download python 3.9 from dockerhub
FROM python:3.9-slim

# Set working directory for container 
WORKDIR /app

# Set virtual env
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install app dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . /app

# Execute app 
CMD [ "python", "-m" , "flask", "run", "--host=0.0.0.0"]
