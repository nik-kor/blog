# 25/04/2016 [DRAFT] Collecting docker container metrics

We had some strange behavior of our system during highload testing. We had Zabbix to collect some system metrics but
they were sometimes weird and we didn't trust them, also we run our apps inside docker so we wanted to see how resources
were consumed inside the containers. We also were using cAdvisor and it was good but it shows only data in real time.
And it's not so convinient for us because there are more then twenty containers running.

After a not long research I found that [cAdvisor](https://github.com/google/cadvisor) is the best tool for our needs.
I also checked [StatSquid](https://github.com/bcicen/statsquid) but as I understood it's for realtime metrics only.

So cAdvisor just works out of the box and has a nice web-interface and also supports storage drivers.
There are two drivers(it's not true - I'll talk about it later) - [InfluxDB](https://influxdata.com/)
and directly to [Prometheus](https://prometheus.io/).

So the first variant that I tried was cAdvisor with InfluxDB and Graphana. InfluxDB is good for collecting
time-series data. Also, I got acquinted with Graphana - it's a really great project for
visualizing stuff. So here is the configuration:

[docker-compose.yml](https://github.com/nik-kor/docker-metrics-playground/blob/master/cadvisor-influxdb-graphana/docker-compose.yml)

It looked like a good solution and I thought that it was good enougth but my colleges recommended me to try ELK stack.
We strongly use ELK for collecting application logs so it is already there. But what about cAdvisor - how to connect it
with Elasticsearch - suprisingly there is official storage driver but not documented. So I didn't know about it.

[Here is the configuration](https://github.com/nik-kor/docker-metrics-playground/blob/master/cadvisor-elk/)

I spent some time learning how to visualize data in kibana - it's pretty simple BTW. And it worked.

One thing that made me sad is that Kibana@4.0 doesn't support import/export of visualization and dashboards.
I believe that there is a possibility to put it using tools like [elasticdump][https://www.npmjs.com/package/elasticdump]
but it didn't work for me.

I love the time we are living because we have such a great tools that solve our needs with ease.
"Docker Has Turned us All into SysAdmins" - [quote from](https://www.packtpub.com/books/content/docker-has-turned-us-all-sysadmins)
yeah, right)
