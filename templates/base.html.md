# base.html

## Function
The page shell every page on the site inherits: document head, header,
`<main>` landmark, and footer. It owns everything that is true of the site
rather than of one page, so a second page can be added without restating any
of it.

## Interface
Blocks a child template may override:
- `title` — contents of `<title>`. Default: `config.title`.
- `description` — the meta description. Default: `config.description`.
- `content` — everything inside `<main id="main">`. No default; a child that
  does not fill it renders an empty page.

Structure the stylesheet depends on (changing any of these class names
requires the matching edit in `static/style.css`):
`.skip`, `.site-head`, `.wordmark`, `.wordmark-mark`, `.site-nav`,
`.site-foot`, and the `#main` id that `.skip` targets.

Reads from config: `config.title`, `config.description`, `config.base_url`,
`config.extra.repo_url`.

## Implementation
URL-valued variables are piped through `| safe`. Tera's autoescaping turns
`/` into `&#x2F;`, which browsers do decode in attributes, so links still
work — but the emitted source is unreadable and the escaping is pure noise in
a URL. `| safe` is sound here because every one of these values comes from
`config.toml`, never from user input.

`get_url(path='style.css', cachebust=true)` appends a content hash to the
stylesheet URL. GitHub Pages serves static assets with long cache lifetimes;
without the hash a visitor who has seen the site before can get new HTML with
an old stylesheet. The favicon is deliberately *not* cachebusted — a stale
favicon is harmless and browsers cache them by path aggressively anyway.

`.wordmark-mark` is an empty `<span>`, not an image or an SVG: the mark is one
accent-coloured square drawn entirely in CSS. It carries `aria-hidden` because
the word "phaselock" directly beside it already names the link.

The skip link is first in the body and visible only on focus, so a keyboard
user can jump past the header without it appearing for anyone else.

## Assertions
- The `content` block exists and sits inside `<main id="main">`.
- Every URL interpolated into an `href` or `content` attribute ends in
  `| safe`, and every such value originates in `config.toml`.
- `.skip`'s target (`#main`) matches the id on `<main>`.
- Exactly one `<h1>` per page — this file emits none, so the child template
  owns it.
- Every class name here has a rule in `static/style.css` — this file
  declares no bare section wrappers, so the rule is exact for base.html.
