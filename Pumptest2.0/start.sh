#!/bin/bash
docker login
docker-compose down
docker-compose pull
docker-compose up -d
