# deploy.yml

## Function
Builds the site and publishes it to GitHub Pages on every push to `main`. It
is the only path by which the live site changes; `public/` is gitignored
precisely so that no hand-built copy can be committed and drift.

## Interface
- Triggers: push to `main`, and manual `workflow_dispatch`.
- Permissions: `contents: read`, `pages: write`, `id-token: write` — the
  minimum the `deploy-pages` action's OIDC flow needs.
- Jobs: `build` (emits the `public/` directory as a Pages artifact) and
  `deploy` (consumes it). `deploy` needs `build`.
- `ZOLA_VERSION` — `0.20.0`, the zola this workflow installs.
- Concurrency group `pages`, `cancel-in-progress: true`.

One-time manual setup this file cannot do for you: Settings → Pages → Source
→ "GitHub Actions", and the custom domain `phaselock.tech` with DNS pointing
at GitHub.

## Implementation
`ZOLA_VERSION` duplicates a fact that lives in `shell.nix`, because Actions
has no nix and `shell.nix`'s nixpkgs pin is the thing that decides the local
version. The two are kept equal by hand. This is the repo's one accepted
duplication; the alternative — installing nix in CI — costs minutes per run
for a site that builds in six milliseconds.

The build step runs a bare `zola build` with no `--base-url`. CI therefore
reads the same `base_url` from `config.toml` that a local build does, and
cannot produce URLs a developer never saw.

`static/CNAME` needs no special handling: zola copies everything under
`static/` into `public/` verbatim, so the CNAME lands at the artifact root
where Pages expects it.

Concurrency is grouped so two pushes cannot deploy out of order, with
`cancel-in-progress` so a superseded build does not spend a runner finishing a
version that is already stale.

## Assertions
- `ZOLA_VERSION` equals `zola --version` inside `nix-shell`.
- The build step passes no `--base-url`, so `config.toml` stays authoritative.
- `upload-pages-artifact`'s `path` is `public`, matching zola's output dir.
- The `permissions` block grants no more than `pages: write`,
  `id-token: write`, `contents: read`.
- `/public` stays in `.gitignore` — a committed build would shadow nothing in
  CI but would mislead every reader of the repo.
