# GitHub guide

## Profile bio

> B.Tech CSE (AI & ML) | AI/ML & Computer Vision | Python | AWS | Building intelligent systems

(Under GitHub's 160-character bio limit. Add `Thanjavur, India` in the Location field.)

## Suggested repository structure

These repositories **do not exist yet**. Create each one only when you have real code and a clean README.

| Suggested name | Based on |
|---|---|
| `building-defect-risk-assessment` | Final-year project (mark "In Progress") |
| `medibot-rag-chatbot` | Medibot, Astonish InfoTech internship |
| `ev-charging-station-locator` | PHP, MySQL, Leaflet |
| `nlp-sentiment-analysis` | NLP project |
| `distributed-financial-database` | Distributed database project |
| `aws-cloud-learning` | S3, EC2, SageMaker notes |
| `aws-cloud-resume` | Cloud Resume Challenge |
| `portfolio` | This website |

## Pinned repositories (eventually)

Priority order: 1) building defect project, 2) Medibot, 3) AWS/cloud project, 4) EV Charging Station Locator, 5) NLP sentiment analysis, 6) portfolio.

**Pin a repository only after** it has a clean README, meaningful code and no secrets. An empty or messy pinned repo hurts more than it helps. Team projects: confirm teammates agree before publishing, and credit them in Contributors.

## Project README template

Use this for every real project repository. Keep `TODO` wherever you do not yet have facts.

```markdown
# Project Title

## Overview
TODO: Add project-specific information

## Problem Statement
TODO: Add project-specific information

## Objectives
- TODO: Add project-specific information

## Features
- TODO: Add project-specific information

## Technology Stack
TODO: Add project-specific information

## Architecture
TODO: Add project-specific information (diagram or description)

## Folder Structure
TODO: Add project-specific information

## Installation
1. Clone the repository
2. Create a virtual environment and install dependencies
3. Copy `.env.example` to `.env` and fill in your own keys (never commit `.env`)

## Usage
TODO: Add project-specific information

## Screenshots
TODO: Add screenshots

## Future Improvements
- TODO: Add project-specific information

## Limitations
- TODO: Add project-specific information

## Contributors
- Kanagamalar C ([@Kanagamalar](https://github.com/Kanagamalar))
- TODO: Add teammates (if a team project)

## License
TODO: Choose a license
```

Note for the final-year project README: state "Final-Year Project — In Progress" and do not publish accuracy numbers until you have real, measured results. For Medibot: describe it as an educational, information-oriented Q&A chatbot, not a medical diagnosis tool.

## Security: keep secrets out of GitHub

Never commit API keys (Cohere, Pinecone, Hugging Face), AWS access keys, tokens, passwords or `.env` files.

### `.gitignore` (starter, Python + Node)

```gitignore
# Secrets
.env
.env.*
!.env.example
*.pem
*.key
.aws/

# Python
__pycache__/
*.pyc
.venv/
venv/

# Node
node_modules/
dist/
build/

# OS / editor
.DS_Store
Thumbs.db
.vscode/
.idea/
*.log
```

### `.env.example` (safe to commit: names only, no real values)

```dotenv
# Copy to .env and fill in your own values. Never commit .env.
COHERE_API_KEY=your_cohere_api_key_here
PINECONE_API_KEY=your_pinecone_api_key_here
PINECONE_INDEX_NAME=your_index_name_here
HUGGINGFACEHUB_API_TOKEN=your_huggingface_token_here
FLASK_SECRET_KEY=generate_a_random_value
```

### Using environment variables in Python / Flask

```python
# pip install python-dotenv
import os
from dotenv import load_dotenv

load_dotenv()  # reads .env locally; in the cloud, set real environment variables instead
cohere_key = os.environ["COHERE_API_KEY"]  # raises an error if missing, which is what you want
```

On AWS, store secrets in **AWS Secrets Manager** or **Systems Manager Parameter Store**, or set environment variables on the service, not in code.

### If a key was already committed

1. **Revoke / rotate the key immediately** at the provider. This is the most important step: deleting the file later does not remove it from Git history.
2. Remove it from history (for example with `git filter-repo`) or recreate the repository.
3. Check provider dashboards for unexpected usage.

### GitHub security features to turn on

In each repository: **Settings > Code security** (or Security & analysis):

- **Secret scanning** and **push protection** (blocks pushes that contain recognized secrets)
- **Dependabot alerts** (and optionally security updates)
- **Code scanning** with CodeQL
- **Private vulnerability reporting**

Also enable **two-factor authentication** on your GitHub account. Availability of some features depends on repository visibility and plan; check the Settings page for what you can enable.
