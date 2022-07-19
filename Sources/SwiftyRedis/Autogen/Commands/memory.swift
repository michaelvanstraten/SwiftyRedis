//
//  memory.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Show memory usage details
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MEMORY STATS](https://redis.io/commands/memory-stats)
    public func memory_stats<T: FromRedisValue>() async throws -> T { try await Cmd("MEMORY").arg("STATS").query(self) }
    /// Ask the allocator to release memory
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// Depends on how much memory is allocated, could be slow
    /// # Documentation
    /// view the docs for [MEMORY PURGE](https://redis.io/commands/memory-purge)
    public func memory_purge<T: FromRedisValue>() async throws -> T { try await Cmd("MEMORY").arg("PURGE").query(self) }
    /// Outputs memory problems report
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MEMORY DOCTOR](https://redis.io/commands/memory-doctor)
    public func memory_doctor<T: FromRedisValue>() async throws -> T {
        try await Cmd("MEMORY").arg("DOCTOR").query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MEMORY HELP](https://redis.io/commands/memory-help)
    public func memory_help<T: FromRedisValue>() async throws -> T { try await Cmd("MEMORY").arg("HELP").query(self) }
    /// Estimate the memory usage of a key
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(N) where N is the number of samples.
    /// # Documentation
    /// view the docs for [MEMORY USAGE](https://redis.io/commands/memory-usage)
    public func memory_usage<T: FromRedisValue>(_ key: String, _ count: Int? = nil) async throws -> T {
        try await Cmd("MEMORY").arg("USAGE").arg(key.to_redis_args()).arg(count.to_redis_args()).query(self)
    }
    /// Show allocator internal stats
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// Depends on how much memory is allocated, could be slow
    /// # Documentation
    /// view the docs for [MEMORY MALLOC_STATS](https://redis.io/commands/memory-malloc-stats)
    public func memory_malloc_stats<T: FromRedisValue>() async throws -> T {
        try await Cmd("MEMORY").arg("MALLOC_STATS").query(self)
    }
}
