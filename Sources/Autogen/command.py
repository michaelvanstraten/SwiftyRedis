from os.path import abspath
from typing import List

from utils import kebab_case, sanitize, snake_case, this_dir

from argument import Argument, parse_args
from jinja2 import Template

with open(abspath(this_dir + "/templates/command.swift")) as file:
    command_template = Template(
        file.read(),
    )

with open(abspath(this_dir + "/templates/options.swift")) as file:
    options_template = Template(file.read())


class Command(object):
    def __init__(self, name, desc, is_subcommand: bool = False):
        self.desc = desc
        self.is_subcommand = is_subcommand
        self.name: str = sanitize(name.upper())
        self.container_name = desc.get("container")
        self.args: List[Argument] = parse_args(self.desc.get(
            "arguments", []), self.fullname())

    def func(self) -> str:
        return command_template.render(
            func_name=self.func_name(),
            name=self.name,
            container_name=self.container_name,
            args=self.args,
            summary=self.desc.get("summary"),
            since=self.desc.get("since"),
            time_complexity=self.desc.get("complexity"),
            history=self.desc.get("history"),
            docs_name=self.fullname(),
            docs_link_name=kebab_case(self.fullname())
        )

    def func_name(self):
        return snake_case(self.fullname())

    def fullname(self):
        if self.is_subcommand:
            return f"{self.container_name} {self.name}"
        else:
            return self.name
