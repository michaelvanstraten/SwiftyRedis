from ast import Set
import json
from typing import List, Dict
from os.path import abspath
from jinja2 import Template

from utils import camel_case, snake_case, this_dir

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

with open(abspath(f"{this_dir}/templates/parameter.swift")) as file:
    parameter_template = Template(file.read())

try:
    with open(abspath(f"{this_dir}/config/tokens_to_substitute.json")) as f:
        tokens_to_substitute: Dict[str, str] = json.load(f)
except:
    tokens_to_substitute: Dict[str, str] = dict()
try:
    with open(abspath(f"{this_dir}/config/names_to_substitute.json")) as f:
        names_to_substitute: Dict[str, str] = json.load(f)
except:
    names_to_substitute: Dict[str, str] = dict()

try:
    with open(abspath(f"{this_dir}/config/arguments_to_ignore.json")) as f:
        ignored_arguments: List[str] = json.load(f)
except:
    ignored_arguments: List[str] = []


class Argument(object):
    def __init__(self, desc: Dict):
        self.name: str = names_to_substitute.get(
            camel_case(desc["name"]), camel_case(desc["name"]))
        self.type: str = ARG_TYPES.get(desc["type"])
        self.token = desc.get("token")
        self.backup_token: str = desc["name"]
        self.sanitized_token: str = tokens_to_substitute.get(
            self.token, self.token) if self.token else snake_case(self.backup_token).upper()
        self.is_optional: bool = desc.get("optional", False)
        self.is_variadic: bool = desc.get("multiple", False)
        if self.token:
            self.token = self.token.replace('"', '\\"')

    def use_token_as_name(self):
        self.name = self.sanitized_token

    def parameter(self):
        return parameter_template.render(
            parameter_name=self.name,
            parameter_type=self.type,
            is_optional=self.is_optional,
            is_variadic=self.is_variadic
        )

    def is_option(self):
        return self.type == "token"

def parse_args(args: List[Dict], parent_name: str, make_options_arg=True, are_sub_args=False):
    parsed_args: List[Argument] = []
    optional_args: List[Argument] = []
    used_arg_names: Set[str] = set()

    for arg in args:
        if arg["type"] == "oneof":
            from enum_argument import EnumArgument
            new_arg = EnumArgument(parent_name, arg, are_sub_args)
        elif arg["type"] == "block":
            from struct_argument import StructArgument
            new_arg = StructArgument(parent_name, arg, are_sub_args)
        else:
            new_arg = Argument(arg)

        if new_arg.name in used_arg_names:
            new_arg.use_token_as_name()
        else:
            used_arg_names.add(new_arg.name)

        if not new_arg.name in ignored_arguments:
            if new_arg.is_option() and make_options_arg:
                optional_args.append(new_arg)
            else:
                parsed_args.append(new_arg)

    if len(optional_args) > 0:
        from options_argument import OptionsArgument
        parsed_args.append(OptionsArgument(parent_name, optional_args, are_sub_args))
    
    return parsed_args
