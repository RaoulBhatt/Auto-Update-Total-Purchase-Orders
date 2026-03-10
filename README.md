# Auto Update Total Purchase Orders

Business Central per-tenant extension managed with AL-Go for GitHub.

## What It Does

This app adds a `Line Totals Check` FactBox to:

- Purchase Order
- Purchase Invoice

The FactBox shows:

- `Live Total Excl Tax`

The value is calculated from `Purchase Line."Line Amount"` for the current document and is intended to refresh when:

- lines are added
- lines are deleted
- `Quantity` changes
- `Direct Unit Cost` changes
