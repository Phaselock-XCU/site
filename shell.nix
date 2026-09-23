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
