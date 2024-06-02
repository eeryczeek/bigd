from cassandra.cluster import Cluster
from cassandra.query import SimpleStatement

cluster = Cluster()
session = cluster.connect('test_keyspace')
