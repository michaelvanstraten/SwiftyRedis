from utils import pascal_case
from argument import Argument

class ComplexArgument(Argument):
    def __init__(self, parent_name, desc, is_sub_arg = False):
        super().__init__(desc)
        self.parent_name: str = parent_name
        self.type: str = pascal_case(self.name) if is_sub_arg else pascal_case(self.fullname())

    def fullname(self):
        return f"{self.parent_name} {self.name}"