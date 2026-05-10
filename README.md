# agents-skills — SQL & ORM Optimization for AI Coding Agents

Developer-focused SQL and ORM optimization skills for AI coding agents.

This repository contains custom skills for GPT Codex-style agents that help developers review, optimize, and safely validate database queries, ORM access patterns, and schema design.

---

## ⚠️ On the Careful Use of Database Queries

Database optimization is one of the highest-risk areas of backend engineering. A query that _looks_ faster can silently return wrong data, skip rows, produce duplicates, lock a table for minutes, or destroy write throughput under load.

**AI-generated SQL must never be trusted blindly.** These skills are built to help you reason — not to replace your judgment.

### What can go wrong

| Change | Hidden risk |
|--------|-------------|
| Adding an index | Slows down `INSERT`, `UPDATE`, `DELETE`; uses disk; may lock table |
| Rewriting a `JOIN` | Can change result cardinality, introduce duplicates, or drop rows |
| Adding a `LIMIT` | Changes result set, not just speed |
| Reordering `WHERE` clauses | Usually safe, but optimizer-dependent |
| Switching from subquery to `CTE` | Different execution plans, different performance profiles |
| Using `DISTINCT` to "fix" duplicates | Masks a broken join — fix the join instead |
| Removing an `ORDER BY` | Can break pagination, cursor logic, or UI assumptions |
| Running `ALTER TABLE` on a large table | May lock reads and writes for the duration |
| Running `CREATE INDEX` without `CONCURRENTLY` | Locks the table while building |
| Data backfills with `UPDATE` | Can hold locks, fill WAL, or kill replication lag headroom |

### Rules before touching any query in production

1. **Understand what the original query returns.** Run it. Count rows. Note ordering. Know the data.
2. **Verify the optimized version returns the same data.** Use `EXCEPT`, `COUNT(*)` diffs, and ordering checks — not just visual inspection.
3. **Run `EXPLAIN (ANALYZE, BUFFERS)`** on both the old and new query with realistic data volumes.
4. **Test on a safe environment first.** Local, development, staging, or a read-only replica — never directly on production.
5. **Have a rollback plan.** For any schema change or index addition, know how to undo it before you apply it.
6. **Consider write impact.** Every index you add is a cost paid on every write to that table.
7. **Review lock behavior.** Some migrations are safe. Others take a full table lock for the duration. Know which you are running.
8. **Never run generated SQL inside an open transaction without understanding the scope.** Long-running queries inside transactions can block everything that touches the same rows.

### Especially dangerous operations — always double-check these

```sql
CREATE INDEX                   -- locks table during build
CREATE INDEX CONCURRENTLY      -- safer, but can fail and leave partial index
ALTER TABLE                    -- may rewrite the entire table
DROP INDEX                     -- may break queries relying on that index
DROP COLUMN                    -- destructive and often irreversible
DELETE                         -- verify WHERE clause thoroughly
UPDATE                         -- same; verify scope before running
```

If you are unsure about any of the above, do not run it. Get a second opinion, test on a copy of production data, and use `EXPLAIN` before touching anything live.

---

## Installation

### Option 1: Without cloning

```bash
# For codex
curl -fsSL https://raw.githubusercontent.com/Nikxxx007/agents-skills/main/scripts/install-codex-remote.sh | bash

# For claude code
curl -fsSL https://raw.githubusercontent.com/Nikxxx007/agents-skills/main/scripts/install-claude-remote.sh | bash
```

### Option 2: With cloning (safer)

```bash
git clone https://github.com/Nikxxx007/agents-skills.git
cd agents-skills

# For codex
./scripts/install-codex.sh

# For claude code
./scripts/install-claude.sh
```

Restart your agent session after install.

---

## What this skill pack helps with

- Reviewing raw SQL queries for correctness, performance, and production risk
- Optimizing SQL queries safely, with explicit tradeoff documentation
- Reviewing ORM-generated database access patterns
- Improving ORM queries without changing response shape
- Reviewing schema design and migration risks
- Identifying index opportunities and write-side tradeoffs
- Generating verification plans with `EXPLAIN (ANALYZE, BUFFERS)`
- Comparing old vs optimized query behavior for correctness
- Producing result comparison scripts to validate equivalence

---

## Safety warning

Do **not** blindly run AI-generated SQL against production databases.

These skills may generate:

- query rewrites
- index suggestions
- schema change suggestions
- migration drafts
- rollback drafts
- performance test scripts
- result comparison scripts

You are responsible for reviewing and testing everything before use. Run all generated SQL in a safe environment first: local, development, staging, or an anonymized copy of production data.

---

## Commands

### `/sql-review-query`

Reviews raw SQL for performance, correctness, index usage, joins, filtering, sorting, pagination, and production risks.

Use this before rewriting anything. Good for finding:

- slow joins
- bad filters
- unstable pagination
- missing tie-breakers in `ORDER BY`
- unsafe date filtering
- duplicate rows from bad joins
- `NULL` handling issues
- missing indexes
- production-level risks

---

### `/sql-optimize-query`

Rewrites raw SQL for better performance while preserving returned data.

The skill explains:

- what the original query does
- what was changed and why
- what behavior could accidentally change
- what indexes may help
- what tradeoffs exist
- how to verify with `EXPLAIN (ANALYZE, BUFFERS)`

---

### `/sql-review-schema`

Reviews schema design, constraints, relationships, data types, indexes, and migration risks.

Good for finding:

- missing constraints and foreign keys
- bad data type choices
- JSON/array misuse
- soft delete problems
- poor table boundaries
- risky migrations
- index design issues that hurt future queries

---

### `/sql-review-orm-query`

Reviews ORM database access code for hidden performance and correctness issues.

Good for finding:

- N+1 queries
- over-fetching and missing projections
- unbounded queries
- application-side filtering and sorting
- bad relation loading strategy
- transaction issues

**Strongly supported:** TypeORM, Prisma, Knex
**Best-effort:** Sequelize, MikroORM, GORM, sqlc, Drizzle, Entity Framework, Hibernate

---

### `/sql-optimize-orm-query`

Optimizes ORM database access code while preserving the returned data shape.

Helps with:

- reducing unnecessary relation loading
- adding explicit projections
- fixing N+1 queries
- improving pagination
- moving filtering into the database
- reducing entity hydration cost
- deciding when raw SQL is the cleaner option

---

### `/sql-test-query-performance`

Generates a safe verification workflow to compare old vs optimized query performance and result equivalence.

Use this to prove an optimization is both faster and returns the same data.

Can generate:

- baseline and optimized `EXPLAIN (ANALYZE, BUFFERS)` commands
- row count comparison SQL
- result diff SQL using `EXCEPT`
- duplicate-aware comparison checks
- ordering stability checks
- index verification steps
- rollback notes
- final verdict: `Safe to consider`, `Not safe`, or `Needs more evidence`

This command is intentionally conservative. It is a verification tool, not an optimization autopilot.

---

## Recommended workflow

```
1. /sql-review-query or /sql-review-orm-query
2. /sql-optimize-query or /sql-optimize-orm-query
3. /sql-test-query-performance
4. /sql-review-schema when schema or migration risk is involved
```

Review first. Optimize second. Verify third. Only then consider applying the change.

---

## Repository structure

```
agents-skills/
  README.md

  skills/
    sql-review-query/
      SKILL.md
    sql-optimize-query/
      SKILL.md
    sql-review-schema/
      SKILL.md
    sql-review-orm-query/
      SKILL.md
    sql-optimize-orm-query/
      SKILL.md
    sql-test-query-performance/
      SKILL.md

  scripts/
    install-codex.sh
    install-codex-remote.sh
    uninstall-codex.sh
```



---

## Uninstall

```bash
# For codex
./scripts/uninstall-codex.sh

# For claude code
./scripts/uninstall-claude.sh
```

Or manually:

```bash
rm -rf ~/.agents/skills/sql-review-query
rm -rf ~/.agents/skills/sql-optimize-query
rm -rf ~/.agents/skills/sql-review-schema
rm -rf ~/.agents/skills/sql-review-orm-query
rm -rf ~/.agents/skills/sql-optimize-orm-query
rm -rf ~/.agents/skills/sql-test-query-performance
```

---

## Providing context for better results

These skills do not know your production workload. For stronger recommendations, provide:

- database engine and version
- table schemas and existing indexes
- approximate row counts
- query frequency and latency target
- generated SQL output for ORM queries
- `EXPLAIN (ANALYZE, BUFFERS)` output
- whether ordering matters for correctness
- whether the query runs in a hot production path

Without this context, the agent will give best-effort advice and mark confidence as low or medium.

---

## Philosophy

Performance advice is cheap. Safe performance improvement is harder.

This skill pack focuses on both. The goal is not to make the agent sound confident — it is to force better reasoning, clearer tradeoff documentation, and safer verification before any change reaches production.
