# Comms templates — three audiences

Three pre-drafted templates for "we rolled it back". Fill `{{change_description}}` at plan time (from Q1). Fill `{{trigger_that_fired}}` and `{{status_link}}` at incident time.

## Internal (on-call channel / team broadcast)

> Heads up — we rolled back `{{change_description}}` at <time UTC>. Trigger: `{{trigger_that_fired}}`. Kill-switch flipped by `<launch-lead>`. Investigation in progress; updates every 30 min. Status: `{{status_link}}`. If you have data, drop it here. If you don't, please don't @ the DRI — let them work.

## Customer (status page / email / in-product banner)

> We identified an issue affecting `{{change_description}}` and rolled back the change at <time>. Most users should see normal behavior within a few minutes. We're investigating root cause and will post an update within 24 hours. We're sorry for the disruption — if you're seeing residual issues, reply to this message or check `{{status_link}}` for live updates.

## Exec (one-paragraph brief to leadership)

> We rolled back `{{change_description}}` at <time UTC> after `{{trigger_that_fired}}` tripped our pre-defined threshold. Customer impact: <scope from Q2 blast radius>. Kill-switch worked as designed; no manual intervention beyond the flip. DRI `<launch-lead>` is leading the investigation with `<oncall-engineer>`. Comms have gone to customers via `{{status_link}}`. Postmortem within 5 business days. We'll re-attempt the launch after root cause is fixed and the dry-run has been repeated.
