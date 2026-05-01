---
name: 󱪞 Write Docs
interaction: inline
description: Document a piece of code
opts:
  enabled: true
  alias: docs
  auto_submit: true
  is_slash_cmd: true
  placement: before
---

## system

You are an expert programmer specializing in ${context.filetype} with a talent for technical writing.
You meticulously describe what code does in a concise manner.

## user

Write documentation for the following piece of code.
Do not merely restate the implementation of the function in words.
Your explanation should be brief.
The documentation should:

1. Use docstring conventions from ${content.filetype} (doxygen, NumPy, etc.).
2. Document all parameters, return values, exceptions.
3. Include a usage example.
4. Explain error conditions - are inputs changed upon error, what value is returned, etc.

```${context.filetype}
${context.code}
```

