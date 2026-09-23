# style.css

## Function
The entire visual design of the site in one file: colour tokens, typography,
the page shell, and the five landing-page sections. It is the only stylesheet;
there is no reset file, no framework and no Sass step.

## Interface
Consumed by `templates/base.html` via `get_url(path='style.css',
cachebust=true)`.

Tokens defined on `:root`, safe for any future rule to use:
`--bg`, `--bg-raised`, `--rule`, `--rule-soft`, `--ink`, `--ink-dim`,
`--ink-faint`, `--accent`, `--amber`, `--violet`, `--mono`, `--sans`,
`--measure`, `--page`.

Class contracts with the templates — `base.html` owns `.skip`, `.site-head`,
`.wordmark`, `.wordmark-mark`, `.site-nav`, `.site-foot`; `index.html` owns
`.hero*`, `.btn*`, `.cycle-rule`, `.prose`, `.term*`, `.eyebrow`, `.stack-grid`,
`.card*`, `.keystone`, `.edge*`, `.status-table`, `.st-*`, and
`.pill-done` / `.pill-wip` / `.pill-planned`.

## Implementation
Dark is the base palette and light is the override under
`prefers-color-scheme: light`, rather than the other way round. The project is
about instrument-grade timing, and the dark treatment is the intended look;
defining it on bare `:root` means it is what renders when a browser reports no
preference. The light block redefines only tokens — no rule outside the two
`:root` blocks names a literal colour, which is what makes a one-block
override sufficient.

Both palettes were picked for contrast, not just for hue: `--ink-dim` against
`--bg` is the lowest-contrast pairing used for running text in each mode, and
the light-mode `--accent` is darkened to `#0f8f7c` because the dark mode's
`#7de2d1` fails against white.

The layout uses no framework and no JavaScript. The stack grid is
`repeat(auto-fit, minmax(16rem, 1fr))` with a 1px gap over a `--rule-soft`
background, which draws the hairlines *between* cards without any card
needing its own border — so three cards on desktop and one per row on mobile
both come out correctly ruled with no media query.

`.cycle-rule` is a decorative clock-tick strip: a `repeating-linear-gradient`
masked to fade out to the right. It is purely a `background-image`, so it
costs no element beyond the empty `div` and no request. The `-webkit-`
prefixed `mask-image` is kept alongside the standard property for older
WebKit.

The proof transcript scrolls horizontally inside `.term-body` rather than
widening the page, so a long command line can never make the document itself
scroll sideways. `.term-cmd` and `.term-out` stay inline: the newlines are
already in the markup, and making them block-level would double the line
spacing. `.term-prompt` is `user-select: none` so copying the block yields
commands you can paste and run.

`.prose strong` is typeset in the accent mono face, which is what visually
links the component names in the pitch paragraph to the card headings
underneath.

The status table has a real responsive breakpoint rather than horizontal
scroll: under `34rem` the header row is moved offscreen (kept in the DOM for
screen readers) and each row becomes a stacked block. The breakpoint is set
where the "Written in" column starts breaking mid-word, not at a round device
width.

`prefers-reduced-motion` blanket-disables transitions and animations. There
are none today; the rule is here so adding one later cannot skip the check.

## Assertions
- No colour literal appears outside the two `:root` blocks.
- Every token in the base `:root` that encodes a colour is redefined in the
  `prefers-color-scheme: light` block.
- Every class rule here corresponds to markup in `templates/`. The reverse
  holds except for the five section wrapper classes `.pitch`, `.proof`,
  `.stack`, `.edges` and `.status`, which are styled only through
  `main > section`.
- `.pill-done`, `.pill-wip` and `.pill-planned` cover exactly the `state`
  values used in `content/_index.md`.
- No `@import`, no external font or asset URL — the file must stay
  self-contained and request-free.
- Body text stays legible in both palettes: re-check contrast after any token
  change.
