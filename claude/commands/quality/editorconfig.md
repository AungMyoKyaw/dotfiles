# Generate EditorConfig

Generates a comprehensive and best-practice-oriented .editorconfig file based on project analysis and user preferences.

## Usage

```bash
/editorconfig [project-type] [indent-style=space|tab] [indent-size=2|4]
```

## Description

The EditorConfig Expert analyzes your project structure and generates a robust `.editorconfig` file that ensures consistent coding styles across different editors and IDEs. The command incorporates universal best practices and provides clear, rule-by-rule explanations for all configuration choices.

## Parameters

- **project-type** (optional): The type of project (e.g., web, python, java, go, javascript, typescript, etc.)
- **indent-style** (optional): Indentation style - `space` (default) or `tab`
- **indent-size** (optional): Indentation size - `2` (default) or `4`

## Examples

```bash
/editorconfig web
/editorconfig python indent-style=tab indent-size=4
/editorconfig javascript indent-style=space indent-size=2
```

## Output

The command generates:

1. A complete `.editorconfig` file content
2. Detailed rule-by-rule explanations
3. Project-specific optimizations

## Best Practices Included

- Proper root declaration
- Universal character encoding (UTF-8)
- Line ending standardization (LF)
- Whitespace management
- Language-specific configurations
- File type glob patterns
- IDE compatibility settings

---

_This command ensures consistent code formatting across all development environments and team members._
