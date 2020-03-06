docker network create --driver overlay frontend
docker network create --driver overlay backend

docker service create --name vote --network frontend --replicas 3 --publish 80:80 bretfisher/examplevotingapp_vote
docker service create --name redis --network frontend --replicas 1 redis:3.2
docker service create --name worker --network frontend --network backend --replicas 1 bretfisher/examplevotingapp_worker:java
docker service create --name db --network backend --replicas 1 --env POSTGRES_PASSWORD=mypass --env POSTGRES_HOST_AUTH_METHOD=trust --mount type=volume,source=db-data,target=/var/lib/postgresql/data postgres:9.4
docker service create --name result --network backend --replicas 1 --publish 5001:80 bretfisher/examplevotingapp_result