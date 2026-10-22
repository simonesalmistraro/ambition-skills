---
name: red-team-crew
description: Bring methods from several fields, including adversarial ones, to a
  piece of work by reframing it as verbs, picking a crew of disciplines, and
  running each as a subagent that applies that discipline's methods. Use when the
  user says "assemble the crew", "red team this", "bring in other fields", "what
  would other disciplines do", "/red-team-crew", or for a high-stakes deliverable
  (deck, launch, proposal, architecture, investment case, website) that should be
  attacked and improved from several angles.
argument-hint: "[the work: file path, URL, or description]"
license: MIT
metadata:
  opencode/slash: "true"
---

# Red-Team Crew

Source: Felix Rieseberg, "How to be more ambitious" (Oct 2026), Range section.
Core rule: each crew member DOES what that professional does. Nobody writes
"in the voice of" anyone. Role-play makes transcripts weirder, not work better.

## Input

The work (path, URL or description): the text the user gave with the request (Claude Code passes it as `$ARGUMENTS`; Codex and opencode put it in the user's message). Read it first. If there is
no artefact yet, work from the description.

## Step 1: Nouns to verbs

Rewrite what the work IS as what it must DO, in one sentence of verbs with its
real constraints (audience, time, stakes).
Example shape: not "a deck" but "get busy people to believe a cause-and-effect
story and decide under uncertainty in 30 minutes".
Show this sentence to the user; it drives every pick below.

## Step 2: Pick the crew (4-6 members)

From the verbs, choose disciplines. Always include:
- **Builders** (2-3): fields that make the work better (e.g. analyst, editor,
  journalist, motion designer, performance engineer, UX researcher).
- **Adversaries** (1-2): fields paid to find the flaw (e.g. short seller,
  forensic accountant, penetration tester, opposing counsel, hostile reviewer).
- **One unexpected field** (0-1): a discipline not obviously related that the
  verbs point to. Say why in one line.

For each member write: field, the concrete method they apply, the tool or data
they need, and what they deliver. Show the table to the user and ask once
whether to adjust before spawning. If the user said "just run it", skip asking.

## Step 3: Spawn

Run each member as a subagent, all in parallel if your tool allows it
(Claude Code: Agent tool, several calls in one message; opencode: `task` tool;
no subagents available: run the members one after another yourself, each in a
fresh section that does not reuse earlier members' findings). Each brief contains:
- the verb sentence from Step 1 and the path/content of the work;
- the method to apply, phrased as actions ("trace every number in the deck to
  its source and list the ones that do not reconcile"), never "act as X";
- read-only by default: findings and proposed changes, no edits to the work;
- output format: max 5 findings, each with evidence (file:line, number, source)
  and a severity (blocker / major / minor).

## Step 4: Synthesize

- Merge duplicates; where builders and adversaries conflict, say so explicitly.
- Rank by severity, then by how many members independently found it.
- Drop findings with no evidence.
- End with the top 3 changes to make, and ask whether to apply them.
