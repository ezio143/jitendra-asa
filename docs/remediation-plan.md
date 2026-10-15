# Remediation Plan

## Python jose 3.3.0

tool : Trivy - SCA
cve  : CVE-2026-85394, 
severity    :   Critical (no official fix listed)
residual risk   : algorithm confusion via a DER-encoded public key as HMAC secret 
remediation : the library needs to be replaced with alternatives like PyJWT or Authlib
Mitigation  : using pinned algorithms