---
mode: "agent"
description: "Prompt for generating git commit messages using the Conventional Commits specification, with XML formatting and workflow guidance."
version: "1.0.0"
created: "2025-07-25"
---

<instructions>
	<title>Conventional Commit Prompt</title>
	<reference>https://www.conventionalcommits.org/en/v1.0.0/#specification</reference>
	<description>
		This prompt will guide you through creating a git commit message that conforms to the Conventional Commits specification. Follow each step and use the provided XML tags to structure your commit message.
	</description>
	<note>
        Just run the prompt and Copilot will commit your changes in the terminal for you.
	</note>
</instructions>

<workflow>
	<step>Run <cmd>git status</cmd> to review changed files.</step>
	<step>Run <cmd>git diff</cmd> or <cmd>git diff --cached</cmd> to inspect changes.</step>
	<step>Stage your changes with <cmd>git add &lt;file&gt;</cmd>.</step>
	<step>Construct your commit message using the following XML structure:</step>
	<step>After generating your commit message, Copilot will automatically run the following command in your integrated terminal (no confirmation needed):</step>
	<code>
	git commit -m "type(scope): description"
	</code>
	<step>Just execute this prompt and Copilot will handle the commit for you in the terminal.</step>
</workflow>

<commit-message>
	<type>feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert</type>
	<scope>()</scope>
	<description>A short, imperative summary of the change</description>
	<body>(optional: more detailed explanation)</body>
	<footer>(optional: e.g. BREAKING CHANGE: details, or issue references)</footer>
</commit-message>

<examples>
	<example>feat(parser): add ability to parse arrays</example>
	<example>fix(ui): correct button alignment</example>
	<example>docs: update README with usage instructions</example>
	<example>refactor: improve performance of data processing</example>
	<example>chore: update dependencies</example>
	<example>feat!: send email on registration (BREAKING CHANGE: email service required)</example>
</examples>

<validation>
	<type>Must be one of the allowed types. See <reference>https://www.conventionalcommits.org/en/v1.0.0/#specification</reference></type>
	<scope>Optional, but recommended for clarity.</scope>
	<description>Required. Use the imperative mood (e.g., "add", not "added").</description>
	<body>Optional. Use for additional context.</body>
	<footer>Use for breaking changes or issue references.</footer>
</validation>

<final-step>
	<cmd>git commit -m "type(scope): description"</cmd>
	<note>Replace with your constructed message. Include body and footer if needed.</note>
</final-step>
