# shell.nix

## Function
The dev environment for the phaselock.tech site, and the single source of
truth for the tools it needs. `nix-shell` from the repo root is the supported
way to build, preview or check the site; running a system-installed `zola`
against this tree is off the supported path, because that binary is not
version-matched to what CI uses.

## Interface
- `nix-shell` → a shell with `zola` on `PATH` (0.20.0 on the current pin).
- `nix-shell --run '<cmd>'` → one-shot execution, used by every verify command
  in this repo's docs.
- The derivation is named `phaselock-site`.
- The shell prints a three-line cheat sheet on entry: `zola serve`,
  `zola build`, `zola check`.
- Accepts a `pkgs` argument so a caller can override nixpkgs; the default is
  the pin below.

## Implementation
nixpkgs is pinned via `builtins.fetchTarball` with an explicit rev and
`sha256`, not `<nixpkgs>`, so the shell resolves to the same zola on any
machine and in any month. The rev (`ac62194c…`, nixos-25.05) is the same one
`~/code/trellis` pins, chosen because it was already known-good and cached
locally; on this rev `pkgs.zola.version` is `"0.20.0"`.

That version is load-bearing in two directions. `config.toml` is written
against configuration keys that are stable in 0.20 rather than any 0.22-only
spelling, and `.github/workflows/deploy.yml` downloads zola `0.20.0` from
GitHub releases because Actions has no nix. Nothing enforces that the two
numbers agree — a bump to this pin that is not mirrored into the workflow
produces a site that builds locally and fails, or silently differs, in CI.

The package list is deliberately one entry. The site has no JavaScript
toolchain, no webfonts to fetch and no Sass to compile (`compile_sass = false`
in `config.toml`), so adding a node or dart-sass dependency here would be
adding a tool nothing uses.

## Assertions
- The nixpkgs import is pinned with both `url` and `sha256`. A bare
  `<nixpkgs>` here is a bug, however convenient.
- `zola --version` inside the shell equals `ZOLA_VERSION` in
  `.github/workflows/deploy.yml`.
- Any tool a documented build/verify step invokes appears in `packages`.
- Bumping the pin is followed by a successful `nix-shell --run 'zola build'`,
  because a newer zola can reject config keys this repo relies on.
