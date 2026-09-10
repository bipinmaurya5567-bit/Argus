# Argus Claude Code Integration

This directory contains the Claude Code skill bundle for Argus.

## User Flow

1. Open Argus Settings > Integrations.
2. Add a Claude Agent.
3. Copy the full setup commands shown after the generated token.
4. Toggle the tools Claude is allowed to use.
5. Configure the terminal Claude Code session:

```bash
export ARGUS_URL=http://your-argus-host:7000
export ARGUS_API_TOKEN=ody_generated_token
mkdir -p ~/.claude
curl -fsSL -H "Authorization: Bearer $ARGUS_API_TOKEN" "$ARGUS_URL/api/claude/plugin.zip" -o /tmp/argus-claude-skill.zip
python3 -m zipfile -e /tmp/argus-claude-skill.zip ~/.claude/
```

Claude Code auto-loads anything under `~/.claude/skills/`, so the `argus` skill is
available in any session that has `ARGUS_URL` and `ARGUS_API_TOKEN` in its
environment.

## What's in the bundle

- `skills/argus/SKILL.md` — the skill definition Claude Code reads.
- `skills/argus/scripts/argus_api.py` — small helper that calls the scoped
  `/api/codex/*` endpoints (these are the canonical scope-gated agent API; the
  `codex` path is historic and shared by all agent integrations).

## Scope enforcement

The token is scope-gated. Every tool surface is checked server-side in Argus,
so even if Claude tries to call a forbidden endpoint, it gets `403` until the
user enables the matching toggle in Settings > Integrations > Claude Agent.
