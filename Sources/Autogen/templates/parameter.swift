{{ parameter_name }}: {{ parameter_type }}{{ "?" if is_optional }}{% if can_be_multiple %}...{% elif is_optional %} = nil{% endif %}