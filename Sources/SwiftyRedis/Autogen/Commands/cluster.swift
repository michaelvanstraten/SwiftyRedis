//
//  cluster.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// Return the node id
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER MYID](https://redis.io/commands/cluster-myid)
    public func cluster_myid<T: FromRedisValue>() async throws -> T { try await Cmd("CLUSTER").arg("MYID").query(self) }
    /// Assign new hash slots to receiving node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(N) where N is the total number of hash slot arguments
    /// # Documentation
    /// view the docs for [CLUSTER ADDSLOTS](https://redis.io/commands/cluster-addslots)
    public func cluster_addslots<T: FromRedisValue>(_ slot: Int...) async throws -> T {
        try await Cmd("CLUSTER").arg("ADDSLOTS").arg(slot.to_redis_args()).query(self)
    }
    /// Returns the hash slot of the specified key
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(N) where N is the number of bytes in the key
    /// # Documentation
    /// view the docs for [CLUSTER KEYSLOT](https://redis.io/commands/cluster-keyslot)
    public func cluster_keyslot<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("CLUSTER").arg("KEYSLOT").arg(key.to_redis_args()).query(self)
    }
    /// Remove a node from the nodes table
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER FORGET](https://redis.io/commands/cluster-forget)
    public func cluster_forget<T: FromRedisValue>(_ nodeId: String) async throws -> T {
        try await Cmd("CLUSTER").arg("FORGET").arg(nodeId.to_redis_args()).query(self)
    }
    /// Force a node cluster to handshake with another node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 4.0.0, Added the optional `cluster_bus_port` argument.
    /// # Documentation
    /// view the docs for [CLUSTER MEET](https://redis.io/commands/cluster-meet)
    public func cluster_meet<T: FromRedisValue>(_ ip: String, _ port: Int, _ clusterBusPort: Int? = nil) async throws
        -> T
    {
        try await Cmd("CLUSTER").arg("MEET").arg(ip.to_redis_args()).arg(port.to_redis_args()).arg(
            clusterBusPort.to_redis_args()
        ).query(self)
    }
    /// Get array of Cluster slot to node mappings
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(N) where N is the total number of Cluster nodes
    /// # History
    /// - 4.0.0, Added node IDs.
    /// - 7.0.0, Added additional networking metadata field.
    /// # Documentation
    /// view the docs for [CLUSTER SLOTS](https://redis.io/commands/cluster-slots)
    public func cluster_slots<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLUSTER").arg("SLOTS").query(self)
    }
    /// Reconfigure a node as a replica of the specified master node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER REPLICATE](https://redis.io/commands/cluster-replicate)
    public func cluster_replicate<T: FromRedisValue>(_ nodeId: String) async throws -> T {
        try await Cmd("CLUSTER").arg("REPLICATE").arg(nodeId.to_redis_args()).query(self)
    }
    /// Returns a list of all TCP links to and from peer nodes in cluster
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the total number of Cluster nodes
    /// # Documentation
    /// view the docs for [CLUSTER LINKS](https://redis.io/commands/cluster-links)
    public func cluster_links<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLUSTER").arg("LINKS").query(self)
    }
    /// Set hash slots as unbound in receiving node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(N) where N is the total number of hash slot arguments
    /// # Documentation
    /// view the docs for [CLUSTER DELSLOTS](https://redis.io/commands/cluster-delslots)
    public func cluster_delslots<T: FromRedisValue>(_ slot: Int...) async throws -> T {
        try await Cmd("CLUSTER").arg("DELSLOTS").arg(slot.to_redis_args()).query(self)
    }
    /// Return the number of local keys in the specified hash slot
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER COUNTKEYSINSLOT](https://redis.io/commands/cluster-countkeysinslot)
    public func cluster_countkeysinslot<T: FromRedisValue>(_ slot: Int) async throws -> T {
        try await Cmd("CLUSTER").arg("COUNTKEYSINSLOT").arg(slot.to_redis_args()).query(self)
    }
    /// Get array of cluster slots to node mappings
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the total number of cluster nodes
    /// # Documentation
    /// view the docs for [CLUSTER SHARDS](https://redis.io/commands/cluster-shards)
    public func cluster_shards<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLUSTER").arg("SHARDS").query(self)
    }
    /// Advance the cluster config epoch
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER BUMPEPOCH](https://redis.io/commands/cluster-bumpepoch)
    public func cluster_bumpepoch<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLUSTER").arg("BUMPEPOCH").query(self)
    }
    /// Return the number of failure reports active for a given node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(N) where N is the number of failure reports
    /// # Documentation
    /// view the docs for [CLUSTER COUNT_FAILURE_REPORTS](https://redis.io/commands/cluster-count-failure-reports)
    public func cluster_count_failure_reports<T: FromRedisValue>(_ nodeId: String) async throws -> T {
        try await Cmd("CLUSTER").arg("COUNT_FAILURE_REPORTS").arg(nodeId.to_redis_args()).query(self)
    }
    /// List replica nodes of the specified master node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER SLAVES](https://redis.io/commands/cluster-slaves)
    public func cluster_slaves<T: FromRedisValue>(_ nodeId: String) async throws -> T {
        try await Cmd("CLUSTER").arg("SLAVES").arg(nodeId.to_redis_args()).query(self)
    }
    /// Assign new hash slots to receiving node
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the total number of the slots between the start slot and end slot arguments.
    /// # Documentation
    /// view the docs for [CLUSTER ADDSLOTSRANGE](https://redis.io/commands/cluster-addslotsrange)
    public func cluster_addslotsrange<T: FromRedisValue>(_ startSlotEndSlot: ClusterAddslotsrangeStartslotendslot...)
        async throws -> T
    { try await Cmd("CLUSTER").arg("ADDSLOTSRANGE").arg(startSlotEndSlot.to_redis_args()).query(self) }
    public struct ClusterAddslotsrangeStartslotendslot: ToRedisArgs {
        let startSlot: Int
        let endSlot: Int
        public func write_redis_args(out: inout [Data]) {
            startSlot.write_redis_args(out: &out)
            endSlot.write_redis_args(out: &out)
        }
    }
    /// Provides info about Redis Cluster node state
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER INFO](https://redis.io/commands/cluster-info)
    public func cluster_info<T: FromRedisValue>() async throws -> T { try await Cmd("CLUSTER").arg("INFO").query(self) }
    /// Return local key names in the specified hash slot
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(log(N)) where N is the number of requested keys
    /// # Documentation
    /// view the docs for [CLUSTER GETKEYSINSLOT](https://redis.io/commands/cluster-getkeysinslot)
    public func cluster_getkeysinslot<T: FromRedisValue>(_ slot: Int, _ count: Int) async throws -> T {
        try await Cmd("CLUSTER").arg("GETKEYSINSLOT").arg(slot.to_redis_args()).arg(count.to_redis_args()).query(self)
    }
    /// Bind a hash slot to a specific node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER SETSLOT](https://redis.io/commands/cluster-setslot)
    public func cluster_setslot<T: FromRedisValue>(_ slot: Int, _ subcommand: ClusterSetslotSubcommand) async throws
        -> T
    { try await Cmd("CLUSTER").arg("SETSLOT").arg(slot.to_redis_args()).arg(subcommand.to_redis_args()).query(self) }
    public enum ClusterSetslotSubcommand: ToRedisArgs {
        case IMPORTING(String)
        case MIGRATING(String)
        case NODE(String)
        case STABLE
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .IMPORTING(let string):
                out.append("IMPORTING".data(using: .utf8)!)
                string.write_redis_args(out: &out)
            case .MIGRATING(let string):
                out.append("MIGRATING".data(using: .utf8)!)
                string.write_redis_args(out: &out)
            case .NODE(let string):
                out.append("NODE".data(using: .utf8)!)
                string.write_redis_args(out: &out)
            case .STABLE: out.append("STABLE".data(using: .utf8)!)
            }
        }
    }
    /// Set hash slots as unbound in receiving node
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the total number of the slots between the start slot and end slot arguments.
    /// # Documentation
    /// view the docs for [CLUSTER DELSLOTSRANGE](https://redis.io/commands/cluster-delslotsrange)
    public func cluster_delslotsrange<T: FromRedisValue>(_ startSlotEndSlot: ClusterDelslotsrangeStartslotendslot...)
        async throws -> T
    { try await Cmd("CLUSTER").arg("DELSLOTSRANGE").arg(startSlotEndSlot.to_redis_args()).query(self) }
    public struct ClusterDelslotsrangeStartslotendslot: ToRedisArgs {
        let startSlot: Int
        let endSlot: Int
        public func write_redis_args(out: inout [Data]) {
            startSlot.write_redis_args(out: &out)
            endSlot.write_redis_args(out: &out)
        }
    }
    /// Show helpful text about the different subcommands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER HELP](https://redis.io/commands/cluster-help)
    public func cluster_help<T: FromRedisValue>() async throws -> T { try await Cmd("CLUSTER").arg("HELP").query(self) }
    /// Forces a replica to perform a manual failover of its master.
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER FAILOVER](https://redis.io/commands/cluster-failover)
    public func cluster_failover<T: FromRedisValue>(_ options: ClusterFailoverOptions? = nil) async throws -> T {
        try await Cmd("CLUSTER").arg("FAILOVER").arg(options.to_redis_args()).query(self)
    }
    public enum ClusterFailoverOptions: ToRedisArgs {
        case FORCE
        case TAKEOVER
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .FORCE: out.append("FORCE".data(using: .utf8)!)
            case .TAKEOVER: out.append("TAKEOVER".data(using: .utf8)!)
            }
        }
    }
    /// Forces the node to save cluster state on disk
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER SAVECONFIG](https://redis.io/commands/cluster-saveconfig)
    public func cluster_saveconfig<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLUSTER").arg("SAVECONFIG").query(self)
    }
    /// Delete a node's own slots information
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER FLUSHSLOTS](https://redis.io/commands/cluster-flushslots)
    public func cluster_flushslots<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLUSTER").arg("FLUSHSLOTS").query(self)
    }
    /// Set the configuration epoch in a new node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER SET_CONFIG_EPOCH](https://redis.io/commands/cluster-set-config-epoch)
    public func cluster_set_config_epoch<T: FromRedisValue>(_ configEpoch: Int) async throws -> T {
        try await Cmd("CLUSTER").arg("SET_CONFIG_EPOCH").arg(configEpoch.to_redis_args()).query(self)
    }
    /// List replica nodes of the specified master node
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [CLUSTER REPLICAS](https://redis.io/commands/cluster-replicas)
    public func cluster_replicas<T: FromRedisValue>(_ nodeId: String) async throws -> T {
        try await Cmd("CLUSTER").arg("REPLICAS").arg(nodeId.to_redis_args()).query(self)
    }
    /// Reset a Redis Cluster node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(N) where N is the number of known nodes. The command may execute a FLUSHALL as a side effect.
    /// # Documentation
    /// view the docs for [CLUSTER RESET](https://redis.io/commands/cluster-reset)
    public func cluster_reset<T: FromRedisValue>(_ hardSoft: ClusterResetHardsoft? = nil) async throws -> T {
        try await Cmd("CLUSTER").arg("RESET").arg(hardSoft.to_redis_args()).query(self)
    }
    public enum ClusterResetHardsoft: ToRedisArgs {
        case HARD
        case SOFT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .HARD: out.append("HARD".data(using: .utf8)!)
            case .SOFT: out.append("SOFT".data(using: .utf8)!)
            }
        }
    }
    /// Get Cluster config for the node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(N) where N is the total number of Cluster nodes
    /// # Documentation
    /// view the docs for [CLUSTER NODES](https://redis.io/commands/cluster-nodes)
    public func cluster_nodes<T: FromRedisValue>() async throws -> T {
        try await Cmd("CLUSTER").arg("NODES").query(self)
    }
}
