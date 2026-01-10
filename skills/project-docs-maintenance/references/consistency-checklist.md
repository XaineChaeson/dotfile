# Consistency Checklist

- Entrypoints in docs exist in code and names match.
- Defaults and required fields match code behavior.
- Config keys and schema match current implementation.
- Errors and edge cases reflect current code paths.
- Examples are runnable or explicitly marked as pseudocode.
- Lifecycle examples (when required) cover all public entrypoints in order.
- If lifecycle is split, the index includes a full coverage matrix and a runnable happy-path subset.
- Phase pages link back to the lifecycle index and avoid repeating full IO details.
- Architecture diagrams align with current modules.
- Module docs reflect actual boundaries and responsibilities.
- User docs link to dev interfaces instead of repeating IO details.
- Scenario index aligns with API overview table.
- Change log or devlog updated when public behavior changes.
- Glossary/term usage is consistent across user and dev docs.
- Versioning and stability labels are present where required.
