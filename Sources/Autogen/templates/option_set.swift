struct {{ name }}: OptionSet, ToRedisArgs {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    {% for case_name in case_names -%}
    static let {{ case_name }} = {{ name }}(rawValue: 1 << {{ loop.index0 }})
    {% endfor %}
    public func write_redis_args(out: inout Array<Data>) {
        {%- for case_name in case_names %}
        if self.contains(.{{ case_name }}) {
            out.append("{{ case_name }}".data(using: .utf8)!)
        }
        {%- endfor %}
    }
}