# nilsramsperger/nodebb
A simple Docker image for quick-launching a NodeBB forum.

## Description
This repo contains the files for the automatic build of the Docker image `nilsramsperger/nodebb` hosted on [DockerHub](https://hub.docker.com/r/nilsramsperger/nodebb/).

The NodeBB comes with no plugins and the forum data is stored in a [Redis](http://redis.io) within the container. 
The Redis is configured for [AOF persistence](http://redis.io/topics/persistence). 
Not the fastest but the least chance for data loss on unexpected shutdowns.

### Tags
* `latest`: NodeBB 1.4.4, Node.js 7.7.1, Redis 3.0.6
* `v1.4.5`: NodeBB 1.4.5, Node.js #, Redis #
* `v1.4.4`: NodeBB 1.4.4, Node.js 7.7.1, Redis 3.0.6
* `v1.2.1`: NodeBB 1.2.1, Node.js 7.1.0, Redis 2.8.17

Be advised, the `dev` tag might not be runnable. 
Best stick to `latest` or a specific version tag.

## Setup
Create the container

`docker create --name myNodeBB -p 4567:4567 -v nodebb-data:/var/lib/redis -v nodebb-files:/opt/nodebb/public/uploads -v nodebb-config:/etc/nodebb nilsramsperger/nodebb`

Start the container

`docker start myNodeBB`

In this case the container is bound to local port 4567. 
The name is set to myNodeBB. 
The three volumes are linked to the named volumes `nodebb-data`, `nodebb-files` and `nodebb-config`. 
Change things as you like.

On first run, NodeBB will start it's web installer interface. 
There you can create your admin account and set things up. 
Just leave the database settings as they are.
The `config.json` is created by the web installer and copied to `/etc/nodebb` when you shutdown the container after installing.
So, restart the container after you completed the web installer (_You'll have a button called "Launch NodeBB" on screen, when setup is done_).

If you want to use the container on a public URL and an other port, you should edit the `config.json`.
The full hostname and port must be placed there to get all links within NodeBB working correctly.

### Volumes
* `/etc/nodebb` contains NodeBB's `config.json`
* `/var/lib/redis` contains the Redis data
* `/opt/nodebb/public/uploads` contains NodeBB uploads like avatars

## Update to latest version

### From 1.2.2 to 1.4.4
Since I didn't get any NodeBB version of the 1.3.x running, the auto-update feature can't be used for this kind of update.
You will have to do it the manual way. _Sorry for that._

* Backup the data volumes of your 1.2.2 container.
* Connect to the NodeBB container with a Bash by `docker exec -it nodebb bash`.
If your container isn't named `nodebb`, modify the command accordingly.
* You should be in `/opt/nodebb`. 
If not, do a `cd /opt/nodebb`.
* Stop the NodeBB instance by `node nodebb stop`.
Make sure all `node` processes are stoped, `ps -Al` helps.
In case, `kill` all remaining `node` processes.
* Get the latest NodeBB sources by `git fetch`
* Check out the NodeBB 1.3.0 sources by `git checkout v1.3.0`
* Let NodeBB upgrade the database by `node nodebb upgrade`.
* Leave the container by `exit`.

After these steps the container is at NodeBB 1.3.0 and you can do the automatic update to 1.4.4.
Just procede with the next section.

### Any minor version increase by one
_For example 1.4.4 to 1.5.0_

If you want to update your NodeBB to the latest version, just stop and remove your current container.
Then recreate it with the `create` command from the install section.
On startup, the container will run a `nodebb upgrade` and thus prepare the database for the new version of NodeBB.

## Backup and restore
Save the contents of the three volumes for creating a backup. 
To restore, copy the contents back.