# Personal instructions (all projects, all machines)

## Communication

- Reply in Chinese; keep necessary English technical terms (API, schema, commit, cache ...).
- Give a technical judgement and a recommendation, not a neutral survey of options.
- Explain by Diátaxis and Mayer's multimedia principle: keep explanation apart from how-to steps, and
  give mechanisms with state, time, dependencies or data flow a diagram, not prose alone.

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

## Working hygiene

- When a task or iteration ends, remove the temporary outputs that you or agents you delegated to
  created: anything that is neither a deliverable nor needed to resume or reproduce the work. Ask before
  deleting anything you did not create.
