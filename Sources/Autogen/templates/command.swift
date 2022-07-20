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
/// view the docs for [{{ docs_name }}](https://redis.io/commands/{{ docs_link_name }})
func {{ func_name }}<T: FromRedisValue>({% for arg in args %}{{ arg.parameter() }}{{ ", " if not loop.last }}{% endfor %}) async throws -> T {
    {% if container_name %}
    try await Cmd("{{ container_name }}")
        .arg("{{ name }}")
    {% else %}
    try await Cmd("{{ name }}")
    {% endif %}
    {% for arg in args %}
        {% if arg.token %}
            {% if arg.is_variadic %}
                .arg((!{{ arg.name }}.isEmpty) ? "{{arg.token}}" : nil)
            {% elif arg.is_optional %}
                .arg(({{ arg.name }} != nil) ? "{{arg.token}}" : nil)
            {% endif %}
        {% endif %}
        .arg({{ arg.name }}.to_redis_args())
    {% endfor %}
        .query(self)   
}
{% for arg in args %}
{{ arg.custom_type() if arg.custom_type is defined }}
{% endfor %}