---
description: 'Generate comprehensive tests for code'
argument-hint: '[test-type] [coverage-target]'
---

## Context

- Testing framework: !`find . -name "jest.config.*" -o -name "pytest.ini" -o -name "vitest.config.*" | head -1 || echo "No test framework detected"`
- Existing tests: !`find . -name "*.test.*" -o -name "*test*" | wc -l` test files found
- Package scripts: !`cat package.json 2>/dev/null | grep -A 5 '"test"' || echo "No test scripts found"`
- Source files: !`find . -name "*.js" -o -name "*.py" -o -name "*.ts" | grep -v test | wc -l` source files to test

## Test Type: $1 (default: comprehensive)

Generate comprehensive tests for this code. Include:

1. **Unit tests** for individual functions/components
2. **Integration tests** for component interactions
3. **Edge case testing** for boundary conditions
4. **Error handling tests** for failure scenarios
5. **Performance tests** if applicable
6. **Mock/stub creation** for external dependencies

## Coverage Target: $2 (default: 80%)

$ARGUMENTS

### Usage Examples:

```bash
/test unit @src/utils.js
/test integration @api/
/test e2e @app/
/test performance @services/
/test 95 @src/components/
/test all @src/
/test "component testing" @ui/
```

### Test Types:

- `unit` - Individual function/component tests
- `integration` - Component interaction tests
- `e2e` - End-to-end application tests
- `performance` - Performance and load tests
- `component` - UI component testing
- `api` - API endpoint testing
- `security` - Security vulnerability tests
- `all` - Comprehensive test suite

### Coverage Targets:

- `50-60` - Basic coverage for small projects
- `70-80` - Good coverage for most projects
- `85-95` - High coverage for critical applications
- `100` - Full coverage (may not always be practical)

Use appropriate testing frameworks and patterns for the language/technology stack. Ensure tests are:

- Descriptive and self-documenting
- Independent and isolated
- Fast and reliable
- Covering both happy paths and error cases
- Following AAA pattern (Arrange, Act, Assert)
- Including proper setup and teardown
- Using meaningful test data and mocks

The test generation will include:

- Test file structure and organization
- Mock/stub implementations for dependencies
- Test data factories and fixtures
- Configuration files for the testing framework
- Scripts for running tests and generating coverage reports
- CI/CD integration for automated testing
