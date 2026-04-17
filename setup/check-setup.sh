#!/usr/bin/env bash
set -uo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

PASS=0
FAIL=0

pass() {
  printf "${GREEN}  ✓ %s${RESET}\n" "$1"
  ((PASS++))
}

fail() {
  printf "${RED}  ✗ %s${RESET}\n" "$1"
  ((FAIL++))
}

# Compare two semver strings: returns 0 if $1 >= $2
version_gte() {
  local IFS='.'
  local -a a=($1) b=($2)
  for i in 0 1 2; do
    local va=${a[$i]:-0}
    local vb=${b[$i]:-0}
    if (( va > vb )); then return 0; fi
    if (( va < vb )); then return 1; fi
  done
  return 0
}

printf "\n${BOLD}Terraform Course — Environment Check${RESET}\n\n"

# --- Terraform >= 1.6 ---
if command -v terraform &>/dev/null; then
  tf_version=$(terraform -version 2>/dev/null | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
  if [ -n "$tf_version" ] && version_gte "$tf_version" "1.6.0"; then
    pass "Terraform $tf_version (>= 1.6 required)"
  else
    fail "Terraform $tf_version found — >= 1.6 required"
  fi
else
  fail "Terraform not found"
fi

# --- Docker running ---
if command -v docker &>/dev/null; then
  if docker ps &>/dev/null; then
    docker_version=$(docker --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    pass "Docker $docker_version (daemon running)"
  else
    fail "Docker installed but daemon is not running (docker ps failed)"
  fi
else
  fail "Docker not found"
fi

# --- Git >= 2.0 ---
if command -v git &>/dev/null; then
  git_version=$(git --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  if [ -n "$git_version" ] && version_gte "$git_version" "2.0.0"; then
    pass "Git $git_version (>= 2.0 required)"
  else
    fail "Git $git_version found — >= 2.0 required"
  fi
else
  fail "Git not found"
fi

# --- VS Code ---
if command -v code &>/dev/null; then
  code_version=$(code --version 2>/dev/null | head -1)
  pass "VS Code $code_version"
else
  fail "VS Code (code) not found — install from https://code.visualstudio.com"
fi

# --- Summary ---
TOTAL=$((PASS + FAIL))
printf "\n${BOLD}Results: ${GREEN}${PASS}/${TOTAL} passed${RESET}"
if (( FAIL > 0 )); then
  printf ", ${RED}${FAIL} failed${RESET}"
fi
printf "\n\n"

if (( FAIL > 0 )); then
  exit 1
fi
