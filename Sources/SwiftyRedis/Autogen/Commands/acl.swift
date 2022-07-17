//
//  acl.swift
//
//
//  Created by Autogen on 16.07.22.
//
import Foundation
extension RedisConnection {
    /// Return the name of the user associated to the current connection
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [ACL WHOAMI](https://redis.io/commands/acl-whoami)
    public func acl_whoami<T: FromRedisValue>() async throws -> T { try await Cmd("ACL").arg("WHOAMI").query(self) }
    /// Get the rules for a specific ACL user
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(N). Where N is the number of password, command and pattern rules that the user has.
    /// # History
    /// - 6.2.0, Added Pub/Sub channel patterns.
    /// - 7.0.0, Added selectors and changed the format of key and channel patterns from a list to their rule representation.
    /// # Documentation
    /// view the docs for [ACL GETUSER](https://redis.io/commands/acl-getuser)
    public func acl_getuser<T: FromRedisValue>(username: String) async throws -> T {
        try await Cmd("ACL").arg("GETUSER").arg(username.to_redis_args()).query(self)
    }
    /// Save the current ACL rules in the configured ACL file
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(N). Where N is the number of configured users.
    /// # Documentation
    /// view the docs for [ACL SAVE](https://redis.io/commands/acl-save)
    public func acl_save<T: FromRedisValue>() async throws -> T { try await Cmd("ACL").arg("SAVE").query(self) }
    /// List latest events denied because of ACLs in place
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(N) with N being the number of entries shown.
    /// # Documentation
    /// view the docs for [ACL LOG](https://redis.io/commands/acl-log)
    public func acl_log<T: FromRedisValue>(operation: AclLogOperation? = nil) async throws -> T {
        try await Cmd("ACL").arg("LOG").arg(operation.to_redis_args()).query(self)
    }
    public enum AclLogOperation: ToRedisArgs {
        case Count(Int)
        case RESET
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .Count(let int): int.write_redis_args(out: &out)
            case .RESET: out.append("RESET".data(using: .utf8)!)
            }
        }
    }
    /// List the ACL categories or the commands inside a category
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1) since the categories and commands are a fixed set.
    /// # Documentation
    /// view the docs for [ACL CAT](https://redis.io/commands/acl-cat)
    public func acl_cat<T: FromRedisValue>(categoryname: String? = nil) async throws -> T {
        try await Cmd("ACL").arg("CAT").arg(categoryname.to_redis_args()).query(self)
    }
    /// Returns whether the user can execute the given command without executing the command.
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1).
    /// # Documentation
    /// view the docs for [ACL DRYRUN](https://redis.io/commands/acl-dryrun)
    public func acl_dryrun<T: FromRedisValue>(username: String, command: String, arg: String?...) async throws -> T {
        try await Cmd("ACL").arg("DRYRUN").arg(username.to_redis_args()).arg(command.to_redis_args()).arg(
            arg.to_redis_args()
        ).query(self)
    }
    /// List the username of all the configured ACL rules
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(N). Where N is the number of configured users.
    /// # Documentation
    /// view the docs for [ACL USERS](https://redis.io/commands/acl-users)
    public func acl_users<T: FromRedisValue>() async throws -> T { try await Cmd("ACL").arg("USERS").query(self) }
    /// Modify or create the rules for a specific ACL user
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(N). Where N is the number of rules provided.
    /// # History
    /// - 6.2.0, Added Pub/Sub channel patterns.
    /// - 7.0.0, Added selectors and key based permissions.
    /// # Documentation
    /// view the docs for [ACL SETUSER](https://redis.io/commands/acl-setuser)
    public func acl_setuser<T: FromRedisValue>(username: String, rule: String?...) async throws -> T {
        try await Cmd("ACL").arg("SETUSER").arg(username.to_redis_args()).arg(rule.to_redis_args()).query(self)
    }
    /// Reload the ACLs from the configured ACL file
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(N). Where N is the number of configured users.
    /// # Documentation
    /// view the docs for [ACL LOAD](https://redis.io/commands/acl-load)
    public func acl_load<T: FromRedisValue>() async throws -> T { try await Cmd("ACL").arg("LOAD").query(self) }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [ACL HELP](https://redis.io/commands/acl-help)
    public func acl_help<T: FromRedisValue>() async throws -> T { try await Cmd("ACL").arg("HELP").query(self) }
    /// Remove the specified ACL users and the associated rules
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1) amortized time considering the typical user.
    /// # Documentation
    /// view the docs for [ACL DELUSER](https://redis.io/commands/acl-deluser)
    public func acl_deluser<T: FromRedisValue>(username: String...) async throws -> T {
        try await Cmd("ACL").arg("DELUSER").arg(username.to_redis_args()).query(self)
    }
    /// Generate a pseudorandom secure password to use for ACL users
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [ACL GENPASS](https://redis.io/commands/acl-genpass)
    public func acl_genpass<T: FromRedisValue>(bits: Int? = nil) async throws -> T {
        try await Cmd("ACL").arg("GENPASS").arg(bits.to_redis_args()).query(self)
    }
    /// List the current ACL rules in ACL config file format
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(N). Where N is the number of configured users.
    /// # Documentation
    /// view the docs for [ACL LIST](https://redis.io/commands/acl-list)
    public func acl_list<T: FromRedisValue>() async throws -> T { try await Cmd("ACL").arg("LIST").query(self) }
}
