# Repository retirement

## Personal skill manager

On 2026-10-13, the local `codex-skills` installation was retired. New-machine
setup uses this repository's [installer](../README.md#install) for portable
configuration. It does not require cloning or running the retired skill manager.
Codex system skills and connected-plugin skills remain managed by their owners.

### Ownership and removal evidence

The manager's `skills.toml`, installer implementation, and
`~/.codex/skills/.skill-provenance.json` agreed on five installed skills. Before
removal, each installed normalized tree hash matched either its custom source
tree or the pinned third-party manifest hash:

| Removed directory under `~/.codex/skills` | Source owner | Verified normalized SHA-256 |
| --- | --- | --- |
| `acceptance-test-builder` | Custom skill in `codex-skills` | `4e1b79f47723daa546c1abde1a6c5d8c6ad09558e988fa3009b37c3b6f9b39fa` |
| `project-docs-maintenance` | Custom skill in `codex-skills` | `9222e226bd76cff1c54f30b140134ccffa5d0da586c865ea47aee3cf2846eaba` |
| `refactor-playbook` | Custom skill in `codex-skills` | `54705d78870362599ff7a9338a7f22cb3cb6e08b2a8d94cdf72246350f8140de` |
| `grill-me` | `mattpocock/skills`, pinned third-party copy | `6bc018fc06fe3a56316f6283df01f9c34506e504c662d9dbf0b6a3f4c956b8f2` |
| `grilling` | `mattpocock/skills`, pinned third-party copy | `2a23ad7b5a80105b1c198a412a9d7a1d1ad83c74b96e44eac31d089eda3a873a` |

Both third-party entries used revision
`2ab958093e83e0ec752e6c1c5932da465bf23e0c`. The `grill-me` manifest transformation
removed its unsupported `disable-model-invocation` frontmatter key. All five
installed paths were directories, not symlinks. Their generated provenance file
contained only these five records and was removed with the directories.

`~/.codex/skills/.system` was preserved. Plugin-owned skill installations were
outside the removed paths. No unmanaged skill directory was present in the
audited installation. The obsolete `dotfile/skills` directory hierarchy contained
no files or links and was removed. The bootstrap and uninstall scripts already
contained no skill installation or removal commands; their configuration and
shell-tool behavior was retained. The old README instruction to clone and run
`codex-skills` was replaced with the current ownership boundary.

### Verification and preserved work

The five pre-existing local changes were protected by file SHA-256 comparison:
`chrome_devtool_remote/runbook.md`, `chrome_devtool_remote/start-devtools.ps1`,
`codex/AGENTS.md`, `codex/config.portable.toml`, and the untracked
`chrome_devtool_remote/chrome-devtools-mcp-launcher.sh`. Their contents were not
changed by retirement work. The system skill tree was also compared before and
after removal. No credentials or machine-local configuration contents are part
of this record.

Shell syntax validation and checks of the retirement edits passed. The existing
`chrome_devtool_remote/runbook.md` change has trailing whitespace at line 186;
that user-owned change was preserved and is outside the retirement edits.
A temporary-home check ran
the existing installer twice and then the uninstaller: the unrelated system and
unmanaged skill markers and pre-existing machine-local config were preserved,
while the managed portable copies were removed. The live installed skill root
contained only `.system` after retirement. The temporary recovery archive was
removed after these checks.

### Cloud archive and local source retirement

The private [codex-skills repository](https://github.com/XaineChaeson/codex-skills)
was archived on 2026-10-13. GitHub returned `archived: true` after the update.
Its main commit `62bb467958659b628a889245e921b178ca9cb42b` matched the local main;
the local repository had no additional branches, tags, worktrees, or uncommitted
content. Only ignored Python bytecode caches remained. After confirming the
remote history and archived state, `/home/xainewsl/code/codex-skills` was removed.
The history remains available from the archived private repository.

The local dotfile checkout retains its existing portable-configuration branch
and the five pre-existing user changes listed above. The cloud default branch
is cleaned separately so those unrelated configuration changes are not bundled
into its retirement commit.

### Codex discovery verification

The live `~/.codex/skills` root contains only `.system`; the removed provenance
file is absent. No personal `~/.agents/skills`, parent `~/code/.agents/skills`,
dotfile-scoped `.agents/skills`, or `/etc/codex/skills` directory was present.
Neither the live Codex config nor the portable dotfile config contains a
`skills` table. Plugin-managed skills were not changed. These paths were checked
against the [official local skill discovery guidance](https://learn.chatgpt.com/docs/build-skills#where-codex-loads-local-skills).
If the UI still displays stale entries, reopen Codex; the official guidance says
skill changes are detected automatically and recommends a restart if needed.

## Resonant repositories

The following private repositories were retired by archival on 2026-10-13:

| Repository | Verified GitHub state |
| --- | --- |
| [resonant-alpha-openclaw](https://github.com/XaineChaeson/resonant-alpha-openclaw) | `archived: true`, private |
| [resonant-alpha-openclaw-system](https://github.com/XaineChaeson/resonant-alpha-openclaw-system) | `archived: true`, private |
| [resonant-alpha-skills](https://github.com/XaineChaeson/resonant-alpha-skills) | `archived: true`, private |
| [resonant-alpha-vault](https://github.com/XaineChaeson/resonant-alpha-vault) | `archived: true`, private |

Each action checked the exact repository identity and administrator permission,
then read the repository again to verify archival. History and private visibility
were preserved. The scoped WSL `~/code` inventory found no corresponding local
checkout. This record covers GitHub and WSL `~/code`; Windows services, other
disks, and deployments are outside this governance scope.

## Remaining ownership

QL naming, Task migration/tool consolidation, environment/performance cloud
repositories, and QL development-artifact cleanup are assigned to Claude in
QuantumLab's `docs/dev/active-plans/repository-governance.md`. BTC and polymarket
repositories remain unchanged. `constellation` and other unrelated repositories
were not included in Resonant retirement.
