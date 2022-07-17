//
//  xgroup.swift
//
//
//  Created by Autogen on 16.07.22.
//
import Foundation
extension RedisConnection {
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [XGROUP HELP](https://redis.io/commands/xgroup-help)
    public func xgroup_help<T: FromRedisValue>() async throws -> T { try await Cmd("XGROUP").arg("HELP").query(self) }
    /// Delete a consumer from a consumer group.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [XGROUP DELCONSUMER](https://redis.io/commands/xgroup-delconsumer)
    public func xgroup_delconsumer<T: FromRedisValue>(key: String, groupname: String, consumername: String) async throws
        -> T
    {
        try await Cmd("XGROUP").arg("DELCONSUMER").arg(key.to_redis_args()).arg(groupname.to_redis_args()).arg(
            consumername.to_redis_args()
        ).query(self)
    }
    /// Destroy a consumer group.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(N) where N is the number of entries in the group's pending entries list (PEL).
    /// # Documentation
    /// view the docs for [XGROUP DESTROY](https://redis.io/commands/xgroup-destroy)
    public func xgroup_destroy<T: FromRedisValue>(key: String, groupname: String) async throws -> T {
        try await Cmd("XGROUP").arg("DESTROY").arg(key.to_redis_args()).arg(groupname.to_redis_args()).query(self)
    }
    /// Create a consumer in a consumer group.
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [XGROUP CREATECONSUMER](https://redis.io/commands/xgroup-createconsumer)
    public func xgroup_createconsumer<T: FromRedisValue>(key: String, groupname: String, consumername: String)
        async throws -> T
    {
        try await Cmd("XGROUP").arg("CREATECONSUMER").arg(key.to_redis_args()).arg(groupname.to_redis_args()).arg(
            consumername.to_redis_args()
        ).query(self)
    }
}
