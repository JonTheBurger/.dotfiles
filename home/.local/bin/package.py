#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["rich~=14.2.0"]
# ///
"""Distro-agnostic "package manager" for installing user-local programs."""
# ruff: noqa: D107, E501, EM102, S602, S603, TRY003

# -------------------------------------------------------------------------------------#
# region imports
# -------------------------------------------------------------------------------------#
from __future__ import annotations

# std
import os
import re
import subprocess
import sys
from argparse import ArgumentParser, Namespace
from dataclasses import dataclass, field
from functools import cached_property
from pathlib import Path
from typing import TYPE_CHECKING

# 3rd party
from rich import print  # noqa: A004, pylint: disable=redefined-builtin

# types
if TYPE_CHECKING:
    from collections.abc import Iterable

# -------------------------------------------------------------------------------------#
# endregion
# region globals
# -------------------------------------------------------------------------------------#
__version__ = "1.0.0"
HOME = Path(os.environ.get("HOME", os.environ.get("USERPROFILE", "")))
SHARE = HOME / ".local/share/jontheburger/package"


# -------------------------------------------------------------------------------------#
# endregion
# region types
# -------------------------------------------------------------------------------------#
class UserError(Exception):
    """The user misused the command line."""


@dataclass
class Cli:
    """Command line configuration arguments."""

    root: Path = Path()
    share: Path = Path()
    command: str | None = None
    packages: list[str] = field(default_factory=list)

    def __init__(self, args: Namespace | None = None) -> None:
        if args is None:
            return
        self.root = args.root
        self.share = args.share
        self.command = args.command
        self.packages = getattr(args, "packages", [])

    @staticmethod
    def from_args(argv: list[str] | None = None) -> Cli:
        """Load the CLI from a list of arguments (excluding argv[0] program)."""
        argv = argv if argv is not None else sys.argv[1:]
        parser = Cli._parser()
        return Cli(parser.parse_args())

    @staticmethod
    def _parser() -> ArgumentParser:
        # Top parser
        parser = ArgumentParser(
            prog="package",
            description="Manages manually written package scripts",
        )
        parser.add_argument("-V", "--version", action="version", version=__version__)
        parser.add_argument(
            "--root",
            help="Change package root directory",
            type=Path,
            default=HOME / ".dotfiles/scripts/pkg",
        )
        parser.add_argument(
            "--share",
            help="Change the shared state directory",
            type=Path,
            default=SHARE,
        )
        subparsers = parser.add_subparsers(
            dest="command",
            help="DESCRIPTION",
            metavar="COMMAND",
            required=True,
        )

        # Shared Arguments
        arg_pkg = ArgumentParser(add_help=False)
        arg_pkg.add_argument(
            "packages",
            metavar="name[=version]",
            nargs="*",
            type=str,
            help="Name (and optional version) of the package(s)",
        )

        # Commands
        subparser = subparsers.add_parser(
            "install",
            help="Add a package",
            parents=[arg_pkg],
        )
        subparser = subparsers.add_parser(
            "uninstall",
            help="Remove a package",
            parents=[arg_pkg],
        )
        subparser = subparsers.add_parser("list", help="List installed packages")
        subparser = subparsers.add_parser(
            "search",
            help="Search installable packages",
            parents=[arg_pkg],
        )
        subparser = subparsers.add_parser(
            "info",
            help="Display package information",
            parents=[arg_pkg],
        )
        _ = subparser

        return parser


class App:
    """Context of the overall application."""

    def __init__(self, cli: Cli) -> None:
        self._cli: Cli = cli

    # ---------------------------------------------------------------------------------#
    # region commands
    # ---------------------------------------------------------------------------------#
    def run(self) -> None:
        """Run the command supplied by the user."""
        {
            "install": self.install,
            "uninstall": self.uninstall,
            "list": self.show_list,
            "search": self.search,
            "info": self.info,
        }[self._cli.command or ""]()

    def install(self) -> None:
        """Install the packages requested by the user."""
        for pkg in self.requested_packages():
            stamp = self._cli.share / pkg
            if stamp.exists():
                print(f"Package {pkg} is already installed, skipping")
                continue
            script = self._cli.root / (f"{pkg}.sh")
            if not script.exists():
                raise UserError(f'Package "{pkg}" does not exist')
            subprocess.run([script], check=False)
            stamp.parent.mkdir(parents=True, exist_ok=True)
            version = self.get_package_version(pkg)
            stamp.write_text(version)

    def uninstall(self) -> None:
        """Uninstall the packages requested by the user."""
        for pkg in self.requested_packages():
            stamp = self._cli.share / pkg
            if stamp.exists():
                subprocess.run(
                    [str(self._cli.root / (f"{pkg}.sh")), "--remove"],
                    check=False,
                )
                stamp.unlink()
            else:
                raise UserError(f'Package "{pkg}" is not installed')

    def show_list(self) -> None:
        """List the installed package versions."""
        width = len(self.longest_package) + 1
        for pkg in self.available_packages:
            version = self.installed_version(pkg)
            indent = " " * (width - len(pkg))
            if version:
                print(f"[green]{pkg}:{indent}{version}")

    def search(self) -> None:
        """Search the package registry for the user-supplied pattern."""
        packages = self.available_packages
        query = self._cli.packages
        for pkg in packages:
            fmt = ""
            if self.is_package_installed(pkg):
                fmt = "[green]"
            if not query:
                print(f"{fmt}{pkg}")
            if any(e for e in query if re.search(e, pkg)):
                print(f"{fmt}{pkg}")

    def info(self) -> None:
        """Display metadata for the packages requested by the user."""
        for pkg in self.requested_packages():
            print(f"[green]{pkg}")
            version = self.get_package_version(pkg)
            installed = self.installed_version(pkg)
            if installed:
                print(
                    f"  [green]installed[/green]: [[bold green]I[/bold green]] <{installed}>",
                )
            else:
                print("  [green]installed:[/green] [bold red][ ][/bold red]")
            print(f"  [green]version[/green]: {version}")
            url = self.get_package_url(pkg, version)
            print(f"  [green]url[/green]: {url}")
            print("  [green]files[/green]:")
            for file in self.get_package_files(pkg):
                print(f"  - {file}")

    # ---------------------------------------------------------------------------------#
    # endregion
    # ---------------------------------------------------------------------------------#
    def requested_packages(self) -> Iterable[str]:
        """List of package queries provided by the user."""
        for pkg in self._cli.packages:
            if pkg not in self.available_packages:
                raise UserError(f'Invalid package "{pkg}"')
            yield pkg

    @cached_property
    def available_packages(self) -> Iterable[str]:
        """Packages in the registry available for install."""
        return sorted(p.stem for p in self._cli.root.glob("*") if p.suffix == ".sh")

    def is_package_installed(self, package: str) -> bool:
        """Check if a package has previously been installed."""
        return bool(self.installed_version(package))

    def installed_version(self, package: str) -> str:
        """Version of the package if installed, else empty string."""
        stamp = self._cli.share / package
        if not stamp.exists():
            return ""
        return stamp.read_text().splitlines()[0]

    @cached_property
    def longest_package(self) -> str:
        """Get the package from the registry with the longest name."""
        return str(max(self.available_packages, key=len))

    def get_package_script(self, package: str) -> Path:
        """Path to the un/installer script for a given package; assumed to exist."""
        return self._cli.root / (f"{package}.sh")

    def get_package_version(self, package: str) -> str:
        """Get the default version of a package in the registry."""
        script = self.get_package_script(package)
        text = script.read_text()
        match = re.search(r'version="([0-9.]+)"', text)
        if not match:
            raise UserError(f'Package "{package}" does not specify a version')
        return match.group(1)

    def get_package_url(self, package: str, version: str) -> str:
        """Get the URL used to download a package at a given version."""
        script = self.get_package_script(package)
        text = script.read_text()
        match = re.search("local URL=(.*)", text)
        if not match:
            raise UserError(f'Package "{package}" does not specify a URL')
        url = match.group(1)
        env = os.environ.copy()
        env["version"] = version
        return subprocess.run(
            f"echo {url}",
            capture_output=True,
            check=True,
            shell=True,
            text=True,
            env=env,
        ).stdout.strip()

    def get_package_files(self, package: str) -> list[str]:
        """Get the list of files that a package installs."""
        script = self.get_package_script(package)
        text = script.read_text()
        text = text[text.find("local::do_uninstall") :]
        matches = re.findall("rm -rf? (.*)", text)
        if not matches:
            raise UserError(f'Package "{package}" does not supply files')
        files: list[str] = []
        for file in matches:
            files.extend(
                subprocess.run(
                    f"echo {file}",
                    capture_output=True,
                    check=True,
                    shell=True,
                    text=True,
                ).stdout.splitlines(),
            )
        return files


# -------------------------------------------------------------------------------------#
# endregion
# region functions
# -------------------------------------------------------------------------------------#
def main() -> None:
    """Run the program from sys.argv, suppressing exceptions."""
    try:
        App(Cli.from_args()).run()
    except UserError as ex:
        print(f"ERROR: {ex}")


# -------------------------------------------------------------------------------------#
# endregion
# region main
# -------------------------------------------------------------------------------------#
if __name__ == "__main__":
    main()

# -------------------------------------------------------------------------------------#
# endregion
# -------------------------------------------------------------------------------------#
