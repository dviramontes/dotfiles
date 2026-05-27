#!/usr/bin/env bash

# disk space info
diskinfo() {
    diskutil info / | grep -E '(Free|Available)'
}

preamble() {
    local work_project template_workspace preamble_marker workspace_name workspace_suffix inferred_project configured_base
    workspace_name="${PWD##*/}"
    workspace_suffix="${workspace_name##*-}"
    inferred_project=""

    if [ "$workspace_suffix" != "$workspace_name" ] && [ "$workspace_suffix" -ge 0 ] 2>/dev/null; then
        inferred_project="${workspace_name%-*}"
    fi

    configured_base="${PRE_BASE:-}"
    if [ -n "$configured_base" ]; then
        work_project="${configured_base##*/}"
    else
        work_project="$inferred_project"
    fi
    [ -z "$work_project" ] && work_project="ops"
    template_workspace="../$work_project"
    preamble_marker=".preamble.done"

    if stat "$template_workspace/.env" >/dev/null 2>&1 && [ ! -f ./.env ]; then
        cp "$template_workspace/.env" ./.env
        printf 'pre: seeded .env\n'
    elif [ ! -f ./.env ]; then
        printf 'pre: template .env not found at %s/.env\n' "$template_workspace"
    fi

    if [ -f ./.envrc ] && command -v direnv >/dev/null 2>&1; then
        direnv allow . >/dev/null 2>&1 || true
        if [ -n "${ZSH_VERSION:-}" ]; then
            eval "$(direnv export zsh 2>/dev/null)"
        else
            eval "$(direnv export bash 2>/dev/null)"
        fi
        printf 'pre: direnv allow\n'
    fi

    if stat "$template_workspace/.claude" >/dev/null 2>&1 && [ ! -d ./.claude ]; then
        cp -R "$template_workspace/.claude" ./.claude
        printf 'pre: seeded .claude/\n'
    fi

    if [ -d ./assets ] && command -v npm >/dev/null 2>&1 && [ ! -f "$preamble_marker" ]; then
        npm --prefix ./assets install playwright
        if [ -f ./mix.exs ]; then
            if [ -n "${BASE_DOMAIN:-}" ]; then
                mdg && mcc && mem
            else
                printf 'pre: skipping mix bootstrap (BASE_DOMAIN missing)\n'
            fi
        fi
        touch "$preamble_marker"
    fi
}

_pre_run_preamble() {
    local preamble_script
    preamble_script="${PRE_PREAMBLE_SCRIPT:-$HOME/.pre-preamble.sh}"

    if stat "$preamble_script" >/dev/null 2>&1; then
        # shellcheck source=/dev/null
        . "$preamble_script"
    fi

    if typeset -f preamble >/dev/null 2>&1; then
        preamble
    fi
}

# Wrapper around the Go pre CLI so navigation commands can cd.
pre() {
    local subcommand destination exit_code name branch selection_file
    subcommand="$1"

    case "$subcommand" in
        list|help|-h|--help|doctor|setup|init|remove|rm)
            command pre "$@"
            return $?
            ;;
    esac

    if [ -z "$subcommand" ]; then
        selection_file=$(mktemp 2>/dev/null) || return 1
        PRE_SELECTION_FILE="$selection_file" command pre "$@"
        exit_code=$?
        destination=$(tr -d '\n' < "$selection_file")
        rm -f "$selection_file"
    else
        destination="$(command pre "$@")"
        exit_code=$?
    fi

    if [ "$exit_code" -ne 0 ]; then
        [ -n "$destination" ] && printf '%s\n' "$destination"
        return "$exit_code"
    fi

    if [ -d "$destination" ]; then
        cd "$destination" || return 1
        _pre_run_preamble

        name=${destination##*/}
        branch=$(git -C "$destination" symbolic-ref --quiet --short HEAD 2>/dev/null)
        if [ -z "$branch" ]; then
            branch=$(git -C "$destination" rev-parse --short HEAD 2>/dev/null)
        fi

        if [ -n "$branch" ]; then
            printf '%s [%s]\n' "$name" "$branch"
        else
            printf '%s\n' "$name"
        fi
        return 0
    fi

    [ -n "$destination" ] && printf '%s\n' "$destination"
}

gitcomain() {
    local latest_commit

    git rev-parse --is-inside-work-tree >/dev/null || return 1
    git remote update

    latest_commit="$(git rev-parse origin/main)" || return 1
    printf 'Latest origin/main commit: %s\n' "$latest_commit"

    git checkout "$latest_commit"
}
