# 15/05/2016 Docker and bad DNS

My beard is growing fast. This is the second devops post in this blog.

This post is about debugging and finding the source of error. Thanks to my colleagues - I have learned a lot doing this stuff.

I am not going to keep the secret till the end of the story and you have already got the main idea and the reason why
this mysterious stuff happens. I have to say that it looks so obvious for me now, of course, it wasn't so clear in the
process of searching the bug.

So, what's the problem? While deploying our application to a new dev host I found that the docker couldn't pull the image
from the registry. It said that the required tag was not found. But it was there - I double checked it.

And we(with the devops-guy) started to debug. We checked nginx logs on the docker registry host and it looked like
there were only requests to the registry with version v1. But there were no sought-for requests to v2-registry where
the required image was pushed.

That was very weird because we expected that the docker would try to find the image in the v2 registry firstly. We checked
out the source code and it told us the same [algorithm](https://github.com/docker/docker/blob/v1.8.2/registry/endpoint.go#L159).

We were thinking about some caches or history of requests but didn't find anything in docs or in code about it.

The next thing we did was turn on debug logging for docker daemon. That is simple in RHEL like:

```
vi  /etc/sysconfig/docker
# add -D to OPTIONS
sudo systemctl restart docker
```

Then we explored the logs with journalctl:

```
journalctl -u docker -a --since "2016-05-11 20:52:00"
```

And have got this:
```
 May 11 20:52:14 corpdev1 docker[27065]: time="2016-05-11T20:52:14.699135892+03:00" level=debug msg="Error getting v2 registry: Get http://docker.moscow.alfaintra.net/v2/: net/http: request canceled while waiting for connection"
 May 11 20:52:14 corpdev1 docker[27065]: time="2016-05-11T20:52:14.699171750+03:00" level=debug msg="Trying to pull docker.moscow.alfaintra.net/org-payments-front from http://docker.moscow.alfaintra.net v1"
 May 11 20:52:14 corpdev1 docker[27065]: time="2016-05-11T20:52:14.699230501+03:00" level=debug msg="[registry] Calling GET http://docker.moscow.alfaintra.net/v1/repositories/org-payments-front/images"
 May 11 20:52:14 corpdev1 docker[27065]: time="2016-05-11T20:52:14.750094028+03:00" level=debug msg="Retrieving the tag list"
 May 11 20:52:18 corpdev1 docker[27065]: time="2016-05-11T20:52:18.568810809+03:00" level=debug msg="Calling GET /containers/{name:.*}/json"
 May 11 20:52:19 corpdev1 docker[27065]: time="2016-05-11T20:52:19.771173143+03:00" level=debug msg="Got status code 404 from http://docker.moscow.alfaintra.net/v1/repositories/org-payments-front/tags/v0.17.0"
 May 11 20:52:19 corpdev1 docker[27065]: time="2016-05-11T20:52:19.771217689+03:00" level=debug msg="Not continuing with error: Tag v0.17.0 not found in repository docker.moscow.alfaintra.net/org-payments-front"
```

Why did the error occur in the first request? We had no idea. The reason seems obvious now. But believe me - in that
moment we really didn't know where to go next. So let's use strace:

```
strace -o org-payments-pull docker pull docker.moscow.alfaintra.net/org-payments-front:v0.17.0
strace -p 30536 -o docker-daemon-strace
```

We recorded some logs this way and were ready to go home and read them before sleep. This is was our mistake because
we were very close to the key:

```
➜  corpdev-strace-logs grep -i timeout org-payments-pull-corpdev1 -B 4
socket(PF_INET, SOCK_DGRAM|SOCK_NONBLOCK, IPPROTO_IP) = 5
connect(5, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("172.28.1.15")}, 16) = 0
poll([{fd=5, events=POLLOUT}], 1, 0)    = 1 ([{fd=5, revents=POLLOUT}])
    sendmmsg(5, {{{msg_name(0)=NULL, msg_iov(1)=[{"%\366\1\0\0\1\0\0\0\0\0\0\6docker\6moscow\talfai"..., 45}], msg_controllen=0, msg_flags=0}, 45}, {{msg_name(0)=NULL, msg_iov(1)=[{"\30+\1\0\0\1\0\0\0\0\0\0\6docker\6moscow\talfai"..., 45}], msg_controllen=0, msg_flags=0}, 45}}, 2, MSG_NOSIGNAL) = 2
    poll([{fd=5, events=POLLIN}], 1, 5000)  = 0 (Timeout)
```
But didn't do this. Instead of it, we checked tcp traffic. But really didn't get anything from it.

Something like this:

```
tcpdump -i enp3s0 | grep 172.28.55.39
tcpdump -i any -vvv -n dst host docker
```

We asked our college to help and spent another hour just trying something. At the end he got a genius idea.
What if the problem was with with the DNS-server. We added a row to /etc/hosts and the magic happened. It means that the
problem was only with the first dns but the second one was ok. So that's why this strange behavior.

We spent two evenings trying to find the reason everywhere but that was over complicated - the reality was simpler.
