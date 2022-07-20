public struct {{ struct_name }}: ToRedisArgs {
    {% for arg in args %}
    let {{ arg.name }}: {{ "[{}]".format(arg.type) if arg.multiple else arg.type }}{{ "? = nil" if arg.optional }}
    {% endfor %}
    public func write_redis_args(out: inout Array<Data>) {
        {% for arg in args %}
        {% if arg.token %}
            out.append("{{ arg.token }}".data(using: .utf8)!)
        {% endif %}
        {{ arg.name }}.write_redis_args(out: &out)
        {% endfor %}
    }
    {% for arg in args %}
    {{ arg.custom_type() if arg.custom_type is defined }}
    {% endfor %}
}