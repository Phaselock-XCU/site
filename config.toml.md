# config.toml

## Function
Zola's site-wide configuration: where the site is served, what it is called,
which of Zola's subsystems are switched on, and the shared values templates
read out of `config.extra`.

## Interface
Read by Zola itself, and by templates through the `config` object:
- `config.title`, `config.description` — used in `<title>`, the meta
  description and the Open Graph tags in `templates/base.html`.
- `config.base_url` — `https://phaselock.tech`. Every absolute URL on the
  site is built from it, including `get_url(...)` for the stylesheet and
  favicon.
- `config.extra.repo_url` — `https://github.com/Phaselock-XCU`. Rendered as
  the header nav link, the footer link, and the hero's "Read the code"
  button.

## Implementation
`base_url` and `static/CNAME` are one decision recorded in two files. CNAME is
what makes GitHub Pages answer for `phaselock.tech` at all; `base_url` is what
makes the emitted HTML point at that host. Change one without the other and
the site either 404s or serves pages whose every link and asset reference the
wrong origin. The deploy workflow deliberately does not pass `--base-url`, so
CI and a local build produce byte-identical URLs.

`compile_sass`, `build_search_index` and `generate_feeds` are all `false` —
which is also Zola's default for each. They are written out anyway so that
adding a second section cannot quietly turn one on and start emitting a search
index or a feed nobody asked for.

`highlight_theme` is set even though the current copy contains no fenced code
blocks. The site's default palette is dark, so an unset theme would render the
first code block that ever gets added as near-black on near-black.

`smart_punctuation` is on because the landing prose in `content/_index.md`
uses em dashes and quotes; without it they render as literal ASCII.

## Assertions
- `base_url` equals the sole line of `static/CNAME`, prefixed with
  `https://` and with no trailing slash.
- Every key referenced from a template as `config.extra.*` exists in the
  `[extra]` table here — Tera fails the build on a missing variable rather
  than rendering blank, so this is enforced by `zola build`.
- No `--base-url` override appears in `.github/workflows/deploy.yml`.
- Every key in this file is accepted by the zola version `shell.nix` pins.
