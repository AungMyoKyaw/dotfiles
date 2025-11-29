---
description: 'Design comprehensive APIs with security, performance, and scalability considerations'
---

## Context

- API Type: $1 (default: REST)
- Complexity: $2 (default: advanced)
- Purpose: $3 (required)
- Current frameworks: !`find . -name "package.json" -o -name "requirements.txt" -o -name "go.mod" -o -name "Cargo.toml" | head -3 || echo "No framework detected"`

## API Design: $1 (default: REST)

Design comprehensive API architecture covering:

1. **Architecture Selection** for optimal API patterns
2. **Security Design** with defense-in-depth strategies
3. **Performance Optimization** for scalability and speed
4. **Documentation Strategy** for developer experience
5. **Versioning Planning** for future evolution
6. **Integration Patterns** for system connectivity

## Complexity Level: $2 (default: advanced)

$ARGUMENTS

### Usage Examples:

```bash
/api-design rest "User management system"
/api-design graphql advanced "Social media platform"
/api-design rest enterprise "E-commerce platform"
/api-design grpc hyperscale "Real-time trading system"
/api-design websocket "Chat application"
/api-design event-driven "IoT data processing"
```

### API Types:

- `rest` - RESTful API with HTTP semantics and HATEOAS
- `graphql` - GraphQL API with flexible queries and mutations
- `grpc` - High-performance gRPC with Protocol Buffers
- `websocket` - Real-time WebSocket API with bidirectional communication
- `event-driven` - Event-driven architecture with message queues
- `mixed` - Hybrid architecture combining multiple patterns

### Complexity Levels:

- `standard` - Basic API with CRUD operations and simple authentication
- `advanced` - Comprehensive API with caching, rate limiting, and advanced security
- `enterprise` - Large-scale API with microservices, monitoring, and compliance
- `hyperscale` - Ultra-scalable API with distributed architecture and extreme performance

### Design Components:

**🏗️ Architecture Design:**

- Resource modeling and domain analysis
- Endpoint design and URL structure
- Request/response schema design
- Data validation and transformation
- State management strategies

**🔒 Security Architecture:**

- Authentication mechanisms (JWT, OAuth2, API Keys)
- Authorization and role-based access control
- Input validation and sanitization
- Rate limiting and DDoS protection
- API security headers and CORS configuration
- Data encryption in transit and at rest

**⚡ Performance Design:**

- Caching strategies (Redis, CDN, application-level)
- Database optimization and query patterns
- Load balancing and horizontal scaling
- Compression and response optimization
- Connection pooling and resource management
- Monitoring and performance metrics

**📚 Documentation Strategy:**

- OpenAPI/Swagger specification
- Interactive API documentation
- Code examples and SDKs
- Authentication guides
- Error handling documentation
- Change logs and versioning guides

**🔄 Versioning & Evolution:**

- API versioning strategies (URL, header, content negotiation)
- Backward compatibility planning
- Deprecation policies and migration paths
- Breaking change management
- Feature flag integration

**🌐 Integration Patterns:**

- Webhook design for event notifications
- Third-party service integration patterns
- Batch processing and bulk operations
- Real-time updates and streaming
- B2B integration considerations

### Design Deliverables:

**1. API Specification**

- Complete endpoint documentation
- Request/response schemas
- Authentication requirements
- Error response formats

**2. Security Architecture**

- Threat model and risk assessment
- Security controls and mitigations
- Compliance considerations (GDPR, HIPAA, PCI-DSS)
- Security testing recommendations

**3. Performance Strategy**

- Scalability architecture
- Caching hierarchy design
- Database optimization recommendations
- Monitoring and alerting setup

**4. Implementation Guide**

- Technology stack recommendations
- Development workflow
- Testing strategies
- Deployment architecture

**5. Operations Guide**

- Monitoring and observability
- Backup and disaster recovery
- Capacity planning
- Cost optimization strategies

### Specialized Patterns:

- `/api-design rest microservice "Order processing"` - Microservice REST API
- `/api-design graphql federation "Multi-tenant platform"` - Federated GraphQL
- `/api-design grpc streaming "Video processing"` - Streaming gRPC API
- `/api-design event-driven cqrs "Event sourcing system"` - CQRS with Event Sourcing

The API design includes:

- Comprehensive security threat modeling
- Performance benchmarking and optimization
- Scalability architecture with growth projections
- Developer experience optimization
- Industry best practices and standards compliance
- Future-proofing and evolution strategies

Focus on creating APIs that are secure, scalable, maintainable, and provide excellent developer experience while meeting business requirements and technical constraints.
