import json
from typing import List
from command import Command
from os.path import abspath
from jinja2 import Template

from utils import pascal_case, this_dir

with open(abspath(this_dir + "/templates/command.swift")) as file:
    command_template = Template(file.read())

try:
    with open(abspath(this_dir + "/commands_ignore.json")) as f:
        ignore: List[str] = json.load(f)
except:
    ignore: List[str] = []


class Subcommand(Command):
    def __init__(self, name, desc):
        self.container_name = desc["container"].upper()
        super(Subcommand, self).__init__(name, desc)

    def fullname(self):
        return "%s %s" % (self.container_name, self.name.replace("-", "_").replace(":", ""))

    def option_name(self):
        return pascal_case(f"{self.container_name} {self.name} Options")

    def docs_name(self):
        return f"{self.container_name.lower()}-{self.name.lower()}"

    def code(self):
        if not self.func_name() in ignore:
            return command_template.render(
                func_name=self.func_name(),
                name=self.name,
                container_name=self.container_name,
                args=self.args,
                has_options=self.has_options(),
                options_type=self.options_type_code(),
                options_name=self.option_name(),
                summary=self.summary(),
                since=self.since(),
                time_complexity=self.time_complexity(),
                tips=self.tips(),
                docs=self.docs()
            )
        else:
            return ""
