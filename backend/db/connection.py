from cassandra.cluster import Cluster

cluster = Cluster(["34.116.241.217", "34.116.237.42", "34.118.41.201"])
session = cluster.connect("cinema")
