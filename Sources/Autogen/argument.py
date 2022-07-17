import json
from typing import List, Optional
from os.path import abspath
from jinja2 import Template

from utils import camel_case, pascal_case, this_dir

ARG_TYPES = {
    "string": "String",
    "integer": "Int",
    "double": "Double",
    "key": "String",
    "pattern": "String",
    "unix-time": "Int64",
    "pure-token": "token",
    "oneof": "oneof",
    "block": "block",
}

try:
    with open(abspath(f"{this_dir}/args_ignore.json")) as f:
        ignore: List[str] = json.load(f)
except:
    ignore: List[str] = []

with open(abspath(f"{this_dir}/templates/parameter.swift")) as file:
    parameter_template = Template(file.read())

with open(abspath(f"{this_dir}/templates/oneof.swift")) as file:
    oneof_template = Template(file.read())

with open(abspath(f"{this_dir}/templates/block.swift")) as file:
    block_template = Template(file.read())

class Argument(object):
    def __init__(self, parent_name, desc):
        self.desc = desc
        self.name: str = self.desc["name"].lower()
        self.should_use_token_as_name: bool = False
        self.token: Optional[str] = self.desc.get("token", None)
        self.type: str = self.desc["type"]
        self.optional: bool = self.desc.get("optional", False)
        self.multiple: bool = self.desc.get("multiple", False)
        self.parent_name: str = parent_name
        self.sub_args: List[Argument] = []
        if self.type in ["oneof", "block"]:
            for sub_desc in self.desc["arguments"]:
                self.sub_args.append(Argument(self.fullname(), sub_desc))

    def parameter(self):
        return parameter_template.render(
            name=self.argument_name(),
            type=self.argument_type(),
            optional=self.optional,
            multiple=self.multiple
        )

    def custom_types(self):
        res = ""
        if self.type == "oneof":
            res += oneof_template.render(
                name=self.custom_type_name(),
                cases=[(pascal_case(arg.name) if not arg.token else arg.token,
                        arg.argument_type()) for arg in self.sub_args],
                camel_case=camel_case
            )
        elif self.type == "block":
            res += block_template.render(
                name=self.custom_type_name(),
                fields=[(camel_case(arg.name) if not arg.token else arg.token,
                        arg.argument_type()) for arg in self.sub_args],
                command=self.name if not self.token else self.token
            )
        for arg in self.sub_args:
            sub_custom_types = arg.custom_types()
            if not sub_custom_types == "":
                res += "\n\n"
                res += sub_custom_types
        return res

    def has_custom_type(self):
        return self.type in ["oneof", "block"]

    def fullname(self):
        return f"{self.parent_name} {self.name}".replace("-", "_")

    def argument_type(self) -> str:
        if self.type in ["oneof", "block"]:
            return self.custom_type_name()
        else:
            return ARG_TYPES.get(self.type)

    def argument_name(self):
        return self.token if self.should_use_token_as_name else camel_case(self.name)

    def custom_type_name(self):
        return pascal_case(f"{self.parent_name} {self.name}")

    def is_option(self):
        return self.type == "pure-token"
