#!/usr/bin/env bash
# install-hooks.sh — Install pre-commit and all required hook dependencies,
# then activate the git hooks for this repository.
#
# Usage:
#   ./install-hooks.sh          # install everything
#   ./install-hooks.sh --check  # only verify tooling is present, don't install
set -euo pipefail

CHECK_ONLY=false
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=true

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

# ── Colour helpers ────────────────────────────────────────────────────────────
GREEN="\033[0;32m"; YELLOW="\033[1;33m"; RED="\033[0;31m"; RESET="\033[0m"
ok()   { echo -e "${GREEN}✔${RESET}  $*"; }
warn() { echo -e "${YELLOW}⚠${RESET}  $*"; }
fail() { echo -e "${RED}✘${RESET}  $*"; exit 1; }

# ── Tool detection ────────────────────────────────────────────────────────────
need() {
  local cmd="$1" install_hint="$2"
  if ! command -v "$cmd" &>/dev/null; then
    if $CHECK_ONLY; then
      fail "Missing: $cmd  →  $install_hint"
    fi
    return 1
  fi
  ok "$cmd $(${cmd} --version 2>&1 | head -1)"
  return 0
}

echo ""
echo "═══════════════════════════════════════════"
echo "  terraform-xo-microk8s — pre-commit hook installer"
echo "═══════════════════════════════════════════"
echo ""

# ── 1. pre-commit ─────────────────────────────────────────────────────────────
if ! need pre-commit "pip install pre-commit  OR  brew install pre-commit"; then
  warn "Installing pre-commit via pip..."
  pip install --quiet pre-commit
fi

# ── 2. tflint ─────────────────────────────────────────────────────────────────
if ! need tflint "https://github.com/terraform-linters/tflint#installation"; then
  if command -v brew &>/dev/null; then
    warn "Installing tflint via brew..."
    brew install tflint
  elif command -v snap &>/dev/null; then
    warn "Installing tflint via snap..."
    sudo snap install --classic tflint
  else
    warn "Downloading tflint binary..."
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
  fi
fi

# ── 3. terraform (for terraform_validate hook) ────────────────────────────────
if ! need terraform "https://developer.hashicorp.com/terraform/install"; then
  warn "terraform not found — terraform_validate hook will be skipped."
fi

# ── 4. trivy ──────────────────────────────────────────────────────────────────
if ! need trivy "https://aquasecurity.github.io/trivy/latest/getting-started/installation/"; then
  if command -v brew &>/dev/null; then
    warn "Installing trivy via brew..."
    brew install trivy
  elif command -v apt-get &>/dev/null; then
    warn "Installing trivy via apt..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sudo bash -s -- -b /usr/local/bin
  elif command -v snap &>/dev/null; then
    warn "Installing trivy via snap..."
    sudo snap install trivy
  else
    warn "Installing trivy binary directly..."
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | bash -s -- -b /usr/local/bin
  fi
fi

# ── 5. Install / update git hooks ─────────────────────────────────────────────
if $CHECK_ONLY; then
  ok "All tools present — run without --check to activate git hooks."
  exit 0
fi

echo ""
echo "Installing pre-commit hooks into .git/hooks ..."
pre-commit install
pre-commit install --hook-type commit-msg

# Optionally update all hook revisions to latest
if [[ "${UPDATE_HOOKS:-false}" == "true" ]]; then
  echo "Updating hook revisions..."
  pre-commit autoupdate
fi

echo ""
ok "Done! Hooks will run automatically on every 'git commit'."
echo "   Run manually with:  pre-commit run --all-files"
echo ""
