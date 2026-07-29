# avm

A shareable dev-environment definition. 
The `Smolfile` is generated from a template.
Installs [pi.dev](https://pi.dev/) and [Claude Code](https://code.claude.com/docs/en/overview).

## Usage

```bash
# 1. Create your local config from the example
cp smol.env.example smol.env

# 2. Edit smol.env to match your machine
$EDITOR smol.env

# 3. Render the Smolfile
./render-smolfile.sh
```

## Parameters

| Variable        | Description                                          |
| --------------- | ---------------------------------------------------- |
| `SMOL_IMAGE`    | Base container image.                                |
| `PROJECTS_DIR`  | Host projects dir, mounted at `/projects`.           |
| `PI_AGENT_DIR`  | Host pi agent config, mounted at `/root/.pi/agent/`. |
| `AGENTS_DIR`    | Host agents/skills dir, mounted at `/root/.agents/`. |


## Useful aliases
```
llmvm () {
  local dir="${1:-/projects}"
  smolvm machine exec --name avm -it -- sh -l
}

avm() {
  local dir="${1:-/projects}"
  smolvm machine exec --name avm -it -- sh -l -c "cd '$dir' && pi"
}

claudevm() {
  local dir="${1:-/projects}"
  smolvm machine exec --name avm -it -- sh -l -c "cd '$dir' && claude"
}

claudevmtar() {
  smolvm machine exec --name avm -- tar czf /workspace/claude.tar.gz -C /root .claude
  smolvm machine cp avm:/workspace/claude.tar.gz ~/.claude_avm_backup.tar.gz
}
```