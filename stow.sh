#!/usr/bin/env bash
rm -f "${HOME}/.gtkrc-2.0"  # Some wise-guy keeps replacing my soft-link.
stow home --no-folding --verbose --ignore='.*AppData.*'     # Farm soft-links; create directories.
