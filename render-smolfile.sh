#!/usr/bin/env bash
# =============================================================================
# render-smolfile.sh
# Renders Smolfile.template + smol.env into a ready-to-use Smolfile.
# =============================================================================
set -euo pipefail

cd "$(dirname "$0")"

TEMPLATE="Smolfile.template"
CONFIG="${SMOL_ENV:-smol.env}"
OUTPUT="Smolfile"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "error: template '$TEMPLATE' not found" >&2
  exit 1
fi

if [[ ! -f "$CONFIG" ]]; then
  echo "error: config '$CONFIG' not found." >&2
  echo "       Create it first:  cp smol.env.example smol.env" >&2
  exit 1
fi

# Load the config values.
set -a
# shellcheck disable=SC1090
source "$CONFIG"
set +a

# Required variables that must be present in the config.
required=(SMOL_IMAGE PROJECTS_DIR PI_AGENT_DIR AGENTS_DIR)
missing=()
for var in "${required[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    missing+=("$var")
  fi
done
if (( ${#missing[@]} > 0 )); then
  echo "error: missing values in '$CONFIG': ${missing[*]}" >&2
  exit 1
fi

# Substitute only our known variables (avoids clobbering shell syntax like $PATH,
# $HOME and $() that legitimately appear inside the Smolfile init block).
export SMOL_IMAGE PROJECTS_DIR PI_AGENT_DIR AGENTS_DIR
envsubst '${SMOL_IMAGE} ${PROJECTS_DIR} ${PI_AGENT_DIR} ${AGENTS_DIR}' \
  < "$TEMPLATE" > "$OUTPUT"

echo "Rendered $OUTPUT from $TEMPLATE using $CONFIG"
