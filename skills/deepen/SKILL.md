---
name: deepen
description: Rewrite a task request into the version a field-leading professional
  would do, before any work starts. Use when the user says "deepen this", "make
  this deeper", "what would an expert do here", "raise the bar on this prompt",
  "/deepen", or hands over a task where quality matters more than speed (analysis,
  reports, performance work, research, design). Not for quick one-off edits.
argument-hint: "[task description, or empty to use the last request]"
license: MIT
metadata:
  opencode/slash: "true"
---

# Deepen, Don't Enlarge

Source: Felix Rieseberg, "How to be more ambitious" (Oct 2026), Depth section.
Goal: a deeper version of the task, NOT a bigger one. More scope is failure.

## Input

The task: the text the user gave with the request (Claude Code passes it as `$ARGUMENTS`; Codex and opencode put it in the user's message). If empty, use the user's most recent task request.
If there is no task to deepen, ask for one and stop.

## Step 1: Ground in the real material

Spend at most a few tool calls finding what actually exists: the raw data, logs,
repo, tools installed. The answers below must name real things in this
environment where possible, not generic advice.

## Step 2: Answer the four questions

Write each as 1-3 concrete lines:

1. **Expert gap.** What would a top professional in this field do here that the
   request does not ask for?
2. **Rawest material.** What source would they start from instead of the
   already-digested input the user supplied (summaries, templates, dashboards)?
   Name the file, table, API or log.
3. **Instruments.** Which specific methods and tools would they use? Real
   instruments (database, statistical model, profiler, test harness), not a
   change of vocabulary. Persona wording with the same method is a fail.
4. **Outside judge.** What, other than you or the user, will show the result is
   right? A test, benchmark, held-out data, validator, real device, second
   source. If nothing exists, say what must be built first.

## Step 3: Set the target

If the task has a number (latency, accuracy, cost, size), propose a target well
beyond what was asked (an order of magnitude where plausible) and state it as
achievable. Keep the user's original number as the floor.

## Step 4: Rewrite the prompt

Output the rewritten request as a single fenced block the user can approve,
edit, or paste. It must name: the raw inputs, the methods/tools, the target, and
the outside judge with its pass criterion.

## Step 5: Stop

Do NOT start the work. Ask: "Run this version, edit it, or keep the original?"
If they approve, execute the rewritten prompt and report against the outside
judge, not your own assessment.

## Checks before output

- Scope did not grow: same deliverable, deeper method.
- Every tool and data source named actually exists or is flagged as missing.
- The judge is external to the model.
