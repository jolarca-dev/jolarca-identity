# Contributing to jolarca-identity

Changes to IAM policy are **security changes**. Every contribution passes the
full compliance gate set before it lands on `main`.

## Prerequisites

1. Install local git hooks (compensating control for GitHub Free plan limits):

   ```bash
   bash scripts/install-hooks.sh
   ```

   This installs the `pre-commit` and `pre-push` hooks (gitleaks secret
   scanning). Hooks are mandatory — do not bypass them with `--no-verify`.

2. Install [gitleaks](https://github.com/gitleaks/gitleaks#installing) and
   [shellcheck](https://www.shellcheck.net/). Without gitleaks the hooks skip
   with a warning, which is a degraded state — install it.

3. Configure GPG commit signing. All commits in this repository are signed;
   unsigned commits are rejected at review.

## Workflow

1. **Branch.** Never work directly on `main`. Create a feature branch:

   ```bash
   git switch -c <type>/<short-description>
   ```

2. **Commit.** One logical change per commit, in
   [Conventional Commits](https://www.conventionalcommits.org/) format
   (`type: lowercase description`), signed:

   ```bash
   git commit -S -m "fix: correct role permission matrix typo"
   ```

3. **Secrets and PII.** No credentials, tokens, customer data, or personal
   data beyond the committer's own git identity. If a secret is ever
   committed — even a brand-new one — STOP, rotate it, and document the
   incident before proceeding.

4. **Push.** Push the feature branch only. Server-side secret-scanning push
   protection is enabled; a rejected push means a real finding, not a
   nuisance — investigate it.

5. **Pull request.** Open a PR against `main` with:
   - a description of what changed and why,
   - linked issue or drift-finding / audit reference where applicable,
   - CI green (gitleaks full-history scan + shellcheck),
   - no unrelated files.

6. **Review and merge.** Resolve all review threads, confirm status checks
   are green, then merge. Branch protection is unavailable on the GitHub Free
   plan (drift findings D-19/D-33); until it is enabled, the merging admin is
   personally accountable for enforcing the PR gate that GitHub cannot.

## Policy-specific rules

- IAM policy changes SHOULD require review from a security-trained reviewer
  once the org has more than one operator (see `.github/CODEOWNERS`).
- Evidence of completed access reviews does **not** belong in this repository;
  it goes to `jolarca-compliance`. This repo holds machinery, not records.
- Compliance gaps discovered while contributing are recorded as drift
  findings in `jolarca-control/docs/drift-findings.md`, never silently fixed.
