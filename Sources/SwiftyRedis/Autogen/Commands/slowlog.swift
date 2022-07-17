//
//  slowlog.swift
//
//
//  Created by Autogen on 16.07.22.
//
import Foundation
extension RedisConnection {
    /// Clear all entries from the slow log
    /// # Available since
    /// 2.2.12
    /// # Time complexity
    /// O(N) where N is the number of entries in the slowlog
    /// # Documentation
    /// view the docs for [SLOWLOG RESET](https://redis.io/commands/slowlog-reset)
    public func slowlog_reset<T: FromRedisValue>() async throws -> T {
        try await Cmd("SLOWLOG").arg("RESET").query(self)
    }
    /// Get the slow log's entries
    /// # Available since
    /// 2.2.12
    /// # Time complexity
    /// O(N) where N is the number of entries returned
    /// # History
    /// - 4.0.0, Added client IP address, port and name to the reply.
    /// # Documentation
    /// view the docs for [SLOWLOG GET](https://redis.io/commands/slowlog-get)
    public func slowlog_get<T: FromRedisValue>(count: Int? = nil) async throws -> T {
        try await Cmd("SLOWLOG").arg("GET").arg(count.to_redis_args()).query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SLOWLOG HELP](https://redis.io/commands/slowlog-help)
    public func slowlog_help<T: FromRedisValue>() async throws -> T { try await Cmd("SLOWLOG").arg("HELP").query(self) }
    /// Get the slow log's length
    /// # Available since
    /// 2.2.12
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SLOWLOG LEN](https://redis.io/commands/slowlog-len)
    public func slowlog_len<T: FromRedisValue>() async throws -> T { try await Cmd("SLOWLOG").arg("LEN").query(self) }
}
