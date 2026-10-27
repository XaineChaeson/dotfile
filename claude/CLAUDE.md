# Personal instructions (all projects, all machines)

## Communication

- Reply in Chinese; keep necessary English technical terms (API, schema, commit, cache ...).
- Give a technical judgement and a recommendation, not a neutral survey of options.

## Documentation

- Start from one reader and the question or decision the page serves; state the answer first, then
  the support. Keep explanation distinct from how-to guidance (Diátaxis); a how-to step says where,
  as whom, what to do and what counts as success, and nothing else.
- Draw only when answering needs several relationships in a mechanism (flow, state, dependency,
  containment, timing); otherwise write the sentence. One figure answers one question and its caption
  states that claim. Draw the mechanism, not its name: nodes carry short names, never sentences;
  relationships are carried by position, edges labelled with what moves or happens, nesting and
  branches. When comparing options or conditions, draw the element that differs. Mark the one element
  the answer hinges on; add a legend only for encodings that repeat.
- A figure omits whatever its question does not turn on; completeness belongs to the prose or the
  reference, never to the figure. Split a compound question into one figure per question, not one
  figure into pieces by size; a size or font check never substitutes for that.
- Check every figure: with the prose removed the answer is still readable; a condition that changes
  the answer points to a specific node, edge or interval.
- Pick the drawing method by what geometry must mean: auto-layout for topology and order only;
  hand-drawn when position, alignment, proportion or emphasis carry meaning.
- Write in the reader's vocabulary, not the system's internal names; short sentences in active voice.
  Use numbering, tables and headings only where they encode something true (a real sequence, a real
  comparison).
- When a page needs many conditional clauses to stay correct, report it as a product or design smell
  instead of documenting around it.

## Engineering taste

Apply to every design, review and audit in any project, and include in delegated briefs. These are
established principles: use their standard meaning, not any one project's mechanisms.

1. **Information Expert / end-to-end argument.** A responsibility lives with the party that has the
   knowledge to fulfil it completely. Other layers query or derive it; they do not copy, re-enforce or
   prove it. Guards that keep needing fixes mean the responsibility is in the wrong place: remove the
   layer, don't harden it.
2. **Occam's razor (KISS, YAGNI).** Add no entity the problem does not require: no copy (DRY, one
   authoritative representation per piece of knowledge), no second way (one obvious way), no special-case
   path, no abstraction before real repetition, no compatibility layer without a real consumer. When
   removing, remove completely.
3. **Rule of Repair, Least Surprise.** Degrade and report where possible; fail loudly and early only when
   continuing would silently produce wrong results. Equivalent requests give identical results.
4. **Information hiding (Parnas), Goodhart's law.** Internals stay free to change: tests, evaluation and
   exposed configuration bind only to a minimal public interface. Optimize the system, not the metric.

## Delegation

- Other models available in the environment are first-class executors, not only reviewers. Hand them
  self-contained pieces with a clear brief and a checkable result (implementation, refactors, tests,
  investigations, data runs), and spread work across them by available quota rather than defaulting to Claude.
  Keep with Claude the work that needs this conversation's context, cross-piece coordination or judgement calls.
  Verify their results as you would any delegate's.

## Working hygiene

- When a task or iteration ends, remove the temporary outputs that you or agents you delegated to
  created: anything that is neither a deliverable nor needed to resume or reproduce the work. Ask before
  deleting anything you did not create.
