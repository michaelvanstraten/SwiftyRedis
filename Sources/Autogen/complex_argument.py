from __future__ import annotations

from typing import TYPE_CHECKING

from typing import List

if TYPE_CHECKING:
    from enum_argument import EnumArgument
    from struct_argument import StructArgument

from utils import camel_case, pascal_case, sanitize, this_dir
from argument import Argument

class ComplexArgument(Argument):
    def __init__(self, parent_name, desc, is_sub_arg = False):
        super().__init__(desc)
        self.parent_name: str = parent_name
        self.type: str = pascal_case(self.name) if is_sub_arg else pascal_case(self.fullname())

    def fullname(self):
        return f"{self.parent_name} {self.name}"