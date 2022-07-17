struct {{ name }}: ToRedisArgs {
    {% for name, type in fields %}
    let {{ name }}: {{ type }}
    {% endfor %}
    public func write_redis_args(out: inout Array<Data>) {
        out.append("{{ command }}".data(using: .utf8)!)
        {% for name, _ in fields %}
        {{ name }}.write_redis_args(out: &out)
        {% endfor %}
    }
}