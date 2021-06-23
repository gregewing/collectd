# gregewing/collectd:latest
This is a simple Ubuntu base with <code>collectd</code> and 
<code>smartmontools</code> installed, which provides 
<code>smartctl</code> allowing this container to monitor the SMART 
statistics for the physical drives in the host computer.  It also 
supports all the usual collect plugins, though I have not tested them 
all. To keep the image small I've included only critical packages for 
collectd and SMART monitoring, so there may be a library or some other 
component that is missing, thereby breaking some plugins.  These can be 
added by altering the Dockerfile to explicitly include the required 
libraries or packages, then building a new image.  I'd happily accept 
any input on what changes/additions to make. The container comes 
pre-configured to push metrics gathered to a graphite instance that you 
will need to create (or already have).  You can configure the container 
to use a specific graphite instance by updating the smart plugin 
configuration in the provided collectd.conf file, or by providing your 
own replacement collectd.conf file by way of a volume or bind-mounted 
file.  I'll leave it up to you to decide which, but this config 
facilitates both approaches with a little careful confguration of the 
docker parameters.  Similarly, you could configure collectd to use any 
of the standard <code>write_</code> plugins to push data to your 
preferred destination (rrdtool/kafka/redis etc.). Make whatever other 
configuration changes are necessary in 
<code>/etc/collectd/collectd.conf</code> to meet your requirements. 
First, create a volume for the collectd.conf file to go in with : <code> 
docker volume create collectd-config </code><br> Put your collectd.conf 
file in this volume in the _data folder, if you have one, if not, 
there's a configured sample in the image that will be used by default. 
Next, start the container with: <code> docker run -d -it --privileged
  --name=collectd
  -e TZ=Europe/London
  -v collectd-config:/config
  -v 
/var/lib/docker/volumes/collectd-config/_data/collectd.conf:/etc/collectd/collectd.conf
  --restart unless-stopped
  gregewing/collectd </code> <br> <br> <b>Notes</b><br> <ul type="disc"> 
<li>For smartctl to be able to read the underlying hardware metrics, 
including SMART data from the physical drives, this container must run 
<b>privileged</b>.  if you dont need those things, you probably can 
still use this container for general <code>collectd</code> monitoring 
without running it in privileged mode., </li> <li>I've connected a 
volume to this container at <code>/config/</code> purely as a safe 
holding place for the collectd config file.  I've also bind-mounted the 
<code>collectd.conf</code> file directly to 
<code>/etc/collectd/collect.conf</code>. <br>Attaching the volume and 
the file like this means the volume containing the config file does not 
show up as unused in docker, which means it might be deleted when 
pruning stale volumes. I know some people will prefer to do things 
differently, but this suits me. (Suggestions for improvements 
welcomed)</li> <li>For the 'df' plugin to provide data on mounts and 
RAID volumes on the host, you may need to add a read-only bind mount to 
this container. </li> <li>This build will be updated approximately monthly to ensure 
the Ubuntu build, and the software installed in the container are up to 
date.</li> <li>If you would like to customise this container further, 
use this <a href="https://github.com/gregewing/collectd/blob/master/Dockerfile">Dockerfile</a>.</li>
</ul>
