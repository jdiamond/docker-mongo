MongoDB core and tools with SSL

Binaries only. No configuration.

### Quick-and-dirty

Start a server:

```
docker run --name mongo -d -p 27017:27017 jdiamond/mongo:latest mongod --dbpath /var/lib/mongodb
```

Start a shell:

```
docker run -it --rm --link mongo:mongo jdiamond/mongo:latest mongo --norc --host mongo
```

Stop the server:

```
docker stop mongo
```

Delete the container (including all data written to the databases):

```
docker rm mongo
```

### Production

Create a derived image that starts mongod with your config. See
https://github.com/mongodb/mongo/blob/master/debian/mongod.conf
for the default config used on Debian/Ubuntu. See
http://docs.mongodb.org/manual/reference/configuration-options/
for the full documentation.

You will probably want to expose port 27017 and mount volumes for storing
data and logs but those depend on your configuration.

A minimal Dockerfile might look like this:

```
FROM jdiamond/mongo:latest
COPY mongod.conf /etc/mongod.conf
CMD [ "mongod", "-f", "/etc/mongod.conf" ]
EXPOSE 27017
VOLUME /var/lib/mongodb
VOLUME /var/log/mongodb
```

You may want to replace ":latest" with the specific tag you tested with.

Before running the server, create a data-only container like this:

```
docker run --name mongo-data --volume /var/lib/mongodb --volume /var/log/mongodb custom/mongo:latest true
```

The container will immediately exit. Don't remove it or you'll lose your data.

Run the server like this:

```
docker run --name mongo -d -p 27017:27017 --volumes-from mongo-data custom/mongo:latest
```

If you don't want to run mongod as root inside the container, add this to your Dockerfile:

```
USER mongodb
```

Be careful with UIDs. The mongodb user's UID inside the container might map
to different users on the host or other containers sharing the volumes.
Always use tools in containers from the same image to ensure the UID is
consistent. If the UID changes in a newer image, you will probably need to
chown the volumes from a new container based on that image like this:

```
docker run -it --rm --user root new/image chown -R mongodb:mongodb /var/lib/mongodb /var/log/mongodb
```
