# agents-skills

## Install for GPT Codex

### Option 1: install without cloning

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/sql-optimization-agent-skills/main/scripts/install-codex-remote.sh | bash
```

### Option 2: install with cloning

```bash
git clone https://github.com/YOUR_USERNAME/sql-optimization-agent-skills.git
cd sql-optimization-agent-skills
./scripts/install-codex.sh
```

## Commands

- `/sql-review-query` — Reviews raw SQL for performance, correctness, index, join, filtering, sorting, pagination, and production risks.
- `/sql-optimize-query` — Rewrites raw SQL for better performance while preserving returned data and providing verification steps.
- `/sql-review-schema` — Reviews schema design, constraints, relationships, data types, indexes, and migration risks.
- `/sql-review-orm-query` — Reviews ORM code for N+1 queries, over-fetching, missing projections, bad relation loading, and generated SQL risks.
- `/sql-optimize-orm-query` — Optimizes ORM code while preserving response shape and explains when raw SQL is a better choice.
- `/sql-test-query-performance` — Generates a safe test plan to compare old vs optimized query performance and result equivalence.

# Do not use sql-optimization-agent-skills in production databases