public enum {{ enum_name }}: ToRedisArgs {
    {% for arg in args %}
    case {{ arg.sanitized_token }}{{ "({})".format(arg.type) if arg.type != "token" }}
    {% endfor %}
    public func write_redis_args(out: inout Array<Data>) {
        switch self {
        {% for arg in args %}
        case .{{ arg.sanitized_token }}{{ "(let {})".format(camel_case(arg.type)) if arg.type != "token" }}:
            {% if arg.token %}
            out.append("{{ arg.token }}".data(using: .utf8)!)
            {% elif arg.type == "token" %}
            out.append("{{ arg.backup_token }}".data(using: .utf8)!)
            {% endif %}
            {% if arg.type != "token" %}
            {{ camel_case(arg.type) }}.write_redis_args(out: &out)
            {% endif %}
        {% endfor %}
        }
    }
    {% for arg in args %}
    {{ arg.custom_type() if arg.custom_type is defined }}
    {% endfor %}
}