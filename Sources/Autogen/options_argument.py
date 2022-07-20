from os.path import abspath
from jinja2 import Template

from utils import pascal_case, this_dir
from complex_argument import ComplexArgument

with open(abspath(this_dir + "/templates/options.swift")) as file:
    options_template = Template(
        file.read(),
    )

class OptionsArgument(ComplexArgument):
    def __init__(self, parent_name, options, is_sub_arg=False):
        self.name = "options"
        self.type = "Options" if is_sub_arg else pascal_case(f"{parent_name} Options")
        self.options = options
        self.is_optional: bool = True
        self.is_variadic: bool = False

    def custom_type(self):
        return options_template.render(
            options_name=self.type,
            options=self.options
        )