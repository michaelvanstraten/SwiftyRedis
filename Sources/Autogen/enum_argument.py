from os.path import abspath
from jinja2 import Template
from argument import parse_args

from utils import camel_case, this_dir
from complex_argument import ComplexArgument

with open(abspath(this_dir + "/templates/enum.swift")) as file:
    enum_template = Template(
        file.read(),
    )

class EnumArgument(ComplexArgument):
    def __init__(self, parent_name, desc, is_sub_arg=False):
        super().__init__(parent_name, desc, is_sub_arg)
        self.args = parse_args(desc.get("arguments", []), self.fullname(), make_options_arg=False, are_sub_args=True)

    def custom_type(self):
        return enum_template.render(
            enum_name=self.type,
            args=self.args,
            camel_case=camel_case
        )