//
//  script.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Kill the script currently in execution.
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SCRIPT KILL](https://redis.io/commands/script-kill)
    public func script_kill<T: FromRedisValue>() async throws -> T { try await Cmd("SCRIPT").arg("KILL").query(self) }
    /// Remove all the scripts from the script cache.
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(N) with N being the number of scripts in cache
    /// # History
    /// - 6.2.0, Added the `ASYNC` and `SYNC` flushing mode modifiers.
    /// # Documentation
    /// view the docs for [SCRIPT FLUSH](https://redis.io/commands/script-flush)
    public func script_flush<T: FromRedisValue>(async: ScriptFlushAsync? = nil) async throws -> T {
        try await Cmd("SCRIPT").arg("FLUSH").arg(async.to_redis_args()).query(self)
    }
    public enum ScriptFlushAsync: ToRedisArgs {
        case ASYNC
        case SYNC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASYNC: out.append("ASYNC".data(using: .utf8)!)
            case .SYNC: out.append("SYNC".data(using: .utf8)!)
            }
        }
    }
    /// Load the specified Lua script into the script cache.
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(N) with N being the length in bytes of the script body.
    /// # Documentation
    /// view the docs for [SCRIPT LOAD](https://redis.io/commands/script-load)
    public func script_load<T: FromRedisValue>(script: String) async throws -> T {
        try await Cmd("SCRIPT").arg("LOAD").arg(script.to_redis_args()).query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SCRIPT HELP](https://redis.io/commands/script-help)
    public func script_help<T: FromRedisValue>() async throws -> T { try await Cmd("SCRIPT").arg("HELP").query(self) }
    /// Set the debug mode for executed scripts.
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SCRIPT DEBUG](https://redis.io/commands/script-debug)
    public func script_debug<T: FromRedisValue>(mode: ScriptDebugMode) async throws -> T {
        try await Cmd("SCRIPT").arg("DEBUG").arg(mode.to_redis_args()).query(self)
    }
    public enum ScriptDebugMode: ToRedisArgs {
        case YES
        case SYNC
        case NO
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .YES: out.append("YES".data(using: .utf8)!)
            case .SYNC: out.append("SYNC".data(using: .utf8)!)
            case .NO: out.append("NO".data(using: .utf8)!)
            }
        }
    }
    /// Check existence of scripts in the script cache.
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(N) with N being the number of scripts to check (so checking a single script is an O(1) operation).
    /// # Documentation
    /// view the docs for [SCRIPT EXISTS](https://redis.io/commands/script-exists)
    public func script_exists<T: FromRedisValue>(sha1: String...) async throws -> T {
        try await Cmd("SCRIPT").arg("EXISTS").arg(sha1.to_redis_args()).query(self)
    }
}
