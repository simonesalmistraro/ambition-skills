---
name: assumption-check
description: Adversarially test a belief against raw data, then look for a signal
  nobody knows about yet and prove it on held-out data. Use when the user says
  "check this assumption", "is it really true that", "test this belief", "prove
  it from the data", "what are we missing in this data", "/assumption-check", or
  states a causal claim ("X is caused by Y", "churn is an onboarding problem")
  alongside a data source.
argument-hint: "\"<belief>\" <data source: path, DB, table, API, logs>"
license: MIT
metadata:
  opencode/slash: "true"
---

# Assumption Check

Source: Felix Rieseberg, "How to be more ambitious" (Oct 2026), Depth section
("challenge what you know", "produce new knowledge", "use an outside judge").

## Input

The belief and the data source: the text the user gave with the request (Claude Code passes it as `$ARGUMENTS`; Codex and opencode put it in the user's message). If either is missing, ask
once and stop. Restate the belief as a falsifiable claim with a measurable
outcome. If it cannot be made falsifiable, say so and stop.

## Rules

- Work from the RAWEST data available (events, logs, rows), never from an
  existing dashboard or summary of it.
- Use real instruments: a database or dataframe and a statistical test or model.
  Markdown tables are output, not analysis.
- Before ANY exploration, split the data: hold out the most recent period (or a
  random 20-30% if not time-ordered). Do not look at the holdout until Phase 3.
  Record the split in the report.
- Read-only on production data. Keep scratch code and queries in one dedicated
  folder. Use parameterized queries; add LIMIT while exploring.

## Phase 1: Try to reproduce the belief

Write down, before computing, what the data would look like if the belief is
true AND what it would look like if false. Then compute both on the
exploration set. Check confounders and base rates. Verdict: supported /
partially supported / not supported, with effect size and uncertainty.

## Phase 2: Find what we don't know

While loaded in the data, search for the earliest or strongest signal of the
outcome that the belief does NOT explain. Build the simplest model that could
reproduce the observed outcome (a baseline first, then one step up). Name at
most 3 candidate signals, each with why it might matter.

## Phase 3: Outside judge

Freeze the candidate signals and thresholds, THEN evaluate on the holdout.
Report each against the baseline with a metric fixed in advance (e.g. AUC,
precision at k, lift). A signal that does not beat baseline on the holdout is
reported as failed, not dropped. No tuning on the holdout.

## Report

1. Belief as tested (falsifiable form) and verdict with numbers.
2. Data used, split, and anything that limits trust (missing data, leakage risk).
3. New signals: holdout result vs baseline, pass/fail.
4. The one decision this changes, and the next test worth running.
Keep code and queries in the scratch folder and list their paths so the result
can be rerun.
