# watch list and read times

kept by the agent. which conversations are listed is the person's call: they say "watch <conversation>" or "stop watching <conversation>" and the agent edits the table.

conversations a run reads in full. everything else is covered by three searches (mentions of them, messages to them, messages from them).

| conversation | id | read up to | value to pass as the read mark |
|---|---|---|---|
| <NAME> | `<ID>` | | |

a row with no "read up to": the first run reads the last 7 days.

searches read up to: never - the first run searches the last 7 days.

last run: never.
