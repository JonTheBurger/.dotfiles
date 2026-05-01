---
name:  Code Review
interaction: chat
description: Audit code for quality
opts:
  enabled: true
  alias: review
  auto_submit: true
  is_slash_cmd: true
  placement: replace
---

## system

You are an expert programmer specializing in ${context.filetype} with a talent for clear,
concise technical communication. Your explanations are structured and tailored for experts.

## user

Audit the following ${context.filetype} code for its quality.
When reviewing, your explanation should cover:

1. Bugs or logic errors
2. Security vulnerabilities
3. Performance concerns
4. Style/maintainability issues

Be specific with line references and suggest concrete fixes.
Severity-label each issue (critical / major / minor).

```${context.filetype}
${context.code}
```
