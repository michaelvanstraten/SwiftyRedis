//
//  function.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Deleting all functions
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of functions deleted
    /// # Documentation
    /// view the docs for [FUNCTION FLUSH](https://redis.io/commands/function-flush)
    public func function_flush<T: FromRedisValue>(async: FunctionFlushAsync? = nil) async throws -> T {
        try await Cmd("FUNCTION").arg("FLUSH").arg(async.to_redis_args()).query(self)
    }
    public enum FunctionFlushAsync: ToRedisArgs {
        case ASYNC
        case SYNC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASYNC: out.append("ASYNC".data(using: .utf8)!)
            case .SYNC: out.append("SYNC".data(using: .utf8)!)
            }
        }
    }
    /// List information about all the functions
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of functions
    /// # Documentation
    /// view the docs for [FUNCTION LIST](https://redis.io/commands/function-list)
    public func function_list<T: FromRedisValue>(libraryNamePattern: String? = nil, options: FunctionListOptions? = nil)
        async throws -> T
    {
        try await Cmd("FUNCTION").arg("LIST").arg((libraryNamePattern != nil) ? "LIBRARYNAME" : nil).arg(
            libraryNamePattern.to_redis_args()
        ).arg(options.to_redis_args()).query(self)
    }
    public struct FunctionListOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHCODE = FunctionListOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHCODE) { out.append("WITHCODE".data(using: .utf8)!) }
        }
    }
    /// Delete a function by name
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [FUNCTION DELETE](https://redis.io/commands/function-delete)
    public func function_delete<T: FromRedisValue>(libraryName: String) async throws -> T {
        try await Cmd("FUNCTION").arg("DELETE").arg(libraryName.to_redis_args()).query(self)
    }
    /// Return information about the function currently running (name, description, duration)
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [FUNCTION STATS](https://redis.io/commands/function-stats)
    public func function_stats<T: FromRedisValue>() async throws -> T {
        try await Cmd("FUNCTION").arg("STATS").query(self)
    }
    /// Restore all the functions on the given payload
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of functions on the payload
    /// # Documentation
    /// view the docs for [FUNCTION RESTORE](https://redis.io/commands/function-restore)
    public func function_restore<T: FromRedisValue>(serializedValue: String, policy: FunctionRestorePolicy? = nil)
        async throws -> T
    {
        try await Cmd("FUNCTION").arg("RESTORE").arg(serializedValue.to_redis_args()).arg(policy.to_redis_args()).query(
            self)
    }
    public enum FunctionRestorePolicy: ToRedisArgs {
        case FLUSH
        case APPEND
        case REPLACE
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .FLUSH: out.append("FLUSH".data(using: .utf8)!)
            case .APPEND: out.append("APPEND".data(using: .utf8)!)
            case .REPLACE: out.append("REPLACE".data(using: .utf8)!)
            }
        }
    }
    /// Create a function with the given arguments (name, code, description)
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1) (considering compilation time is redundant)
    /// # Documentation
    /// view the docs for [FUNCTION LOAD](https://redis.io/commands/function-load)
    public func function_load<T: FromRedisValue>(functionCode: String, options: FunctionLoadOptions? = nil) async throws
        -> T
    { try await Cmd("FUNCTION").arg("LOAD").arg(functionCode.to_redis_args()).arg(options.to_redis_args()).query(self) }
    public struct FunctionLoadOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let REPLACE = FunctionLoadOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.REPLACE) { out.append("REPLACE".data(using: .utf8)!) }
        }
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [FUNCTION HELP](https://redis.io/commands/function-help)
    public func function_help<T: FromRedisValue>() async throws -> T {
        try await Cmd("FUNCTION").arg("HELP").query(self)
    }
    /// Kill the function currently in execution.
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [FUNCTION KILL](https://redis.io/commands/function-kill)
    public func function_kill<T: FromRedisValue>() async throws -> T {
        try await Cmd("FUNCTION").arg("KILL").query(self)
    }
    /// Dump all functions into a serialized binary payload
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of functions
    /// # Documentation
    /// view the docs for [FUNCTION DUMP](https://redis.io/commands/function-dump)
    public func function_dump<T: FromRedisValue>() async throws -> T {
        try await Cmd("FUNCTION").arg("DUMP").query(self)
    }
}
