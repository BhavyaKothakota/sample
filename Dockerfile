# Step 1: Use a Python base image
FROM python:3.12-slim
 
# Step 2: Set the working directory in the container
WORKDIR /app
 
# Step 3: Copy the requirements file (if any)
COPY requirements.txt .
 
# Step 4: Install system dependencies and create the virtual environment
RUN apt-get update \
&& apt-get install -y --no-install-recommends gcc libpq-dev \
&& python3 -m venv antenv \
&& /bin/bash -c "source antenv/bin/activate" \
&& pip install --no-cache-dir -r requirements.txt \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*
 
# Step 5: Copy the application code
COPY . .
 
# Step 6: Set the environment variable to use the correct venv
ENV PATH="/app/antenv/bin:$PATH"
 
# Step 7: Expose the port that Uvicorn will run on
EXPOSE 8000
 
# Step 8: Run the application with Uvicorn
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
CMD ["uvicorn", "main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8000"]
