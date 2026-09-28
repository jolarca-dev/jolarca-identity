# jolarca-identity

**Identity management, access control, RBAC policy, and joiner/mover/leaver
automation for the `jolarca-dev` marketplace.**

> **Compliance:** SOC 2 Type II (CC6.1–CC6.3) · ISO 27001:2022 (A.5.15–A.5.18)
> · PCI-DSS 4.0 (Req 7, 8) · GDPR (Art. 32)

---

## Purpose

This repository is the **authoritative source for IAM policy** in the
marketplace fleet. It defines:

- **Who** may access what (RBAC policy as code)
- **How** identities are provisioned, moved, and deprovisioned (JML automation)
- **When** access is reviewed and by whom (access review procedures)
- **What** authentication standards apply (MFA, credentials, sessions)

## What this repository is NOT

**This repository holds the machinery, not the records.**

Evidence of completed access reviews, signed attestations, and audit trails is
stored in [`jolarca-compliance`](https://github.com/jolarca-dev/jolarca-compliance).
An auditor examining the marketplace's access-control posture reads *this* repo
for the policy and *jolarca-compliance* for the proof that the policy was
followed. The separation is deliberate: policy and evidence must not share a
repository, because the same repository cannot be both the rule-maker and the
proof-of-compliance.

| Repository | Role |
|---|---|
| `jolarca-identity` (this repo) | IAM policy, RBAC definitions, JML procedures, access review procedures |
| `jolarca-compliance` | Evidence: completed review records, signed attestations, audit logs |
| `jolarca-security` | Threat models, vulnerability management, incident response |

## Repository Structure

```
jolarca-identity/
├── .github/
│   ├── CODEOWNERS                  # Code ownership (ADR-0004 R4)
│   └── workflows/
│       └── ci.yml                  # CI: gitleaks history scan + shellcheck
├── policies/
│   ├── access-control-policy.md    # Master access control policy (A.5.15, CC6.1)
│   ├── authentication-standards.md # Authentication requirements (A.5.17, CC6.3)
│   └── rbac.md                     # RBAC model as code (A.5.15, CC6.1)
├── lifecycle/
│   └── joiner-mover-leaver.md      # JML automation procedures (A.5.16, CC6.2)
├── access-reviews/
│   └── procedure.md                # Access review procedure (A.5.18, CC6.1)
├── roles/
│   └── role-definitions.md         # Role catalogue and permission matrix
├── metrics/
│   └── access-review-metrics.md    # KPIs and reporting for access reviews
├── scripts/
│   ├── hooks/
│   │   ├── pre-commit              # gitleaks scan of staged changes
│   │   └── pre-push                # gitleaks scan before push
│   └── install-hooks.sh            # Hook installer (run after cloning)
├── .gitignore
├── CONTRIBUTING.md                 # Contribution workflow and compliance gates
├── SECURITY.md                     # Vulnerability disclosure policy
├── README.md                       # This file
├── pyproject.toml                  # Python project metadata (docs-only repo)
└── LICENSE                         # Proprietary — All Rights Reserved
```

## Compliance Framework Mapping

| Framework | Controls Covered |
|---|---|
| SOC 2 Type II | CC6.1 (logical access), CC6.2 (authentication), CC6.3 (security events) |
| ISO 27001:2022 | A.5.15 (identity mgmt), A.5.16 (auth info), A.5.17 (access rights), A.5.18 (access review) |
| PCI-DSS 4.0 | Req 7 (least privilege / access control), Req 8 (authentication management) |
| GDPR | Art. 32 (security of processing — identity and access aspects) |

## Current Status

**Operational.** Published at
[`jolarca-dev/jolarca-identity`](https://github.com/jolarca-dev/jolarca-identity)
and declared in the
[`jolarca-control`](https://github.com/jolarca-dev/jolarca-control) fleet
allow-list (`repos/jolarca-identity.yml`).

### Known Dependencies

- **D-10 (no teams in `jolarca-dev`):** The RBAC model and role definitions in
  this repository assume that GitHub teams will be created when the second
  operator onboards. Until then, all access is via org ownership and the RBAC
  policy serves as the *target-state definition*, not the live enforcement.
- **D-18 (2FA not enforced):** Authentication standards defined here are
  aspirational until org-wide 2FA is enabled manually in the GitHub UI.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for the branch → signed commit →
PR → review workflow and the local hook setup. Changes to IAM policy are
**security changes** and require the full compliance gate set: secret scan,
lint, and security review.

## License

Proprietary — All Rights Reserved. See [`LICENSE`](LICENSE). This repository
contains governance policy, not software; no OSS license is granted.
