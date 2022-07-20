//
//  pubsub.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Get the count of subscribers for channels
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(N) for the NUMSUB subcommand, where N is the number of requested channels
    /// # Documentation
    /// view the docs for [PUBSUB NUMSUB](https://redis.io/commands/pubsub-numsub)
    public func pubsub_numsub<T: FromRedisValue>(channel: String...) async throws -> T {
        try await Cmd("PUBSUB").arg("NUMSUB").arg(channel.to_redis_args()).query(self)
    }
    /// Get the count of subscribers for shard channels
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) for the SHARDNUMSUB subcommand, where N is the number of requested shard channels
    /// # Documentation
    /// view the docs for [PUBSUB SHARDNUMSUB](https://redis.io/commands/pubsub-shardnumsub)
    public func pubsub_shardnumsub<T: FromRedisValue>(shardchannel: String...) async throws -> T {
        try await Cmd("PUBSUB").arg("SHARDNUMSUB").arg(shardchannel.to_redis_args()).query(self)
    }
    /// List active shard channels
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of active shard channels, and assuming constant time pattern matching (relatively short shard channels).
    /// # Documentation
    /// view the docs for [PUBSUB SHARDCHANNELS](https://redis.io/commands/pubsub-shardchannels)
    public func pubsub_shardchannels<T: FromRedisValue>(pattern: String? = nil) async throws -> T {
        try await Cmd("PUBSUB").arg("SHARDCHANNELS").arg(pattern.to_redis_args()).query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [PUBSUB HELP](https://redis.io/commands/pubsub-help)
    public func pubsub_help<T: FromRedisValue>() async throws -> T { try await Cmd("PUBSUB").arg("HELP").query(self) }
    /// Get the count of unique patterns pattern subscriptions
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [PUBSUB NUMPAT](https://redis.io/commands/pubsub-numpat)
    public func pubsub_numpat<T: FromRedisValue>() async throws -> T {
        try await Cmd("PUBSUB").arg("NUMPAT").query(self)
    }
    /// List active channels
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(N) where N is the number of active channels, and assuming constant time pattern matching (relatively short channels and patterns)
    /// # Documentation
    /// view the docs for [PUBSUB CHANNELS](https://redis.io/commands/pubsub-channels)
    public func pubsub_channels<T: FromRedisValue>(pattern: String? = nil) async throws -> T {
        try await Cmd("PUBSUB").arg("CHANNELS").arg(pattern.to_redis_args()).query(self)
    }
}
