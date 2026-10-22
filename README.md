# ambition-skills

Three agent skills for doing more ambitious work with models. They follow the
[Agent Skills](https://agentskills.io) `SKILL.md` format and work in
**Claude Code**, **Codex** and **opencode**.

The techniques come from Felix Rieseberg's essay
[How to be more ambitious: A tutorial for humans with models](https://felixrieseberg.com/how-to-be-more-ambitious-a-tutorial-for-humans-with-models/)
(October 2026). The skills are an independent implementation; read the essay
for the reasoning behind them.

| Skill | What it does | Its outside judge |
|---|---|---|
| `deepen` | Rewrites a task as a field-leading professional would do it: rawest inputs, real instruments, a much harder target. Stops for approval before doing the work. | You approve the rewrite, and the rewrite must name an external check. |
| `red-team-crew` | Turns the work into verbs, picks 4-6 disciplines (builders, adversaries, one unexpected field) and runs each as a subagent applying that field's *methods*, not its voice. | Adversarial members; findings without evidence are dropped. |
| `assumption-check` | Tests a belief against raw data, looks for a signal the belief does not explain, and validates it on data held out before exploring. | A holdout set aside first, a metric fixed in advance, and no tuning on it. |

## Install

```sh
git clone https://github.com/simonesalmistraro/ambition-skills
cd ambition-skills
./install.sh            # symlinks; `git pull` updates every tool
```

| Tool | Where `install.sh` puts them |
|---|---|
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |
| opencode | reads both of the above (no duplicates) |

Options: `--copy`, `--project DIR` (per-repo install), `--only claude|agents`,
`--uninstall`, `--force`. Existing skills with the same name are left alone
unless you pass `--force`.

### Claude Code plugin

```
/plugin marketplace add simonesalmistraro/ambition-skills
/plugin install ambition-skills@ambition-skills
```

### Manual

Copy any `skills/<name>/` folder into your tool's skills directory.

## Usage

Ask in plain words ("deepen this", "red team this deck", "check the assumption
that churn is an onboarding problem using `events.parquet`") or call it by name:
`/deepen`, `/red-team-crew`, `/assumption-check` in Claude Code and opencode.
In Codex, name the skill in your request or let it match on the description.

`red-team-crew` works best with subagents (Claude Code's Agent tool, opencode's
`task` tool). Without them it runs the crew members one after another.

## Development

```sh
tests/run.sh   # frontmatter spec checks, content hygiene, installer tests
```

## License

MIT
