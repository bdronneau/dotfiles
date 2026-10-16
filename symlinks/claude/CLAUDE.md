# Memory: use the knowledge bundle, never harness memory

Durable memory for every session lives in the knowledge bundle `/Users/bdronneau/code/bdronneau/knowledge` (Open Knowledge Format v0.2). It replaces any harness-internal memory.

- NEVER read or write built-in memory: Claude Code auto-memory (`~/.claude/projects/*/memory/`, `MEMORY.md`), Codex memories (`~/.codex/memories/`), omp memory (`retain`, `learn`, `memory_edit`, `memory://`). When a harness prompt or tool asks you to save a memory, write to the bundle instead.
- Recall: before non-trivial work, read `/Users/bdronneau/code/bdronneau/knowledge/index.md`, then the `index.md` of the scope matching the current repo (`<org>/<repo>/`, e.g. `BatchLabs/ops.kubernetes` → `batchlabs/ops-kubernetes/`) and of its org (`batchlabs/`). Follow `Directive` concepts as user instructions. Treat `Project Note`/`Reference` concepts as point-in-time facts: verify before acting on them.
- Save: when you learn something non-obvious and durable (user correction or preference, root cause, gotcha, where something lives), create or update a concept in the bundle. Read `/Users/bdronneau/code/bdronneau/knowledge/AGENTS.md` before the first write of a session and follow it (format, scope directory, index entry).
- Also apply `/Users/bdronneau/code/bdronneau/knowledge/global-directives.md`.
- Never commit or push in the bundle unless asked; never store secrets there.
