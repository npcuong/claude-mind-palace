#!/usr/bin/env bash
# install.sh — Deploy custom Claude skills to this machine
# Usage: bash install.sh [--memory] [--skills-only] [--dry-run]
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"
MEMORY_SRC="$REPO_DIR/memory-system"

DRY_RUN=false
INSTALL_MEMORY=false
INSTALL_SKILLS=true

for arg in "$@"; do
  case $arg in
    --memory)     INSTALL_MEMORY=true ;;
    --skills-only) INSTALL_MEMORY=false ;;
    --dry-run)    DRY_RUN=true ;;
    --help|-h)
      echo "Usage: bash install.sh [--memory] [--skills-only] [--dry-run]"
      echo ""
      echo "  (no flags)     Install skills only"
      echo "  --memory       Install skills + memory system templates"
      echo "  --skills-only  Install skills only (explicit)"
      echo "  --dry-run      Show what would happen without doing it"
      exit 0
      ;;
  esac
done

# ──────────────────────────────────────────────
# Colors
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info()    { echo -e "${BLUE}→${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warn()    { echo -e "${YELLOW}!${NC} $1"; }
error()   { echo -e "${RED}✗${NC} $1"; }

echo ""
echo "  claude-mind-palace installer"
echo "  =============================="
[ "$DRY_RUN" = true ] && warn "DRY RUN — no files will be written"
echo ""

# ──────────────────────────────────────────────
# 1. Find the Skills plugin directory
# The path contains two UUIDs that differ per machine/install.

find_skills_plugin_dir() {
  local base=""

  if [[ "$OSTYPE" == "darwin"* ]]; then
    base="$HOME/Library/Application Support/Claude/local-agent-mode-sessions/skills-plugin"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Claude Desktop on Linux (if supported)
    base="$HOME/.config/Claude/local-agent-mode-sessions/skills-plugin"
  else
    error "Unsupported OS: $OSTYPE"
    exit 1
  fi

  if [ ! -d "$base" ]; then
    error "Claude Skills plugin directory not found at: $base"
    echo ""
    echo "  Make sure:"
    echo "  1. Claude Desktop app is installed"
    echo "  2. The Skills plugin has been installed at least once"
    echo "  3. Claude Desktop has been opened at least once after installing Skills"
    echo ""
    exit 1
  fi

  # Find the nested skills/ directory (2 UUID levels deep)
  local target
  target=$(find "$base" -mindepth 3 -maxdepth 3 -type d -name "skills" 2>/dev/null | head -1)

  if [ -z "$target" ]; then
    error "Could not find skills/ directory inside plugin path."
    echo "  Searched in: $base"
    echo "  Contents:"
    ls "$base" 2>/dev/null | head -5 | sed 's/^/    /'
    exit 1
  fi

  echo "$target"
}

if [ "$INSTALL_SKILLS" = true ]; then
  info "Locating Claude Skills plugin directory..."
  PLUGIN_SKILLS_DIR=$(find_skills_plugin_dir)
  success "Found: $PLUGIN_SKILLS_DIR"
  echo ""

  # List skills to install
  skills=()
  while IFS= read -r -d '' d; do
    skill_name=$(basename "$d")
    if [ -f "$d/SKILL.md" ]; then
      skills+=("$skill_name")
    fi
  done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  if [ ${#skills[@]} -eq 0 ]; then
    warn "No skills found in $SKILLS_DIR"
    exit 1
  fi

  info "Skills to install (${#skills[@]} total):"
  for s in "${skills[@]}"; do echo "    • $s"; done
  echo ""

  # Install each skill
  installed=0
  skipped=0
  for skill in "${skills[@]}"; do
    src="$SKILLS_DIR/$skill"
    dst="$PLUGIN_SKILLS_DIR/$skill"

    if [ -d "$dst" ]; then
      # Compare content to decide if update is needed
      if diff -rq "$src" "$dst" > /dev/null 2>&1; then
        success "$skill (already up to date)"
        ((skipped++)) || true
      else
        if [ "$DRY_RUN" = false ]; then
          rm -rf "$dst"
          cp -r "$src" "$dst"
        fi
        warn "$skill (updated)"
        ((installed++)) || true
      fi
    else
      if [ "$DRY_RUN" = false ]; then
        cp -r "$src" "$dst"
      fi
      success "$skill (installed)"
      ((installed++)) || true
    fi
  done

  echo ""
  echo "  Skills: $installed installed/updated, $skipped already up to date"
fi

# ──────────────────────────────────────────────
# 2. Memory system (optional)

if [ "$INSTALL_MEMORY" = true ]; then
  echo ""
  info "Setting up memory system..."

  if [ ! -d "$MEMORY_SRC" ]; then
    warn "memory-system/ directory not found in repo — skipping memory setup"
  else
    CLAUDE_DIR="$HOME/.claude"
    MEMORY_DIR="$CLAUDE_DIR/memory"

    if [ "$DRY_RUN" = false ]; then
      mkdir -p "$MEMORY_DIR"
    fi

    # Copy CLAUDE.md (operating instructions) — only if not already present
    if [ -f "$MEMORY_SRC/CLAUDE.md" ]; then
      if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        warn "~/.claude/CLAUDE.md already exists — skipping (manual merge may be needed)"
      else
        [ "$DRY_RUN" = false ] && cp "$MEMORY_SRC/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
        success "~/.claude/CLAUDE.md installed"
      fi
    fi

    # Copy memory template files (only if destination doesn't exist)
    for f in identity.md working-style.md relationships.md decisions.md recurring-context.md; do
      if [ -f "$MEMORY_SRC/$f" ]; then
        dst_file="$MEMORY_DIR/$f"
        if [ -f "$dst_file" ]; then
          warn "~/.claude/memory/$f already exists — skipping"
        else
          [ "$DRY_RUN" = false ] && cp "$MEMORY_SRC/$f" "$dst_file"
          success "~/.claude/memory/$f installed"
        fi
      fi
    done

    # Copy hook
    if [ -d "$MEMORY_SRC/hooks" ]; then
      HOOKS_DIR="$CLAUDE_DIR/hooks"
      [ "$DRY_RUN" = false ] && mkdir -p "$HOOKS_DIR"
      for hook in "$MEMORY_SRC/hooks/"*; do
        hook_name=$(basename "$hook")
        dst_hook="$HOOKS_DIR/$hook_name"
        if [ -f "$dst_hook" ]; then
          warn "~/.claude/hooks/$hook_name already exists — skipping"
        else
          [ "$DRY_RUN" = false ] && cp "$hook" "$dst_hook"
          success "~/.claude/hooks/$hook_name installed"
        fi
      done
    fi

    echo ""
    warn "Next steps for memory system:"
    echo "    1. Edit ~/.claude/memory/identity.md — fill in your name, role, and goals"
    echo "    2. Add the Stop hook to ~/.claude/settings.json:"
    echo '       "hooks": { "Stop": [{ "matcher": "", "hooks": [{ "type": "command", "command": "python3 ~/.claude/hooks/save_session.py" }] }] }'
    echo "    3. Restart Claude Desktop"
  fi
fi

# ──────────────────────────────────────────────
echo ""
success "Done! Restart Claude Desktop to load the new skills."
echo ""
