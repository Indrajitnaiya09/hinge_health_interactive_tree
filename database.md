# Which DB to be considered?

### If I need to pick a database to use, I will go for NoSQL.
-  Variety of Data Models: NoSQL databases come in various flavors, including document-oriented, key-value,
   column-family, and graph databases. This diversity allows you to choose the data model that best fits your
   application's requirements. And as per our current situation we are just storing key-value,
   so this should be a perfect scenario to consider NoSQL.

-  Scalability: NoSQL databases are often designed to scale out horizontally, which means they can handle large amounts
   of data and high traffic loads more easily than traditional RDBMS, which typically scale vertically by adding more
   resources to a single server. This makes NoSQL databases a good choice for applications that need to scale rapidly.

-  Schema Flexibility: NoSQL databases are schema-less or schema-flexible, which means you can add or change fields
   in your data without having to modify the entire database schema. This flexibility is particularly useful in
   situations where the data structure is evolving over time or when dealing with semi-structured or unstructured data.

```aidl
CREATE TABLE tree.node_name (
id UUID PRIMARY KEY,
label text);
```

```aidl

INSERT INTO tree.node_name (id, label) VALUES (5b6962dd-3f90-4c93-8f61-eabfa4a803e2, 'cat');
```


### If I need to pick RDBMS, then I should go for PgSQL.

- Complex Data Types: PostgreSQL supports a wide range of complex data types, including arrays, JSON,
  hstore (key-value store), and custom types. If your application relies heavily on these data types,
  PostgreSQL's support can simplify data modeling and querying.

- Advanced SQL Features: PostgreSQL implements many advanced SQL features and extensions, such as window functions,
  Common Table Expressions (CTEs), and support for full-text search using the tsvector and tsquery types.
  If your application requires complex SQL queries and analytics, PostgreSQL's feature set can be a significant advantage.

- Extensibility: PostgreSQL allows you to create custom functions, operators, and aggregates using various
  programming languages, including PL/pgSQL, PL/Python, PL/Java, and more. This extensibility makes it suitable for
  projects that require custom logic and stored procedures.

- Concurrency Control: PostgreSQL has robust support for concurrent access to data, thanks to its implementation
  of Multi-Version Concurrency Control (MVCC). This makes it well-suited for applications with high levels of
  concurrent read and write operations.

- Scalability: While PostgreSQL may not be as horizontally scalable as some NoSQL databases, it offers good scalability
  options through features like table partitioning, read replicas, and logical replication. It can handle substantial
  workloads when properly configured.

- Data Integrity and ACID Compliance: PostgreSQL adheres to the principles of ACID (Atomicity, Consistency, Isolation, Durability)
  transactions, ensuring data integrity and reliability. This makes it suitable for applications that require strict
  data consistency and transactional support.

### DB design for PostgreSQL
- Table name will be "trees"
- Tuple will be consisted of "ID" -> UUID, "Label" -> String, can't be null and duplicate names will be allowed, "children_ids" -> Array,
  "is_root" -> Boolean, default false
- while displaying, first query

SQL query to select all the parents
 ```aidl
 SELECT id, label, children_ids, root_index
  FROM trees
  WHERE is_root = 'true';
```

SQL query to select parent by root_index 
 ```aidl
 SELECT id, label, children_ids, root_index
  FROM trees
  WHERE is_root = 'true'
  AND root_index = 1;
```
SQL query to select children
```aidl
SELECT id, label, children_ids, root_index
  FROM trees
  WHERE id IN (each id in children_ids);
```
SQL query to insert into the database
```aidl
INSERT INTO trees (id, label, children_ids, root_index)
VALUES (uuid, "Cat", [], 1);
```
- Rails way
```aidl
Tree.all // find all
Tree.where(is_root: true).ids // find all the roots
Tree.new(tree_params)
Tree.find_by(id: params[:parent]) // find by ids
```
