import os
from re import sub

this_dir= os.path.dirname(os.path.abspath(__file__))

def get_optional_desc_string(desc, field, force_uppercase=False):
    v = desc.get(field, None)
    if v and force_uppercase:
        v = v.upper()
    ret = "\"%s\"" % v if v else "NULL"
    return ret.replace("\n", "\\n")

def camel_case(s):
  s = pascal_case(s)
  return ''.join([s[0].lower(), s[1:]])

def pascal_case(s):
    return sub("[\_\-\/\.\:]", " ", s).title().replace(" ", "")

#https://www.w3resource.com/python-exercises/string/python-data-type-string-exercise-97.php
def snake_case(s):
  return '_'.join(
    sub('([A-Z][a-z]+)', r' \1',
    sub('([A-Z]+)', r' \1',
    s.replace('-', ' ').replace('_', ' '))).split()).lower()

def kebab_case(s):
    return '-'.join(
    sub('([A-Z][a-z]+)', r' \1',
    sub('([A-Z]+)', r' \1',
    s.replace('-', ' ').replace('_', ' '))).split()).lower()

def sanitize(s):
    return s.replace("-", "_").replace(":", "")