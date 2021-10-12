# Build image 
docker build -t devschool/frontend .

# Test image
docker run -p 3000:80 devschool/frontend .
