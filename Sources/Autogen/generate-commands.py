#!/usr/bin/env python3

import glob
import json
import os
from os.path import abspath, exists
from typing import Dict, List
from datetime import date

from jinja2 import Template

from command import Command
from git_utils import make_sure_remote_repo_is_downloaded
from utils import this_dir
from swift_format import format_files

try:
    with open(abspath(this_dir + "/config/commands_to_ignore.json")) as f:
        commands_to_ignore: List[str] = json.load(f)
except:
    commands_to_ignore: List[str] = []


def create_command(name, desc):
    if desc.get("container"):
        cmd = Command(name, desc, True)
        if not cmd.func_name() in commands_to_ignore:
            if subcommands.get(desc["container"]):
                cmds = subcommands[desc["container"]]
                cmds.append(cmd)
            else:
                cmds = [cmd]
                subcommands[desc["container"]] = cmds
    else:
        cmd = Command(name, desc)
        if not cmd.func_name() in commands_to_ignore:
            commands.append(cmd)


def write_extensions_file(commands: List[Command], file_name: str):
    with open(f"{outdir}/{file_name}", 'x') as file:
        file.write(extension.render(
            filename=file_name,
            creation_date=todays_date,
            commands=commands
        ))
with open(this_dir + "/templates/extension.swift", 'r') as file:
    extension = Template(file.read())

todays_date = date.today().strftime("%d.%m.%y")

subcommands: Dict[str, List[Command]] = {}
commands: List[Command] = []


make_sure_remote_repo_is_downloaded(
    "redis", "https://github.com/redis/redis.git", branch="7.0")

srcdir = abspath(this_dir + "/redis/src")
outdir = abspath(this_dir + "/../SwiftyRedis/Autogen/Commands")

# Create all command objects
print("Processing json files...")
for filename in glob.glob(f"{srcdir}/commands/*.json"):
    with open(filename, "r") as f:
        try:
            d = json.load(f)
            for name, desc in d.items():
                create_command(name, desc)
        except json.decoder.JSONDecodeError as err:
            print(f"Error processing {filename}: {err}")
            exit(1)

print("Cleaning out directory...")
if not exists(outdir):
    os.makedirs(outdir)
else:
    for f in glob.glob(f"{outdir}/*"):
        os.remove(f)

commands.sort(key=lambda command: command.fullname())

print("Creating swift files...")
to_format_files = []

if len(commands) > 0:
    write_extensions_file(commands, "containerless.swift")
    to_format_files.append(f"{outdir}/containerless.swift")

for container_name, commands in subcommands.items():
    container_name = container_name.lower()
    write_extensions_file(
        commands,
        f"{container_name}.swift"
    )
    to_format_files.append(
        f"{outdir}/{container_name}.swift"
    )

if len(to_format_files) > 0:
    format_files(*to_format_files)
