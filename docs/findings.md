# Based on the tools and manual code review I have summarized my findings below

## Tooling
| Category | Tool |
|---|---|---|
| SAST | Semgrep (`p/python`, `p/fastapi`, `p/owasp-top-ten`) 
| SCA | Trivy (`fs` on `requirements.txt`) 
| Container | Trivy (image) 
| IaC | Checkov

## Overall Findings

<!-- Gates only on SAST/SCA -->
SAST (Semgrep) - 2 Critical, 1 High , 1 Low Findings
SCA (Trivy) - 27 total ,  2 Critical/ 10 High Findings

## Findings Summary
1. Plaintext password logged

tool: Manual / Semgrep - SAST
location: app/main.py - 156 and 159
severity: High
business impact: medium - internal log monitoring tools can display sensitive information
source: starter code

2. SQL Injection

tool: Manual / Semgrep - SAST
location: app/database.py - 22
severity: CRITICAL
business impact: High - this can cause sensitive information disclosure
source: starter code

3. JWT none algorithm

tool: Semgrep - SAST
Location: app/auth.py:38
severity: HIGH
business impact: High - accepting algorithm from user or setting it to none may lead to jwt nonce attack - a forged token can grant access to everything
source: starter code


4. python-jose 3.3.0

tool: Trivy - SCA
location: requirements.txt
severity: High
business impact: High - the library is used in unauthenticated api route which can cause account takeover, also no fix available for CVE-2026-85394 - switch to pyjwt recommended
source: starter code

5. python-multipart 0.0.6 (9 findings)

tool: Trivy - SCA
location: requirements.txt
severity: High
business impact: High - Crafted requests could take down the API, including login
source: starter code


6. cryptography 38.0.1

tool: Trivy - SCA
location: requirements.txt
severity: Medium
business impact: Low - mostly DoS attacks possible
source: starter code

7. pytest 7.4.3

tool: Trivy - SCA
location: requirements.txt
severity: Low
business impact: Low - Test tools are not necessary for production build
source: starter code

