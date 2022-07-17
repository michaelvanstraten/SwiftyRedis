//
//  xinfo.swift
//
//
//  Created by Autogen on 16.07.22.
//
import Foundation
extension RedisConnection {
    /// List the consumer groups of a stream
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added the `entries-read` and `lag` fields
    /// # Documentation
    /// view the docs for [XINFO GROUPS](https://redis.io/commands/xinfo-groups)
    public func xinfo_groups<T: FromRedisValue>(key: String) async throws -> T {
        try await Cmd("XINFO").arg("GROUPS").arg(key.to_redis_args()).query(self)
    }
    /// List the consumers in a consumer group
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [XINFO CONSUMERS](https://redis.io/commands/xinfo-consumers)
    public func xinfo_consumers<T: FromRedisValue>(key: String, groupname: String) async throws -> T {
        try await Cmd("XINFO").arg("CONSUMERS").arg(key.to_redis_args()).arg(groupname.to_redis_args()).query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [XINFO HELP](https://redis.io/commands/xinfo-help)
    public func xinfo_help<T: FromRedisValue>() async throws -> T { try await Cmd("XINFO").arg("HELP").query(self) }
    /// Get information about a stream
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 6.0.0, Added the `FULL` modifier.
    /// - 7.0.0, Added the `max-deleted-entry-id`, `entries-added`, `recorded-first-entry-id`, `entries-read` and `lag` fields
    /// # Documentation
    /// view the docs for [XINFO STREAM](https://redis.io/commands/xinfo-stream)
    public func xinfo_stream<T: FromRedisValue>(key: String, full: XinfoStreamFull? = nil) async throws -> T {
        try await Cmd("XINFO").arg("STREAM").arg(key.to_redis_args()).arg(full.to_redis_args()).query(self)
    }
    public struct XinfoStreamFull: ToRedisArgs {
        let COUNT: Int
        public func write_redis_args(out: inout [Data]) {
            out.append("FULL".data(using: .utf8)!)
            COUNT.write_redis_args(out: &out)
        }
    }
}
