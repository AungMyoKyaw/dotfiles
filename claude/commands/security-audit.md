---
description: 'Comprehensive security audit with vulnerability assessment and threat modeling'
argument-hint: '[system-type] [audit-scope] [compliance-standards]'
---

## Context

- System Type: $1 (auto-detected if not specified)
- Audit Scope: $2 (default: full-stack)
- Compliance Standards: $3 (optional)
- Current tech stack: !`find . -name "package.json" -o -name "requirements.txt" -o -name "*.yaml" -o -name "*.yml" | head -3 || echo "No stack detected"`

## Security Audit: $1 (default: auto-detect)

Perform comprehensive security audit covering:

1. **Vulnerability Assessment** for technical security flaws
2. **Threat Modeling** for attack surface analysis
3. **Compliance Review** for regulatory requirements
4. **Security Controls Evaluation** for existing protections
5. **Penetration Testing** for exploitable weaknesses
6. **Risk Assessment** for business impact analysis

## Audit Scope: $2 (default: full-stack)

$ARGUMENTS

### Usage Examples:

```bash
/security-audit webapp full-stack "GDPR, SOC2"
/security-audit api application-level "OWASP Top 10"
/security-audit microservices infrastructure "PCI-DSS"
/security-audit mobile penetration-test
/security-audit cloud full-stack "ISO 27001, HIPAA"
/security-audit enterprise compliance "SOX, NIST"
```

### System Types:

- `webapp` - Web application security audit
- `api` - REST/GraphQL API security assessment
- `mobile` - iOS/Android mobile app security
- `microservices` - Distributed systems security
- `cloud` - Cloud infrastructure and services
- `enterprise` - Large-scale enterprise systems
- `iot` - Internet of Things device security
- `blockchain` - Smart contract and blockchain security

### Audit Scopes:

- `application-level` - Code, application logic, and implementation flaws
- `infrastructure` - Network, servers, and cloud configuration
- `full-stack` - Comprehensive security across all layers
- `compliance-focused` - Regulatory and standards compliance
- `penetration-test` - Active security testing and exploitation

### Compliance Standards:

- `OWASP` - OWASP Top 10 and secure coding practices
- `GDPR` - General Data Protection Regulation compliance
- `HIPAA` - Healthcare information privacy and security
- `PCI-DSS` - Payment card industry security standards
- `SOC2` - Service Organization Control 2 compliance
- `ISO 27001` - Information security management
- `NIST` - NIST Cybersecurity Framework
- `SOX` - Sarbanes-Oxley Act compliance

### Security Analysis Areas:

**🔍 Vulnerability Assessment:**

- SQL injection and XSS vulnerabilities
- Authentication and authorization flaws
- Input validation and sanitization issues
- Cryptographic weaknesses and implementation flaws
- Session management and token security
- File upload and inclusion vulnerabilities
- API security flaws and injection attacks

**🎯 Threat Modeling:**

- Attack surface analysis and identification
- Threat actor profiling and capability assessment
- Attack vector mapping and exploitation chains
- Business logic flaw identification
- Social engineering and human factor risks
- Supply chain and third-party dependency risks
- Insider threat and privilege escalation risks

**🛡️ Security Controls Evaluation:**

- Access control and identity management
- Network security and firewall configurations
- Encryption and data protection measures
- Logging, monitoring, and incident response
- Backup and disaster recovery capabilities
- Security awareness and training programs
- Physical security and environmental controls

**📋 Compliance Assessment:**

- Regulatory requirement mapping
- Policy and procedure documentation review
- Control implementation and effectiveness testing
- Gap analysis and remediation planning
- Audit trail and evidence collection
- Reporting and documentation requirements

**🔬 Penetration Testing:**

- Network penetration testing
- Web application penetration testing
- API security testing
- Mobile application security testing
- Social engineering testing
- Physical security testing
- Wireless network security testing

### Audit Deliverables:

**1. Executive Summary**

- Critical security risks and immediate actions
- Compliance status and regulatory gaps
- Business impact and risk prioritization
- Resource requirements and timeline estimates

**2. Technical Findings**

- Detailed vulnerability descriptions with evidence
- Exploitation scenarios and proof-of-concepts
- Risk scoring and severity ratings
- Technical remediation recommendations

**3. Compliance Report**

- Regulatory requirement compliance status
- Gap analysis with specific control deficiencies
- Remediation plans and implementation guidance
- Audit evidence and documentation requirements

**4. Security Roadmap**

- Prioritized remediation timeline
- Resource allocation and budget planning
- Security improvement initiatives
- Monitoring and continuous improvement plan

**5. Incident Response Plan**

- Security incident handling procedures
- Communication and escalation protocols
- Business continuity and disaster recovery
- Forensic investigation and evidence preservation

### Risk Assessment Framework:

**🔴 Critical Risks**

- Immediate threats requiring urgent action
- Regulatory compliance failures
- High-impact security vulnerabilities

**🟠 High Risks**

- Significant security gaps
- Potential compliance violations
- Business-impacting security issues

**🟡 Medium Risks**

- Important security improvements
- Best practice implementations
- Moderate compliance gaps

**🟢 Low Risks**

- Minor security enhancements
- Defense-in-depth improvements
- Future security considerations

### Specialized Audits:

- `/security-audit webapp owasp "E-commerce platform"` - OWASP-focused web app audit
- `/security-audit api authentication "REST API gateway"` - API authentication security
- `/security-audit cloud aws "Infrastructure as code"` - Cloud security assessment
- `/security-audit mobile ios "Banking application"` - Mobile security audit

The security audit includes:

- Comprehensive vulnerability scanning and assessment
- Current threat intelligence integration
- Industry best practices and standards compliance
- Actionable remediation guidance
- Risk-based prioritization framework
- Continuous security monitoring recommendations

Focus on identifying real security risks while providing practical, actionable recommendations that improve security posture and ensure regulatory compliance.
