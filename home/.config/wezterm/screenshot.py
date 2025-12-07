#!/usr/bin/env -S uv run --script
# /// script
# dependencies = [
#   "cairosvg",
#   "rich",
# ]
# ///
from __future__ import annotations

import io
import json
import sys
from argparse import ArgumentParser
from dataclasses import dataclass
from pathlib import Path

import cairosvg
from rich.color import Color
from rich.console import Console
from rich.terminal_theme import TerminalTheme
from rich.text import Text


@dataclass
class Args:
    input: Path
    output: Path
    title: str = ""

    @staticmethod
    def from_cli(argv: list[str] | None = None) -> Args:
        parser = ArgumentParser(
            usage="hi",
            description="",
            epilog="https://www.alcarney.me/blog/2025/rich-screenshots-with-wezterm/",
        )
        parser.add_argument(
            "-i",
            "--input",
            type=Path,
            default=Path("/tmp/terminal.cast"),
            metavar="<in-file.cast>",
            help="Input '.cast' file",
        )
        parser.add_argument(
            "-o",
            "--output",
            type=Path,
            default=Path("/tmp/terminal.svg"),
            metavar="<out-file.svg>",
            help="Output file path; format deduced from extension",
        )
        parser.add_argument(
            "--title",
            type=str,
            default="",
            metavar="<Image Title>",
            help="Text shown in screenshot terminal window title bar",
        )
        args = parser.parse_args(argv or sys.argv[1:])
        return Args(
            input=args.input,
            output=args.output,
        )


def main(argv: list[str] | None = None) -> None:
    args = Args.from_cli(argv)

    with args.input.open() as f:
        header = json.loads(f.readline())
        body = json.loads(f.readline())

    term = header["term"]
    text = Text.from_ansi(body[-1])
    console = Console(
        file=io.StringIO(),
        force_terminal=True,
        record=True,
        width=header["term"]["cols"],
        height=header["term"]["rows"],
    )
    ansi_colors = term["theme"]["palette"].split(":")
    theme = TerminalTheme(
        background=Color.parse(term["theme"]["bg"]).triplet,
        foreground=Color.parse(term["theme"]["fg"]).triplet,
        normal=[Color.parse(col).triplet for col in ansi_colors[:8]],
        bright=[Color.parse(col).triplet for col in ansi_colors[8:]],
    )
    console.print(text, end="")
    svg = console.export_svg(title=args.title, theme=theme)

    args.output.parent.mkdir(parents=True, exist_ok=True)
    if args.output.suffix == ".png":
        cairosvg.svg2png(bytestring=svg.encode("utf-8"), write_to=str(args.output))
    else:
        args.output.write_text(svg)


if __name__ == "__main__":
    main()
