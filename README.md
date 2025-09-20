# Sairen

![Logo](assets/logo.svg)

Sairen is a suite of AI tools written in Pharo Smalltalk
that provides wrappers for Large Language Model (LLM) APIs.
It's designed to simplify the process of integrating LLM functionalities like:

- Text generation
- Image generation
- Audio transcription

It also includes several usage examples and useful tools wrapping its own objects.

> *Name origin*: A play on words, [AI](https://en.wikipedia.org/wiki/Artificial_intelligence) +
> [Siren](https://en.wikipedia.org/wiki/Siren_(mythology)), reflecting how
> [LLMs](https://en.wikipedia.org/wiki/Large_language_model), in particular, resemble a siren's
> song—promising bliss to those who heed their call.

[![Unit Tests](https://github.com/ba-st/Sairen/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/ba-st/Sairen/actions/workflows/unit-tests.yml)
[![Coverage Status](https://codecov.io/github/ba-st/Sairen/coverage.svg?branch=release-candidate)](https://codecov.io/gh/ba-st/Sairen/branch/release-candidate)
[![Baseline Groups](https://github.com/ba-st/Sairen/actions/workflows/loading-groups.yml/badge.svg)](https://github.com/ba-st/Sairen/actions/workflows/loading-groups.yml)
[![Markdown Lint](https://github.com/ba-st/Sairen/actions/workflows/markdown-lint.yml/badge.svg)](https://github.com/ba-st/Sairen/actions/workflows/markdown-lint.yml)

[![GitHub release](https://img.shields.io/github/release/ba-st/Sairen.svg)](https://github.com/ba-st/Sairen/releases/latest)
[![Pharo 10](https://img.shields.io/badge/Pharo-10-informational)](https://pharo.org)
[![Pharo 11](https://img.shields.io/badge/Pharo-11-informational)](https://pharo.org)

## Quick links

- [**Explore the docs**](docs/README.md)
- [Report a defect](https://github.com/ba-st/Sairen/issues/new?labels=Type%3A+Defect)
- [Request a feature](https://github.com/ba-st/Sairen/issues/new?labels=Type%3A+Feature)

## Core Concepts and Usage

The project's design revolves around several key ideas:

- **API Abstraction:** Sairen encapsulates the complexities
of interacting with the Gemini API,
allowing developers to make requests for generative content
without needing to handle the underlying HTTP calls
and JSON formatting directly. This is seen in classes like
`GeminiTextPrompter` and `GeminiBase64ImagePrompter`, which handle
the specifics of communicating with the Gemini models.

- **Prompter-based Interaction:** The main way to use the library
is through "prompter" objects.
These objects, such as `GeminiTextPrompter` and `GeminiBase64ImagePrompter`,
are configured with an API key and specific parameters like
temperature and maximum tokens.
They have a `prompt:` method that takes a string or other data
and returns the generated content from the LLM.

- **Application-level Wrappers:** The project includes example applications
that demonstrate how to build useful tools on top of the prompter objects.
  - `SairenCodeReviewer`: This application takes a project's source code and
uses an LLM to generate a code review based on a detailed, specialized prompt.
  - `SairenCodingAssistant`: This acts as a centralized interface for
other tools, allowing you to ask questions about Smalltalk, explain methods,
or request a code review.
  - `SairenPharoTutor`: This is a conversational chat bot specifically
instructed to answer questions about Pharo Smalltalk and
related software engineering principles.
  - `SairenExampleWebView`: This is a web application that showcases
multimodal capabilities, generating a poem and an image based on a subject,
and translating spoken audio to text.

## License

- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).

## Installation

To load the project in a Pharo image follow these [instructions](docs/how-to/how-to-load-in-pharo.md).

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)

---

> *Icons by [Game-icons.net](https://game-icons.net/1x1/delapouite/mermaid.html)*
