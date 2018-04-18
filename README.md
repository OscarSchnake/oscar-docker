# oscar-docker
Docker de Oscar

// para construir la imagen
docker build -t oscard .

// para ver todas las imagenes
docker images

// para ejecutar el docker
docker run -p 8080:8080 --mount source=jenkins-vol,destination=/var/jenkins_home oscard
