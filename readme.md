# phaselock.tech

The website for [phaselock](https://github.com/Phaselock-XCU) — an
exact-cycle computing stack. A single landing page, built with
[Zola](https://www.getzola.org/), deployed to GitHub Pages.

## Working on it

Everything runs inside the nix shell; `shell.nix` is the single source of
truth for the toolchain.

```sh
nix-shell                      # drops you in with zola 0.20.0 on PATH
zola serve                     # live preview on http://127.0.0.1:1111
zola build                     # emit public/
```

Or one-shot, without entering the shell:

```sh
nix-shell --run 'zola build'
```

## Where things are

| path | what |
| --- | --- |
| `content/_index.md` | **all landing-page copy.** Prose in the body; the stack components, edges and status rows as `[extra]` tables in the front matter |
| `templates/base.html` | page shell — head, header, footer |
| `templates/index.html` | landing-page layout; contains no copy |
| `static/style.css` | the whole design: colour tokens, layout, dark + light |
| `static/CNAME` | `phaselock.tech` — paired with `base_url` in `config.toml` |
| `.github/workflows/deploy.yml` | build + publish on push to `main` |

Editing the pitch is a `content/_index.md` change and nothing else. Adding a
fourth stack component or another status row is likewise content-only — the
template iterates.

Each file carries its own documentation in a header comment: what it is for,
the non-obvious decisions, and an **INVARIANTS** list of the things an edit
must not break. Read the top of a file before changing it.

This repo does not use the sidecar-doc convention — there is no
`.claude/sidecar.json` and no `<filename>.md` beside any source file. The
templates directory is the reason it would not work here anyway: Zola parses
every file under `templates/` as a Tera template, `.md` included, so a sidecar
there fails the build the moment it quotes tag syntax.

## Deploying

Pushing to `main` builds and deploys. Two things must be set up by hand once:

1. **Settings → Pages → Source → "GitHub Actions"**.
2. **DNS for `phaselock.tech`.** For the apex, four `A` records to
   `185.199.108.153`, `185.199.109.153`, `185.199.110.153`,
   `185.199.111.153` (and the `AAAA` equivalents if you want IPv6). Then set
   the custom domain in Settings → Pages and enable "Enforce HTTPS" once the
   certificate is issued.

`ZOLA_VERSION` in the workflow duplicates the version `shell.nix` pins —
bump both together.
