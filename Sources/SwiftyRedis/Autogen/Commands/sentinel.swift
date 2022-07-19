//
//  sentinel.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Shows the state of a master
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL MASTER](https://redis.io/commands/sentinel-master)
    public func sentinel_master<T: FromRedisValue>(_ masterName: String) async throws -> T {
        try await Cmd("SENTINEL").arg("MASTER").arg(masterName.to_redis_args()).query(self)
    }
    /// Simulate failover scenarios
    /// # Available since
    /// 3.2.0
    /// # Documentation
    /// view the docs for [SENTINEL SIMULATE_FAILURE](https://redis.io/commands/sentinel-simulate-failure)
    public func sentinel_simulate_failure<T: FromRedisValue>(_ mode: SentinelSimulateFailureMode?...) async throws -> T
    { try await Cmd("SENTINEL").arg("SIMULATE_FAILURE").arg(mode.to_redis_args()).query(self) }
    public enum SentinelSimulateFailureMode: ToRedisArgs {
        case CRASH_AFTER_ELECTION
        case CRASH_AFTER_PROMOTION
        case HELP
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .CRASH_AFTER_ELECTION: out.append("None".data(using: .utf8)!)
            case .CRASH_AFTER_PROMOTION: out.append("None".data(using: .utf8)!)
            case .HELP: out.append("None".data(using: .utf8)!)
            }
        }
    }
    /// Force a failover
    /// # Available since
    /// 2.8.4
    /// # Documentation
    /// view the docs for [SENTINEL FAILOVER](https://redis.io/commands/sentinel-failover)
    public func sentinel_failover<T: FromRedisValue>(_ masterName: String) async throws -> T {
        try await Cmd("SENTINEL").arg("FAILOVER").arg(masterName.to_redis_args()).query(self)
    }
    /// List the monitored replicas
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(N) where N is the number of replicas
    /// # Documentation
    /// view the docs for [SENTINEL REPLICAS](https://redis.io/commands/sentinel-replicas)
    public func sentinel_replicas<T: FromRedisValue>(_ masterName: String) async throws -> T {
        try await Cmd("SENTINEL").arg("REPLICAS").arg(masterName.to_redis_args()).query(self)
    }
    /// List the monitored masters
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(N) where N is the number of masters
    /// # Documentation
    /// view the docs for [SENTINEL MASTERS](https://redis.io/commands/sentinel-masters)
    public func sentinel_masters<T: FromRedisValue>() async throws -> T {
        try await Cmd("SENTINEL").arg("MASTERS").query(self)
    }
    /// Get the Sentinel instance ID
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL MYID](https://redis.io/commands/sentinel-myid)
    public func sentinel_myid<T: FromRedisValue>() async throws -> T {
        try await Cmd("SENTINEL").arg("MYID").query(self)
    }
    /// Get information about pending scripts
    /// # Available since
    /// 2.8.4
    /// # Documentation
    /// view the docs for [SENTINEL PENDING_SCRIPTS](https://redis.io/commands/sentinel-pending-scripts)
    public func sentinel_pending_scripts<T: FromRedisValue>() async throws -> T {
        try await Cmd("SENTINEL").arg("PENDING_SCRIPTS").query(self)
    }
    /// List or update the current configurable parameters
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of configurable parameters
    /// # Documentation
    /// view the docs for [SENTINEL DEBUG](https://redis.io/commands/sentinel-debug)
    public func sentinel_debug<T: FromRedisValue>(_ parameterValue: SentinelDebugParametervalue...) async throws -> T {
        try await Cmd("SENTINEL").arg("DEBUG").arg(parameterValue.to_redis_args()).query(self)
    }
    public struct SentinelDebugParametervalue: ToRedisArgs {
        let parameter: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            parameter.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
    /// Get cached INFO from the instances in the deployment
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(N) where N is the number of instances
    /// # Documentation
    /// view the docs for [SENTINEL INFO_CACHE](https://redis.io/commands/sentinel-info-cache)
    public func sentinel_info_cache<T: FromRedisValue>(_ nodename: String...) async throws -> T {
        try await Cmd("SENTINEL").arg("INFO_CACHE").arg(nodename.to_redis_args()).query(self)
    }
    /// Stop monitoring
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL REMOVE](https://redis.io/commands/sentinel-remove)
    public func sentinel_remove<T: FromRedisValue>(_ masterName: String) async throws -> T {
        try await Cmd("SENTINEL").arg("REMOVE").arg(masterName.to_redis_args()).query(self)
    }
    /// Check if a master is down
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL IS_MASTER_DOWN_BY_ADDR](https://redis.io/commands/sentinel-is-master-down-by-addr)
    public func sentinel_is_master_down_by_addr<T: FromRedisValue>(
        _ ip: String, _ port: Int, _ currentEpoch: Int, _ runid: String
    ) async throws -> T {
        try await Cmd("SENTINEL").arg("IS_MASTER_DOWN_BY_ADDR").arg(ip.to_redis_args()).arg(port.to_redis_args()).arg(
            currentEpoch.to_redis_args()
        ).arg(runid.to_redis_args()).query(self)
    }
    /// Rewrite configuration file
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL FLUSHCONFIG](https://redis.io/commands/sentinel-flushconfig)
    public func sentinel_flushconfig<T: FromRedisValue>() async throws -> T {
        try await Cmd("SENTINEL").arg("FLUSHCONFIG").query(self)
    }
    /// Get port and address of a master
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL GET_MASTER_ADDR_BY_NAME](https://redis.io/commands/sentinel-get-master-addr-by-name)
    public func sentinel_get_master_addr_by_name<T: FromRedisValue>(_ masterName: String) async throws -> T {
        try await Cmd("SENTINEL").arg("GET_MASTER_ADDR_BY_NAME").arg(masterName.to_redis_args()).query(self)
    }
    /// Configure Sentinel
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL CONFIG](https://redis.io/commands/sentinel-config)
    public func sentinel_config<T: FromRedisValue>(_ setOrGet: SentinelConfigSetorget) async throws -> T {
        try await Cmd("SENTINEL").arg("CONFIG").arg(setOrGet.to_redis_args()).query(self)
    }
    public enum SentinelConfigSetorget: ToRedisArgs {
        case SET(Setparamvalue)
        case GET(String)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .SET(let setparamvalue):
                out.append("SET".data(using: .utf8)!)
                setparamvalue.write_redis_args(out: &out)
            case .GET(let string):
                out.append("GET".data(using: .utf8)!)
                string.write_redis_args(out: &out)
            }
        }
        public struct Setparamvalue: ToRedisArgs {
            let parameter: String
            let value: String
            public func write_redis_args(out: inout [Data]) {
                parameter.write_redis_args(out: &out)
                value.write_redis_args(out: &out)
            }
        }
    }
    /// List the Sentinel instances
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(N) where N is the number of Sentinels
    /// # Documentation
    /// view the docs for [SENTINEL SENTINELS](https://redis.io/commands/sentinel-sentinels)
    public func sentinel_sentinels<T: FromRedisValue>(_ masterName: String) async throws -> T {
        try await Cmd("SENTINEL").arg("SENTINELS").arg(masterName.to_redis_args()).query(self)
    }
    /// Check for a Sentinel quorum
    /// # Available since
    /// 2.8.4
    /// # Documentation
    /// view the docs for [SENTINEL CKQUORUM](https://redis.io/commands/sentinel-ckquorum)
    public func sentinel_ckquorum<T: FromRedisValue>(_ masterName: String) async throws -> T {
        try await Cmd("SENTINEL").arg("CKQUORUM").arg(masterName.to_redis_args()).query(self)
    }
    /// Start monitoring
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL MONITOR](https://redis.io/commands/sentinel-monitor)
    public func sentinel_monitor<T: FromRedisValue>(_ name: String, _ ip: String, _ port: Int, _ quorum: Int)
        async throws -> T
    {
        try await Cmd("SENTINEL").arg("MONITOR").arg(name.to_redis_args()).arg(ip.to_redis_args()).arg(
            port.to_redis_args()
        ).arg(quorum.to_redis_args()).query(self)
    }
    /// List the monitored slaves
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(N) where N is the number of slaves
    /// # Documentation
    /// view the docs for [SENTINEL SLAVES](https://redis.io/commands/sentinel-slaves)
    public func sentinel_slaves<T: FromRedisValue>(_ masterName: String) async throws -> T {
        try await Cmd("SENTINEL").arg("SLAVES").arg(masterName.to_redis_args()).query(self)
    }
    /// Reset masters by name pattern
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(N) where N is the number of monitored masters
    /// # Documentation
    /// view the docs for [SENTINEL RESET](https://redis.io/commands/sentinel-reset)
    public func sentinel_reset<T: FromRedisValue>(_ pattern: String) async throws -> T {
        try await Cmd("SENTINEL").arg("RESET").arg(pattern.to_redis_args()).query(self)
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL HELP](https://redis.io/commands/sentinel-help)
    public func sentinel_help<T: FromRedisValue>() async throws -> T {
        try await Cmd("SENTINEL").arg("HELP").query(self)
    }
    /// Change the configuration of a monitored master
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SENTINEL SET](https://redis.io/commands/sentinel-set)
    public func sentinel_set<T: FromRedisValue>(_ masterName: String, _ optionValue: SentinelSetOptionvalue...)
        async throws -> T
    {
        try await Cmd("SENTINEL").arg("SET").arg(masterName.to_redis_args()).arg(optionValue.to_redis_args()).query(
            self)
    }
    public struct SentinelSetOptionvalue: ToRedisArgs {
        let option: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            option.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
}
