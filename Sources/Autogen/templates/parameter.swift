{{ name }}: {{ type }}{{ "?" if optional }}{% if multiple %}...{% elif optional %} = nil{% endif %}