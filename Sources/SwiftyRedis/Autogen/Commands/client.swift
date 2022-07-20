//
//  client.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Unblock a client blocked in a blocking command from a different connection
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(log N) where N is the number of client connections
    /// # Documentation
    /// view the docs for [CLIENT UNBLOCK](https://redis.io/commands/client-unblock)
    public func client_unblock<T: FromRedisValue>(clientId: Int, timeoutError: ClientUnblockTimeouterror? = nil)
        async throws -> T
    {
        try await Cmd("CLIENT").arg("UNBLOCK").arg(clientId.to_redis_args()).arg(timeoutError.to_redis_args()).query(
            self)
    }
    public enum ClientUnblockTimeouterror: ToRedisArgs {
        case TIMEOUT
        case ERROR
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .TIMEOUT: out.append("TIMEOUT".data(using: .utf8)!)
            case .ERROR: out.append("ERROR".data(using: .utf8)!)
            }
        }
    }
    /// Returns the client ID for the current connection
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT ID](https://redis.io/commands/client-id)
    public func client_id<T: FromRedisValue>() async throws -> T { try await Cmd("CLIENT").arg("ID").query(self) }
    /// Set the current connection name
    /// # Available since
    /// 2.6.9
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT SETNAME](https://redis.io/commands/client-setname)
    public func client_setname<T: FromRedisValue>(connectionName: String) async throws -> T {
        try await Cmd("CLIENT").arg("SETNAME").arg(connectionName.to_redis_args()).query(self)
    }
    /// Get the list of client connections
    /// # Available since
    /// 2.4.0
    /// # Time complexity
    /// O(N) where N is the number of client connections
    /// # History
    /// - 2.8.12, Added unique client `id` field.
    /// - 5.0.0, Added optional `TYPE` filter.
    /// - 6.2.0, Added `laddr` field and the optional `ID` filter.
    /// # Documentation
    /// view the docs for [CLIENT LIST](https://redis.io/commands/client-list)
    public func client_list<T: FromRedisValue>(
        normalMasterReplicaPubsub: ClientListNormalmasterreplicapubsub? = nil, id: ClientListId? = nil
    ) async throws -> T {
        try await Cmd("CLIENT").arg("LIST").arg((normalMasterReplicaPubsub != nil) ? "TYPE" : nil).arg(
            normalMasterReplicaPubsub.to_redis_args()
        ).arg((id != nil) ? "ID" : nil).arg(id.to_redis_args()).query(self)
    }
    public enum ClientListNormalmasterreplicapubsub: ToRedisArgs {
        case normal
        case master
        case replica
        case pubsub
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .normal: out.append("normal".data(using: .utf8)!)
            case .master: out.append("master".data(using: .utf8)!)
            case .replica: out.append("replica".data(using: .utf8)!)
            case .pubsub: out.append("pubsub".data(using: .utf8)!)
            }
        }
    }
    public struct ClientListId: ToRedisArgs {
        let clientId: Int
        public func write_redis_args(out: inout [Data]) { clientId.write_redis_args(out: &out) }
    }
    /// Returns information about the current client connection.
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT INFO](https://redis.io/commands/client-info)
    public func client_info<T: FromRedisValue>() async throws -> T { try await Cmd("CLIENT").arg("INFO").query(self) }
    /// Get the current connection name
    /// # Available since
    /// 2.6.9
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT GETNAME](https://redis.io/commands/client-getname)
    public func client_getname<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLIENT").arg("GETNAME").query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT HELP](https://redis.io/commands/client-help)
    public func client_help<T: FromRedisValue>() async throws -> T { try await Cmd("CLIENT").arg("HELP").query(self) }
    /// Return information about server assisted client side caching for the current connection
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT TRACKINGINFO](https://redis.io/commands/client-trackinginfo)
    public func client_trackinginfo<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLIENT").arg("TRACKINGINFO").query(self)
    }
    /// Set client eviction mode for the current connection
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT NO_EVICT](https://redis.io/commands/client-no-evict)
    public func client_no_evict<T: FromRedisValue>(enabled: ClientNoEvictEnabled) async throws -> T {
        try await Cmd("CLIENT").arg("NO_EVICT").arg(enabled.to_redis_args()).query(self)
    }
    public enum ClientNoEvictEnabled: ToRedisArgs {
        case ON
        case OFF
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ON: out.append("ON".data(using: .utf8)!)
            case .OFF: out.append("OFF".data(using: .utf8)!)
            }
        }
    }
    /// Stop processing commands from clients for some time
    /// # Available since
    /// 2.9.50
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 6.2.0, `CLIENT PAUSE WRITE` mode added along with the `mode` option.
    /// # Documentation
    /// view the docs for [CLIENT PAUSE](https://redis.io/commands/client-pause)
    public func client_pause<T: FromRedisValue>(timeout: Int, mode: ClientPauseMode? = nil) async throws -> T {
        try await Cmd("CLIENT").arg("PAUSE").arg(timeout.to_redis_args()).arg(mode.to_redis_args()).query(self)
    }
    public enum ClientPauseMode: ToRedisArgs {
        case WRITE
        case ALL
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .WRITE: out.append("WRITE".data(using: .utf8)!)
            case .ALL: out.append("ALL".data(using: .utf8)!)
            }
        }
    }
    /// Instruct the server whether to reply to commands
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT REPLY](https://redis.io/commands/client-reply)
    public func client_reply<T: FromRedisValue>(onOffSkip: ClientReplyOnoffskip) async throws -> T {
        try await Cmd("CLIENT").arg("REPLY").arg(onOffSkip.to_redis_args()).query(self)
    }
    public enum ClientReplyOnoffskip: ToRedisArgs {
        case ON
        case OFF
        case SKIP
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ON: out.append("ON".data(using: .utf8)!)
            case .OFF: out.append("OFF".data(using: .utf8)!)
            case .SKIP: out.append("SKIP".data(using: .utf8)!)
            }
        }
    }
    /// Kill the connection of a client
    /// # Available since
    /// 2.4.0
    /// # Time complexity
    /// O(N) where N is the number of client connections
    /// # History
    /// - 2.8.12, Added new filter format.
    /// - 2.8.12, `ID` option.
    /// - 3.2.0, Added `master` type in for `TYPE` option.
    /// - 5.0.0, Replaced `slave` `TYPE` with `replica`. `slave` still supported for backward compatibility.
    /// - 6.2.0, `LADDR` option.
    /// # Documentation
    /// view the docs for [CLIENT KILL](https://redis.io/commands/client-kill)
    public func client_kill<T: FromRedisValue>(
        ipPort: String? = nil, clientId: Int? = nil, normalMasterSlavePubsub: ClientKillNormalmasterslavepubsub? = nil,
        username: String? = nil, ADDR: String? = nil, LADDR: String? = nil, yesNo: String? = nil
    ) async throws -> T {
        try await Cmd("CLIENT").arg("KILL").arg(ipPort.to_redis_args()).arg((clientId != nil) ? "ID" : nil).arg(
            clientId.to_redis_args()
        ).arg((normalMasterSlavePubsub != nil) ? "TYPE" : nil).arg(normalMasterSlavePubsub.to_redis_args()).arg(
            (username != nil) ? "USER" : nil
        ).arg(username.to_redis_args()).arg((ADDR != nil) ? "ADDR" : nil).arg(ADDR.to_redis_args()).arg(
            (LADDR != nil) ? "LADDR" : nil
        ).arg(LADDR.to_redis_args()).arg((yesNo != nil) ? "SKIPME" : nil).arg(yesNo.to_redis_args()).query(self)
    }
    public enum ClientKillNormalmasterslavepubsub: ToRedisArgs {
        case normal
        case master
        case slave
        case replica
        case pubsub
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .normal: out.append("normal".data(using: .utf8)!)
            case .master: out.append("master".data(using: .utf8)!)
            case .slave: out.append("slave".data(using: .utf8)!)
            case .replica: out.append("replica".data(using: .utf8)!)
            case .pubsub: out.append("pubsub".data(using: .utf8)!)
            }
        }
    }
    /// Instruct the server about tracking or not keys in the next request
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT CACHING](https://redis.io/commands/client-caching)
    public func client_caching<T: FromRedisValue>(mode: ClientCachingMode) async throws -> T {
        try await Cmd("CLIENT").arg("CACHING").arg(mode.to_redis_args()).query(self)
    }
    public enum ClientCachingMode: ToRedisArgs {
        case YES
        case NO
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .YES: out.append("YES".data(using: .utf8)!)
            case .NO: out.append("NO".data(using: .utf8)!)
            }
        }
    }
    /// Get tracking notifications redirection client ID if any
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLIENT GETREDIR](https://redis.io/commands/client-getredir)
    public func client_getredir<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLIENT").arg("GETREDIR").query(self)
    }
    /// Resume processing of clients that were paused
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N) Where N is the number of paused clients
    /// # Documentation
    /// view the docs for [CLIENT UNPAUSE](https://redis.io/commands/client-unpause)
    public func client_unpause<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLIENT").arg("UNPAUSE").query(self)
    }
    /// Enable or disable server assisted client side caching support
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1). Some options may introduce additional complexity.
    /// # Documentation
    /// view the docs for [CLIENT TRACKING](https://redis.io/commands/client-tracking)
    public func client_tracking<T: FromRedisValue>(
        status: ClientTrackingStatus, clientId: Int? = nil, prefix: String..., options: ClientTrackingOptions? = nil
    ) async throws -> T {
        try await Cmd("CLIENT").arg("TRACKING").arg(status.to_redis_args()).arg((clientId != nil) ? "REDIRECT" : nil)
            .arg(clientId.to_redis_args()).arg((!prefix.isEmpty) ? "PREFIX" : nil).arg(prefix.to_redis_args()).arg(
                options.to_redis_args()
            ).query(self)
    }
    public enum ClientTrackingStatus: ToRedisArgs {
        case ON
        case OFF
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ON: out.append("ON".data(using: .utf8)!)
            case .OFF: out.append("OFF".data(using: .utf8)!)
            }
        }
    }
    public struct ClientTrackingOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let BCAST = ClientTrackingOptions(rawValue: 1 << 0)
        static let OPTIN = ClientTrackingOptions(rawValue: 1 << 1)
        static let OPTOUT = ClientTrackingOptions(rawValue: 1 << 2)
        static let NOLOOP = ClientTrackingOptions(rawValue: 1 << 3)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.BCAST) { out.append("BCAST".data(using: .utf8)!) }
            if self.contains(.OPTIN) { out.append("OPTIN".data(using: .utf8)!) }
            if self.contains(.OPTOUT) { out.append("OPTOUT".data(using: .utf8)!) }
            if self.contains(.NOLOOP) { out.append("NOLOOP".data(using: .utf8)!) }
        }
    }
}
