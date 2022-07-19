public enum {{ enum_name }}: ToRedisArgs {
    {% for arg in args %}
    case {{ arg.sanitized_token }}{{ "({})".format(arg.type) if not arg.type == "token" }}
    {% endfor %}
    public func write_redis_args(out: inout Array<Data>) {
        switch self {
        {% for arg in args %}
        {% if arg.type == "token" %}
        case .{{ arg.sanitized_token }}:
            out.append("{{ arg.token }}".data(using: .utf8)!)
        {% else %}
        case .{{ arg.sanitized_token }}{{ "(let {})".format(camel_case(arg.type)) }}:
            {% if arg.token %}
            out.append("{{ arg.token }}".data(using: .utf8)!)
            {% endif %}
            {{ camel_case(arg.type) }}.write_redis_args(out: &out)
        {% endif %}
        {% endfor %}
        }
    }
    {% for arg in args %}
    {% if arg.custom_type is defined %}
    {{ arg.custom_type() }}
    {% endif %}
    {% endfor %}
}