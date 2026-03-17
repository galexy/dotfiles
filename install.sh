#!/bin/bash
set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORCE=false
FIX=false
DRY_RUN=false

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- XDG ---
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# --- Link registry ---
# Each entry: "config_name|source_relative_path|target_path[|legacy_path]"
# If legacy_path is set, doctor will check for stale configs at the old location.
LINKS=(
    # bash (no XDG support)
    "bash|bash/bash_profile|~/.bash_profile"
    "bash|bash/bashrc|~/.bashrc"
    "bash|bash/bash_aliases|~/.bash_aliases"
    "bash|bash/profile|~/.profile"
    # zsh (no XDG support — uses ZDOTDIR)
    "zsh|zsh/completion|~/.zsh/completion"
    "zsh|zsh/zshrc|~/.zshrc"
    "zsh|zsh/zshenv|~/.zshenv"
    "zsh|zsh/zprofile|~/.zprofile"
    # spacemacs
    "spacemacs|emacs/spacemacs|~/.spacemacs"
    "spacemacs|emacs/galexy|~/.emacs.d/private/galexy"
    # powerline (already XDG)
    "powerline|powerline/config.json|~/.config/powerline/config.json"
    "powerline|powerline/themes|~/.config/powerline/themes"
    # git (XDG since git 2.x)
    "git|git/gitconfig|~/.config/git/config|~/.gitconfig"
    # tmux (XDG since tmux 3.1)
    "tmux|tmux/tmux.conf|~/.config/tmux/tmux.conf|~/.tmux.conf"
    # bin
    "bin|bin/ec|~/.local/bin/ec"
    # ghci (XDG since GHC 8.x)
    "ghci|ghc/ghci.conf|~/.config/ghc/ghci.conf|~/.ghc/ghci.conf"
    # readline (no XDG support)
    "readline|readline/inputrc|~/.inputrc"
    # cargo (no XDG support)
    "cargo|cargo/env|~/.cargo/env"
    # guile (no XDG support)
    "guile|guile/guile|~/.guile"
    # aws (no XDG support)
    "aws|aws/config|~/.aws/config"
    # cabal (XDG since cabal 3.x)
    "cabal|cabal/config|~/.config/cabal/config|~/.cabal/config"
    # 1password (already XDG)
    "1password|1Password/ssh/agent.toml|~/.config/1Password/ssh/agent.toml"
    # helix (already XDG)
    "helix|helix/config.toml|~/.config/helix/config.toml"
    # wezterm (already XDG)
    "wezterm|wezterm/wezterm.lua|~/.config/wezterm/wezterm.lua"
)

# --- Helpers ---

expand_tilde() {
    local path="$1"
    echo "${path/#\~/$HOME}"
}

log_ok()    { printf "  ${GREEN}✓${RESET} %s\n" "$1"; }
log_skip()  { printf "  ${CYAN}–${RESET} %s\n" "$1"; }
log_warn()  { printf "  ${YELLOW}!${RESET} %s\n" "$1"; }
log_error() { printf "  ${RED}✗${RESET} %s\n" "$1"; }
log_dry()   { printf "  ${CYAN}▷${RESET} %s ${CYAN}(dry run)${RESET}\n" "$1"; }
log_head()  { printf "\n${BOLD}[%s]${RESET}\n" "$1"; }

# Get all unique config names
config_names() {
    printf '%s\n' "${LINKS[@]}" | cut -d'|' -f1 | sort -u
}

# Filter links by config name ("all" returns everything)
links_for_config() {
    local config="$1"
    for entry in "${LINKS[@]}"; do
        local name="${entry%%|*}"
        if [[ "$config" == "all" ]] || [[ "$name" == "$config" ]]; then
            echo "$entry"
        fi
    done
}

# --- Commands ---

cmd_install() {
    local config="$1"
    local had_errors=false

    log_head "Installing: $config"

    while IFS= read -r entry; do
        [[ -z "$entry" ]] && continue
        local legacy_raw=""
        IFS='|' read -r name src_rel target_raw legacy_raw <<< "$entry"
        local src="${BASEDIR}/${src_rel}"
        local target
        target="$(expand_tilde "$target_raw")"

        # Ensure source exists
        if [[ ! -e "$src" ]]; then
            log_error "$target_raw — source $src_rel does not exist"
            had_errors=true
            continue
        fi

        # Create parent directory
        local parent
        parent="$(dirname "$target")"
        if [[ ! -d "$parent" ]]; then
            mkdir -p "$parent"
        fi

        # Check what's at the target
        if [[ -L "$target" ]]; then
            local current
            current="$(readlink "$target")"
            if [[ "$current" == "$src" ]]; then
                log_skip "$target_raw already correct"
                continue
            else
                if [[ "$FORCE" == true ]]; then
                    rm "$target"
                    ln -s "$src" "$target"
                    log_ok "$target_raw (replaced link from $current)"
                else
                    log_warn "$target_raw is a symlink to $current — use --force to overwrite"
                    had_errors=true
                fi
            fi
        elif [[ -e "$target" ]]; then
            if [[ "$FORCE" == true ]]; then
                local backup="${target}.dotfiles-backup"
                mv "$target" "$backup"
                ln -s "$src" "$target"
                log_ok "$target_raw (backed up existing file to ${target_raw}.dotfiles-backup)"
            else
                log_error "$target_raw is a real file — refusing to overwrite (use --force to backup and replace)"
                had_errors=true
            fi
        else
            ln -s "$src" "$target"
            log_ok "$target_raw"
        fi
    done <<< "$(links_for_config "$config")"

    if [[ "$had_errors" == true ]]; then
        printf "\n${YELLOW}Some items were skipped. Re-run with --force to override.${RESET}\n"
        return 1
    fi
}

cmd_doctor() {
    local config="$1"
    local ok=0 warn=0 err=0 fixed=0

    if [[ "$DRY_RUN" == true ]] && [[ "$FIX" == false ]]; then
        FIX=true
        printf "${CYAN}--dry-run implies --fix, showing what would be changed${RESET}\n"
    fi

    log_head "Doctor: $config"

    while IFS= read -r entry; do
        [[ -z "$entry" ]] && continue
        local legacy_raw=""
        IFS='|' read -r name src_rel target_raw legacy_raw <<< "$entry"
        local src="${BASEDIR}/${src_rel}"
        local target
        target="$(expand_tilde "$target_raw")"

        # Check the XDG (current) target
        if [[ -L "$target" ]]; then
            local current
            current="$(readlink "$target")"
            if [[ "$current" == "$src" ]]; then
                log_ok "$target_raw → $src_rel"
                ((++ok))
            elif [[ ! -e "$target" ]]; then
                if [[ "$FIX" == true ]]; then
                    local msg="$target_raw — remove broken link, relink to $src_rel"
                    if [[ "$DRY_RUN" == true ]]; then
                        log_dry "$msg"
                    else
                        rm "$target"
                        mkdir -p "$(dirname "$target")"
                        ln -s "$src" "$target"
                        log_ok "$msg"
                    fi
                    ((++fixed))
                else
                    log_error "$target_raw → $current (broken symlink)"
                    ((++err))
                fi
            else
                if [[ "$FIX" == true ]]; then
                    local msg="$target_raw — relink from $current to $src_rel"
                    if [[ "$DRY_RUN" == true ]]; then
                        log_dry "$msg"
                    else
                        rm "$target"
                        ln -s "$src" "$target"
                        log_ok "$msg"
                    fi
                    ((++fixed))
                else
                    log_warn "$target_raw → $current (expected $src_rel)"
                    ((++warn))
                fi
            fi
        elif [[ -e "$target" ]]; then
            if [[ "$FIX" == true ]]; then
                local msg="$target_raw — back up to ${target_raw}.dotfiles-backup, link to $src_rel"
                if [[ "$DRY_RUN" == true ]]; then
                    log_dry "$msg"
                else
                    local backup="${target}.dotfiles-backup"
                    mv "$target" "$backup"
                    mkdir -p "$(dirname "$target")"
                    ln -s "$src" "$target"
                    log_ok "$msg"
                fi
                ((++fixed))
            else
                log_error "$target_raw exists as a real file (not managed)"
                ((++err))
            fi
        else
            if [[ "$FIX" == true ]]; then
                local msg="$target_raw — install → $src_rel"
                if [[ "$DRY_RUN" == true ]]; then
                    log_dry "$msg"
                else
                    mkdir -p "$(dirname "$target")"
                    ln -s "$src" "$target"
                    log_ok "$msg"
                fi
                ((++fixed))
            else
                log_warn "$target_raw is not installed"
                ((++warn))
            fi
        fi

        # Check for stale config at legacy (non-XDG) path
        if [[ -n "$legacy_raw" ]]; then
            local legacy
            legacy="$(expand_tilde "$legacy_raw")"
            if [[ -L "$legacy" || -e "$legacy" ]]; then
                if [[ "$FIX" == true ]]; then
                    if [[ -L "$legacy" ]]; then
                        local msg="$legacy_raw — remove stale symlink (moved to $target_raw)"
                    else
                        local msg="$legacy_raw — back up to ${legacy_raw}.dotfiles-backup (moved to $target_raw)"
                    fi
                    if [[ "$DRY_RUN" == true ]]; then
                        log_dry "$msg"
                    else
                        if [[ -L "$legacy" ]]; then
                            rm "$legacy"
                        else
                            mv "$legacy" "${legacy}.dotfiles-backup"
                        fi
                        log_ok "$msg"
                    fi
                    ((++fixed))
                else
                    log_warn "$legacy_raw still exists — should be at $target_raw instead"
                    ((++warn))
                fi
            fi
        fi
    done <<< "$(links_for_config "$config")"

    local summary="${GREEN}$ok ok${RESET}  ${YELLOW}$warn warnings${RESET}  ${RED}$err errors${RESET}"
    if [[ "$fixed" -gt 0 ]]; then
        local fix_label="fixed"
        [[ "$DRY_RUN" == true ]] && fix_label="would fix"
        summary="$summary  ${CYAN}$fixed $fix_label${RESET}"
    fi
    printf "\n  $summary\n"

    if [[ "$err" -gt 0 || "$warn" -gt 0 ]] && [[ "$FIX" == false ]]; then
        printf "  ${CYAN}Run with --fix to resolve issues.${RESET}\n"
    fi
}

cmd_uninstall() {
    local config="$1"

    log_head "Uninstalling: $config"

    while IFS= read -r entry; do
        [[ -z "$entry" ]] && continue
        local legacy_raw=""
        IFS='|' read -r name src_rel target_raw legacy_raw <<< "$entry"
        local src="${BASEDIR}/${src_rel}"
        local target
        target="$(expand_tilde "$target_raw")"

        if [[ -L "$target" ]]; then
            local current
            current="$(readlink "$target")"
            if [[ "$current" == "$src" ]]; then
                rm "$target"
                log_ok "Removed $target_raw"
            else
                log_skip "$target_raw points to $current — not ours, leaving alone"
            fi
        elif [[ -e "$target" ]]; then
            log_skip "$target_raw is a real file — leaving alone"
        else
            log_skip "$target_raw does not exist"
        fi

        # Also clean up legacy path if it points to us
        if [[ -n "$legacy_raw" ]]; then
            local legacy
            legacy="$(expand_tilde "$legacy_raw")"
            if [[ -L "$legacy" ]]; then
                local legacy_current
                legacy_current="$(readlink "$legacy")"
                if [[ "$legacy_current" == "$src" ]]; then
                    rm "$legacy"
                    log_ok "Removed legacy $legacy_raw"
                fi
            fi
        fi
    done <<< "$(links_for_config "$config")"
}

cmd_list() {
    printf "${BOLD}Available configs:${RESET}\n"
    config_names | while read -r name; do
        local count
        count="$(links_for_config "$name" | wc -l | tr -d ' ')"
        printf "  %-15s %s links\n" "$name" "$count"
    done
}

cmd_help() {
    cat <<EOF
Usage: $(basename "$0") <command> [config] [options]

Commands:
  install [config]    Symlink dotfiles (default: all)
  uninstall [config]  Remove symlinks managed by this repo (default: all)
  doctor [config]     Audit symlink status (default: all)
  list                Show available configs
  help                Show this message

Options:
  --force             Force overwrite (install backs up real files, replaces wrong symlinks)
  --fix               Used with doctor to fix issues (broken links, wrong targets, missing links)
  --dry-run           Preview what --fix would do without making changes

Config names:
  $(config_names | tr '\n' ' ')
  (or "all" to target everything)

Examples:
  ./install.sh install              # install all configs
  ./install.sh install zsh          # install only zsh config
  ./install.sh install --force      # install all, overwriting conflicts
  ./install.sh doctor               # check status of all links
  ./install.sh doctor tmux          # check only tmux links
  ./install.sh doctor --fix         # fix all issues found by doctor
  ./install.sh doctor --dry-run    # preview what --fix would change
  ./install.sh uninstall git        # remove git symlinks
EOF
}

# --- Main ---

# Parse arguments
COMMAND=""
CONFIG="all"
for arg in "$@"; do
    case "$arg" in
        --force)   FORCE=true ;;
        --fix)     FIX=true ;;
        --dry-run) DRY_RUN=true ;;
        -*) echo "Unknown option: $arg"; cmd_help; exit 1 ;;
        *)
            if [[ -z "$COMMAND" ]]; then
                COMMAND="$arg"
            else
                CONFIG="$arg"
            fi
            ;;
    esac
done

# Default to install if no command given
if [[ -z "$COMMAND" ]]; then
    COMMAND="install"
fi

# Validate config name
if [[ "$CONFIG" != "all" ]] && ! config_names | grep -qx "$CONFIG"; then
    echo "Unknown config: $CONFIG"
    echo "Available: $(config_names | tr '\n' ' ')"
    exit 1
fi

case "$COMMAND" in
    install)   cmd_install "$CONFIG" ;;
    uninstall) cmd_uninstall "$CONFIG" ;;
    doctor)    cmd_doctor "$CONFIG" ;;
    list)      cmd_list ;;
    help)      cmd_help ;;
    *)         echo "Unknown command: $COMMAND"; cmd_help; exit 1 ;;
esac
