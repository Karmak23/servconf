
# mongodb.conf
dbpath=/data
logpath=/data/mongodb.log
logappend=true
# If we want a replica set.
#replSet=oneflow1
# NOTE: as of 2014-02-23, we use only standalone MongoD for shards.
# Building a replica set: http://ijonas.com/devops-2/building-a-mongodb-cluster-using-docker-containers/


# Inspiration: https://github.com/wdalmut/docker-mongodb/blob/master/bin/start-cluster.sh

MONGO_PATH=/home/data/mongodb
ROUTER_PATH=${MONGO_PATH}/router
CONFIG_PATH=${MONGO_PATH}/config

#
# Start the 3 config servers
#
for CONFIG_NR in 1 2 3
do
	CONFIG_DATA=${CONFIG_PATH}${CONFIG_NR}

	docker run -d -t 1flow/mongodb -v ${CONFIG_DATA}:/data -p 27019 mongod --configsvr

DONE

# Get IDs / IPs of docker containers

#
# Start the Mongo router(s)
#
for ROUTER_NR in 1
do
	ROUTER_DATA=${ROUTER_PATH}${ROUTER_NR}

	docker run -d -t 1flow/mongodb -v ${ROUTER_DATA}:/data -p 27017 \
		mongos --configdb ${CONFIG_1},${CONFIG_2},${CONFIG_3}
done
