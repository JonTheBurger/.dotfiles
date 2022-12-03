#!/bin/env python3
# Imports
from configparser import RawConfigParser
from dataclasses import dataclass
from os import path
from typing import Tuple

# Config
INI_PATHS = [
    path.expandvars("%APPDATA%/QtProject/QtCreator.ini"),
    path.expandvars("$XDG_CONFIG_HOME/QtProject/QtCreator.ini"),
    path.expandvars("$HOME/.config/QtProject/QtCreator.ini"),
]

# Functions
def get_qtcreator_ini_config() -> Tuple[RawConfigParser, str]:
    qt_creator_ini = next((p for p in INI_PATHS if path.exists(p)), None)
    if not qt_creator_ini:
        print(f"QtCreator.ini not found! Checked {INI_PATHS}; aborting!")
        exit(1)

    config = RawConfigParser()
    config.optionxform = str
    with open(qt_creator_ini, "r", encoding="utf-8") as f:
        config.read_file(f)
    return config, qt_creator_ini


def set_fake_vim_ex_commands(config: RawConfigParser):
    SECTION = "FakeVimExCommand"
    SETTINGS = {
        "AutoTest.RunAll": "^Test$",
        "CMakeProject.RunCMake": "^CMake$",
        "ClangFormat.FormatFile": "^Format$",
        "ClangFormat.FormatLines": "^Fmt$",
        "ClangTools.RunOnCurrentFile": "^Clang$",
        "Coreplugin.OutputPane.clear": "^Cls$",
        "CppEditor.RenameSymbolUnderCursor": "^Rename$",
        "Cppcheck.ManualRun": "^Cppcheck$",
        "Debugger.Continue": "^C$",
        "Debugger.Debug": "^Debug$",
        "Debugger.FrameDown": "^Fd$",
        "AutoTest.RunDebugUnderCursor": "^T[Bb]ug$",
        "Debugger.FrameUp": "^Fu$",
        "Debugger.HiddenStop": "^STOP$",
        "Debugger.Reset": "^Rebug$",
        "Debugger.ReturnFromFunction": "^(Finish|Return)$",
        "Debugger.RunToLine": "^RunTo$",
        "Debugger.Stop": "^Stop$",
        "DiffEditor.DiffCurrentFile": "^Diff$",
        "Git.Blame": "^Blame$",
        "MemcheckWithGdb.Local": "^MDebug$",
        "ProjectExplorer.AddNewFile": "^NFile$",
        "AutoTest.RunFailed": "^Retest$",
        "ProjectExplorer.Build": "^Build$",
        "ProjectExplorer.Clean": "^Clean$",
        "ProjectExplorer.Rebuild": "^Rebuild$",
        "ProjectExplorer.Run": "^Run$",
        "ProjectExplorer.SelectTargetQuick": "^Target$",
        "QtCreator.Close": "^Bdel$",
        "QtCreator.CloseAll": "^Qa$",
        "QtCreator.CloseAllExceptVisible": "^Qaev$",
        "QtCreator.Pane.TestResults": "^TR$",
        "QtCreator.SplitNewWindow": "^Nsplit$",
        "AutoTest.RunFile": "^FTest$",
        "TextEditor.FindUsages": "^Usages$",
        "TextEditor.RewrapParagraph": "^Wrap$",
        "TextEditor.SortSelectedLines": "^sort$",
        "Uncrustify.FormatFile": "^Uncrustify$",
        "AutoTest.RunSelected": "^GTest$",
        "AutoTest.RunUnderCursor": "^T$",
        "Bookmarks.Toggle": "^Bm$",
        "CMakeProject.BuildFile": "^B$",
        "CMakeProject.ClearCache": "^CCache$",
    }
    if config.has_section(SECTION):
        config.remove_section(SECTION)
    config.add_section(SECTION)
    for n, (cmd, rgx) in enumerate(SETTINGS.items()):
        config[SECTION][f"{n + 1}\\Command"] = cmd
        config[SECTION][f"{n + 1}\\RegEx"] = rgx
    config[SECTION]["size"] = str(len(SETTINGS))


def main():
    config, qt_creator_ini = get_qtcreator_ini_config()
    set_fake_vim_ex_commands(config)
    with open(qt_creator_ini, 'w', encoding="utf-8") as f:
        config.write(f)


if __name__ == "__main__":
    main()
