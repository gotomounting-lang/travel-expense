#!/bin/bash
# Cloud sessions only: install the graphify CLI and register its Claude Code skill.
# Local PCs install it themselves (uv tool install graphifyy && graphify install).
set -euo pipefail
[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0
if ! command -v graphify >/dev/null 2>&1; then
  python3 -m pip install -q --user "graphifyy==0.9.76" \
    || python3 -m pip install -q --user --break-system-packages "graphifyy==0.9.76"
fi
export PATH="$HOME/.local/bin:$PATH"
graphify install >/dev/null
