[![Judge0 Wallpaper](./.github/Judge0%20Wallpaper%2002%20Center%20White%208192x4608.png)](https://judge0.com)

# Judge0
[![X (formerly Twitter) Follow](https://img.shields.io/twitter/follow/Judge0HQ)](https://x.com/Judge0HQ)
[![X (formerly Twitter) Follow](https://img.shields.io/twitter/follow/hermanzvonimir)](https://x.com/hermanzvonimir)

[![License](https://img.shields.io/github/license/judge0/judge0?color=2185d0&style=flat-square)](LICENSE)
[![Release](https://img.shields.io/github/v/release/judge0/judge0?color=2185d0&style=flat-square)](https://github.com/judge0/judge0/releases)
[![Stars](https://img.shields.io/github/stars/judge0/judge0?color=2185d0&style=flat-square)](https://github.com/judge0/judge0/stargazers)

Established in August 2016.

Code execution made simple for every business.

Robust, fast, scalable, and sandboxed open-source online code execution system for humans and AI.

## Table of Contents

* [About](#about)
* [Features](#features)
* [Get Started](#get-started)

## About

[Judge0](https://judge0.com) (pronounced like "judge zero") is a robust, scalable, and [open-source](https://github.com/judge0/judge0) **online code execution system**. You can use it to build a wide range of applications that need online code execution features. Some examples include AI agents, competitive programming platforms, e-learning platforms, candidate assessment and recruitment platforms, online code editors, online IDEs, and many more.

Judge0 is an open-source online code execution system that enables the robust, fast, scalable, and sandboxed execution of AI-generated code, with support for multiple languages and frameworks.

In our research paper [Robust and Scalable Online Code Execution System](https://paper.judge0.com), we present Judge0's modern modular architecture that can be easily deployed and scaled. We study its design, comment on the various challenges in building such systems, and compare it with other available online code execution systems and online judge systems.

To see Judge0 in action, try [Judge0 IDE](https://ide.judge0.com) - our free and open-source online code editor.

## Features

* [Self-hostable](https://github.com/judge0/judge0/blob/master/CHANGELOG.md#deployment-procedure) or [fully managed (SaaS)](https://judge0.com#pricing)
* Quick and easy self-hosting [installation](https://github.com/judge0/judge0/blob/master/CHANGELOG.md#deployment-procedure)
* Rich and verbose [API documentation](https://ce.judge0.com)
* Simple HTTP JSON API for easy integration
* [Official Python SDK](https://github.com/judge0/judge0-python) for easy integration
* Scalable architecture for handling high loads
* Sandboxed compilation and execution of untrusted code
* Support for 90+ languages (see the full [list of supported languages](https://ide.judge0.com))
* Compilation and execution of multi-file programs (i.e. projects)
* Support for additional files alongside the single-file user's program
* Support for custom user-defined compiler options, command-line arguments, and time and memory limits
* Detailed execution results
* Webhooks (HTTP callbacks)

For more information about these and other features, please [read the documentation](https://ce.judge0.com).

## Get Started

You have plenty of options to get started with Judge0:
1. [Use our Judge0 Cloud via Rapid](https://rapidapi.com/organization/judge0)
2. [Use our Judge0 Cloud by directly working with us](https://judge0.com/#pricing)
3. [Self-host Judge0 on your own infrastructure](https://github.com/judge0/judge0/blob/master/CHANGELOG.md#deployment-procedure)

Integrating Judge0 into your application is easy. You can either use our simple HTTP JSON API or use our [official Python SDK](https://github.com/judge0/judge0-python).

### HTTP JSON API
```bash
curl \
  -H "Content-Type: application/json" \
  -d '{
      "language_id": 109,
      "source_code": "print(f\"hello, {input()}\")",
      "stdin": "Alice"
  }' \
  "https://ce.judge0.com/submissions?wait=true"
```

### Python SDK
```python
# pip install judge0
import judge0
result = judge0.run(source_code="print(f'hello, {input()}')", stdin="Alice", language=judge0.PYTHON)
print(result.stdout)
```

Judge0 is licensed under the [GNU General Public License v3.0](LICENSE).
