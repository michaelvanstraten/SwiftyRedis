/// {{ summary }}
{% if since %}
/// # Available since 
/// {{ since }}
{% endif %}
{% if time_complexity %}
/// # Time complexity
/// {{ time_complexity }}
{% endif %}
{% if history %}
/// # History
{% for entry in history %}
/// - {{ "{}, {}".format(entry[0], entry[1]) }}
{% endfor %}
{% endif %}
/// # Documentation
/// view the docs for [{{ fullname }}](https://redis.io/commands/{{ docs_name }})
func {{ func_name }}<T: FromRedisValue>({% for arg in args %}{{ arg.parameter() }}{{ ", " if not loop.last or has_options }}{% endfor %}{{ "options: {}".format(options_name) if has_options }}) async throws -> T {
    {% if is_subcommand %}
    try await Cmd("{{ container_name }}")
        .arg("{{ name }}")
    {% else %}
    try await Cmd("{{ name }}")
    {% endif %}
    {% for arg in args %}
        .arg({{ arg.argument_name() }}.to_redis_args())
    {% endfor %}
        .query(self)   
}
{% for arg in args %}
{{ arg.custom_types() }}
{% endfor %}
{{ options_type if has_options }}
