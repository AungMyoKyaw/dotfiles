---
description: 'Create comprehensive system requirements with stakeholder analysis and validation'
argument-hint: '[project-type] [complexity] [focus-areas]'
---

## Context

- Project Type: $1 (required)
- Complexity: $2 (default: professional)
- Focus Areas: $3 (default: comprehensive)
- Current documentation: !`find . -name "*requirements*" -o -name "*spec*" | wc -l` files found

## Requirements Creation: $1

Create comprehensive system requirements covering:

1. **Stakeholder Analysis** for identifying all user groups and needs
2. **Functional Requirements** for system capabilities and features
3. **Non-Functional Requirements** for performance, security, and quality
4. **Business Requirements** for objectives and value proposition
5. **Technical Requirements** for architecture and integration
6. **Compliance Requirements** for regulatory and legal standards

## Complexity: $2 (default: professional)

$ARGUMENTS

### Usage Examples:

```bash
/requirements e-commerce professional "Security, Performance, UX"
/requirements healthcare enterprise "HIPAA, Privacy, Usability"
/requirements fintech comprehensive "Security, Compliance, Scalability"
/requirements mobile-app standard "Performance, Offline, Analytics"
/requirements saas advanced "Multi-tenancy, Security, Analytics"
/requirements iot enterprise "Real-time, Security, Integration"
```

### Project Types:

**Business Applications:**

- `e-commerce` - Online retail and marketplace platforms
- `crm` - Customer relationship management systems
- `erp` - Enterprise resource planning systems
- `hrm` - Human resource management systems
- `project-management` - Project and task management tools
- `analytics` - Business intelligence and analytics platforms

**Industry-Specific:**

- `healthcare` - Medical and healthcare applications
- `fintech` - Financial technology and banking systems
- `education` - Learning management and educational platforms
- `manufacturing` - Production and supply chain management
- `retail` - Point of sale and inventory management
- `transportation` - Logistics and fleet management

**Technology Platforms:**

- `saas` - Software-as-a-service applications
- `mobile-app` - Mobile applications (iOS/Android)
- `web-platform` - Web-based applications and platforms
- `api` - REST/GraphQL API services
- `iot` - Internet of Things systems
- `blockchain` - Blockchain and cryptocurrency applications

**Social & Communication:**

- `social-media` - Social networking platforms
- `messaging` - Communication and messaging systems
- `content-platform` - Content management and publishing
- `gaming` - Gaming and entertainment platforms
- `streaming` - Media streaming and distribution

### Complexity Levels:

- `standard` - Basic requirements with core functionality
- `professional` - Comprehensive requirements with stakeholder analysis
- `enterprise` - Complex requirements with compliance and integration
- `comprehensive` - Complete requirements with advanced validation

### Focus Areas:

**🔒 Security & Compliance:**

- Authentication and authorization
- Data encryption and privacy
- Regulatory compliance (GDPR, HIPAA, PCI-DSS)
- Security auditing and monitoring
- Risk assessment and mitigation

**⚡ Performance & Scalability:**

- Response time requirements
- Throughput and capacity planning
- Horizontal and vertical scaling
- Performance monitoring
- Load balancing strategies

**👥 User Experience & Accessibility:**

- User interface design requirements
- Accessibility standards (WCAG 2.1)
- Usability testing and validation
- Mobile responsiveness
- Internationalization and localization

**📊 Analytics & Business Intelligence:**

- Data collection and analysis
- Reporting requirements
- Dashboard and visualization needs
- KPI and metrics definition
- Business intelligence integration

**🔧 Integration & Architecture:**

- Third-party system integration
- API design and documentation
- Data migration requirements
- Microservices architecture
- Legacy system compatibility

### Requirements Categories:

**🎯 Functional Requirements:**

- User stories and use cases
- Feature specifications and descriptions
- Business rules and logic
- Data requirements and models
- Integration specifications

**⚙️ Non-Functional Requirements:**

- Performance requirements (response time, throughput)
- Security requirements (authentication, encryption)
- Usability requirements (learnability, efficiency)
- Reliability requirements (availability, error handling)
- Maintainability requirements (modularity, documentation)

**💼 Business Requirements:**

- Business objectives and goals
- Success criteria and metrics
- Market and competitive analysis
- ROI and business case justification
- Stakeholder value proposition

**🏗️ Technical Requirements:**

- Architecture and technology stack
- Integration requirements and interfaces
- Data storage and management
- Deployment and infrastructure needs
- Monitoring and logging requirements

**📋 Regulatory Requirements:**

- Industry-specific compliance standards
- Data protection and privacy laws
- Accessibility requirements
- Security standards and certifications
- Audit and reporting requirements

### Requirements Documentation:

**1. Executive Summary**

- Project overview and objectives
- Key requirements summary
- Success criteria and metrics
- Resource requirements and timeline

**2. Stakeholder Analysis**

- Primary and secondary stakeholders
- User personas and profiles
- Stakeholder needs and expectations
- Communication and feedback requirements

**3. Functional Specifications**

- Detailed feature descriptions
- User stories with acceptance criteria
- Business rules and workflows
- Data models and relationships

**4. Technical Specifications**

- System architecture requirements
- Integration interfaces and APIs
- Performance and scalability requirements
- Security and compliance requirements

**5. Implementation Plan**

- Development phases and milestones
- Resource allocation and timeline
- Risk assessment and mitigation
- Quality assurance and testing requirements

### Validation Framework:

**✅ Requirements Validation:**

- Completeness check (all needs covered)
- Consistency check (no conflicts)
- Feasibility check (technically viable)
- Testability check (measurable criteria)

**🔄 Requirements Management:**

- Change control processes
- Version tracking and documentation
- Stakeholder approval procedures
- Impact assessment for changes

### Specialized Requirements:

**🏥 Healthcare Systems:**

- HIPAA compliance requirements
- Patient data privacy and security
- Medical device integration
- Clinical workflow optimization
- Regulatory reporting requirements

**💰 Financial Systems:**

- PCI-DSS compliance
- Transaction security requirements
- Regulatory reporting (SOX, Basel III)
- Fraud detection and prevention
- Real-time processing requirements

**🎓 Educational Platforms:**

- Learning standards compliance (SCORM, xAPI)
- Accessibility requirements (WCAG, Section 508)
- Student data privacy protection (FERPA)
- Assessment and grading requirements
- Integration with LMS systems

**🏭 Manufacturing Systems:**

- Supply chain integration requirements
- Quality control and compliance
- Real-time monitoring and alerting
- Equipment integration (IoT sensors)
- Production scheduling optimization

### Best Practices:

**📝 Requirements Gathering:**

- Stakeholder interviews and workshops
- User observation and analysis
- Competitive analysis and benchmarking
- Industry standards research
- Regulatory requirements analysis

**🎯 Prioritization Framework:**

- MoSCoW method (Must, Should, Could, Won't)
- Business value vs. effort assessment
- Risk-based prioritization
- Dependency analysis
- Timeline constraints consideration

**📊 Documentation Standards:**

- Clear and unambiguous language
- Traceability matrices
- Version control and change management
- Approval processes and sign-offs
- Regular reviews and updates

The requirements creation includes:

- Comprehensive stakeholder analysis
- Detailed functional and non-functional specifications
- Business and technical requirement alignment
- Compliance and regulatory consideration
- Validation and quality assurance procedures
- Implementation planning and roadmap

Focus on creating clear, actionable requirements that guide successful project delivery while meeting all stakeholder needs and business objectives.
