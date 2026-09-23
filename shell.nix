# Dev shell for the phaselock.tech site — `nix-shell` from the repo root.
#
# Single source of truth for every tool the site needs. The site is a static
# Zola build with no JavaScript, no webfonts and no CSS preprocessor, so the
# toolchain is exactly one binary: zola.
#
# nixpkgs is pinned to the same rev the trellis repo uses (nixos-25.05), which
# provides zola 0.20.0. config.toml is written against keys that are stable in
# 0.20 — if you bump this pin, re-run `zola check` before trusting the build.
# The GitHub Actions deploy workflow pins the same zola version separately;
# bump both together or CI and local builds can disagree.
#
# The package list is deliberately one entry. The site has no JavaScript
# toolchain, no webfonts to fetch and no Sass step (compile_sass = false in
# config.toml), so a node or dart-sass dependency here would be a tool nothing
# uses.
#
# INVARIANTS
#   - nixpkgs is pinned with both url and sha256. A bare <nixpkgs> here is a
#     bug, however convenient: the pin is what makes the shell resolve to the
#     same zola on any machine and in any month.
#   - `zola --version` inside this shell equals ZOLA_VERSION in
#     .github/workflows/deploy.yml.
#   - Any tool a documented build or verify step invokes appears in packages.
#   - config.toml stays buildable by both the pinned zola and a current one.
#     In practice the site gets built by whatever zola is on a developer's
#     PATH; a config key that exists in only one version is a live breakage,
#     not a theoretical one. (This already happened once: highlight_code was
#     valid in 0.20 and rejected by 0.22.)
#   - Bumping the pin is followed by a successful
#     `nix-shell --run 'zola build'` — a newer zola can reject config keys
#     this repo relies on.
{
  pkgs ? import (builtins.fetchTarball {
    # nixos-25.05 as of 2026-08-22; bump by taking a new rev + hash.
    url = "https://github.com/NixOS/nixpkgs/archive/ac62194c3917d5f474c1a844b6fd6da2db95077d.tar.gz";
    sha256 = "0v6bd1xk8a2aal83karlvc853x44dg1n4nk08jg3dajqyy0s98np";
  }) { },
}:

pkgs.mkShell {
  name = "phaselock-site";

  packages = with pkgs; [
    zola  # static site generator (0.20.0 on this pin)
  ];

  shellHook = ''
    echo "phaselock site — zola $(zola --version | cut -d' ' -f2)"
    echo "  zola serve   live preview on http://127.0.0.1:1111"
    echo "  zola build   emit public/"
    echo "  zola check   validate links + front matter"
  '';
}
