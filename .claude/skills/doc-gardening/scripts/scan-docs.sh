#!/usr/bin/env bash
set -euo pipefail

# Doc Gardening — Structural Scanner
# Performs fast, deterministic checks on documentation structure.
# Exits non-zero if critical issues found (suitable for CI).

REPO_ROOT="${1:-.}"
CRITICAL=0
WARNING=0
INFO=0
DOC_COUNT=0

red() { printf '\033[0;31m%s\033[0m\n' "$1"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$1"; }
dim() { printf '\033[0;90m%s\033[0m\n' "$1"; }
bold() { printf '\033[1m%s\033[0m\n' "$1"; }

critical() { red "[CRITICAL] $1"; ((CRITICAL++)); }
warning() { yellow "[WARNING] $1"; ((WARNING++)); }
info() { dim "[INFO] $1"; ((INFO++)); }

# --- Load configuration from .doc-gardening.yml ---
CONFIG_FILE="$REPO_ROOT/.doc-gardening.yml"

# Defaults
CFG_COMMITS_THRESHOLD=10
CFG_LINES_THRESHOLD=500
CFG_DAYS_THRESHOLD=90
CFG_ACTIVE_PLAN_DAYS=30
CFG_AGENTS_MAX_LINES=100
CFG_IGNORE=""

parse_yaml_value() {
    local key="$1"
    local file="$2"
    grep -E "^\s*${key}:" "$file" 2>/dev/null | head -1 | sed 's/.*:\s*//' | sed 's/\s*#.*//' | tr -d ' '
}

if [[ -f "$CONFIG_FILE" ]]; then
    dim "Loading config from .doc-gardening.yml"
    val=$(parse_yaml_value "commits_threshold" "$CONFIG_FILE")
    [[ -n "$val" ]] && CFG_COMMITS_THRESHOLD="$val"
    val=$(parse_yaml_value "lines_threshold" "$CONFIG_FILE")
    [[ -n "$val" ]] && CFG_LINES_THRESHOLD="$val"
    val=$(parse_yaml_value "days_threshold" "$CONFIG_FILE")
    [[ -n "$val" ]] && CFG_DAYS_THRESHOLD="$val"
    val=$(parse_yaml_value "active_plan_days" "$CONFIG_FILE")
    [[ -n "$val" ]] && CFG_ACTIVE_PLAN_DAYS="$val"
    val=$(parse_yaml_value "max_lines" "$CONFIG_FILE")
    [[ -n "$val" ]] && CFG_AGENTS_MAX_LINES="$val"
    # Collect ignore patterns (simple list parsing)
    CFG_IGNORE=$(grep -A 50 "^ignore:" "$CONFIG_FILE" 2>/dev/null | tail -n +2 | grep "^\s*-" | sed 's/.*-\s*//' | tr '\n' '|' | sed 's/|$//')
else
    dim "No .doc-gardening.yml found, using defaults"
fi

dim "Config: commits=$CFG_COMMITS_THRESHOLD lines=$CFG_LINES_THRESHOLD days=$CFG_DAYS_THRESHOLD plan_days=$CFG_ACTIVE_PLAN_DAYS agents_max=$CFG_AGENTS_MAX_LINES"
echo ""

is_ignored() {
    local path="$1"
    if [[ -z "$CFG_IGNORE" ]]; then return 1; fi
    echo "$path" | grep -qE "$CFG_IGNORE"
}

bold "=== Doc Gardening Scan ==="
echo "Repository: $REPO_ROOT"
echo ""

# --- Phase 1: Structural Completeness ---
bold "--- Structural Completeness ---"
STRUCTURAL_GAPS=0

if [[ ! -f "$REPO_ROOT/AGENTS.md" ]]; then
    critical "AGENTS.md not found — Create a 20-line stub with pointers to whatever docs exist"
    ((STRUCTURAL_GAPS++))
fi

if [[ ! -f "$REPO_ROOT/ARCHITECTURE.md" ]]; then
    critical "ARCHITECTURE.md not found — Document current domain dirs and intended dependency directions"
    ((STRUCTURAL_GAPS++))
fi

if [[ ! -f "$REPO_ROOT/docs/DESIGN.md" ]] && [[ ! -f "$REPO_ROOT/docs/design-docs/core-beliefs.md" ]]; then
    critical "No design principles found (docs/DESIGN.md or docs/design-docs/core-beliefs.md) — Draft 5-10 core belief statements"
    ((STRUCTURAL_GAPS++))
fi

if [[ -d "$REPO_ROOT/docs" ]]; then
    if [[ ! -f "$REPO_ROOT/docs/SECURITY.md" ]]; then
        warning "docs/SECURITY.md not found — Create with boundary rules: where input enters, where validated, what must not be logged"
        ((STRUCTURAL_GAPS++))
    fi

    if [[ ! -d "$REPO_ROOT/docs/exec-plans" ]]; then
        warning "docs/exec-plans/ not found — Create active/, completed/, tech-debt-tracker.md"
        ((STRUCTURAL_GAPS++))
    elif [[ ! -d "$REPO_ROOT/docs/exec-plans/active" ]] || [[ ! -d "$REPO_ROOT/docs/exec-plans/completed" ]]; then
        warning "docs/exec-plans/ incomplete — Needs active/ and completed/ subdirectories"
        ((STRUCTURAL_GAPS++))
    fi

    if [[ -d "$REPO_ROOT/docs/design-docs" ]] && [[ ! -f "$REPO_ROOT/docs/design-docs/index.md" ]]; then
        warning "docs/design-docs/ exists but has no index.md — Scan directory and catalogue existing docs with status"
        ((STRUCTURAL_GAPS++))
    fi

    if [[ ! -f "$REPO_ROOT/docs/QUALITY.md" ]]; then
        info "docs/QUALITY.md not found — Grade each domain/layer A-F with one justification sentence"
    fi

    if [[ ! -d "$REPO_ROOT/docs/references" ]]; then
        info "docs/references/ not found — Add LLM-friendly docs for top 3 most-used dependencies"
    fi

    if [[ ! -f "$REPO_ROOT/docs/RELIABILITY.md" ]]; then
        info "docs/RELIABILITY.md not found — Wire up minimal structured logs queryable by agents"
    fi
else
    critical "docs/ directory not found — Create docs/ with at minimum DESIGN.md and SECURITY.md"
    ((STRUCTURAL_GAPS++))
fi

if [[ $STRUCTURAL_GAPS -ge 3 ]]; then
    echo ""
    red ">>> ESCALATION: $STRUCTURAL_GAPS structural gaps detected (threshold: 3)"
    red ">>> This project is NOT ready for agent-first development at scale."
    red ">>> Recommend a docs-first sprint before feature work begins."
    echo ""
fi

# --- Phase 2: AGENTS.md Validation ---
bold "--- AGENTS.md Validation ---"
if [[ -f "$REPO_ROOT/AGENTS.md" ]]; then
    LINE_COUNT=$(wc -l < "$REPO_ROOT/AGENTS.md" | tr -d ' ')
    if [[ $LINE_COUNT -gt $CFG_AGENTS_MAX_LINES ]]; then
        warning "AGENTS.md is $LINE_COUNT lines (target: <=$CFG_AGENTS_MAX_LINES)"
    else
        dim "AGENTS.md: $LINE_COUNT lines (OK)"
    fi

    grep -oP '\[.*?\]\(\K[^)]+' "$REPO_ROOT/AGENTS.md" 2>/dev/null | \
        grep -v '^http' | grep -v '^#' | while read -r ref; do
        path="${ref%%#*}"
        if [[ -n "$path" && ! -e "$REPO_ROOT/$path" ]]; then
            critical "AGENTS.md references '$path' which does not exist"
        fi
    done || true
fi

# --- Phase 3: docs/ Structure & Freshness ---
bold "--- Documentation Structure ---"
if [[ -d "$REPO_ROOT/docs" ]]; then
    DOC_COUNT=$(find "$REPO_ROOT/docs" -name "*.md" | wc -l | tr -d ' ')
    dim "Found $DOC_COUNT markdown files in docs/"

    # Check index completeness
    for dir in design-docs product-specs; do
        if [[ -d "$REPO_ROOT/docs/$dir" && -f "$REPO_ROOT/docs/$dir/index.md" ]]; then
            find "$REPO_ROOT/docs/$dir" -maxdepth 1 -name "*.md" ! -name "index.md" | while read -r filepath; do
                file=$(basename "$filepath")
                relpath="docs/$dir/$file"
                if is_ignored "$relpath"; then continue; fi
                if ! grep -q "$file" "$REPO_ROOT/docs/$dir/index.md" 2>/dev/null; then
                    warning "docs/$dir/$file not listed in docs/$dir/index.md"
                fi
            done || true
        fi
    done

    # Check for broken relative links
    find "$REPO_ROOT/docs" -name "*.md" | while read -r mdfile; do
        relpath="${mdfile#$REPO_ROOT/}"
        if is_ignored "$relpath"; then continue; fi
        grep -oP '\[.*?\]\(\K[^)]+' "$mdfile" 2>/dev/null | \
            grep -v '^http' | grep -v '^#' | while read -r ref; do
            path="${ref%%#*}"
            docdir=$(dirname "$mdfile")
            if [[ -n "$path" && ! -e "$docdir/$path" && ! -e "$REPO_ROOT/$path" ]]; then
                warning "$relpath has broken link to '$path'"
            fi
        done || true
    done || true

    # Check staleness of docs in git repos
    if [[ -d "$REPO_ROOT/.git" ]]; then
        bold "--- Freshness (git-based) ---"

        # Check active exec-plans for staleness
        if [[ -d "$REPO_ROOT/docs/exec-plans/active" ]]; then
            find "$REPO_ROOT/docs/exec-plans/active" -name "*.md" | while read -r plan; do
                relpath="${plan#$REPO_ROOT/}"
                if is_ignored "$relpath"; then continue; fi
                last_modified=$(git -C "$REPO_ROOT" log -1 --format="%at" -- "$relpath" 2>/dev/null || echo "0")
                if [[ "$last_modified" != "0" ]]; then
                    days_ago=$(( ($(date +%s) - last_modified) / 86400 ))
                    if [[ $days_ago -gt $CFG_ACTIVE_PLAN_DAYS ]]; then
                        warning "$relpath not updated in ${days_ago} days (threshold: $CFG_ACTIVE_PLAN_DAYS)"
                    fi
                fi
            done || true
        fi

        # Check general doc staleness against domain code
        for doc in ARCHITECTURE.md docs/DESIGN.md docs/FRONTEND.md docs/SECURITY.md docs/RELIABILITY.md; do
            if [[ ! -f "$REPO_ROOT/$doc" ]]; then continue; fi
            if is_ignored "$doc"; then continue; fi
            doc_date=$(git -C "$REPO_ROOT" log -1 --format="%ai" -- "$doc" 2>/dev/null || echo "")
            if [[ -z "$doc_date" ]]; then continue; fi
            # Count commits in entire repo since doc was last updated (broad heuristic)
            commits_since=$(git -C "$REPO_ROOT" log --since="$doc_date" --oneline -- '*.ts' '*.tsx' '*.js' '*.jsx' '*.py' '*.go' '*.rs' 2>/dev/null | wc -l | tr -d ' ')
            if [[ $commits_since -gt $(( CFG_COMMITS_THRESHOLD * 3 )) ]]; then
                critical "$doc stale — $commits_since code commits since last update (threshold: $((CFG_COMMITS_THRESHOLD * 3)))"
            elif [[ $commits_since -gt $CFG_COMMITS_THRESHOLD ]]; then
                warning "$doc may be stale — $commits_since code commits since last update (threshold: $CFG_COMMITS_THRESHOLD)"
            fi
        done

        # Check generated docs staleness
        if [[ -d "$REPO_ROOT/docs/generated" ]]; then
            find "$REPO_ROOT/docs/generated" -name "*.md" | while read -r genfile; do
                relpath="${genfile#$REPO_ROOT/}"
                if is_ignored "$relpath"; then continue; fi
                source_path=$(grep -oP '<!-- Source: \K[^>]+(?= -->)' "$genfile" 2>/dev/null | tr -d ' ' || echo "")
                if [[ -z "$source_path" ]]; then continue; fi
                # Check if source exists and is newer
                if [[ -e "$REPO_ROOT/$source_path" ]]; then
                    gen_ts=$(git -C "$REPO_ROOT" log -1 --format="%at" -- "$relpath" 2>/dev/null || echo "0")
                    src_ts=$(git -C "$REPO_ROOT" log -1 --format="%at" -- "$source_path" 2>/dev/null || echo "0")
                    if [[ "$src_ts" -gt "$gen_ts" && "$gen_ts" != "0" ]]; then
                        warning "$relpath is stale — source '$source_path' has been updated since last generation"
                    fi
                elif [[ -n "$source_path" ]]; then
                    warning "$relpath references source '$source_path' which no longer exists"
                fi
            done || true
        fi
    fi
fi

# --- Summary ---
echo ""
bold "=== Summary ==="
echo "Critical: $CRITICAL"
echo "Warnings: $WARNING"
echo "Info: $INFO"
echo "Structural Gaps: $STRUCTURAL_GAPS"

# Calculate score
SCORE=$((100 - (CRITICAL * 20) - (WARNING * 5) - (INFO * 1)))
if [[ $SCORE -lt 0 ]]; then SCORE=0; fi

if [[ $SCORE -ge 90 ]]; then GRADE="A";
elif [[ $SCORE -ge 75 ]]; then GRADE="B";
elif [[ $SCORE -ge 60 ]]; then GRADE="C";
elif [[ $SCORE -ge 40 ]]; then GRADE="D";
else GRADE="F"; fi

AGENT_READY="Yes"
if [[ $STRUCTURAL_GAPS -ge 3 ]]; then AGENT_READY="No"; fi

bold "Grade: $GRADE (score: $SCORE)"
bold "Agent-Ready: $AGENT_READY"

# --- Persist to docs/DOC_HEALTH.md ---
DOC_HEALTH="$REPO_ROOT/docs/DOC_HEALTH.md"
TODAY=$(date +%Y-%m-%d)

# Preserve existing History and Resolved tables if file exists
HISTORY_TABLE=""
RESOLVED_TABLE=""
if [[ -f "$DOC_HEALTH" ]]; then
    HISTORY_TABLE=$(sed -n '/^## History$/,/^$/{ /^|[^-]/p; }' "$DOC_HEALTH" | grep -v "^| Date" || true)
    RESOLVED_TABLE=$(sed -n '/^## Resolved$/,/^## /{ /^|[^-]/p; }' "$DOC_HEALTH" | grep -v "^| Artifact" || true)
fi

mkdir -p "$REPO_ROOT/docs"

cat > "$DOC_HEALTH" << HEALTH_EOF
# Documentation Health

<!-- Maintained by /doc-gardening — do not edit manually -->
<!-- Last scan: $TODAY -->

**Overall Grade:** $GRADE (score: $SCORE)
**Agent-Ready:** $AGENT_READY

## Active Action Items

| # | Severity | Finding | Since |
|---|----------|---------|-------|
HEALTH_EOF

ITEM_NUM=0
if [[ ! -f "$REPO_ROOT/AGENTS.md" ]]; then
    ((ITEM_NUM++))
    echo "| $ITEM_NUM | Critical | Create \`AGENTS.md\` — 20-line stub with pointers to existing docs | $TODAY |" >> "$DOC_HEALTH"
fi
if [[ ! -f "$REPO_ROOT/ARCHITECTURE.md" ]]; then
    ((ITEM_NUM++))
    echo "| $ITEM_NUM | Critical | Create \`ARCHITECTURE.md\` — domain dirs and dependency directions | $TODAY |" >> "$DOC_HEALTH"
fi
if [[ ! -f "$REPO_ROOT/docs/DESIGN.md" ]] && [[ ! -f "$REPO_ROOT/docs/design-docs/core-beliefs.md" ]]; then
    ((ITEM_NUM++))
    echo "| $ITEM_NUM | Critical | Create \`docs/DESIGN.md\` — 5-10 core belief statements | $TODAY |" >> "$DOC_HEALTH"
fi
if [[ -d "$REPO_ROOT/docs" ]] && [[ ! -f "$REPO_ROOT/docs/SECURITY.md" ]]; then
    ((ITEM_NUM++))
    echo "| $ITEM_NUM | Warning | Create \`docs/SECURITY.md\` — boundary rules, input validation, logging constraints | $TODAY |" >> "$DOC_HEALTH"
fi
if [[ ! -d "$REPO_ROOT/docs/exec-plans" ]]; then
    ((ITEM_NUM++))
    echo "| $ITEM_NUM | Warning | Create \`docs/exec-plans/\` — active/, completed/, tech-debt-tracker.md | $TODAY |" >> "$DOC_HEALTH"
fi
if [[ -d "$REPO_ROOT/docs/design-docs" ]] && [[ ! -f "$REPO_ROOT/docs/design-docs/index.md" ]]; then
    ((ITEM_NUM++))
    echo "| $ITEM_NUM | Warning | Create \`docs/design-docs/index.md\` — catalogue existing docs with status | $TODAY |" >> "$DOC_HEALTH"
fi

if [[ $ITEM_NUM -eq 0 ]]; then
    echo "| — | — | No structural gaps detected | — |" >> "$DOC_HEALTH"
fi

cat >> "$DOC_HEALTH" << HEALTH_EOF

## Summary

- **Docs scanned:** $DOC_COUNT
- **Critical:** $CRITICAL
- **Warnings:** $WARNING
- **Info:** $INFO
- **Structural gaps:** $STRUCTURAL_GAPS

## Resolved

| Artifact | Resolved | Was Severity |
|----------|----------|--------------|
HEALTH_EOF

if [[ -n "$RESOLVED_TABLE" ]]; then
    echo "$RESOLVED_TABLE" >> "$DOC_HEALTH"
fi

cat >> "$DOC_HEALTH" << HEALTH_EOF

## History

| Date | Grade | Score | Gaps | Findings |
|------|-------|-------|------|----------|
| $TODAY | $GRADE | $SCORE | $STRUCTURAL_GAPS | $((CRITICAL + WARNING + INFO)) |
HEALTH_EOF

if [[ -n "$HISTORY_TABLE" ]]; then
    echo "$HISTORY_TABLE" | grep -v "^| $TODAY " >> "$DOC_HEALTH" || true
fi

dim "Report written to docs/DOC_HEALTH.md"

# Exit non-zero for CI if critical issues
if [[ $CRITICAL -gt 0 ]]; then
    exit 1
fi
