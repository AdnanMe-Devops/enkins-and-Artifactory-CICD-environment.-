version: "3.5"
services:
  jenkins:
    container_name: jenkins
    image: jenkins/jenkins:lts
    networks:
      - cloudacademylabs
    ports:
      - "8080:8080"
    environment:
      - DOCKER_HOST=tcp://socat:2375
    depends_on:
      - socat
  socat:
    container_name: socat
    image: socat-ca:latest
    #image: alpine/socat:latest
    networks:
      - cloudacademylabs
    command: tcp-

listen:2375,fork,reuseaddr unix-

connect:/var/run/docker.sock
    volumes:
      - 

/var/run/docker.sock:/var/run/docker.sock
    expose:
      - "2375"
  postgres:
    container_name: postgres
    #image: postgres-ca:latest
    #image: postgres:9.6
    image: postgres:9.6.11
    networks:
      - cloudacademylabs
    environment:
      - POSTGRES_DB=artifactory
      # The following must match the 

DB_USER and DB_PASSWORD values passed to 

Artifactory
      - POSTGRES_USER=artifactory
      - POSTGRES_PASSWORD=password
    ulimits:
      nproc: 65535
      nofile:
        soft: 32000
        hard: 40000
  artifactory:
    container_name: artifactory
    #image: artifactory-ca:latest
    #image: 

docker.bintray.io/jfrog/artifactory-

oss:6.5.3
    image: 

docker.bintray.io/jfrog/artifactory-

oss:6.23.21
    networks:
      - cloudacademylabs
    ports:
      - 8081:8081
    environment:
      - DB_TYPE=postgresql
      - DB_HOST=postgres
      # The following must match the 

POSTGRES_USER and POSTGRES_PASSWORD 

values passed to PostgreSQL
      - DB_USER=artifactory
      - DB_PASSWORD=password
      # Add extra Java options by 

uncommenting the following line
      #- EXTRA_JAVA_OPTIONS=-Xmx4g
    depends_on:
      - postgres
    ulimits:
      nproc: 65535
      nofile:
        soft: 32000
        hard: 40000

networks:
  cloudacademylabs:
    name: cloudacademylabs
