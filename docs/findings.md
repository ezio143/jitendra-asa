# Based on the tools and manual code review I have summarized my findings below

## Tooling

| SAST - Semgrep (`p/python`, `p/fastapi`, `p/owasp-top-ten`) 

| SCA - Trivy (`fs` on `requirements.txt`) 

| Container - Trivy (image) 

| IaC - Checkov

## Overall Findings

<!-- Gates only on SAST/SCA -->

SAST (Semgrep) - 2 Critical, 1 High , 1 Low Findings
SCA (Trivy) - 27 total ,  2 Critical/ 10 High Findings
Manual Findings - 

## Findings Summary

| # | Finding | Tool | Location | Severity | Business Impact | Source |
|---|---------|------|----------|----------|-----------------|--------|
| 0 | Hardcoded credentials | Manual - SAST | `app/config.py` | Critical | **High** - Credential theft from repositories may lead to sensitive information disclosure | Starter code |
| 1 | Plaintext password logged | Manual / Semgrep - SAST | `app/main.py:156`, `app/main.py:159` | High | **Medium** - Internal log monitoring tools can display sensitive information | Starter code |
| 2 | SQL Injection | Manual / Semgrep - SAST | `app/database.py:22` | Critical | **High** - Can cause sensitive information disclosure | Starter code |
| 3 | JWT `none` algorithm | Semgrep - SAST | `app/auth.py:38` | High | **High** - Accepting the algorithm from the user or setting it to `none` may lead to a JWT nonce attack; a forged token can grant access to everything | Starter code |
| 4 | python-jose 3.3.0 | Trivy - SCA | `requirements.txt` | High | **High** - Library is used in an unauthenticated API route, which can cause account takeover; no fix available for CVE-2026-85394 - vulnerability is mitigated and exception used to pass cicd piple, switch to PyJWT recommended | Starter code |
| 5 | python-multipart 0.0.6 (9 findings) | Trivy - SCA | `requirements.txt` | High | **High** - Crafted requests could take down the API, including login | Starter code |
| 6 | cryptography 38.0.1 | Trivy - SCA | `requirements.txt` | Medium | **Low** - Mostly DoS attacks possible | Starter code |
| 7 | pytest 7.4.3 | Trivy - SCA | `requirements.txt` | Low | **Low** - Test tools are not necessary for the production build | Starter code |