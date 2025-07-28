---
title: "Code Formatter Setup"
description: "Guide for setting up a code formatter in your project. Includes Prettier for JS/TS/HTML and general advice for other languages."
version: "1.0.0"
created: "2025-07-28"
mode: "interactive"
category: "development"
tags:
  - formatter
  - prettier
  - setup
  - config
  - guide
  - javascript
  - typescript
difficulty: "beginner"
---

# Code Formatter Setup Prompt

## Purpose

Guide for setting up a code formatter in your project. This prompt will help you configure formatting for JavaScript/TypeScript/HTML projects using Prettier, and provide general advice for other languages.

---

## 1. Detect Project Language

- Identify if your project is JavaScript, TypeScript, or HTML-based.
- If so, follow the Prettier setup below.
- For other languages, see the general advice section.

---

## 2. JavaScript/TypeScript/HTML Projects: Prettier Setup

### a. Install Prettier

```sh
npm install --save-dev prettier
```

### b. Create Prettier Config

Create a `.prettierrc` file in your project root with the following content:

```json
{
  "trailingComma": "none"
}
```

### c. Add Format Script to package.json

Add the following script to your `package.json`:

```json
"scripts": {
  "format": "prettier --write ."
}
```

### d. Run Formatter

```sh
npm run format
```

---

## 3. Other Languages: General Formatter Setup

- **Python:** Use [Black](https://black.readthedocs.io/en/stable/):
  - Install: `pip install black`
  - Format: `black .`
- **Go:** Use [gofmt](https://golang.org/cmd/gofmt/):
  - Format: `gofmt -w .`
- **Rust:** Use [rustfmt](https://github.com/rust-lang/rustfmt):
  - Format: `cargo fmt`
- **Lua:** Use [lua-format](https://github.com/Koihik/LuaFormatter):
  - Install and run as per documentation.
- **Other:** Research the recommended formatter for your language and set up a config/script as needed.

---

## 4. Editor Integration

- Consider installing editor extensions for your formatter (e.g., Prettier for VS Code).
- Enable "Format on Save" for a seamless workflow.

---

## 5. Additional Tips

- Add your formatter config files to version control.
- Document formatter usage in your project README.
- Run the formatter before committing code.
