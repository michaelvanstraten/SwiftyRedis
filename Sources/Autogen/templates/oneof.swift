enum {{ name }}: ToRedisArgs {
    {% for name, type in cases %}
    case {{ name }}{{ "({})".format(type) if not type == "token" }}
    {% endfor %}
    public func write_redis_args(out: inout Array<Data>) {
        switch self {
        {% for name, type in cases %}
        {% if type == "token" %}
        case .{{ name }}:
            out.append("{{ name }}".data(using: .utf8)!)
        {% else %}
        case .{{ name }}{{ "(let {})".format(camel_case(type)) }}:
            {{ camel_case(type) }}.write_redis_args(out: &out)
        {% endif %}
        {% endfor %}
        }
    }
}