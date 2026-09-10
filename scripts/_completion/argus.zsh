#compdef argus argus-backup argus-calendar argus-contacts argus-cookbook argus-docs argus-gallery argus-mail argus-mcp argus-memory argus-notes argus-personal argus-preset argus-research argus-sessions argus-signature argus-skills argus-tasks argus-theme argus-webhook
# Zsh tab-completion for the argus umbrella + sub-CLIs.
#
# Drop in any directory on $fpath, e.g.:
#     fpath=(/path/to/argus-ui/scripts/_completion $fpath)
#     autoload -U compinit; compinit
#
# Then `argus <tab>` completes subcommands; `argus mail <tab>`
# completes mail subcommands; `argus-mail <tab>` works the same.

_argus_scripts_dir() {
    local self="${(%):-%x}"
    while [[ -L "$self" ]]; do self="$(readlink "$self")"; done
    cd "${self:h}/.." && pwd
}

typeset -gA _argus_subs

_argus_refresh() {
    _argus_subs=()
    local dir="$(_argus_scripts_dir)"
    local py="$dir/../venv/bin/python"
    [[ -x "$py" ]] || py="$(command -v python3)"
    local f sub help_out commands
    for f in "$dir"/argus-*; do
        [[ -x "$f" ]] || continue
        case "$f" in
            *.bak|*.pyc|*.pre-*) continue ;;
        esac
        sub="${${f:t}#argus-}"
        help_out=$("$py" "$f" --help 2>/dev/null) || continue
        commands=$(echo "$help_out" | grep -oE '\{[a-z0-9_,-]+\}' | head -1 \
            | tr -d '{}' | tr ',' ' ')
        _argus_subs[$sub]="$commands"
    done
}

_argus() {
    [[ ${#_argus_subs} -eq 0 ]] && _argus_refresh

    local cmd="${words[1]}"

    if [[ "$cmd" == "argus" ]]; then
        if (( CURRENT == 2 )); then
            local -a subs=(${(k)_argus_subs} help)
            _describe 'subcommand' subs
            return
        fi
        local sub="${words[2]}"
        if [[ "$sub" == "help" ]] && (( CURRENT == 3 )); then
            local -a subs=(${(k)_argus_subs})
            _describe 'subcommand' subs
            return
        fi
        if (( CURRENT == 3 )); then
            local -a sc=(${(s/ /)_argus_subs[$sub]})
            _describe 'command' sc
            return
        fi
        return
    fi

    # argus-foo <tab>
    local sub="${cmd#argus-}"
    if (( CURRENT == 2 )); then
        local -a sc=(${(s/ /)_argus_subs[$sub]})
        _describe 'command' sc
        return
    fi
}

_argus "$@"
