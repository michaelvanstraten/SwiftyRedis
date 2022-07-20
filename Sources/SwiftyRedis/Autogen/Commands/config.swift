//
//  config.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CONFIG HELP](https://redis.io/commands/config-help)
    public func config_help<T: FromRedisValue>() async throws -> T { try await Cmd("CONFIG").arg("HELP").query(self) }
    /// Rewrite the configuration file with the in memory configuration
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CONFIG REWRITE](https://redis.io/commands/config-rewrite)
    public func config_rewrite<T: FromRedisValue>() async throws -> T {
        try await Cmd("CONFIG").arg("REWRITE").query(self)
    }
    /// Reset the stats returned by INFO
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CONFIG RESETSTAT](https://redis.io/commands/config-resetstat)
    public func config_resetstat<T: FromRedisValue>() async throws -> T {
        try await Cmd("CONFIG").arg("RESETSTAT").query(self)
    }
    /// Get the values of configuration parameters
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) when N is the number of configuration parameters provided
    /// # History
    /// - 7.0.0, Added the ability to pass multiple pattern parameters in one call
    /// # Documentation
    /// view the docs for [CONFIG GET](https://redis.io/commands/config-get)
    public func config_get<T: FromRedisValue>(parameter: ConfigGetParameter...) async throws -> T {
        try await Cmd("CONFIG").arg("GET").arg(parameter.to_redis_args()).query(self)
    }
    public struct ConfigGetParameter: ToRedisArgs {
        let parameter: String
        public func write_redis_args(out: inout [Data]) { parameter.write_redis_args(out: &out) }
    }
    /// Set configuration parameters to the given values
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) when N is the number of configuration parameters provided
    /// # History
    /// - 7.0.0, Added the ability to set multiple parameters in one call.
    /// # Documentation
    /// view the docs for [CONFIG SET](https://redis.io/commands/config-set)
    public func config_set<T: FromRedisValue>(parameterValue: ConfigSetParametervalue...) async throws -> T {
        try await Cmd("CONFIG").arg("SET").arg(parameterValue.to_redis_args()).query(self)
    }
    public struct ConfigSetParametervalue: ToRedisArgs {
        let parameter: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            parameter.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
}
