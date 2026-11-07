#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["rich~=14.2.0"]
# ///
"""Distro-agnostic "package manager" for installing user-local programs."""
# ruff: noqa: D107, E501, EM102, S602, S603, TRY003

# TODO(JON): wrong package version written to stamp
# TODO(JON) query github for releases
# import json
# from urllib.request import Request, urlopen
#
#
# def get_latest_version(owner: str, repo: str) -> str:
#     url = f"https://api.github.com/repos/{owner}/{repo}/releases/latest"
#
#     # GitHub API requires a User-Agent header
#     req = Request(url, headers={"User-Agent": "Python-Stdlib-Script"})
#
#     with urlopen(req) as response:
#         data = json.loads(response.read().decode("utf-8"))
#         return data["tag_name"]
#
#
# # Example usage
# version = get_latest_version("python", "cpython")
# print(f"Latest version tag: {version}")

# import json
# from urllib.request import Request, urlopen
#
#
# def get_last_n_releases(owner: str, repo: str, count: int = 5) -> list[str]:
#     # Query parameter per_page controls how many releases to fetch (max 100)
#     url = f"https://api.github.com/repos/{owner}/{repo}/releases?per_page={count}"
#
#     req = Request(url, headers={"User-Agent": "Python-Stdlib-Script"})
#
#     with urlopen(req) as response:
#         releases = json.loads(response.read().decode("utf-8"))
#         # Extract tag_name from each release object
#         return [release["tag_name"] for release in releases]
#
#
# # Example: Get the last 5 release tags for Python CPython
# tags = get_last_n_releases("python", "cpython", count=5)
# print("Latest tags:", tags)

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
__version__ = "1.0.1"
HOME = Path(os.environ.get("HOME", os.environ.get("USERPROFILE", "")))
SHARE = HOME / ".local/share/jontheburger/package"


# -------------------------------------------------------------------------------------#
# endregion
# region types
# -------------------------------------------------------------------------------------#
@dataclass
class PackageSpec:
    """Represents a package installation."""

    name: str
    version: str = ""

    def __str__(self) -> str:
        return f"{self.name}@{self.version or 'latest'}"

    @staticmethod
    def from_string(string: str) -> PackageSpec:
        """Parse a spec from 'name@version' or 'name=version'"""
        delimiter = "@" if "@" in string else "="
        tokens = string.split(delimiter)
        spec = PackageSpec(name=tokens[0])
        if len(tokens) > 1:
            spec.version = tokens[-1]
        return spec


class UserError(Exception):
    """The user misused the command line."""


@dataclass
class Cli:
    """Command line configuration arguments."""

    root: Path = Path()
    share: Path = Path()
    command: str | None = None
    packages: list[PackageSpec] = field(default_factory=list)

    def __init__(self, args: Namespace | None = None) -> None:
        if args is None:
            return
        self.root = args.root
        self.share = args.share
        self.command = args.command
        self.packages = [
            PackageSpec.from_string(e)
            for e in getattr(args, "packages", [])
        ]

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
            stamp = self._cli.share / pkg.name
            if stamp.exists():
                print(f"Package {pkg.name} is already installed, skipping")
                continue
            script = self._cli.root / (f"{pkg.name}.sh")
            if not script.exists():
                raise UserError(f'Package "{pkg.name}" does not exist')
            cmd = [str(script)]
            if pkg.version:
                cmd += ["--version", pkg.version]
            subprocess.run(cmd, check=False)
            stamp.parent.mkdir(parents=True, exist_ok=True)
            version = self.get_package_version(pkg.name)
            stamp.write_text(version)

    def uninstall(self) -> None:
        """Uninstall the packages requested by the user."""
        for pkg in self.requested_packages():
            stamp = self._cli.share / pkg.name
            if stamp.exists():
                subprocess.run(
                    [str(self._cli.root / (f"{pkg.name}.sh")), "--remove"],
                    check=False,
                )
                stamp.unlink()
            else:
                raise UserError(f'Package "{pkg.name}" is not installed')

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
            if any(e for e in query if re.search(e.name, pkg)):
                print(f"{fmt}{pkg}")

    def info(self) -> None:
        """Display metadata for the packages requested by the user."""
        for pkg in self.requested_packages():
            print(f"[green]{pkg}")
            version = self.get_package_version(pkg.name)
            installed = self.installed_version(pkg.name)
            if installed:
                print(
                    f"  [green]installed[/green]: [[bold green]I[/bold green]] <{installed}>",
                )
            else:
                print("  [green]installed:[/green] [bold red][ ][/bold red]")
            print(f"  [green]version[/green]: {version}")
            url = self.get_package_url(pkg.name, version)
            print(f"  [green]url[/green]: {url}")
            print("  [green]files[/green]:")
            for file in self.get_package_files(pkg.name):
                print(f"  - {file}")

    # ---------------------------------------------------------------------------------#
    # endregion
    # ---------------------------------------------------------------------------------#
    def requested_packages(self) -> Iterable[PackageSpec]:
        """List of package queries provided by the user."""
        for pkg in self._cli.packages:
            if pkg.name not in (p for p in self.available_packages):
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
