#!/bin/sh

import sys
import os
from cx_Freeze import setup, Executable

# ADD FILES
files = ['icon.ico', 'fullchain.pem', 'themes/', 'jsons/']
base = "Win32GUI" if sys.platform == "win32" else None

# TARGET
target = Executable(
    script="main.py",
    base=base,
    icon="icon.ico"
)

# SETUP CX FREEZE
setup(
    name="SOLIDSIGN",
    version="1.1",
    description="Modern GUI for restaurant applications",
    author="49/1",
    options={'build_exe': {'include_files': files}},
    executables=[target]
)
