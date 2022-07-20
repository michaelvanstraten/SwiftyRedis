//
//  latency.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Show helpful text about the different subcommands.
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LATENCY HELP](https://redis.io/commands/latency-help)
    public func latency_help<T: FromRedisValue>() async throws -> T { try await Cmd("LATENCY").arg("HELP").query(self) }
    /// Return a latency graph for the event.
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LATENCY GRAPH](https://redis.io/commands/latency-graph)
    public func latency_graph<T: FromRedisValue>(event: String) async throws -> T {
        try await Cmd("LATENCY").arg("GRAPH").arg(event.to_redis_args()).query(self)
    }
    /// Return timestamp-latency samples for the event.
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LATENCY HISTORY](https://redis.io/commands/latency-history)
    public func latency_history<T: FromRedisValue>(event: String) async throws -> T {
        try await Cmd("LATENCY").arg("HISTORY").arg(event.to_redis_args()).query(self)
    }
    /// Return the latest latency samples for all events.
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LATENCY LATEST](https://redis.io/commands/latency-latest)
    public func latency_latest<T: FromRedisValue>() async throws -> T {
        try await Cmd("LATENCY").arg("LATEST").query(self)
    }
    /// Return the cumulative distribution of latencies of a subset of commands or all.
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of commands with latency information being retrieved.
    /// # Documentation
    /// view the docs for [LATENCY HISTOGRAM](https://redis.io/commands/latency-histogram)
    public func latency_histogram<T: FromRedisValue>(command: String...) async throws -> T {
        try await Cmd("LATENCY").arg("HISTOGRAM").arg(command.to_redis_args()).query(self)
    }
    /// Reset latency data for one or more events.
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LATENCY RESET](https://redis.io/commands/latency-reset)
    public func latency_reset<T: FromRedisValue>(event: String...) async throws -> T {
        try await Cmd("LATENCY").arg("RESET").arg(event.to_redis_args()).query(self)
    }
    /// Return a human readable latency analysis report.
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LATENCY DOCTOR](https://redis.io/commands/latency-doctor)
    public func latency_doctor<T: FromRedisValue>() async throws -> T {
        try await Cmd("LATENCY").arg("DOCTOR").query(self)
    }
}
