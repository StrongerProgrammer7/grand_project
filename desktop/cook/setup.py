import sys
import os
from cx_Freeze import setup, Executable

# ADD FILES
files = ['icon.ico', 'themes/']

# TARGET
target = Executable(
    script="cook_app.py",
    base="Win32GUI",
    icon="icon.ico"
)

# SETUP CX FREEZE
setup(
    name="SOLIDSIGN for kitchen",
    version="1.0",
    description="Modern GUI for kitchen",
    author="49/1",
    options={'build_exe': {'include_files': files}},
    executables=[target]

)
