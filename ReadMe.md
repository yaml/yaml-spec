
## Changes

- Update `@actions/cache` from `^5.0.5` to `5.1.0`
- Add npm `overrides` to pin transitive dependencies to secure versions:
  - `undici`: `^6.24.1` (resolves to 6.27.0) — addresses CVEs in undici <6.x
  - `fast-xml-parser`: `^5.9.2` (resolves to 5.9.3)
- Update `.licenses/npm/` dep.yml files via `licensed cache` to reflect new resolved versions
- `npm audit` reports 0 vulnerabilities
