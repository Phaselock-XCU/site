# index.html

## Function
The landing page, and currently the only page. It lays out the copy held in
`content/_index.md` in a fixed order: hero, pitch prose, the proof transcript,
the three-component grid, the keystone pull-quote, the edges, and the status
table. It contains no
copy of its own — every sentence a visitor reads comes from the content file.

## Interface
Extends `base.html`; overrides `title` and `content`.

Requires these fields on `section.extra` (from `content/_index.md`'s front
matter). Tera aborts the build if any is absent, so this list is enforced:
- `tagline` — string, the hero's accent line; also appended to `<title>`.
- `lede` — string, the hero paragraph.
- `keystone` — string, the pull-quote.
- `proof` — table of `{ label, caption, lines }`, where `lines` is an array of
  `{ kind, text }` and `kind` is `cmd` (rendered with a `$` prompt) or
  anything else (rendered as program output).
- `components` — array of `{ role, name, claim, detail }`. This is the page's
  plain-language layer: `claim` is a short readable sentence and `detail`
  explains the idea without naming the mechanism. Precise terminology belongs
  in the specs and lessons in the main repo, not in these cards.
- `edges` — array of `{ title, body }`.
- `status` — array of `{ name, what, lang, state, note }`, where `state` is
  one of `done`, `wip`, `planned`.

Also renders `section.content` — the markdown body of `content/_index.md` —
as the pitch.

## Implementation
Front matter strings are not processed by `smart_punctuation` — that applies
only to the markdown body — so any apostrophe or dash written in `[extra]`
must be typed as the real character. A straight `'` there renders beside the
body's curly ones and the mismatch is visible.

The split between this file and the content file is the point: copy lives in
front matter and prose, layout lives here. Editing the pitch must never mean
editing HTML, and the arrays mean adding a fourth stack component or a sixth
status row is a content edit with no template change at all.

The interpolation of `section.content` is the one place `safe` is applied to
something that is not a config value. It is
Zola's rendered markdown, which is already HTML; escaping it would print tags
as text.

`state` is interpolated straight into a class name — the `pill-` prefix
followed by the value — rather than being branched on in an if/elif chain. A
typo in the content file therefore yields an unstyled pill
rather than a build error — the tradeoff taken for keeping the template free
of presentation logic. The three legal values are the ones `style.css` defines
rules for.

The proof transcript is a `<figure>` wrapping a `<pre><code>`, so the shell
session is marked up as preformatted text rather than faked with styled divs
— it survives copy-paste and reads correctly to a screen reader. The line
breaks come from the loop emitting a newline before every line *except* the
first; a trailing newline inside a `<pre>` renders as a visible blank row.
The `$` prompts sit in their own spans so CSS can make them unselectable,
leaving a copied transcript runnable.

Line text is left escaped rather than marked safe. Shell commands legitimately
contain `<`, `>` and `&`, so escaping is correct here even though it renders
`/` as a character reference in the emitted source.

The edges are an `<ol>`, not a `<ul>`: the readme numbers them, and the
visible `01`/`02`/`03` markers come from a CSS counter rather than from
literal numbers in the markup, so reordering is a content edit.

The status table uses `<th scope="row">` for the component name so a screen
reader announces "quartz" as the row header rather than as another cell.

## Assertions
- No user-facing sentence is written in this file; all copy comes from
  `section.*`.
- Exactly one `<h1>` (`.hero-name`).
- The proof transcript's cycle count in `content/_index.md` matches what
  `golden/101_uart_hello.qasm` actually reports; it is a public commitment.
- The proof transcript's label and caption keep saying that the demonstration
  is the assembly path (`qasm` → `scope`) and that the exactness comes from
  quartz's fixed instruction latencies. The pitch immediately above promises a
  compiler-reported cycle count, so a caption that omits this reads as phi
  having produced the number — which it did not.
- Every `state` value in `content/_index.md` has a matching `.pill-*` rule in
  `static/style.css`.
- The decorative `.cycle-rule` stays `aria-hidden` and carries no text.
- Every class name here that carries styling has a rule in
  `static/style.css`. The section wrapper classes `.pitch`, `.stack`,
  `.edges` and `.status` are the deliberate exception: they are identity
  hooks for anchors and future targeting, and their spacing comes from the
  shared `main > section` rule.

## A note on this file
Zola registers *every* file under `templates/` as a Tera template, this
sidecar included, and a parse failure in any of them fails the whole build.
Sidecars in this directory therefore cannot quote Tera tag syntax literally —
describe it in prose instead. See
`.claude/lessons/zola-parses-every-file-in-templates.md`.
