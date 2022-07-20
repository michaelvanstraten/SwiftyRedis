//
//  module.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Unload a module
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MODULE UNLOAD](https://redis.io/commands/module-unload)
    public func module_unload<T: FromRedisValue>(name: String) async throws -> T {
        try await Cmd("MODULE").arg("UNLOAD").arg(name.to_redis_args()).query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MODULE HELP](https://redis.io/commands/module-help)
    public func module_help<T: FromRedisValue>() async throws -> T { try await Cmd("MODULE").arg("HELP").query(self) }
    /// Load a module
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MODULE LOAD](https://redis.io/commands/module-load)
    public func module_load<T: FromRedisValue>(path: String, arg: String...) async throws -> T {
        try await Cmd("MODULE").arg("LOAD").arg(path.to_redis_args()).arg(arg.to_redis_args()).query(self)
    }
    /// Load a module with extended parameters
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MODULE LOADEX](https://redis.io/commands/module-loadex)
    public func module_loadex<T: FromRedisValue>(
        path: String, configs: ModuleLoadexConfigs..., args: ModuleLoadexArgs...
    ) async throws -> T {
        try await Cmd("MODULE").arg("LOADEX").arg(path.to_redis_args()).arg((!configs.isEmpty) ? "CONFIG" : nil).arg(
            configs.to_redis_args()
        ).arg((!args.isEmpty) ? "ARGS" : nil).arg(args.to_redis_args()).query(self)
    }
    public struct ModuleLoadexConfigs: ToRedisArgs {
        let name: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            name.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
    public struct ModuleLoadexArgs: ToRedisArgs {
        let arg: String
        public func write_redis_args(out: inout [Data]) { arg.write_redis_args(out: &out) }
    }
    /// List all modules loaded by the server
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(N) where N is the number of loaded modules.
    /// # Documentation
    /// view the docs for [MODULE LIST](https://redis.io/commands/module-list)
    public func module_list<T: FromRedisValue>() async throws -> T { try await Cmd("MODULE").arg("LIST").query(self) }
}
