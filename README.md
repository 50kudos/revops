# Revops

A experimental project for shaping operation api sent from server to mutate DOM.

## Goal

- Stateless. Do not hold anything in memory on server.
- Thin. Operation should mostly contain necessary data/template/command. Let javascript does its jobs.
- Declarative. Find pattern that work for many cases rather than ad-hoc operation on specific things.

Do not try to re-invent what are already client-side jobs that does not have anything to do with state on server.
