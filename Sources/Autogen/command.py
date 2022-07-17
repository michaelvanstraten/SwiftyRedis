from os.path import abspath
from typing import List, Set

from utils import kebab_case, pascal_case, snake_case, this_dir

from argument import Argument
from jinja2 import Template


with open(abspath(this_dir + "/templates/command.swift")) as file:
    command_template = Template(
        file.read(),
    )

with open(abspath(this_dir + "/templates/option_set.swift")) as file:
    option_set_template = Template(file.read())

def sanitize(s):
    return s.replace("-", "_").replace(":", "")

class Command(object):
    def __init__(self, name, desc, is_subcommand: bool = False):
        self.desc = desc
        self.is_subcommand = is_subcommand
        self.name: str = sanitize(name.upper())
        self.container_name = sanitize(desc.get("container", "").upper())
        self.args: List[Argument] = []
        self.options: List[Argument] = []
        used_arg_names: Set[str] = set()
        for arg_desc in self.desc.get("arguments", []):
            arg = Argument(self.fullname(), arg_desc)
            if arg.is_option():
                self.options.append(arg)
            else:
                if arg.name in used_arg_names:
                    arg.should_use_token_as_name = True
                else:
                    used_arg_names.add(arg.name)
                self.args.append(arg)

    def code(self) -> str:
        return command_template.render(
            func_name=self.func_name(),
            name=self.name,
            fullname=self.fullname(),
            container_name=self.container_name,
            args=self.args,
            is_subcommand=self.is_subcommand,
            has_options=self.has_options(),
            options_name=self.option_name(),
            options_type=self.options_type_code(),
            summary=self.desc.get("summary"),
            since=self.desc.get("since"),
            time_complexity=self.desc.get("complexity"),
            history=self.desc.get("history"),
            docs_name=self.docs_name()
        )

    def fullname(self):
        if self.is_subcommand:
            return f"{self.container_name} {self.name}"
        else:
            return self.name

    def func_name(self):
        return snake_case(self.fullname())

    def options_type_code(self):
        return option_set_template.render(
            name=self.option_name(),
            case_names=[option.name.upper() for option in self.options]
        )

    def has_options(self) -> bool:
        return len(self.options) > 0

    def option_name(self):
        return pascal_case(f"{self.fullname()} Options")

    def docs_name(self):
        return kebab_case(self.fullname())
