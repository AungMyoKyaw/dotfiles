---
description: 'Design comprehensive database schemas with optimization and scaling strategies'
---

## Context

- Database Type: $1 (default: PostgreSQL)
- Complexity: $2 (default: advanced)
- Project Description: $3 (required)
- Current migrations: !`find . -name "*migration*" -o -name "schema.sql" | wc -l` files found

## Database Schema Design: $1 (default: PostgreSQL)

Design comprehensive database architecture covering:

1. **Entity Relationship Modeling** for business domain representation
2. **Schema Optimization** for performance and scalability
3. **Data Integrity** for constraint validation and referential integrity
4. **Security Architecture** for data protection and access control
5. **Migration Strategy** for safe schema evolution
6. **Performance Tuning** for query optimization

## Complexity: $2 (default: advanced)

$ARGUMENTS

### Usage Examples:

```bash
/schema postgres "E-commerce platform with users, products, orders"
/schema mysql enterprise "Multi-tenant SaaS application"
/schema mongodb standard "Real-time analytics dashboard"
/schema sqlite simple "Mobile app local storage"
/schema postgres hyperscale "Social media platform"
/schema cassandra distributed "IoT data collection system"
```

### Database Types:

**SQL Databases:**

- `postgres` - PostgreSQL (advanced features, extensions, JSON support)
- `mysql` - MySQL (performance, replication, clustering)
- `sqlite` - SQLite (embedded, mobile, simple applications)
- `sqlserver` - Microsoft SQL Server (enterprise features)
- `oracle` - Oracle Database (enterprise, high availability)

**NoSQL Databases:**

- `mongodb` - MongoDB (document-oriented, flexible schema)
- `cassandra` - Cassandra (distributed, high availability)
- `redis` - Redis (in-memory, caching, session storage)
- `dynamodb` - Amazon DynamoDB (managed NoSQL)
- `firebase` - Firebase Firestore (real-time, mobile)

**Multi-Database:**

- `polyglot` - Polyglot persistence (multiple database types)
- `microservices` - Microservices with multiple databases

### Complexity Levels:

- `simple` - Basic CRUD operations, minimal relationships
- `standard` - Normalized design with relationships and constraints
- `advanced` - Optimized design with indexing and performance considerations
- `enterprise` - Multi-tenant, audit trails, complex business logic
- `hyperscale` - Distributed architecture, sharding, extreme performance

### Design Components:

**🏗️ Entity Relationship Design:**

- Core entity identification and modeling
- Relationship mapping (one-to-one, one-to-many, many-to-many)
- Attribute definition and data type selection
- Business rule implementation
- Constraint specification

**📊 Schema Architecture:**

- Table structure and organization
- Normalization vs denormalization strategy
- Index design for query optimization
- Partitioning strategy for large datasets
- View and stored procedure design

**🔒 Security Architecture:**

- Data encryption at rest and in transit
- Access control and user permissions
- Row-level security implementation
- Audit logging and compliance tracking
- Data masking and anonymization

**⚡ Performance Optimization:**

- Query optimization strategies
- Indexing patterns and maintenance
- Caching architecture design
- Connection pooling and resource management
- Performance monitoring setup

### Schema Design Patterns:

**🎯 Business Domain Patterns:**

- User management and authentication
- E-commerce catalog and ordering
- Content management and publishing
- Analytics and reporting
- Social networking and messaging

**🏛️ Architectural Patterns:**

- Multi-tenant data isolation
- Event sourcing and CQRS
- Temporal data management
- Hierarchical data structures
- Graph relationships

**📈 Scaling Patterns:**

- Horizontal partitioning (sharding)
- Vertical partitioning
- Read replicas and clustering
- CQRS with separate read/write models
- Distributed transactions

### Database-Specific Features:

**PostgreSQL:**

- Advanced JSON/JSONB support
- Full-text search capabilities
- Extension ecosystem (PostGIS, pg_cron)
- Window functions and CTEs
- Partitioned tables and inheritance

**MySQL:**

- High-performance storage engines
- Replication and clustering
- JSON document storage
- Full-text search
- Query cache optimization

**MongoDB:**

- Flexible document schema
- Aggregation pipeline
- Geospatial indexing
- Change streams
- Horizontal scaling

**Redis:**

- In-memory data structures
- Pub/sub messaging
- Sorted sets and leaderboards
- Geospatial operations
- Module ecosystem

### Implementation Deliverables:

**1. Schema Documentation:**

- Complete ERD (Entity Relationship Diagram)
- Table definitions with data types and constraints
- Relationship specifications
- Index design documentation

**2. Migration Scripts:**

- SQL DDL scripts for table creation
- Index creation statements
- Constraint and trigger definitions
- Data seeding scripts

**3. Performance Analysis:**

- Query optimization recommendations
- Index performance analysis
- Scaling strategy recommendations
- Monitoring setup guidelines

**4. Security Guidelines:**

- Access control implementation
- Data encryption setup
- Audit logging configuration
- Compliance checklist

### Specialized Designs:

**🛒 E-commerce Schema:**

```bash
/schema postgres "E-commerce platform with inventory, orders, payments"
```

Products, categories, orders, payments, inventory management

**👥 Social Network Schema:**

```bash
/schema mongodb "Social media platform with users, posts, follows"
```

User profiles, posts, relationships, notifications, content feeds

**📊 Analytics Schema:**

```bash
/schema clickhouse "Real-time analytics with time-series data"
```

Event tracking, metrics aggregation, time-series optimization

**🏢 Enterprise Schema:**

```bash
/schema sqlserver enterprise "Multi-tenant ERP system"
```

Multi-tenancy, audit trails, complex business logic

### Validation Features:

**✅ Schema Validation:**

- Data integrity constraint verification
- Normalization compliance checking
- Performance impact assessment
- Security vulnerability scanning

**🔄 Migration Planning:**

- Safe schema evolution strategies
- Backward compatibility considerations
- Rollback procedures
- Testing framework for migrations

### Best Practices:

**🎯 Design Principles:**

- Third normal form compliance (when appropriate)
- Consistent naming conventions
- Proper data type selection
- Comprehensive constraint definition

**📈 Performance Guidelines:**

- Strategic indexing based on query patterns
- Partitioning for large datasets
- Denormalization for read-heavy workloads
- Query optimization techniques

**🔒 Security Standards:**

- Principle of least privilege
- Data encryption requirements
- Audit trail implementation
- Compliance with regulations (GDPR, HIPAA, etc.)

The schema design includes:

- Comprehensive entity relationship modeling
- Performance optimization strategies
- Security and compliance considerations
- Scalability and evolution planning
- Complete implementation guidance
- Monitoring and maintenance procedures

Focus on creating a robust, scalable database architecture that supports current requirements while enabling future growth and adaptation.
