# Kanagamalar C — Developer Portfolio

Static portfolio website (HTML, CSS, JavaScript; no frameworks) for **Kanagamalar C**, B.Tech CSE (AI & ML) student at PMIST. Designed to be hosted on **Amazon S3 + Amazon CloudFront**.

## Structure

```text
kanagamalar-portfolio/
├── index.html
├── style.css
├── script.js
├── README.md
├── deploy.sh                 # optional helper: sync to S3 + invalidate CloudFront
├── .gitignore
├── assets/
│   ├── profile.jpg           # TODO: add your photo (page shows "KC" until you do)
│   └── Kanagamalar_C_Resume.pdf   # TODO: add your resume PDF
└── docs/
    ├── AWS_DEPLOYMENT.md     # step-by-step S3 + CloudFront + Route 53 guide
    ├── GITHUB_GUIDE.md       # repo structure, README template, security
    └── PROFILE_README_for_Kanagamalar_repo.md  # paste into Kanagamalar/Kanagamalar
```

## Placeholders to replace before publishing

Email and LinkedIn are already filled in from your resume. Search the project for `YOUR_` and replace the rest:

| Placeholder | Where | Replace with |
|---|---|---|
| `YOUR_PORTFOLIO_URL` | `index.html` (Contact, canonical tag) | your deployed site URL |
| `YOUR_NPTEL_CERTIFICATE_URL` | `index.html` (Learning → The Joy of Computing using Python) | link to your NPTEL certificate |
| `YOUR_DOMAIN.com` | docs / AWS steps | your real domain |

Until replaced, placeholder links are disabled automatically by `script.js`.

## Run locally

Open `index.html` in a browser, or:

```bash
python -m http.server 8000
# then visit http://localhost:8000
```

## Deploy

See [`docs/AWS_DEPLOYMENT.md`](docs/AWS_DEPLOYMENT.md).

## Content policy

Everything on the site reflects information provided by the owner. Add new achievements, certificates or scores only when verified.

## Security

No API keys, AWS access keys, passwords or `.env` files belong in this repository.

## License

TODO: choose a license (for example MIT) or keep all rights reserved.
