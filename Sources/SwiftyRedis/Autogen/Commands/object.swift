//
//  object.swift
//
//
//  Created by Autogen on 16.07.22.
//
import Foundation
extension RedisConnection {
    /// Get the logarithmic access frequency counter of a Redis object
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [OBJECT FREQ](https://redis.io/commands/object-freq)
    public func object_freq<T: FromRedisValue>(key: String) async throws -> T {
        try await Cmd("OBJECT").arg("FREQ").arg(key.to_redis_args()).query(self)
    }
    /// Get the number of references to the value of the key
    /// # Available since
    /// 2.2.3
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [OBJECT REFCOUNT](https://redis.io/commands/object-refcount)
    public func object_refcount<T: FromRedisValue>(key: String) async throws -> T {
        try await Cmd("OBJECT").arg("REFCOUNT").arg(key.to_redis_args()).query(self)
    }
    /// Get the time since a Redis object was last accessed
    /// # Available since
    /// 2.2.3
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [OBJECT IDLETIME](https://redis.io/commands/object-idletime)
    public func object_idletime<T: FromRedisValue>(key: String) async throws -> T {
        try await Cmd("OBJECT").arg("IDLETIME").arg(key.to_redis_args()).query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [OBJECT HELP](https://redis.io/commands/object-help)
    public func object_help<T: FromRedisValue>() async throws -> T { try await Cmd("OBJECT").arg("HELP").query(self) }
    /// Inspect the internal encoding of a Redis object
    /// # Available since
    /// 2.2.3
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [OBJECT ENCODING](https://redis.io/commands/object-encoding)
    public func object_encoding<T: FromRedisValue>(key: String) async throws -> T {
        try await Cmd("OBJECT").arg("ENCODING").arg(key.to_redis_args()).query(self)
    }
}
