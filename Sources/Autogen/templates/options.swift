public struct {{ options_name }}: OptionSet, ToRedisArgs {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    {% for option in options %}
    static let {{ option.sanitized_token }} = {{ options_name }}(rawValue: 1 << {{ loop.index0 }})
    {% endfor %}
    public func write_redis_args(out: inout Array<Data>) {
        {% for option in options %}
        if self.contains(.{{ option.sanitized_token }}) {
            out.append("{{ option.token }}".data(using: .utf8)!)
        }
        {% endfor %}
    }
}