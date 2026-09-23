+++
title = "phaselock"
template = "index.html"

# Every piece of landing-page copy lives here, not in the template. Editing
# the pitch must never mean editing HTML. The template's only job is to decide
# where these values land on the page.
[extra]
tagline = "Performance as a compile time property."
lede = "An exact-cycle computing stack: a VLIW CPU, a dataflow language, and a unikernel; all designed together so the compiler knows the cycle count before the program ever runs."

# The property that falls out of the three above. Rendered as a pull-quote
# between the grid and the edges.
keystone = "quartz runs with no non-deterministic runtime behaviour, so phi gets deterministic runtimes. The compiler knows the exact cycle length of every functional unit."

# The concrete demonstration, rendered as a terminal block under the pitch.
# `kind` is one of: cmd (shell prompt), out (program output).
# The cycle count is a public commitment — if golden/101_uart_hello.qasm
# changes, this number changes with it.
[extra.proof]
label = "hello, world — start to finish"
caption = "94 cycles. Guaranteed by the compiler, not measured after the fact."

[[extra.proof.lines]]
kind = "cmd"
text = "qasm build golden/101_uart_hello.qasm -o hello.qx"

[[extra.proof.lines]]
kind = "cmd"
text = "scope run hello.qx"

[[extra.proof.lines]]
kind = "out"
text = "hello, world"

# The three components of the stack. Order is processor → language → OS,
# bottom upward.
#
# These cards are the page's plain-language layer, and they are meant to stay
# that way: `claim` is a short sentence anyone can read, `detail` explains the
# idea without naming the mechanism. The precise terms — VLIW, region-based
# memory, unikernel, static task topology — live in the specs and the lessons
# in the main repo, not here. Resist putting them back.
[[extra.components]]
name = "quartz"
role = "The processor"
claim = "It never guesses."
detail = "A processor that does exactly what the compiler planned. It doesn’t try to predict what you’ll do next or keep a stash of what you might need — the tricks that make ordinary chips fast on average and ultimately unpredictable. Take the guesswork out and what’s left is a machine whose timing you can count on."

[[extra.components]]
name = "phi"
role = "The language"
claim = "Speed is enforced."
detail = "A language built on parallelism, with deterministic parallel execution as the target. No GC, no locking, no guessing. The compiler will statically schedule your code and produce exact cycle counts."

[[extra.components]]
name = "carrier"
role = "The operating system"
claim = "Nothing in the way."
detail = "An operating system built into your program rather than sitting underneath it. Nothing stands between a piece of hardware and the code reading from it, and nothing decides at the last moment what runs next."

[[extra.edges]]
title = "Deterministic latency"
body = "An exact-cycle unit — an XCU — that executes instructions with cycle times and latencies known in advance rather than measured after the fact."

[[extra.edges]]
title = "Regressions are build failures"
body = "When cycle counts are a compile-time property, a slowdown stops being a production surprise and starts being a broken build."

[[extra.edges]]
title = "FPGAs without an HDL"
body = "An easy way to put business logic on an FPGA that is neither an HDL nor HLS. Write phi, get snappy code, in the familiar environment of an OS."

# `state` drives the status pill's colour in the template: done | wip | planned.
[[extra.status]]
name = "quartz"
what = "The FPGA CPU"
lang = "Clash"
state = "wip"
note = "Mostly done"

[[extra.status]]
name = "scope"
what = "The simulator"
lang = "Rust"
state = "done"
note = "Finished"

[[extra.status]]
name = "np"
what = "The nanopass framework"
lang = "Rust"
state = "done"
note = "Finished"

[[extra.status]]
name = "phi"
what = "The language"
lang = "Rust"
state = "wip"
note = "Specified, compiler in progress"

[[extra.status]]
name = "carrier"
what = "The OS"
lang = "—"
state = "planned"
note = "Planned, unimplemented"
+++

Write a program, compile it, and the compiler hands back the number of cycles
it will take. Not a benchmark. Not a p99 taken over a thousand runs. **The number.**

How do we achieve that? By removing all the guessing. **quartz** has no caches, no branch
predictor, no interlocks and no interrupts. **phi** has no garbage collector
and no implicit ordering. **carrier**
has no dynamic scheduler, and nothing sitting between a device and the code
that reads it. Each layer gives up a mechanism that buys average-case speed at
the price of predictability.

What comes back in exchange is timing as a fact about the *program* rather
than a property of the *run*. Latency stops being something you measure after
deployment and becomes something the build checks.

_**Performance as a compile time property**_
