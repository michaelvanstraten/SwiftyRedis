//
//  xgroup.swift
//
//
//  Created by Autogen on 20.07.22.
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
    /// Create a consumer group.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added the `entries_read` named argument.
    /// # Documentation
    /// view the docs for [XGROUP CREATE](https://redis.io/commands/xgroup-create)
    public func xgroup_create<T: FromRedisValue>(
        key: String, groupname: String, id: XgroupCreateId, entriesRead: Int? = nil, options: XgroupCreateOptions? = nil
    ) async throws -> T {
        try await Cmd("XGROUP").arg("CREATE").arg(key.to_redis_args()).arg(groupname.to_redis_args()).arg(
            id.to_redis_args()
        ).arg((entriesRead != nil) ? "ENTRIESREAD" : nil).arg(entriesRead.to_redis_args()).arg(options.to_redis_args())
            .query(self)
    }
    public enum XgroupCreateId: ToRedisArgs {
        case ID(String)
        case NEW_ID
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ID(let string): string.write_redis_args(out: &out)
            case .NEW_ID: out.append("$".data(using: .utf8)!)
            }
        }
    }
    public struct XgroupCreateOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let MKSTREAM = XgroupCreateOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.MKSTREAM) { out.append("MKSTREAM".data(using: .utf8)!) }
        }
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
    /// Set a consumer group to an arbitrary last delivered ID value.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added the optional `entries_read` argument.
    /// # Documentation
    /// view the docs for [XGROUP SETID](https://redis.io/commands/xgroup-setid)
    public func xgroup_setid<T: FromRedisValue>(
        key: String, groupname: String, id: XgroupSetidId, entriesRead: Int? = nil
    ) async throws -> T {
        try await Cmd("XGROUP").arg("SETID").arg(key.to_redis_args()).arg(groupname.to_redis_args()).arg(
            id.to_redis_args()
        ).arg((entriesRead != nil) ? "ENTRIESREAD" : nil).arg(entriesRead.to_redis_args()).query(self)
    }
    public enum XgroupSetidId: ToRedisArgs {
        case ID(String)
        case NEW_ID
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ID(let string): string.write_redis_args(out: &out)
            case .NEW_ID: out.append("$".data(using: .utf8)!)
            }
        }
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
