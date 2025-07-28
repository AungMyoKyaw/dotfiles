---
title: "EditorConfig Generator"
description: "Generate an .editorconfig file with 2-space indentation and spaces instead of tabs."
version: "1.0.0"
created: "2025-07-28"
mode: "interactive"
category: "development"
tags:
  - editorconfig
  - formatting
  - config
  - development
  - setup
difficulty: "beginner"
---

# EditorConfig Generator Prompt

Generate an `.editorconfig` file for a project with the following settings:

- Use spaces instead of tabs for indentation
- Set indentation size to 2 spaces

The generated `.editorconfig` file should look like this:

```
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

Include only the relevant settings for a typical project. Do not add unnecessary comments or sections.
