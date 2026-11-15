# how this works

trial: <START DATE> to <END DATE>. keep this file under one page.

## the idea

you keep one list, [[todo]], however you like: add, reword, check, delete. an agent reads it next to the chat tool and the ticket board and writes [[implications]]: what your list touches, what follows from your edits, and what's happening that your list doesn't mention. your list says what you intend; the chat tool and the board say what's happening; the agent works on the gap.

## rules

1. **your list is yours.** the agent never writes to `todo.md` on its own. it makes a specific edit only when you ask for one in that session, in your words. order doesn't mean priority unless you say so. bullets are items; anything else you write in that file is a note the agent reads as context.
2. **everything else is generated** and rebuilt on each run, except the log (append-only), `state/decisions.md` (the memory), and outside reading you hand in (`reading/` and sections marked kept).
3. **implications run both ways.** list -> world: what a new, checked or deleted item leaves behind. world -> list: commitments, asks and dated things your list doesn't have.
4. **nothing found is silently dropped.** an entry under "not on your list" stays until it's resolved, you put it on your list, or you say drop it.
5. **tags on anything that isn't plain fact.** (committed) someone said they'd do it or it's a ticket · (proposed) floated, not agreed · (inferred) a reading, check the source · (digest) from a summary, not re-read.
6. **every line an agent adds has a source link.** click through before acting on a top item.
7. **reading is free; writing to the chat tool or the board needs an explicit yes, each time.** tickets are queried, never copied.
8. **sharing rule.** an item can be shown only to people who can already see its source, and only if it's a sourced fact. this folder is private.
9. **rules change only at the weekly pass,** unless you say yes on the spot, and each change names the incident that caused it.

## layout

- [[todo]] - your list. [[implications]] is embedded under it.
- [[implications]] - generated: not on your list, your list item by item, changes since last run, writes waiting for your yes, waiting on others
- `streams/` - one page per workstream, for depth.
- `reading/` - outside reading you hand the agent ("ingest"). never rebuilt.
- [[agent]] - instructions for any agent session running this, incl. ids and the board query
- [[log]] - one entry per session; the handoff between sessions
- `state/` - the agent's bookkeeping: your list as of the last run, the watch list and read marks, `decisions.md`, `archive/` (your list and [[implications]] as each run left them) and `metrics.csv` (one row of counts per run)

## rhythm

- **daily:** edit your list, then tell an agent session "process".
- **weekly:** "weekly pass" - this week's tickets vs your list, items untouched for 14+ days, the trial checks, rule changes.
- **after a gap:** "catch up on <stream>".

## trial checks

1. re-entry: can you start the week from [[todo]] + [[implications]] in ~10 min without opening the chat tool first?
2. catches: at least one thing per week under "not on your list" that you'd have dropped?
3. upkeep: daily run under 10 min of your attention?

## changes

one line per change: the date, what changed, and the incident that caused it. a rule with no incident behind it doesn't go in.

- <DATE>: created.

optional add-on from the first user (2026-11-15): cmux workspaces, one per top-level list item, with "take stock", "regroup" and "spawn" - see "workspaces (cmux)" in agent.md. incident behind it: 58 terminal tabs in 11 workspaces named after whichever tab was selected. tested with cmux 0.65.2 only.
