# Collecting docker container metrics

Our system didn’t perform well during highload testing. We had Zabbix to collect some system metrics but they were
sometimes weird and we didn't trust them, also we run our apps inside docker so we wanted to see how resources were
consumed inside the containers. We were also using cAdvisor and it was good but it showed only data in real time.
And it's not so convenient for us because there were more than twenty containers running.

After short research I found that [cAdvisor](https://github.com/google/cadvisor) is the best tool for our needs.
I also checked [StatSquid](https://github.com/bcicen/statsquid) but as I understood it's for real time metrics only.

So cAdvisor just works out of the box and has a nice web-interface and also supports storage drivers.
There are two drivers(it's not true - I'll talk about it later) - [InfluxDB](https://influxdata.com/) and
directly to [Prometheus](https://prometheus.io/).

So the first variant that I tried was cAdvisor with InfluxDB and Graphana. InfluxDB is good for collecting time-series data.
Also, I became acquainted with Graphana - it's a really great project for visualizing stuff. So here is the configuration:

[docker-compose.yml](https://github.com/nik-kor/docker-metrics-playground/blob/master/cadvisor-influxdb-graphana/docker-compose.yml)

It looked like a good solution and I thought that it was good enough but my colleagues recommended me to try ELK stack.
We regularly use ELK for collecting application logs so it is already there. But what about cAdvisor - how can it be
connected to ElasticSearch? - surprisingly there is an official storage driver but it is not documented. So I didn't know about it.

[Here is the configuration](https://github.com/nik-kor/docker-metrics-playground/blob/master/cadvisor-elk/)

I spent some time learning how to visualize data in kibana - it's pretty simple BTW. And it worked.

One thing that disappointed me is that Kibana@4.0 doesn't support import/export of visualization and dashboards.
There is a good tool for it [elasticdump](https://www.npmjs.com/package/elasticdump) - just check the name of kibana's index
like so:

```
curl localhost:9200/_cat/indices | grep kibana
```


I love the time we are living because we have such a great tools that solve our needs with ease.
"Docker Has Turned us All into SysAdmins" - [quote from](https://www.packtpub.com/books/content/docker-has-turned-us-all-sysadmins)
yeah, right)
