public struct {{ struct_name }}: ToRedisArgs {
    {% for arg in args %}
    let {{ arg.name }}: {{ arg.type }}
    {% endfor %}
    public func write_redis_args(out: inout Array<Data>) {
        {% for arg in args %}
        {% if loop.first and arg.token %}
            out.append("{{ arg.token }}".data(using: .utf8)!)
        {% endif %}
        {{ arg.name }}.write_redis_args(out: &out)
        {% endfor %}
    }
    {% for arg in args %}
    {% if arg.custom_type is defined %}
    {{ arg.custom_type() }}
    {% endif %}
    {% endfor %}
}