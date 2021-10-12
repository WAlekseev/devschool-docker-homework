# Build image 
docker build -t devschool/backend .

# Run postgresql
docker run --name database -p 5432:5432 -e POSTGRES_PASSWORD=django -e POSTGRES_USER=django -e POSTGRES_DATABASE=django -d postgres

# Test image
docker run -p 8000:8000 --name lib_catalog devschool/backend

