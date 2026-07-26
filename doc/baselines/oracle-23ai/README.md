# Oracle 23ai Reference Baseline

This directory records the Oracle reference environment and semantic-layer state captured for AISA-002.

## Environment

* Database: Oracle Database 23ai Free
* Version: 23.9.0.25.07
* Schema: AISQL
* Database/PDB: FREEPDB1
* Service: freepdb1
* Source revision: `bba8269d6d5a3ad5a563034d9ef39ab2bfb16934`

## Evidence

* `query1.log` — database identity, version, objects, statistics, privileges, and enabled roles
* `query2.log` — semantic-table counts, definitions, constraints, indexes, and comments
* `query3.log` — semantic-to-physical integrity and coverage checks
* `semantic.log` — complete demo semantic-object, column, alias, question, and exemplar SQL content
* `test_results.log` — application unit-test baseline

## Interpretation

The semantic layer contains 15 registered views, 132 semantic columns, 60 aliases, and 31 enabled example questions with exemplar SQL.

All registered semantic objects exist as Oracle views. No missing physical objects, invalid object types, foreign-key orphans, inconsistent object flags, or duplicate display ranks were detected.

Audit fields such as `CREATED_ON` are intentionally excluded from semantic metadata. `V_ADDRESS_MASTER.ADDRESS_LINE2` was identified as a reporting field that should be added to the semantic layer in follow-up work.

The current AISQL identity is broadly privileged. Least-privilege runtime access is deferred to AISA-010.

This directory preserves the observed baseline; identified semantic-content improvements are not silently applied here.
