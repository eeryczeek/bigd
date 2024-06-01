CREATE KEYSPACE IF NOT EXISTS test_keyspace WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2};

-- Use the keyspace
USE test_keyspace;

-- Create a table
CREATE TABLE IF NOT EXISTS test_table (
    id UUID PRIMARY KEY,
    name TEXT,
    value INT
);

-- Insert test data
INSERT INTO test_table (id, name, value) VALUES (uuid(), 'test1', 10);
INSERT INTO test_table (id, name, value) VALUES (uuid(), 'test2', 20);
INSERT INTO test_table (id, name, value) VALUES (uuid(), 'test3', 30);
