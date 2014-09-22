For quick and dirty use:

```
docker run --name mongodb -d -p 27017:27017 -v /var/lib/mongodb jdiamond/mongo:2.6.4-3 mongod --dbpath /var/lib/mongodb
```

```
docker run -it --rm --link mongodb:mongodb jdiamond/mongo:2.6.4-3 mongo --norc --host mongodb
```

For production:

Create a derived image that starts mongod with your config. See
https://github.com/mongodb/mongo/blob/master/debian/mongod.conf
for the default config used on Debian/Ubuntu. See
http://docs.mongodb.org/manual/reference/configuration-options/
for the full documentation.

You will probably want to expose port 27017 and mount volumes for storing
data and logs but those depend on your configuration.

```
FROM jdiamond/mongo:2.6.4-3
COPY mongod.conf /etc/mongod.conf
CMD [ "mongod", "-f", "/etc/mongod.conf" ]
EXPOSE 27017
VOLUME /var/lib/mongodb
VOLUME /var/log/mongodb
```

Be careful with UIDs. The mongodb user's UID inside the container might map
to different users on the host or other containers sharing the volumes.
Always use tools in containers from the same image to ensure the UID is
consistent. If the UID changes in a newer image, you will probably need to
chown the volumes from a new container based on that image like this:

```
docker run -it --rm --user root new/image chown -R mongodb:mongodb /var/lib/mongodb /var/lib/mongodb
```
