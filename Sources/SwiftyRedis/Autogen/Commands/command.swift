//
//  command.swift
//
//
//  Created by Autogen on 16.07.22.
//
import Foundation
extension RedisConnection {
    /// Extract keys and access flags given a full Redis command
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of arguments to the command
    /// # Documentation
    /// view the docs for [COMMAND GETKEYSANDFLAGS](https://redis.io/commands/command-getkeysandflags)
    public func command_getkeysandflags<T: FromRedisValue>() async throws -> T {
        try await Cmd("COMMAND").arg("GETKEYSANDFLAGS").query(self)
    }
    /// Get array of specific Redis command documentation
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of commands to look up
    /// # Documentation
    /// view the docs for [COMMAND DOCS](https://redis.io/commands/command-docs)
    public func command_docs<T: FromRedisValue>(commandName: String?...) async throws -> T {
        try await Cmd("COMMAND").arg("DOCS").arg(commandName.to_redis_args()).query(self)
    }
    /// Get total number of Redis commands
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [COMMAND COUNT](https://redis.io/commands/command-count)
    public func command_count<T: FromRedisValue>() async throws -> T {
        try await Cmd("COMMAND").arg("COUNT").query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [COMMAND HELP](https://redis.io/commands/command-help)
    public func command_help<T: FromRedisValue>() async throws -> T { try await Cmd("COMMAND").arg("HELP").query(self) }
    /// Extract keys given a full Redis command
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(N) where N is the number of arguments to the command
    /// # Documentation
    /// view the docs for [COMMAND GETKEYS](https://redis.io/commands/command-getkeys)
    public func command_getkeys<T: FromRedisValue>() async throws -> T {
        try await Cmd("COMMAND").arg("GETKEYS").query(self)
    }
    /// Get array of specific Redis command details, or all when no argument is given.
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(N) where N is the number of commands to look up
    /// # History
    /// - 7.0.0, Allowed to be called with no argument to get info on all commands.
    /// # Documentation
    /// view the docs for [COMMAND INFO](https://redis.io/commands/command-info)
    public func command_info<T: FromRedisValue>(commandName: String?...) async throws -> T {
        try await Cmd("COMMAND").arg("INFO").arg(commandName.to_redis_args()).query(self)
    }
    /// Get an array of Redis command names
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the total number of Redis commands
    /// # Documentation
    /// view the docs for [COMMAND LIST](https://redis.io/commands/command-list)
    public func command_list<T: FromRedisValue>(filterby: CommandListFilterby? = nil) async throws -> T {
        try await Cmd("COMMAND").arg("LIST").arg(filterby.to_redis_args()).query(self)
    }
    public enum CommandListFilterby: ToRedisArgs {
        case MODULE(String)
        case ACLCAT(String)
        case PATTERN(String)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .MODULE(let string): string.write_redis_args(out: &out)
            case .ACLCAT(let string): string.write_redis_args(out: &out)
            case .PATTERN(let string): string.write_redis_args(out: &out)
            }
        }
    }
}
