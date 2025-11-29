---
description: 'Conduct comprehensive security review of code'
---

## Context

- Dependency scan: !`npm audit 2>/dev/null || pip list --outdated 2>/dev/null || echo "No package manager found"`
- Environment variables: !`env | grep -E "(KEY|SECRET|TOKEN|PASSWORD)" | head -3 || echo "No obvious secrets found"`
- Network exposure: !`find . -name "*.js" -o -name "*.py" | xargs grep -l "http\|api\|server" 2>/dev/null | head -5 || echo "No network code found"`
- Authentication patterns: !`find . -name "*.js" -o -name "*.py" | xargs grep -l "auth\|login\|session" 2>/dev/null | head -5 || echo "No auth code found"`

## Threat Model: $1 (default: comprehensive)

Perform a thorough security review of this code. Analyze for:

1. **Injection vulnerabilities** (SQL, XSS, Command injection, etc.)
2. **Authentication and authorization issues**
3. **Data exposure and privacy concerns**
4. **Cryptography and sensitive data handling**
5. **Input validation and sanitization**
6. **Configuration and secrets management**
7. **Dependency security issues**
8. **API security best practices**
9. **Error handling that might leak information**
10. **Cross-site request forgery (CSRF) and other web vulnerabilities**

## Compliance Standard: $2 (optional)

$ARGUMENTS

### Usage Examples:

```bash
/security-review owasp @api/
/security-review "gdpr" @user-service.js
/security-review "payment processing" @billing/
/security-review "authentication" @auth/
/security-review hipaa @healthcare-app.py
/security-review all @src/
```

### Threat Models:

- `owasp` - OWASP Top 10 vulnerabilities
- `injection` - SQL, XSS, command injection focus
- `authentication` - Auth and authorization issues
- `data` - Data exposure and privacy
- `crypto` - Cryptography and secrets handling
- `api` - API security best practices
- `infrastructure` - Configuration and deployment security
- `all` - Comprehensive security assessment

### Compliance Standards:

- `gdpr` - General Data Protection Regulation
- `hipaa` - Healthcare information privacy
- `pci` - Payment Card Industry standards
- `soc2` - Service Organization Control 2
- `iso27001` - Information security management

Provide specific remediation steps with code examples for any issues found, including:

- Severity assessment (Critical/High/Medium/Low)
- Exploitation scenarios
- Remediation priority
- Code fixes with examples
- Prevention strategies
- Compliance mapping (if applicable)
- Security testing recommendations
