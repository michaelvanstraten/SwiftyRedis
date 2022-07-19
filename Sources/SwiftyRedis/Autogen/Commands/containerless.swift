//
//  containerless.swift
//
//
//  Created by Autogen on 20.07.22.
//
import Foundation
extension RedisConnection {
    /// A container for Access List Control commands
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [ACL](https://redis.io/commands/acl)
    public func acl<T: FromRedisValue>() async throws -> T { try await Cmd("ACL").query(self) }
    /// Append a value to a key
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1). The amortized time complexity is O(1) assuming the appended value is small and the already present value is of any size, since the dynamic string library used by Redis will double the free space available on every reallocation.
    /// # Documentation
    /// view the docs for [APPEND](https://redis.io/commands/append)
    public func append<T: FromRedisValue>(_ key: String, _ value: String) async throws -> T {
        try await Cmd("APPEND").arg(key.to_redis_args()).arg(value.to_redis_args()).query(self)
    }
    /// Sent by cluster clients after an -ASK redirect
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [ASKING](https://redis.io/commands/asking)
    public func asking<T: FromRedisValue>() async throws -> T { try await Cmd("ASKING").query(self) }
    /// Authenticate to the server
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of passwords defined for the user
    /// # History
    /// - 6.0.0, Added ACL style (username and password).
    /// # Documentation
    /// view the docs for [AUTH](https://redis.io/commands/auth)
    public func auth<T: FromRedisValue>(_ username: String? = nil, password: String) async throws -> T {
        try await Cmd("AUTH").arg(username.to_redis_args()).arg(password.to_redis_args()).query(self)
    }
    /// Asynchronously rewrite the append-only file
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [BGREWRITEAOF](https://redis.io/commands/bgrewriteaof)
    public func bgrewriteaof<T: FromRedisValue>() async throws -> T { try await Cmd("BGREWRITEAOF").query(self) }
    /// Asynchronously save the dataset to disk
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 3.2.2, Added the `SCHEDULE` option.
    /// # Documentation
    /// view the docs for [BGSAVE](https://redis.io/commands/bgsave)
    public func bgsave<T: FromRedisValue>(_ options: BgsaveOptions? = nil) async throws -> T {
        try await Cmd("BGSAVE").arg(options.to_redis_args()).query(self)
    }
    public struct BgsaveOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let SCHEDULE = BgsaveOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.SCHEDULE) { out.append("SCHEDULE".data(using: .utf8)!) }
        }
    }
    /// Count set bits in a string
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(N)
    /// # History
    /// - 7.0.0, Added the `BYTE|BIT` option.
    /// # Documentation
    /// view the docs for [BITCOUNT](https://redis.io/commands/bitcount)
    public func bitcount<T: FromRedisValue>(_ key: String, _ index: BitcountIndex? = nil) async throws -> T {
        try await Cmd("BITCOUNT").arg(key.to_redis_args()).arg(index.to_redis_args()).query(self)
    }
    public struct BitcountIndex: ToRedisArgs {
        let start: Int
        let end: Int
        let indexUnit: Indexunit
        public func write_redis_args(out: inout [Data]) {
            start.write_redis_args(out: &out)
            end.write_redis_args(out: &out)
            indexUnit.write_redis_args(out: &out)
        }
        public enum Indexunit: ToRedisArgs {
            case BYTE
            case BIT
            public func write_redis_args(out: inout [Data]) {
                switch self {
                case .BYTE: out.append("BYTE".data(using: .utf8)!)
                case .BIT: out.append("BIT".data(using: .utf8)!)
                }
            }
        }
    }
    /// Perform arbitrary bitfield integer operations on strings
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(1) for each subcommand specified
    /// # Documentation
    /// view the docs for [BITFIELD](https://redis.io/commands/bitfield)
    public func bitfield<T: FromRedisValue>(_ key: String, _ operation: BitfieldOperation...) async throws -> T {
        try await Cmd("BITFIELD").arg(key.to_redis_args()).arg(operation.to_redis_args()).query(self)
    }
    public enum BitfieldOperation: ToRedisArgs {
        case GET(Encodingoffset)
        case WRITE(Write)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .GET(let encodingoffset):
                out.append("GET".data(using: .utf8)!)
                encodingoffset.write_redis_args(out: &out)
            case .WRITE(let write): write.write_redis_args(out: &out)
            }
        }
        public struct Encodingoffset: ToRedisArgs {
            let encoding: String
            let offset: Int
            public func write_redis_args(out: inout [Data]) {
                encoding.write_redis_args(out: &out)
                offset.write_redis_args(out: &out)
            }
        }
        public struct Write: ToRedisArgs {
            let wrapSatFail: Wrapsatfail
            let writeOperation: Writeoperation
            public func write_redis_args(out: inout [Data]) {
                out.append("OVERFLOW".data(using: .utf8)!)
                wrapSatFail.write_redis_args(out: &out)
                writeOperation.write_redis_args(out: &out)
            }
            public enum Wrapsatfail: ToRedisArgs {
                case WRAP
                case SAT
                case FAIL
                public func write_redis_args(out: inout [Data]) {
                    switch self {
                    case .WRAP: out.append("WRAP".data(using: .utf8)!)
                    case .SAT: out.append("SAT".data(using: .utf8)!)
                    case .FAIL: out.append("FAIL".data(using: .utf8)!)
                    }
                }
            }
            public enum Writeoperation: ToRedisArgs {
                case SET(Encodingoffsetvalue)
                case INCRBY(Encodingoffsetincrement)
                public func write_redis_args(out: inout [Data]) {
                    switch self {
                    case .SET(let encodingoffsetvalue):
                        out.append("SET".data(using: .utf8)!)
                        encodingoffsetvalue.write_redis_args(out: &out)
                    case .INCRBY(let encodingoffsetincrement):
                        out.append("INCRBY".data(using: .utf8)!)
                        encodingoffsetincrement.write_redis_args(out: &out)
                    }
                }
                public struct Encodingoffsetvalue: ToRedisArgs {
                    let encoding: String
                    let offset: Int
                    let value: Int
                    public func write_redis_args(out: inout [Data]) {
                        encoding.write_redis_args(out: &out)
                        offset.write_redis_args(out: &out)
                        value.write_redis_args(out: &out)
                    }
                }
                public struct Encodingoffsetincrement: ToRedisArgs {
                    let encoding: String
                    let offset: Int
                    let increment: Int
                    public func write_redis_args(out: inout [Data]) {
                        encoding.write_redis_args(out: &out)
                        offset.write_redis_args(out: &out)
                        increment.write_redis_args(out: &out)
                    }
                }
            }
        }
    }
    /// Perform arbitrary bitfield integer operations on strings. Read-only variant of BITFIELD
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1) for each subcommand specified
    /// # Documentation
    /// view the docs for [BITFIELD_RO](https://redis.io/commands/bitfield-ro)
    public func bitfield_ro<T: FromRedisValue>(_ key: String, _ encodingOffset: BitfieldRoEncodingoffset...)
        async throws -> T
    { try await Cmd("BITFIELD_RO").arg(key.to_redis_args()).arg(encodingOffset.to_redis_args()).query(self) }
    public struct BitfieldRoEncodingoffset: ToRedisArgs {
        let encoding: String
        let offset: Int
        public func write_redis_args(out: inout [Data]) {
            encoding.write_redis_args(out: &out)
            offset.write_redis_args(out: &out)
        }
    }
    /// Perform bitwise operations between strings
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(N)
    /// # Documentation
    /// view the docs for [BITOP](https://redis.io/commands/bitop)
    public func bitop<T: FromRedisValue>(_ operation: String, _ destkey: String, _ key: String...) async throws -> T {
        try await Cmd("BITOP").arg(operation.to_redis_args()).arg(destkey.to_redis_args()).arg(key.to_redis_args())
            .query(self)
    }
    /// Find first bit set or clear in a string
    /// # Available since
    /// 2.8.7
    /// # Time complexity
    /// O(N)
    /// # History
    /// - 7.0.0, Added the `BYTE|BIT` option.
    /// # Documentation
    /// view the docs for [BITPOS](https://redis.io/commands/bitpos)
    public func bitpos<T: FromRedisValue>(_ key: String, _ bit: Int, _ index: BitposIndex? = nil) async throws -> T {
        try await Cmd("BITPOS").arg(key.to_redis_args()).arg(bit.to_redis_args()).arg(index.to_redis_args()).query(self)
    }
    public struct BitposIndex: ToRedisArgs {
        let start: Int
        let endIndex: Endindex
        public func write_redis_args(out: inout [Data]) {
            start.write_redis_args(out: &out)
            endIndex.write_redis_args(out: &out)
        }
        public struct Endindex: ToRedisArgs {
            let end: Int
            let indexUnit: Indexunit
            public func write_redis_args(out: inout [Data]) {
                end.write_redis_args(out: &out)
                indexUnit.write_redis_args(out: &out)
            }
            public enum Indexunit: ToRedisArgs {
                case BYTE
                case BIT
                public func write_redis_args(out: inout [Data]) {
                    switch self {
                    case .BYTE: out.append("BYTE".data(using: .utf8)!)
                    case .BIT: out.append("BIT".data(using: .utf8)!)
                    }
                }
            }
        }
    }
    /// Pop an element from a list, push it to another list and return it; or block until one is available
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [BLMOVE](https://redis.io/commands/blmove)
    public func blmove<T: FromRedisValue>(
        _ source: String, _ destination: String, _ wherefrom: BlmoveWherefrom, _ whereto: BlmoveWhereto,
        _ timeout: Double
    ) async throws -> T {
        try await Cmd("BLMOVE").arg(source.to_redis_args()).arg(destination.to_redis_args()).arg(
            wherefrom.to_redis_args()
        ).arg(whereto.to_redis_args()).arg(timeout.to_redis_args()).query(self)
    }
    public enum BlmoveWherefrom: ToRedisArgs {
        case LEFT
        case RIGHT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .LEFT: out.append("LEFT".data(using: .utf8)!)
            case .RIGHT: out.append("RIGHT".data(using: .utf8)!)
            }
        }
    }
    public enum BlmoveWhereto: ToRedisArgs {
        case LEFT
        case RIGHT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .LEFT: out.append("LEFT".data(using: .utf8)!)
            case .RIGHT: out.append("RIGHT".data(using: .utf8)!)
            }
        }
    }
    /// Pop elements from a list, or block until one is available
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N+M) where N is the number of provided keys and M is the number of elements returned.
    /// # Documentation
    /// view the docs for [BLMPOP](https://redis.io/commands/blmpop)
    public func blmpop<T: FromRedisValue>(
        _ timeout: Double, _ numkeys: Int, _ sdfsdf: BlmpopSdfsdf, _ count: Int? = nil, key: String...
    ) async throws -> T {
        try await Cmd("BLMPOP").arg(timeout.to_redis_args()).arg(numkeys.to_redis_args()).arg(sdfsdf.to_redis_args())
            .arg(count.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    public enum BlmpopSdfsdf: ToRedisArgs {
        case LEFT
        case RIGHT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .LEFT: out.append("LEFT".data(using: .utf8)!)
            case .RIGHT: out.append("RIGHT".data(using: .utf8)!)
            }
        }
    }
    /// Remove and get the first element in a list, or block until one is available
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the number of provided keys.
    /// # History
    /// - 6.0.0, `timeout` is interpreted as a double instead of an integer.
    /// # Documentation
    /// view the docs for [BLPOP](https://redis.io/commands/blpop)
    public func blpop<T: FromRedisValue>(_ timeout: Double, _ key: String...) async throws -> T {
        try await Cmd("BLPOP").arg(timeout.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    /// Remove and get the last element in a list, or block until one is available
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the number of provided keys.
    /// # History
    /// - 6.0.0, `timeout` is interpreted as a double instead of an integer.
    /// # Documentation
    /// view the docs for [BRPOP](https://redis.io/commands/brpop)
    public func brpop<T: FromRedisValue>(_ timeout: Double, _ key: String...) async throws -> T {
        try await Cmd("BRPOP").arg(timeout.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    /// Pop an element from a list, push it to another list and return it; or block until one is available
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 6.0.0, `timeout` is interpreted as a double instead of an integer.
    /// # Documentation
    /// view the docs for [BRPOPLPUSH](https://redis.io/commands/brpoplpush)
    public func brpoplpush<T: FromRedisValue>(_ source: String, _ destination: String, _ timeout: Double) async throws
        -> T
    {
        try await Cmd("BRPOPLPUSH").arg(source.to_redis_args()).arg(destination.to_redis_args()).arg(
            timeout.to_redis_args()
        ).query(self)
    }
    /// Remove and return members with scores in a sorted set or block until one is available
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(K) + O(N*log(M)) where K is the number of provided keys, N being the number of elements in the sorted set, and M being the number of elements popped.
    /// # Documentation
    /// view the docs for [BZMPOP](https://redis.io/commands/bzmpop)
    public func bzmpop<T: FromRedisValue>(
        _ timeout: Double, _ numkeys: Int, _ sdfsdf: BzmpopSdfsdf, _ count: Int? = nil, key: String...
    ) async throws -> T {
        try await Cmd("BZMPOP").arg(timeout.to_redis_args()).arg(numkeys.to_redis_args()).arg(sdfsdf.to_redis_args())
            .arg(count.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    public enum BzmpopSdfsdf: ToRedisArgs {
        case MIN
        case MAX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .MIN: out.append("MIN".data(using: .utf8)!)
            case .MAX: out.append("MAX".data(using: .utf8)!)
            }
        }
    }
    /// Remove and return the member with the highest score from one or more sorted sets, or block until one is available
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(log(N)) with N being the number of elements in the sorted set.
    /// # History
    /// - 6.0.0, `timeout` is interpreted as a double instead of an integer.
    /// # Documentation
    /// view the docs for [BZPOPMAX](https://redis.io/commands/bzpopmax)
    public func bzpopmax<T: FromRedisValue>(_ timeout: Double, _ key: String...) async throws -> T {
        try await Cmd("BZPOPMAX").arg(timeout.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    /// Remove and return the member with the lowest score from one or more sorted sets, or block until one is available
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(log(N)) with N being the number of elements in the sorted set.
    /// # History
    /// - 6.0.0, `timeout` is interpreted as a double instead of an integer.
    /// # Documentation
    /// view the docs for [BZPOPMIN](https://redis.io/commands/bzpopmin)
    public func bzpopmin<T: FromRedisValue>(_ timeout: Double, _ key: String...) async throws -> T {
        try await Cmd("BZPOPMIN").arg(timeout.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    /// A container for client connection commands
    /// # Available since
    /// 2.4.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [CLIENT](https://redis.io/commands/client)
    public func client<T: FromRedisValue>() async throws -> T { try await Cmd("CLIENT").query(self) }
    /// A container for cluster commands
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [CLUSTER](https://redis.io/commands/cluster)
    public func cluster<T: FromRedisValue>() async throws -> T { try await Cmd("CLUSTER").query(self) }
    /// Get array of Redis command details
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// O(N) where N is the total number of Redis commands
    /// # Documentation
    /// view the docs for [COMMAND](https://redis.io/commands/command)
    public func command<T: FromRedisValue>() async throws -> T { try await Cmd("COMMAND").query(self) }
    /// A container for server configuration commands
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [CONFIG](https://redis.io/commands/config)
    public func config<T: FromRedisValue>() async throws -> T { try await Cmd("CONFIG").query(self) }
    /// Copy a key
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N) worst case for collections, where N is the number of nested items. O(1) for string values.
    /// # Documentation
    /// view the docs for [COPY](https://redis.io/commands/copy)
    public func copy<T: FromRedisValue>(
        _ source: String, _ destination: String, _ destinationDb: Int? = nil, options: CopyOptions? = nil
    ) async throws -> T {
        try await Cmd("COPY").arg(source.to_redis_args()).arg(destination.to_redis_args()).arg(
            destinationDb.to_redis_args()
        ).arg(options.to_redis_args()).query(self)
    }
    public struct CopyOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let REPLACE = CopyOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.REPLACE) { out.append("REPLACE".data(using: .utf8)!) }
        }
    }
    /// Return the number of keys in the selected database
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [DBSIZE](https://redis.io/commands/dbsize)
    public func dbsize<T: FromRedisValue>() async throws -> T { try await Cmd("DBSIZE").query(self) }
    /// A container for debugging commands
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [DEBUG](https://redis.io/commands/debug)
    public func debug<T: FromRedisValue>() async throws -> T { try await Cmd("DEBUG").query(self) }
    /// Decrement the integer value of a key by one
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [DECR](https://redis.io/commands/decr)
    public func decr<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("DECR").arg(key.to_redis_args()).query(self)
    }
    /// Decrement the integer value of a key by the given number
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [DECRBY](https://redis.io/commands/decrby)
    public func decrby<T: FromRedisValue>(_ key: String, _ decrement: Int) async throws -> T {
        try await Cmd("DECRBY").arg(key.to_redis_args()).arg(decrement.to_redis_args()).query(self)
    }
    /// Delete a key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of keys that will be removed. When a key to remove holds a value other than a string, the individual complexity for this key is O(M) where M is the number of elements in the list, set, sorted set or hash. Removing a single key that holds a string value is O(1).
    /// # Documentation
    /// view the docs for [DEL](https://redis.io/commands/del)
    public func del<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("DEL").arg(key.to_redis_args()).query(self)
    }
    /// Discard all commands issued after MULTI
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N), when N is the number of queued commands
    /// # Documentation
    /// view the docs for [DISCARD](https://redis.io/commands/discard)
    public func discard<T: FromRedisValue>() async throws -> T { try await Cmd("DISCARD").query(self) }
    /// Return a serialized version of the value stored at the specified key.
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1) to access the key and additional O(N*M) to serialize it, where N is the number of Redis objects composing the value and M their average size. For small string values the time complexity is thus O(1)+O(1*M) where M is small, so simply O(1).
    /// # Documentation
    /// view the docs for [DUMP](https://redis.io/commands/dump)
    public func dump<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("DUMP").arg(key.to_redis_args()).query(self)
    }
    /// Echo the given string
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [ECHO](https://redis.io/commands/echo)
    public func echo<T: FromRedisValue>(_ message: String) async throws -> T {
        try await Cmd("ECHO").arg(message.to_redis_args()).query(self)
    }
    /// Execute a Lua script server side
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// Depends on the script that is executed.
    /// # Documentation
    /// view the docs for [EVAL](https://redis.io/commands/eval)
    public func eval<T: FromRedisValue>(_ script: String, _ numkeys: Int, _ key: String?..., arg: String?...)
        async throws -> T
    {
        try await Cmd("EVAL").arg(script.to_redis_args()).arg(numkeys.to_redis_args()).arg(key.to_redis_args()).arg(
            arg.to_redis_args()
        ).query(self)
    }
    /// Execute a Lua script server side
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// Depends on the script that is executed.
    /// # Documentation
    /// view the docs for [EVALSHA](https://redis.io/commands/evalsha)
    public func evalsha<T: FromRedisValue>(_ sha1: String, _ numkeys: Int, _ key: String?..., arg: String?...)
        async throws -> T
    {
        try await Cmd("EVALSHA").arg(sha1.to_redis_args()).arg(numkeys.to_redis_args()).arg(key.to_redis_args()).arg(
            arg.to_redis_args()
        ).query(self)
    }
    /// Execute a read-only Lua script server side
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// Depends on the script that is executed.
    /// # Documentation
    /// view the docs for [EVALSHA_RO](https://redis.io/commands/evalsha-ro)
    public func evalsha_ro<T: FromRedisValue>(_ sha1: String, _ numkeys: Int, _ key: String..., arg: String...)
        async throws -> T
    {
        try await Cmd("EVALSHA_RO").arg(sha1.to_redis_args()).arg(numkeys.to_redis_args()).arg(key.to_redis_args()).arg(
            arg.to_redis_args()
        ).query(self)
    }
    /// Execute a read-only Lua script server side
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// Depends on the script that is executed.
    /// # Documentation
    /// view the docs for [EVAL_RO](https://redis.io/commands/eval-ro)
    public func eval_ro<T: FromRedisValue>(_ script: String, _ numkeys: Int, _ key: String..., arg: String...)
        async throws -> T
    {
        try await Cmd("EVAL_RO").arg(script.to_redis_args()).arg(numkeys.to_redis_args()).arg(key.to_redis_args()).arg(
            arg.to_redis_args()
        ).query(self)
    }
    /// Execute all commands issued after MULTI
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// Depends on commands in the transaction
    /// # Documentation
    /// view the docs for [EXEC](https://redis.io/commands/exec)
    public func exec<T: FromRedisValue>() async throws -> T { try await Cmd("EXEC").query(self) }
    /// Determine if a key exists
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of keys to check.
    /// # History
    /// - 3.0.3, Accepts multiple `key` arguments.
    /// # Documentation
    /// view the docs for [EXISTS](https://redis.io/commands/exists)
    public func exists<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("EXISTS").arg(key.to_redis_args()).query(self)
    }
    /// Set a key's time to live in seconds
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added options: `NX`, `XX`, `GT` and `LT`.
    /// # Documentation
    /// view the docs for [EXPIRE](https://redis.io/commands/expire)
    public func expire<T: FromRedisValue>(_ key: String, _ seconds: Int, _ condition: ExpireCondition? = nil)
        async throws -> T
    {
        try await Cmd("EXPIRE").arg(key.to_redis_args()).arg(seconds.to_redis_args()).arg(condition.to_redis_args())
            .query(self)
    }
    public enum ExpireCondition: ToRedisArgs {
        case NX
        case XX
        case GT
        case LT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .NX: out.append("NX".data(using: .utf8)!)
            case .XX: out.append("XX".data(using: .utf8)!)
            case .GT: out.append("GT".data(using: .utf8)!)
            case .LT: out.append("LT".data(using: .utf8)!)
            }
        }
    }
    /// Set the expiration for a key as a UNIX timestamp
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added options: `NX`, `XX`, `GT` and `LT`.
    /// # Documentation
    /// view the docs for [EXPIREAT](https://redis.io/commands/expireat)
    public func expireat<T: FromRedisValue>(
        _ key: String, _ unixTimeSeconds: Int64, _ condition: ExpireatCondition? = nil
    ) async throws -> T {
        try await Cmd("EXPIREAT").arg(key.to_redis_args()).arg(unixTimeSeconds.to_redis_args()).arg(
            condition.to_redis_args()
        ).query(self)
    }
    public enum ExpireatCondition: ToRedisArgs {
        case NX
        case XX
        case GT
        case LT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .NX: out.append("NX".data(using: .utf8)!)
            case .XX: out.append("XX".data(using: .utf8)!)
            case .GT: out.append("GT".data(using: .utf8)!)
            case .LT: out.append("LT".data(using: .utf8)!)
            }
        }
    }
    /// Get the expiration Unix timestamp for a key
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [EXPIRETIME](https://redis.io/commands/expiretime)
    public func expiretime<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("EXPIRETIME").arg(key.to_redis_args()).query(self)
    }
    /// Start a coordinated failover between this server and one of its replicas.
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [FAILOVER](https://redis.io/commands/failover)
    public func failover<T: FromRedisValue>(
        _ target: FailoverTarget? = nil, milliseconds: Int? = nil, options: FailoverOptions? = nil
    ) async throws -> T {
        try await Cmd("FAILOVER").arg(target.to_redis_args()).arg(milliseconds.to_redis_args()).arg(
            options.to_redis_args()
        ).query(self)
    }
    public struct FailoverTarget: ToRedisArgs {
        let host: String
        let port: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            host.write_redis_args(out: &out)
            port.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let FORCE = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.FORCE) { out.append("FORCE".data(using: .utf8)!) }
            }
        }
    }
    public struct FailoverOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let ABORT = FailoverOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.ABORT) { out.append("ABORT".data(using: .utf8)!) }
        }
    }
    /// Invoke a function
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// Depends on the function that is executed.
    /// # Documentation
    /// view the docs for [FCALL](https://redis.io/commands/fcall)
    public func fcall<T: FromRedisValue>(_ function: String, _ numkeys: Int, _ key: String..., arg: String...)
        async throws -> T
    {
        try await Cmd("FCALL").arg(function.to_redis_args()).arg(numkeys.to_redis_args()).arg(key.to_redis_args()).arg(
            arg.to_redis_args()
        ).query(self)
    }
    /// Invoke a read-only function
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// Depends on the function that is executed.
    /// # Documentation
    /// view the docs for [FCALL_RO](https://redis.io/commands/fcall-ro)
    public func fcall_ro<T: FromRedisValue>(_ function: String, _ numkeys: Int, _ key: String..., arg: String...)
        async throws -> T
    {
        try await Cmd("FCALL_RO").arg(function.to_redis_args()).arg(numkeys.to_redis_args()).arg(key.to_redis_args())
            .arg(arg.to_redis_args()).query(self)
    }
    /// Remove all keys from all databases
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the total number of keys in all databases
    /// # History
    /// - 4.0.0, Added the `ASYNC` flushing mode modifier.
    /// - 6.2.0, Added the `SYNC` flushing mode modifier.
    /// # Documentation
    /// view the docs for [FLUSHALL](https://redis.io/commands/flushall)
    public func flushall<T: FromRedisValue>(_ async: FlushallAsync? = nil) async throws -> T {
        try await Cmd("FLUSHALL").arg(async.to_redis_args()).query(self)
    }
    public enum FlushallAsync: ToRedisArgs {
        case ASYNC
        case SYNC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASYNC: out.append("ASYNC".data(using: .utf8)!)
            case .SYNC: out.append("SYNC".data(using: .utf8)!)
            }
        }
    }
    /// Remove all keys from the current database
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of keys in the selected database
    /// # History
    /// - 4.0.0, Added the `ASYNC` flushing mode modifier.
    /// - 6.2.0, Added the `SYNC` flushing mode modifier.
    /// # Documentation
    /// view the docs for [FLUSHDB](https://redis.io/commands/flushdb)
    public func flushdb<T: FromRedisValue>(_ async: FlushdbAsync? = nil) async throws -> T {
        try await Cmd("FLUSHDB").arg(async.to_redis_args()).query(self)
    }
    public enum FlushdbAsync: ToRedisArgs {
        case ASYNC
        case SYNC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASYNC: out.append("ASYNC".data(using: .utf8)!)
            case .SYNC: out.append("SYNC".data(using: .utf8)!)
            }
        }
    }
    /// A container for function commands
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [FUNCTION](https://redis.io/commands/function)
    public func function<T: FromRedisValue>() async throws -> T { try await Cmd("FUNCTION").query(self) }
    /// Add one or more geospatial items in the geospatial index represented using a sorted set
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(log(N)) for each item added, where N is the number of elements in the sorted set.
    /// # History
    /// - 6.2.0, Added the `CH`, `NX` and `XX` options.
    /// # Documentation
    /// view the docs for [GEOADD](https://redis.io/commands/geoadd)
    public func geoadd<T: FromRedisValue>(
        _ key: String, _ condition: GeoaddCondition? = nil, options: GeoaddOptions? = nil,
        longitudeLatitudeMember: GeoaddLongitudelatitudemember...
    ) async throws -> T {
        try await Cmd("GEOADD").arg(key.to_redis_args()).arg(condition.to_redis_args()).arg(options.to_redis_args())
            .arg(longitudeLatitudeMember.to_redis_args()).query(self)
    }
    public enum GeoaddCondition: ToRedisArgs {
        case NX
        case XX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .NX: out.append("NX".data(using: .utf8)!)
            case .XX: out.append("XX".data(using: .utf8)!)
            }
        }
    }
    public struct GeoaddOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let CH = GeoaddOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.CH) { out.append("CH".data(using: .utf8)!) }
        }
    }
    public struct GeoaddLongitudelatitudemember: ToRedisArgs {
        let longitude: Double
        let latitude: Double
        let member: String
        public func write_redis_args(out: inout [Data]) {
            longitude.write_redis_args(out: &out)
            latitude.write_redis_args(out: &out)
            member.write_redis_args(out: &out)
        }
    }
    /// Returns the distance between two members of a geospatial index
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(log(N))
    /// # Documentation
    /// view the docs for [GEODIST](https://redis.io/commands/geodist)
    public func geodist<T: FromRedisValue>(
        _ key: String, _ member1: String, _ member2: String, _ unit: GeodistUnit? = nil
    ) async throws -> T {
        try await Cmd("GEODIST").arg(key.to_redis_args()).arg(member1.to_redis_args()).arg(member2.to_redis_args()).arg(
            unit.to_redis_args()
        ).query(self)
    }
    public enum GeodistUnit: ToRedisArgs {
        case m
        case km
        case ft
        case mi
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .m: out.append("m".data(using: .utf8)!)
            case .km: out.append("km".data(using: .utf8)!)
            case .ft: out.append("ft".data(using: .utf8)!)
            case .mi: out.append("mi".data(using: .utf8)!)
            }
        }
    }
    /// Returns members of a geospatial index as standard geohash strings
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(log(N)) for each member requested, where N is the number of elements in the sorted set.
    /// # Documentation
    /// view the docs for [GEOHASH](https://redis.io/commands/geohash)
    public func geohash<T: FromRedisValue>(_ key: String, _ member: String...) async throws -> T {
        try await Cmd("GEOHASH").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Returns longitude and latitude of members of a geospatial index
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(N) where N is the number of members requested.
    /// # Documentation
    /// view the docs for [GEOPOS](https://redis.io/commands/geopos)
    public func geopos<T: FromRedisValue>(_ key: String, _ member: String...) async throws -> T {
        try await Cmd("GEOPOS").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Query a sorted set representing a geospatial index to fetch members matching a given maximum distance from a point
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(N+log(M)) where N is the number of elements inside the bounding box of the circular area delimited by center and radius and M is the number of items inside the index.
    /// # History
    /// - 6.2.0, Added the `ANY` option for `COUNT`.
    /// # Documentation
    /// view the docs for [GEORADIUS](https://redis.io/commands/georadius)
    public func georadius<T: FromRedisValue>(
        _ key: String, _ longitude: Double, _ latitude: Double, _ radius: Double, _ unit: GeoradiusUnit,
        _ count: GeoradiusCount? = nil, order: GeoradiusOrder? = nil, STORE: String? = nil, STOREDIST: String? = nil,
        options: GeoradiusOptions? = nil
    ) async throws -> T {
        try await Cmd("GEORADIUS").arg(key.to_redis_args()).arg(longitude.to_redis_args()).arg(latitude.to_redis_args())
            .arg(radius.to_redis_args()).arg(unit.to_redis_args()).arg(count.to_redis_args()).arg(order.to_redis_args())
            .arg(STORE.to_redis_args()).arg(STOREDIST.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public enum GeoradiusUnit: ToRedisArgs {
        case m
        case km
        case ft
        case mi
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .m: out.append("m".data(using: .utf8)!)
            case .km: out.append("km".data(using: .utf8)!)
            case .ft: out.append("ft".data(using: .utf8)!)
            case .mi: out.append("mi".data(using: .utf8)!)
            }
        }
    }
    public struct GeoradiusCount: ToRedisArgs {
        let count: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            out.append("COUNT".data(using: .utf8)!)
            count.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let ANY = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.ANY) { out.append("ANY".data(using: .utf8)!) }
            }
        }
    }
    public enum GeoradiusOrder: ToRedisArgs {
        case ASC
        case DESC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASC: out.append("ASC".data(using: .utf8)!)
            case .DESC: out.append("DESC".data(using: .utf8)!)
            }
        }
    }
    public struct GeoradiusOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHCOORD = GeoradiusOptions(rawValue: 1 << 0)
        static let WITHDIST = GeoradiusOptions(rawValue: 1 << 1)
        static let WITHHASH = GeoradiusOptions(rawValue: 1 << 2)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHCOORD) { out.append("WITHCOORD".data(using: .utf8)!) }
            if self.contains(.WITHDIST) { out.append("WITHDIST".data(using: .utf8)!) }
            if self.contains(.WITHHASH) { out.append("WITHHASH".data(using: .utf8)!) }
        }
    }
    /// Query a sorted set representing a geospatial index to fetch members matching a given maximum distance from a member
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(N+log(M)) where N is the number of elements inside the bounding box of the circular area delimited by center and radius and M is the number of items inside the index.
    /// # Documentation
    /// view the docs for [GEORADIUSBYMEMBER](https://redis.io/commands/georadiusbymember)
    public func georadiusbymember<T: FromRedisValue>(
        _ key: String, _ member: String, _ radius: Double, _ unit: GeoradiusbymemberUnit,
        _ count: GeoradiusbymemberCount? = nil, order: GeoradiusbymemberOrder? = nil, STORE: String? = nil,
        STOREDIST: String? = nil, options: GeoradiusbymemberOptions? = nil
    ) async throws -> T {
        try await Cmd("GEORADIUSBYMEMBER").arg(key.to_redis_args()).arg(member.to_redis_args()).arg(
            radius.to_redis_args()
        ).arg(unit.to_redis_args()).arg(count.to_redis_args()).arg(order.to_redis_args()).arg(STORE.to_redis_args())
            .arg(STOREDIST.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public enum GeoradiusbymemberUnit: ToRedisArgs {
        case m
        case km
        case ft
        case mi
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .m: out.append("m".data(using: .utf8)!)
            case .km: out.append("km".data(using: .utf8)!)
            case .ft: out.append("ft".data(using: .utf8)!)
            case .mi: out.append("mi".data(using: .utf8)!)
            }
        }
    }
    public struct GeoradiusbymemberCount: ToRedisArgs {
        let count: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            out.append("COUNT".data(using: .utf8)!)
            count.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let ANY = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.ANY) { out.append("ANY".data(using: .utf8)!) }
            }
        }
    }
    public enum GeoradiusbymemberOrder: ToRedisArgs {
        case ASC
        case DESC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASC: out.append("ASC".data(using: .utf8)!)
            case .DESC: out.append("DESC".data(using: .utf8)!)
            }
        }
    }
    public struct GeoradiusbymemberOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHCOORD = GeoradiusbymemberOptions(rawValue: 1 << 0)
        static let WITHDIST = GeoradiusbymemberOptions(rawValue: 1 << 1)
        static let WITHHASH = GeoradiusbymemberOptions(rawValue: 1 << 2)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHCOORD) { out.append("WITHCOORD".data(using: .utf8)!) }
            if self.contains(.WITHDIST) { out.append("WITHDIST".data(using: .utf8)!) }
            if self.contains(.WITHHASH) { out.append("WITHHASH".data(using: .utf8)!) }
        }
    }
    /// A read-only variant for GEORADIUSBYMEMBER
    /// # Available since
    /// 3.2.10
    /// # Time complexity
    /// O(N+log(M)) where N is the number of elements inside the bounding box of the circular area delimited by center and radius and M is the number of items inside the index.
    /// # Documentation
    /// view the docs for [GEORADIUSBYMEMBER_RO](https://redis.io/commands/georadiusbymember-ro)
    public func georadiusbymember_ro<T: FromRedisValue>(
        _ key: String, _ member: String, _ radius: Double, _ unit: GeoradiusbymemberRoUnit,
        _ count: GeoradiusbymemberRoCount? = nil, order: GeoradiusbymemberRoOrder? = nil,
        options: GeoradiusbymemberRoOptions? = nil
    ) async throws -> T {
        try await Cmd("GEORADIUSBYMEMBER_RO").arg(key.to_redis_args()).arg(member.to_redis_args()).arg(
            radius.to_redis_args()
        ).arg(unit.to_redis_args()).arg(count.to_redis_args()).arg(order.to_redis_args()).arg(options.to_redis_args())
            .query(self)
    }
    public enum GeoradiusbymemberRoUnit: ToRedisArgs {
        case m
        case km
        case ft
        case mi
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .m: out.append("m".data(using: .utf8)!)
            case .km: out.append("km".data(using: .utf8)!)
            case .ft: out.append("ft".data(using: .utf8)!)
            case .mi: out.append("mi".data(using: .utf8)!)
            }
        }
    }
    public struct GeoradiusbymemberRoCount: ToRedisArgs {
        let count: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            out.append("COUNT".data(using: .utf8)!)
            count.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let ANY = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.ANY) { out.append("ANY".data(using: .utf8)!) }
            }
        }
    }
    public enum GeoradiusbymemberRoOrder: ToRedisArgs {
        case ASC
        case DESC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASC: out.append("ASC".data(using: .utf8)!)
            case .DESC: out.append("DESC".data(using: .utf8)!)
            }
        }
    }
    public struct GeoradiusbymemberRoOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHCOORD = GeoradiusbymemberRoOptions(rawValue: 1 << 0)
        static let WITHDIST = GeoradiusbymemberRoOptions(rawValue: 1 << 1)
        static let WITHHASH = GeoradiusbymemberRoOptions(rawValue: 1 << 2)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHCOORD) { out.append("WITHCOORD".data(using: .utf8)!) }
            if self.contains(.WITHDIST) { out.append("WITHDIST".data(using: .utf8)!) }
            if self.contains(.WITHHASH) { out.append("WITHHASH".data(using: .utf8)!) }
        }
    }
    /// A read-only variant for GEORADIUS
    /// # Available since
    /// 3.2.10
    /// # Time complexity
    /// O(N+log(M)) where N is the number of elements inside the bounding box of the circular area delimited by center and radius and M is the number of items inside the index.
    /// # History
    /// - 6.2.0, Added the `ANY` option for `COUNT`.
    /// # Documentation
    /// view the docs for [GEORADIUS_RO](https://redis.io/commands/georadius-ro)
    public func georadius_ro<T: FromRedisValue>(
        _ key: String, _ longitude: Double, _ latitude: Double, _ radius: Double, _ unit: GeoradiusRoUnit,
        _ count: GeoradiusRoCount? = nil, order: GeoradiusRoOrder? = nil, options: GeoradiusRoOptions? = nil
    ) async throws -> T {
        try await Cmd("GEORADIUS_RO").arg(key.to_redis_args()).arg(longitude.to_redis_args()).arg(
            latitude.to_redis_args()
        ).arg(radius.to_redis_args()).arg(unit.to_redis_args()).arg(count.to_redis_args()).arg(order.to_redis_args())
            .arg(options.to_redis_args()).query(self)
    }
    public enum GeoradiusRoUnit: ToRedisArgs {
        case m
        case km
        case ft
        case mi
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .m: out.append("m".data(using: .utf8)!)
            case .km: out.append("km".data(using: .utf8)!)
            case .ft: out.append("ft".data(using: .utf8)!)
            case .mi: out.append("mi".data(using: .utf8)!)
            }
        }
    }
    public struct GeoradiusRoCount: ToRedisArgs {
        let count: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            out.append("COUNT".data(using: .utf8)!)
            count.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let ANY = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.ANY) { out.append("ANY".data(using: .utf8)!) }
            }
        }
    }
    public enum GeoradiusRoOrder: ToRedisArgs {
        case ASC
        case DESC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASC: out.append("ASC".data(using: .utf8)!)
            case .DESC: out.append("DESC".data(using: .utf8)!)
            }
        }
    }
    public struct GeoradiusRoOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHCOORD = GeoradiusRoOptions(rawValue: 1 << 0)
        static let WITHDIST = GeoradiusRoOptions(rawValue: 1 << 1)
        static let WITHHASH = GeoradiusRoOptions(rawValue: 1 << 2)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHCOORD) { out.append("WITHCOORD".data(using: .utf8)!) }
            if self.contains(.WITHDIST) { out.append("WITHDIST".data(using: .utf8)!) }
            if self.contains(.WITHHASH) { out.append("WITHHASH".data(using: .utf8)!) }
        }
    }
    /// Query a sorted set representing a geospatial index to fetch members inside an area of a box or a circle.
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N+log(M)) where N is the number of elements in the grid-aligned bounding box area around the shape provided as the filter and M is the number of items inside the shape
    /// # Documentation
    /// view the docs for [GEOSEARCH](https://redis.io/commands/geosearch)
    public func geosearch<T: FromRedisValue>(
        _ key: String, _ from: GeosearchFrom, _ by: GeosearchBy, _ order: GeosearchOrder? = nil,
        count: GeosearchCount? = nil, options: GeosearchOptions? = nil
    ) async throws -> T {
        try await Cmd("GEOSEARCH").arg(key.to_redis_args()).arg(from.to_redis_args()).arg(by.to_redis_args()).arg(
            order.to_redis_args()
        ).arg(count.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public enum GeosearchFrom: ToRedisArgs {
        case FROMMEMBER(String)
        case FROMLONLAT(Longitudelatitude)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .FROMMEMBER(let string):
                out.append("FROMMEMBER".data(using: .utf8)!)
                string.write_redis_args(out: &out)
            case .FROMLONLAT(let longitudelatitude):
                out.append("FROMLONLAT".data(using: .utf8)!)
                longitudelatitude.write_redis_args(out: &out)
            }
        }
        public struct Longitudelatitude: ToRedisArgs {
            let longitude: Double
            let latitude: Double
            public func write_redis_args(out: inout [Data]) {
                longitude.write_redis_args(out: &out)
                latitude.write_redis_args(out: &out)
            }
        }
    }
    public enum GeosearchBy: ToRedisArgs {
        case CIRCLE(Circle)
        case BOX(Box)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .CIRCLE(let circle): circle.write_redis_args(out: &out)
            case .BOX(let box): box.write_redis_args(out: &out)
            }
        }
        public struct Circle: ToRedisArgs {
            let radius: Double
            let unit: Unit
            public func write_redis_args(out: inout [Data]) {
                out.append("BYRADIUS".data(using: .utf8)!)
                radius.write_redis_args(out: &out)
                unit.write_redis_args(out: &out)
            }
            public enum Unit: ToRedisArgs {
                case m
                case km
                case ft
                case mi
                public func write_redis_args(out: inout [Data]) {
                    switch self {
                    case .m: out.append("m".data(using: .utf8)!)
                    case .km: out.append("km".data(using: .utf8)!)
                    case .ft: out.append("ft".data(using: .utf8)!)
                    case .mi: out.append("mi".data(using: .utf8)!)
                    }
                }
            }
        }
        public struct Box: ToRedisArgs {
            let width: Double
            let height: Double
            let unit: Unit
            public func write_redis_args(out: inout [Data]) {
                out.append("BYBOX".data(using: .utf8)!)
                width.write_redis_args(out: &out)
                height.write_redis_args(out: &out)
                unit.write_redis_args(out: &out)
            }
            public enum Unit: ToRedisArgs {
                case m
                case km
                case ft
                case mi
                public func write_redis_args(out: inout [Data]) {
                    switch self {
                    case .m: out.append("m".data(using: .utf8)!)
                    case .km: out.append("km".data(using: .utf8)!)
                    case .ft: out.append("ft".data(using: .utf8)!)
                    case .mi: out.append("mi".data(using: .utf8)!)
                    }
                }
            }
        }
    }
    public enum GeosearchOrder: ToRedisArgs {
        case ASC
        case DESC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASC: out.append("ASC".data(using: .utf8)!)
            case .DESC: out.append("DESC".data(using: .utf8)!)
            }
        }
    }
    public struct GeosearchCount: ToRedisArgs {
        let count: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            out.append("COUNT".data(using: .utf8)!)
            count.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let ANY = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.ANY) { out.append("ANY".data(using: .utf8)!) }
            }
        }
    }
    public struct GeosearchOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHCOORD = GeosearchOptions(rawValue: 1 << 0)
        static let WITHDIST = GeosearchOptions(rawValue: 1 << 1)
        static let WITHHASH = GeosearchOptions(rawValue: 1 << 2)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHCOORD) { out.append("WITHCOORD".data(using: .utf8)!) }
            if self.contains(.WITHDIST) { out.append("WITHDIST".data(using: .utf8)!) }
            if self.contains(.WITHHASH) { out.append("WITHHASH".data(using: .utf8)!) }
        }
    }
    /// Query a sorted set representing a geospatial index to fetch members inside an area of a box or a circle, and store the result in another key.
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N+log(M)) where N is the number of elements in the grid-aligned bounding box area around the shape provided as the filter and M is the number of items inside the shape
    /// # Documentation
    /// view the docs for [GEOSEARCHSTORE](https://redis.io/commands/geosearchstore)
    public func geosearchstore<T: FromRedisValue>(
        _ destination: String, _ source: String, _ from: GeosearchstoreFrom, _ by: GeosearchstoreBy,
        _ order: GeosearchstoreOrder? = nil, count: GeosearchstoreCount? = nil, options: GeosearchstoreOptions? = nil
    ) async throws -> T {
        try await Cmd("GEOSEARCHSTORE").arg(destination.to_redis_args()).arg(source.to_redis_args()).arg(
            from.to_redis_args()
        ).arg(by.to_redis_args()).arg(order.to_redis_args()).arg(count.to_redis_args()).arg(options.to_redis_args())
            .query(self)
    }
    public enum GeosearchstoreFrom: ToRedisArgs {
        case FROMMEMBER(String)
        case FROMLONLAT(Longitudelatitude)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .FROMMEMBER(let string):
                out.append("FROMMEMBER".data(using: .utf8)!)
                string.write_redis_args(out: &out)
            case .FROMLONLAT(let longitudelatitude):
                out.append("FROMLONLAT".data(using: .utf8)!)
                longitudelatitude.write_redis_args(out: &out)
            }
        }
        public struct Longitudelatitude: ToRedisArgs {
            let longitude: Double
            let latitude: Double
            public func write_redis_args(out: inout [Data]) {
                longitude.write_redis_args(out: &out)
                latitude.write_redis_args(out: &out)
            }
        }
    }
    public enum GeosearchstoreBy: ToRedisArgs {
        case CIRCLE(Circle)
        case BOX(Box)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .CIRCLE(let circle): circle.write_redis_args(out: &out)
            case .BOX(let box): box.write_redis_args(out: &out)
            }
        }
        public struct Circle: ToRedisArgs {
            let radius: Double
            let unit: Unit
            public func write_redis_args(out: inout [Data]) {
                out.append("BYRADIUS".data(using: .utf8)!)
                radius.write_redis_args(out: &out)
                unit.write_redis_args(out: &out)
            }
            public enum Unit: ToRedisArgs {
                case m
                case km
                case ft
                case mi
                public func write_redis_args(out: inout [Data]) {
                    switch self {
                    case .m: out.append("m".data(using: .utf8)!)
                    case .km: out.append("km".data(using: .utf8)!)
                    case .ft: out.append("ft".data(using: .utf8)!)
                    case .mi: out.append("mi".data(using: .utf8)!)
                    }
                }
            }
        }
        public struct Box: ToRedisArgs {
            let width: Double
            let height: Double
            let unit: Unit
            public func write_redis_args(out: inout [Data]) {
                out.append("BYBOX".data(using: .utf8)!)
                width.write_redis_args(out: &out)
                height.write_redis_args(out: &out)
                unit.write_redis_args(out: &out)
            }
            public enum Unit: ToRedisArgs {
                case m
                case km
                case ft
                case mi
                public func write_redis_args(out: inout [Data]) {
                    switch self {
                    case .m: out.append("m".data(using: .utf8)!)
                    case .km: out.append("km".data(using: .utf8)!)
                    case .ft: out.append("ft".data(using: .utf8)!)
                    case .mi: out.append("mi".data(using: .utf8)!)
                    }
                }
            }
        }
    }
    public enum GeosearchstoreOrder: ToRedisArgs {
        case ASC
        case DESC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASC: out.append("ASC".data(using: .utf8)!)
            case .DESC: out.append("DESC".data(using: .utf8)!)
            }
        }
    }
    public struct GeosearchstoreCount: ToRedisArgs {
        let count: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            out.append("COUNT".data(using: .utf8)!)
            count.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let ANY = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.ANY) { out.append("ANY".data(using: .utf8)!) }
            }
        }
    }
    public struct GeosearchstoreOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let STOREDIST = GeosearchstoreOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.STOREDIST) { out.append("STOREDIST".data(using: .utf8)!) }
        }
    }
    /// Get the value of a key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [GET](https://redis.io/commands/get)
    public func get<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("GET").arg(key.to_redis_args()).query(self)
    }
    /// Returns the bit value at offset in the string value stored at key
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [GETBIT](https://redis.io/commands/getbit)
    public func getbit<T: FromRedisValue>(_ key: String, _ offset: Int) async throws -> T {
        try await Cmd("GETBIT").arg(key.to_redis_args()).arg(offset.to_redis_args()).query(self)
    }
    /// Get the value of a key and delete the key
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [GETDEL](https://redis.io/commands/getdel)
    public func getdel<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("GETDEL").arg(key.to_redis_args()).query(self)
    }
    /// Get the value of a key and optionally set its expiration
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [GETEX](https://redis.io/commands/getex)
    public func getex<T: FromRedisValue>(_ key: String, _ expiration: GetexExpiration? = nil) async throws -> T {
        try await Cmd("GETEX").arg(key.to_redis_args()).arg(expiration.to_redis_args()).query(self)
    }
    public enum GetexExpiration: ToRedisArgs {
        case EX(Int)
        case PX(Int)
        case EXAT(Int64)
        case PXAT(Int64)
        case PERSIST
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .EX(let int):
                out.append("EX".data(using: .utf8)!)
                int.write_redis_args(out: &out)
            case .PX(let int):
                out.append("PX".data(using: .utf8)!)
                int.write_redis_args(out: &out)
            case .EXAT(let int64):
                out.append("EXAT".data(using: .utf8)!)
                int64.write_redis_args(out: &out)
            case .PXAT(let int64):
                out.append("PXAT".data(using: .utf8)!)
                int64.write_redis_args(out: &out)
            case .PERSIST: out.append("PERSIST".data(using: .utf8)!)
            }
        }
    }
    /// Get a substring of the string stored at a key
    /// # Available since
    /// 2.4.0
    /// # Time complexity
    /// O(N) where N is the length of the returned string. The complexity is ultimately determined by the returned length, but because creating a substring from an existing string is very cheap, it can be considered O(1) for small strings.
    /// # Documentation
    /// view the docs for [GETRANGE](https://redis.io/commands/getrange)
    public func getrange<T: FromRedisValue>(_ key: String, _ start: Int, _ end: Int) async throws -> T {
        try await Cmd("GETRANGE").arg(key.to_redis_args()).arg(start.to_redis_args()).arg(end.to_redis_args()).query(
            self)
    }
    /// Set the string value of a key and return its old value
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [GETSET](https://redis.io/commands/getset)
    public func getset<T: FromRedisValue>(_ key: String, _ value: String) async throws -> T {
        try await Cmd("GETSET").arg(key.to_redis_args()).arg(value.to_redis_args()).query(self)
    }
    /// Delete one or more hash fields
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the number of fields to be removed.
    /// # History
    /// - 2.4.0, Accepts multiple `field` arguments.
    /// # Documentation
    /// view the docs for [HDEL](https://redis.io/commands/hdel)
    public func hdel<T: FromRedisValue>(_ key: String, _ field: String...) async throws -> T {
        try await Cmd("HDEL").arg(key.to_redis_args()).arg(field.to_redis_args()).query(self)
    }
    /// Handshake with Redis
    /// # Available since
    /// 6.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 6.2.0, `protover` made optional; when called without arguments the command reports the current connection's context.
    /// # Documentation
    /// view the docs for [HELLO](https://redis.io/commands/hello)
    public func hello<T: FromRedisValue>(_ arguments: HelloArguments? = nil) async throws -> T {
        try await Cmd("HELLO").arg(arguments.to_redis_args()).query(self)
    }
    public struct HelloArguments: ToRedisArgs {
        let protover: Int
        let usernamePassword: Usernamepassword
        let clientname: String
        public func write_redis_args(out: inout [Data]) {
            protover.write_redis_args(out: &out)
            usernamePassword.write_redis_args(out: &out)
            clientname.write_redis_args(out: &out)
        }
        public struct Usernamepassword: ToRedisArgs {
            let username: String
            let password: String
            public func write_redis_args(out: inout [Data]) {
                username.write_redis_args(out: &out)
                password.write_redis_args(out: &out)
            }
        }
    }
    /// Determine if a hash field exists
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [HEXISTS](https://redis.io/commands/hexists)
    public func hexists<T: FromRedisValue>(_ key: String, _ field: String) async throws -> T {
        try await Cmd("HEXISTS").arg(key.to_redis_args()).arg(field.to_redis_args()).query(self)
    }
    /// Get the value of a hash field
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [HGET](https://redis.io/commands/hget)
    public func hget<T: FromRedisValue>(_ key: String, _ field: String) async throws -> T {
        try await Cmd("HGET").arg(key.to_redis_args()).arg(field.to_redis_args()).query(self)
    }
    /// Get all the fields and values in a hash
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the size of the hash.
    /// # Documentation
    /// view the docs for [HGETALL](https://redis.io/commands/hgetall)
    public func hgetall<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("HGETALL").arg(key.to_redis_args()).query(self)
    }
    /// Increment the integer value of a hash field by the given number
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [HINCRBY](https://redis.io/commands/hincrby)
    public func hincrby<T: FromRedisValue>(_ key: String, _ field: String, _ increment: Int) async throws -> T {
        try await Cmd("HINCRBY").arg(key.to_redis_args()).arg(field.to_redis_args()).arg(increment.to_redis_args())
            .query(self)
    }
    /// Increment the float value of a hash field by the given amount
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [HINCRBYFLOAT](https://redis.io/commands/hincrbyfloat)
    public func hincrbyfloat<T: FromRedisValue>(_ key: String, _ field: String, _ increment: Double) async throws -> T {
        try await Cmd("HINCRBYFLOAT").arg(key.to_redis_args()).arg(field.to_redis_args()).arg(increment.to_redis_args())
            .query(self)
    }
    /// Get all the fields in a hash
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the size of the hash.
    /// # Documentation
    /// view the docs for [HKEYS](https://redis.io/commands/hkeys)
    public func hkeys<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("HKEYS").arg(key.to_redis_args()).query(self)
    }
    /// Get the number of fields in a hash
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [HLEN](https://redis.io/commands/hlen)
    public func hlen<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("HLEN").arg(key.to_redis_args()).query(self)
    }
    /// Get the values of all the given hash fields
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the number of fields being requested.
    /// # Documentation
    /// view the docs for [HMGET](https://redis.io/commands/hmget)
    public func hmget<T: FromRedisValue>(_ key: String, _ field: String...) async throws -> T {
        try await Cmd("HMGET").arg(key.to_redis_args()).arg(field.to_redis_args()).query(self)
    }
    /// Set multiple hash fields to multiple values
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the number of fields being set.
    /// # Documentation
    /// view the docs for [HMSET](https://redis.io/commands/hmset)
    public func hmset<T: FromRedisValue>(_ key: String, _ fieldValue: HmsetFieldvalue...) async throws -> T {
        try await Cmd("HMSET").arg(key.to_redis_args()).arg(fieldValue.to_redis_args()).query(self)
    }
    public struct HmsetFieldvalue: ToRedisArgs {
        let field: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            field.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
    /// Get one or multiple random fields from a hash
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N) where N is the number of fields returned
    /// # Documentation
    /// view the docs for [HRANDFIELD](https://redis.io/commands/hrandfield)
    public func hrandfield<T: FromRedisValue>(_ key: String, _ options: HrandfieldOptions? = nil) async throws -> T {
        try await Cmd("HRANDFIELD").arg(key.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public struct HrandfieldOptions: ToRedisArgs {
        let count: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            count.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let WITHVALUES = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.WITHVALUES) { out.append("WITHVALUES".data(using: .utf8)!) }
            }
        }
    }
    /// Incrementally iterate hash fields and associated values
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection..
    /// # Documentation
    /// view the docs for [HSCAN](https://redis.io/commands/hscan)
    public func hscan<T: FromRedisValue>(_ key: String, _ cursor: Int, _ pattern: String? = nil, count: Int? = nil)
        async throws -> T
    {
        try await Cmd("HSCAN").arg(key.to_redis_args()).arg(cursor.to_redis_args()).arg(pattern.to_redis_args()).arg(
            count.to_redis_args()
        ).query(self)
    }
    /// Set the string value of a hash field
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1) for each field/value pair added, so O(N) to add N field/value pairs when the command is called with multiple field/value pairs.
    /// # History
    /// - 4.0.0, Accepts multiple `field` and `value` arguments.
    /// # Documentation
    /// view the docs for [HSET](https://redis.io/commands/hset)
    public func hset<T: FromRedisValue>(_ key: String, _ fieldValue: HsetFieldvalue...) async throws -> T {
        try await Cmd("HSET").arg(key.to_redis_args()).arg(fieldValue.to_redis_args()).query(self)
    }
    public struct HsetFieldvalue: ToRedisArgs {
        let field: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            field.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
    /// Set the value of a hash field, only if the field does not exist
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [HSETNX](https://redis.io/commands/hsetnx)
    public func hsetnx<T: FromRedisValue>(_ key: String, _ field: String, _ value: String) async throws -> T {
        try await Cmd("HSETNX").arg(key.to_redis_args()).arg(field.to_redis_args()).arg(value.to_redis_args()).query(
            self)
    }
    /// Get the length of the value of a hash field
    /// # Available since
    /// 3.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [HSTRLEN](https://redis.io/commands/hstrlen)
    public func hstrlen<T: FromRedisValue>(_ key: String, _ field: String) async throws -> T {
        try await Cmd("HSTRLEN").arg(key.to_redis_args()).arg(field.to_redis_args()).query(self)
    }
    /// Get all the values in a hash
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the size of the hash.
    /// # Documentation
    /// view the docs for [HVALS](https://redis.io/commands/hvals)
    public func hvals<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("HVALS").arg(key.to_redis_args()).query(self)
    }
    /// Increment the integer value of a key by one
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [INCR](https://redis.io/commands/incr)
    public func incr<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("INCR").arg(key.to_redis_args()).query(self)
    }
    /// Increment the integer value of a key by the given amount
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [INCRBY](https://redis.io/commands/incrby)
    public func incrby<T: FromRedisValue>(_ key: String, _ increment: Int) async throws -> T {
        try await Cmd("INCRBY").arg(key.to_redis_args()).arg(increment.to_redis_args()).query(self)
    }
    /// Increment the float value of a key by the given amount
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [INCRBYFLOAT](https://redis.io/commands/incrbyfloat)
    public func incrbyfloat<T: FromRedisValue>(_ key: String, _ increment: Double) async throws -> T {
        try await Cmd("INCRBYFLOAT").arg(key.to_redis_args()).arg(increment.to_redis_args()).query(self)
    }
    /// Get information and statistics about the server
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added support for taking multiple section arguments.
    /// # Documentation
    /// view the docs for [INFO](https://redis.io/commands/info)
    public func info<T: FromRedisValue>(_ section: String?...) async throws -> T {
        try await Cmd("INFO").arg(section.to_redis_args()).query(self)
    }
    /// Find all keys matching the given pattern
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) with N being the number of keys in the database, under the assumption that the key names in the database and the given pattern have limited length.
    /// # Documentation
    /// view the docs for [KEYS](https://redis.io/commands/keys)
    public func keys<T: FromRedisValue>(_ pattern: String) async throws -> T {
        try await Cmd("KEYS").arg(pattern.to_redis_args()).query(self)
    }
    /// Get the UNIX time stamp of the last successful save to disk
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LASTSAVE](https://redis.io/commands/lastsave)
    public func lastsave<T: FromRedisValue>() async throws -> T { try await Cmd("LASTSAVE").query(self) }
    /// A container for latency diagnostics commands
    /// # Available since
    /// 2.8.13
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [LATENCY](https://redis.io/commands/latency)
    public func latency<T: FromRedisValue>() async throws -> T { try await Cmd("LATENCY").query(self) }
    /// Find longest common substring
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N*M) where N and M are the lengths of s1 and s2, respectively
    /// # Documentation
    /// view the docs for [LCS](https://redis.io/commands/lcs)
    public func lcs<T: FromRedisValue>(
        _ key1: String, _ key2: String, _ MINMATCHLEN: Int? = nil, options: LcsOptions? = nil
    ) async throws -> T {
        try await Cmd("LCS").arg(key1.to_redis_args()).arg(key2.to_redis_args()).arg(MINMATCHLEN.to_redis_args()).arg(
            options.to_redis_args()
        ).query(self)
    }
    public struct LcsOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let LEN = LcsOptions(rawValue: 1 << 0)
        static let IDX = LcsOptions(rawValue: 1 << 1)
        static let WITHMATCHLEN = LcsOptions(rawValue: 1 << 2)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.LEN) { out.append("LEN".data(using: .utf8)!) }
            if self.contains(.IDX) { out.append("IDX".data(using: .utf8)!) }
            if self.contains(.WITHMATCHLEN) { out.append("WITHMATCHLEN".data(using: .utf8)!) }
        }
    }
    /// Get an element from a list by its index
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of elements to traverse to get to the element at index. This makes asking for the first or the last element of the list O(1).
    /// # Documentation
    /// view the docs for [LINDEX](https://redis.io/commands/lindex)
    public func lindex<T: FromRedisValue>(_ key: String, _ index: Int) async throws -> T {
        try await Cmd("LINDEX").arg(key.to_redis_args()).arg(index.to_redis_args()).query(self)
    }
    /// Insert an element before or after another element in a list
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(N) where N is the number of elements to traverse before seeing the value pivot. This means that inserting somewhere on the left end on the list (head) can be considered O(1) and inserting somewhere on the right end (tail) is O(N).
    /// # Documentation
    /// view the docs for [LINSERT](https://redis.io/commands/linsert)
    public func linsert<T: FromRedisValue>(_ key: String, _ sdfsdf: LinsertSdfsdf, _ pivot: String, _ element: String)
        async throws -> T
    {
        try await Cmd("LINSERT").arg(key.to_redis_args()).arg(sdfsdf.to_redis_args()).arg(pivot.to_redis_args()).arg(
            element.to_redis_args()
        ).query(self)
    }
    public enum LinsertSdfsdf: ToRedisArgs {
        case BEFORE
        case AFTER
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .BEFORE: out.append("BEFORE".data(using: .utf8)!)
            case .AFTER: out.append("AFTER".data(using: .utf8)!)
            }
        }
    }
    /// Get the length of a list
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LLEN](https://redis.io/commands/llen)
    public func llen<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("LLEN").arg(key.to_redis_args()).query(self)
    }
    /// Pop an element from a list, push it to another list and return it
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [LMOVE](https://redis.io/commands/lmove)
    public func lmove<T: FromRedisValue>(
        _ source: String, _ destination: String, _ wherefrom: LmoveWherefrom, _ whereto: LmoveWhereto
    ) async throws -> T {
        try await Cmd("LMOVE").arg(source.to_redis_args()).arg(destination.to_redis_args()).arg(
            wherefrom.to_redis_args()
        ).arg(whereto.to_redis_args()).query(self)
    }
    public enum LmoveWherefrom: ToRedisArgs {
        case LEFT
        case RIGHT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .LEFT: out.append("LEFT".data(using: .utf8)!)
            case .RIGHT: out.append("RIGHT".data(using: .utf8)!)
            }
        }
    }
    public enum LmoveWhereto: ToRedisArgs {
        case LEFT
        case RIGHT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .LEFT: out.append("LEFT".data(using: .utf8)!)
            case .RIGHT: out.append("RIGHT".data(using: .utf8)!)
            }
        }
    }
    /// Pop elements from a list
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N+M) where N is the number of provided keys and M is the number of elements returned.
    /// # Documentation
    /// view the docs for [LMPOP](https://redis.io/commands/lmpop)
    public func lmpop<T: FromRedisValue>(_ numkeys: Int, _ sdfsdf: LmpopSdfsdf, _ count: Int? = nil, key: String...)
        async throws -> T
    {
        try await Cmd("LMPOP").arg(numkeys.to_redis_args()).arg(sdfsdf.to_redis_args()).arg(count.to_redis_args()).arg(
            key.to_redis_args()
        ).query(self)
    }
    public enum LmpopSdfsdf: ToRedisArgs {
        case LEFT
        case RIGHT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .LEFT: out.append("LEFT".data(using: .utf8)!)
            case .RIGHT: out.append("RIGHT".data(using: .utf8)!)
            }
        }
    }
    /// Display some computer art and the Redis version
    /// # Available since
    /// 5.0.0
    /// # Documentation
    /// view the docs for [LOLWUT](https://redis.io/commands/lolwut)
    public func lolwut<T: FromRedisValue>(_ version: Int? = nil) async throws -> T {
        try await Cmd("LOLWUT").arg(version.to_redis_args()).query(self)
    }
    /// Remove and get the first elements in a list
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of elements returned
    /// # History
    /// - 6.2.0, Added the `count` argument.
    /// # Documentation
    /// view the docs for [LPOP](https://redis.io/commands/lpop)
    public func lpop<T: FromRedisValue>(_ key: String, _ count: Int? = nil) async throws -> T {
        try await Cmd("LPOP").arg(key.to_redis_args()).arg(count.to_redis_args()).query(self)
    }
    /// Return the index of matching elements on a list
    /// # Available since
    /// 6.0.6
    /// # Time complexity
    /// O(N) where N is the number of elements in the list, for the average case. When searching for elements near the head or the tail of the list, or when the MAXLEN option is provided, the command may run in constant time.
    /// # Documentation
    /// view the docs for [LPOS](https://redis.io/commands/lpos)
    public func lpos<T: FromRedisValue>(
        _ key: String, _ element: String, _ rank: Int? = nil, numMatches: Int? = nil, len: Int? = nil
    ) async throws -> T {
        try await Cmd("LPOS").arg(key.to_redis_args()).arg(element.to_redis_args()).arg(rank.to_redis_args()).arg(
            numMatches.to_redis_args()
        ).arg(len.to_redis_args()).query(self)
    }
    /// Prepend one or multiple elements to a list
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
    /// # History
    /// - 2.4.0, Accepts multiple `element` arguments.
    /// # Documentation
    /// view the docs for [LPUSH](https://redis.io/commands/lpush)
    public func lpush<T: FromRedisValue>(_ key: String, _ element: String...) async throws -> T {
        try await Cmd("LPUSH").arg(key.to_redis_args()).arg(element.to_redis_args()).query(self)
    }
    /// Prepend an element to a list, only if the list exists
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
    /// # History
    /// - 4.0.0, Accepts multiple `element` arguments.
    /// # Documentation
    /// view the docs for [LPUSHX](https://redis.io/commands/lpushx)
    public func lpushx<T: FromRedisValue>(_ key: String, _ element: String...) async throws -> T {
        try await Cmd("LPUSHX").arg(key.to_redis_args()).arg(element.to_redis_args()).query(self)
    }
    /// Get a range of elements from a list
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(S+N) where S is the distance of start offset from HEAD for small lists, from nearest end (HEAD or TAIL) for large lists; and N is the number of elements in the specified range.
    /// # Documentation
    /// view the docs for [LRANGE](https://redis.io/commands/lrange)
    public func lrange<T: FromRedisValue>(_ key: String, _ start: Int, _ stop: Int) async throws -> T {
        try await Cmd("LRANGE").arg(key.to_redis_args()).arg(start.to_redis_args()).arg(stop.to_redis_args()).query(
            self)
    }
    /// Remove elements from a list
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N+M) where N is the length of the list and M is the number of elements removed.
    /// # Documentation
    /// view the docs for [LREM](https://redis.io/commands/lrem)
    public func lrem<T: FromRedisValue>(_ key: String, _ count: Int, _ element: String) async throws -> T {
        try await Cmd("LREM").arg(key.to_redis_args()).arg(count.to_redis_args()).arg(element.to_redis_args()).query(
            self)
    }
    /// Set the value of an element in a list by its index
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the length of the list. Setting either the first or the last element of the list is O(1).
    /// # Documentation
    /// view the docs for [LSET](https://redis.io/commands/lset)
    public func lset<T: FromRedisValue>(_ key: String, _ index: Int, _ element: String) async throws -> T {
        try await Cmd("LSET").arg(key.to_redis_args()).arg(index.to_redis_args()).arg(element.to_redis_args()).query(
            self)
    }
    /// Trim a list to the specified range
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of elements to be removed by the operation.
    /// # Documentation
    /// view the docs for [LTRIM](https://redis.io/commands/ltrim)
    public func ltrim<T: FromRedisValue>(_ key: String, _ start: Int, _ stop: Int) async throws -> T {
        try await Cmd("LTRIM").arg(key.to_redis_args()).arg(start.to_redis_args()).arg(stop.to_redis_args()).query(self)
    }
    /// A container for memory diagnostics commands
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [MEMORY](https://redis.io/commands/memory)
    public func memory<T: FromRedisValue>() async throws -> T { try await Cmd("MEMORY").query(self) }
    /// Get the values of all the given keys
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of keys to retrieve.
    /// # Documentation
    /// view the docs for [MGET](https://redis.io/commands/mget)
    public func mget<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("MGET").arg(key.to_redis_args()).query(self)
    }
    /// Atomically transfer a key from a Redis instance to another one.
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// This command actually executes a DUMP+DEL in the source instance, and a RESTORE in the target instance. See the pages of these commands for time complexity. Also an O(N) data transfer between the two instances is performed.
    /// # History
    /// - 3.0.0, Added the `COPY` and `REPLACE` options.
    /// - 3.0.6, Added the `KEYS` option.
    /// - 4.0.7, Added the `AUTH` option.
    /// - 6.0.0, Added the `AUTH2` option.
    /// # Documentation
    /// view the docs for [MIGRATE](https://redis.io/commands/migrate)
    public func migrate<T: FromRedisValue>(
        _ host: String, _ port: Int, _ keyOrEmptyString: MigrateKeyoremptystring, _ destinationDb: Int, _ timeout: Int,
        _ authentication: MigrateAuthentication? = nil, options: MigrateOptions? = nil, key: String?...
    ) async throws -> T {
        try await Cmd("MIGRATE").arg(host.to_redis_args()).arg(port.to_redis_args()).arg(
            keyOrEmptyString.to_redis_args()
        ).arg(destinationDb.to_redis_args()).arg(timeout.to_redis_args()).arg(authentication.to_redis_args()).arg(
            options.to_redis_args()
        ).arg(key.to_redis_args()).query(self)
    }
    public enum MigrateKeyoremptystring: ToRedisArgs {
        case KEY(String)
        case empty_string
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .KEY(let string): string.write_redis_args(out: &out)
            case .empty_string: out.append("\"\"".data(using: .utf8)!)
            }
        }
    }
    public enum MigrateAuthentication: ToRedisArgs {
        case AUTH(String)
        case AUTH2(Usernamepassword)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .AUTH(let string):
                out.append("AUTH".data(using: .utf8)!)
                string.write_redis_args(out: &out)
            case .AUTH2(let usernamepassword):
                out.append("AUTH2".data(using: .utf8)!)
                usernamepassword.write_redis_args(out: &out)
            }
        }
        public struct Usernamepassword: ToRedisArgs {
            let username: String
            let password: String
            public func write_redis_args(out: inout [Data]) {
                username.write_redis_args(out: &out)
                password.write_redis_args(out: &out)
            }
        }
    }
    public struct MigrateOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let COPY = MigrateOptions(rawValue: 1 << 0)
        static let REPLACE = MigrateOptions(rawValue: 1 << 1)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.COPY) { out.append("COPY".data(using: .utf8)!) }
            if self.contains(.REPLACE) { out.append("REPLACE".data(using: .utf8)!) }
        }
    }
    /// A container for module commands
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [MODULE](https://redis.io/commands/module)
    public func module<T: FromRedisValue>() async throws -> T { try await Cmd("MODULE").query(self) }
    /// Listen for all requests received by the server in real time
    /// # Available since
    /// 1.0.0
    /// # Documentation
    /// view the docs for [MONITOR](https://redis.io/commands/monitor)
    public func monitor<T: FromRedisValue>() async throws -> T { try await Cmd("MONITOR").query(self) }
    /// Move a key to another database
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MOVE](https://redis.io/commands/move)
    public func move<T: FromRedisValue>(_ key: String, _ db: Int) async throws -> T {
        try await Cmd("MOVE").arg(key.to_redis_args()).arg(db.to_redis_args()).query(self)
    }
    /// Set multiple keys to multiple values
    /// # Available since
    /// 1.0.1
    /// # Time complexity
    /// O(N) where N is the number of keys to set.
    /// # Documentation
    /// view the docs for [MSET](https://redis.io/commands/mset)
    public func mset<T: FromRedisValue>(_ keyValue: MsetKeyvalue...) async throws -> T {
        try await Cmd("MSET").arg(keyValue.to_redis_args()).query(self)
    }
    public struct MsetKeyvalue: ToRedisArgs {
        let key: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            key.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
    /// Set multiple keys to multiple values, only if none of the keys exist
    /// # Available since
    /// 1.0.1
    /// # Time complexity
    /// O(N) where N is the number of keys to set.
    /// # Documentation
    /// view the docs for [MSETNX](https://redis.io/commands/msetnx)
    public func msetnx<T: FromRedisValue>(_ keyValue: MsetnxKeyvalue...) async throws -> T {
        try await Cmd("MSETNX").arg(keyValue.to_redis_args()).query(self)
    }
    public struct MsetnxKeyvalue: ToRedisArgs {
        let key: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            key.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
    /// Mark the start of a transaction block
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [MULTI](https://redis.io/commands/multi)
    public func multi<T: FromRedisValue>() async throws -> T { try await Cmd("MULTI").query(self) }
    /// A container for object introspection commands
    /// # Available since
    /// 2.2.3
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [OBJECT](https://redis.io/commands/object)
    public func object<T: FromRedisValue>() async throws -> T { try await Cmd("OBJECT").query(self) }
    /// Remove the expiration from a key
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [PERSIST](https://redis.io/commands/persist)
    public func persist<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("PERSIST").arg(key.to_redis_args()).query(self)
    }
    /// Set a key's time to live in milliseconds
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added options: `NX`, `XX`, `GT` and `LT`.
    /// # Documentation
    /// view the docs for [PEXPIRE](https://redis.io/commands/pexpire)
    public func pexpire<T: FromRedisValue>(_ key: String, _ milliseconds: Int, _ condition: PexpireCondition? = nil)
        async throws -> T
    {
        try await Cmd("PEXPIRE").arg(key.to_redis_args()).arg(milliseconds.to_redis_args()).arg(
            condition.to_redis_args()
        ).query(self)
    }
    public enum PexpireCondition: ToRedisArgs {
        case NX
        case XX
        case GT
        case LT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .NX: out.append("NX".data(using: .utf8)!)
            case .XX: out.append("XX".data(using: .utf8)!)
            case .GT: out.append("GT".data(using: .utf8)!)
            case .LT: out.append("LT".data(using: .utf8)!)
            }
        }
    }
    /// Set the expiration for a key as a UNIX timestamp specified in milliseconds
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added options: `NX`, `XX`, `GT` and `LT`.
    /// # Documentation
    /// view the docs for [PEXPIREAT](https://redis.io/commands/pexpireat)
    public func pexpireat<T: FromRedisValue>(
        _ key: String, _ unixTimeMilliseconds: Int64, _ condition: PexpireatCondition? = nil
    ) async throws -> T {
        try await Cmd("PEXPIREAT").arg(key.to_redis_args()).arg(unixTimeMilliseconds.to_redis_args()).arg(
            condition.to_redis_args()
        ).query(self)
    }
    public enum PexpireatCondition: ToRedisArgs {
        case NX
        case XX
        case GT
        case LT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .NX: out.append("NX".data(using: .utf8)!)
            case .XX: out.append("XX".data(using: .utf8)!)
            case .GT: out.append("GT".data(using: .utf8)!)
            case .LT: out.append("LT".data(using: .utf8)!)
            }
        }
    }
    /// Get the expiration Unix timestamp for a key in milliseconds
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [PEXPIRETIME](https://redis.io/commands/pexpiretime)
    public func pexpiretime<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("PEXPIRETIME").arg(key.to_redis_args()).query(self)
    }
    /// Adds the specified elements to the specified HyperLogLog.
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// O(1) to add every element.
    /// # Documentation
    /// view the docs for [PFADD](https://redis.io/commands/pfadd)
    public func pfadd<T: FromRedisValue>(_ key: String, _ element: String?...) async throws -> T {
        try await Cmd("PFADD").arg(key.to_redis_args()).arg(element.to_redis_args()).query(self)
    }
    /// Return the approximated cardinality of the set(s) observed by the HyperLogLog at key(s).
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// O(1) with a very small average constant time when called with a single key. O(N) with N being the number of keys, and much bigger constant times, when called with multiple keys.
    /// # Documentation
    /// view the docs for [PFCOUNT](https://redis.io/commands/pfcount)
    public func pfcount<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("PFCOUNT").arg(key.to_redis_args()).query(self)
    }
    /// Internal commands for debugging HyperLogLog values
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// N/A
    /// # Documentation
    /// view the docs for [PFDEBUG](https://redis.io/commands/pfdebug)
    public func pfdebug<T: FromRedisValue>(_ subcommand: String, _ key: String) async throws -> T {
        try await Cmd("PFDEBUG").arg(subcommand.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    /// Merge N different HyperLogLogs into a single one.
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// O(N) to merge N HyperLogLogs, but with high constant times.
    /// # Documentation
    /// view the docs for [PFMERGE](https://redis.io/commands/pfmerge)
    public func pfmerge<T: FromRedisValue>(_ destkey: String, _ sourcekey: String...) async throws -> T {
        try await Cmd("PFMERGE").arg(destkey.to_redis_args()).arg(sourcekey.to_redis_args()).query(self)
    }
    /// An internal command for testing HyperLogLog values
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// N/A
    /// # Documentation
    /// view the docs for [PFSELFTEST](https://redis.io/commands/pfselftest)
    public func pfselftest<T: FromRedisValue>() async throws -> T { try await Cmd("PFSELFTEST").query(self) }
    /// Ping the server
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [PING](https://redis.io/commands/ping)
    public func ping<T: FromRedisValue>(_ message: String? = nil) async throws -> T {
        try await Cmd("PING").arg(message.to_redis_args()).query(self)
    }
    /// Set the value and expiration in milliseconds of a key
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [PSETEX](https://redis.io/commands/psetex)
    public func psetex<T: FromRedisValue>(_ key: String, _ milliseconds: Int, _ value: String) async throws -> T {
        try await Cmd("PSETEX").arg(key.to_redis_args()).arg(milliseconds.to_redis_args()).arg(value.to_redis_args())
            .query(self)
    }
    /// Listen for messages published to channels matching the given patterns
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the number of patterns the client is already subscribed to.
    /// # Documentation
    /// view the docs for [PSUBSCRIBE](https://redis.io/commands/psubscribe)
    public func psubscribe<T: FromRedisValue>(_ pattern: PsubscribePattern...) async throws -> T {
        try await Cmd("PSUBSCRIBE").arg(pattern.to_redis_args()).query(self)
    }
    public struct PsubscribePattern: ToRedisArgs {
        let pattern: String
        public func write_redis_args(out: inout [Data]) { pattern.write_redis_args(out: &out) }
    }
    /// Internal command used for replication
    /// # Available since
    /// 2.8.0
    /// # Documentation
    /// view the docs for [PSYNC](https://redis.io/commands/psync)
    public func psync<T: FromRedisValue>(_ replicationid: String, _ offset: Int) async throws -> T {
        try await Cmd("PSYNC").arg(replicationid.to_redis_args()).arg(offset.to_redis_args()).query(self)
    }
    /// Get the time to live for a key in milliseconds
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 2.8.0, Added the -2 reply.
    /// # Documentation
    /// view the docs for [PTTL](https://redis.io/commands/pttl)
    public func pttl<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("PTTL").arg(key.to_redis_args()).query(self)
    }
    /// Post a message to a channel
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N+M) where N is the number of clients subscribed to the receiving channel and M is the total number of subscribed patterns (by any client).
    /// # Documentation
    /// view the docs for [PUBLISH](https://redis.io/commands/publish)
    public func publish<T: FromRedisValue>(_ channel: String, _ message: String) async throws -> T {
        try await Cmd("PUBLISH").arg(channel.to_redis_args()).arg(message.to_redis_args()).query(self)
    }
    /// A container for Pub/Sub commands
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [PUBSUB](https://redis.io/commands/pubsub)
    public func pubsub<T: FromRedisValue>() async throws -> T { try await Cmd("PUBSUB").query(self) }
    /// Stop listening for messages posted to channels matching the given patterns
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N+M) where N is the number of patterns the client is already subscribed and M is the number of total patterns subscribed in the system (by any client).
    /// # Documentation
    /// view the docs for [PUNSUBSCRIBE](https://redis.io/commands/punsubscribe)
    public func punsubscribe<T: FromRedisValue>(_ pattern: String?...) async throws -> T {
        try await Cmd("PUNSUBSCRIBE").arg(pattern.to_redis_args()).query(self)
    }
    /// Close the connection
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [QUIT](https://redis.io/commands/quit)
    public func quit<T: FromRedisValue>() async throws -> T { try await Cmd("QUIT").query(self) }
    /// Return a random key from the keyspace
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [RANDOMKEY](https://redis.io/commands/randomkey)
    public func randomkey<T: FromRedisValue>() async throws -> T { try await Cmd("RANDOMKEY").query(self) }
    /// Enables read queries for a connection to a cluster replica node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [READONLY](https://redis.io/commands/readonly)
    public func readonly<T: FromRedisValue>() async throws -> T { try await Cmd("READONLY").query(self) }
    /// Disables read queries for a connection to a cluster replica node
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [READWRITE](https://redis.io/commands/readwrite)
    public func readwrite<T: FromRedisValue>() async throws -> T { try await Cmd("READWRITE").query(self) }
    /// Rename a key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [RENAME](https://redis.io/commands/rename)
    public func rename<T: FromRedisValue>(_ key: String, _ newkey: String) async throws -> T {
        try await Cmd("RENAME").arg(key.to_redis_args()).arg(newkey.to_redis_args()).query(self)
    }
    /// Rename a key, only if the new key does not exist
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 3.2.0, The command no longer returns an error when source and destination names are the same.
    /// # Documentation
    /// view the docs for [RENAMENX](https://redis.io/commands/renamenx)
    public func renamenx<T: FromRedisValue>(_ key: String, _ newkey: String) async throws -> T {
        try await Cmd("RENAMENX").arg(key.to_redis_args()).arg(newkey.to_redis_args()).query(self)
    }
    /// An internal command for configuring the replication stream
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [REPLCONF](https://redis.io/commands/replconf)
    public func replconf<T: FromRedisValue>() async throws -> T { try await Cmd("REPLCONF").query(self) }
    /// Make the server a replica of another instance, or promote it as master.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [REPLICAOF](https://redis.io/commands/replicaof)
    public func replicaof<T: FromRedisValue>(_ host: String, _ port: Int) async throws -> T {
        try await Cmd("REPLICAOF").arg(host.to_redis_args()).arg(port.to_redis_args()).query(self)
    }
    /// Reset the connection
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [RESET](https://redis.io/commands/reset)
    public func reset<T: FromRedisValue>() async throws -> T { try await Cmd("RESET").query(self) }
    /// Create a key using the provided serialized value, previously obtained using DUMP.
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1) to create the new key and additional O(N*M) to reconstruct the serialized value, where N is the number of Redis objects composing the value and M their average size. For small string values the time complexity is thus O(1)+O(1*M) where M is small, so simply O(1). However for sorted set values the complexity is O(N*M*log(N)) because inserting values into sorted sets is O(log(N)).
    /// # History
    /// - 3.0.0, Added the `REPLACE` modifier.
    /// - 5.0.0, Added the `ABSTTL` modifier.
    /// - 5.0.0, Added the `IDLETIME` and `FREQ` options.
    /// # Documentation
    /// view the docs for [RESTORE](https://redis.io/commands/restore)
    public func restore<T: FromRedisValue>(
        _ key: String, _ ttl: Int, _ serializedValue: String, _ seconds: Int? = nil, frequency: Int? = nil,
        options: RestoreOptions? = nil
    ) async throws -> T {
        try await Cmd("RESTORE").arg(key.to_redis_args()).arg(ttl.to_redis_args()).arg(serializedValue.to_redis_args())
            .arg(seconds.to_redis_args()).arg(frequency.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public struct RestoreOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let REPLACE = RestoreOptions(rawValue: 1 << 0)
        static let ABSTTL = RestoreOptions(rawValue: 1 << 1)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.REPLACE) { out.append("REPLACE".data(using: .utf8)!) }
            if self.contains(.ABSTTL) { out.append("ABSTTL".data(using: .utf8)!) }
        }
    }
    /// An internal command for migrating keys in a cluster
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1) to create the new key and additional O(N*M) to reconstruct the serialized value, where N is the number of Redis objects composing the value and M their average size. For small string values the time complexity is thus O(1)+O(1*M) where M is small, so simply O(1). However for sorted set values the complexity is O(N*M*log(N)) because inserting values into sorted sets is O(log(N)).
    /// # History
    /// - 3.0.0, Added the `REPLACE` modifier.
    /// - 5.0.0, Added the `ABSTTL` modifier.
    /// - 5.0.0, Added the `IDLETIME` and `FREQ` options.
    /// # Documentation
    /// view the docs for [RESTORE_ASKING](https://redis.io/commands/restore-asking)
    public func restore_asking<T: FromRedisValue>(
        _ key: String, _ ttl: Int, _ serializedValue: String, _ seconds: Int? = nil, frequency: Int? = nil,
        options: RestoreAskingOptions? = nil
    ) async throws -> T {
        try await Cmd("RESTORE_ASKING").arg(key.to_redis_args()).arg(ttl.to_redis_args()).arg(
            serializedValue.to_redis_args()
        ).arg(seconds.to_redis_args()).arg(frequency.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public struct RestoreAskingOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let REPLACE = RestoreAskingOptions(rawValue: 1 << 0)
        static let ABSTTL = RestoreAskingOptions(rawValue: 1 << 1)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.REPLACE) { out.append("REPLACE".data(using: .utf8)!) }
            if self.contains(.ABSTTL) { out.append("ABSTTL".data(using: .utf8)!) }
        }
    }
    /// Return the role of the instance in the context of replication
    /// # Available since
    /// 2.8.12
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [ROLE](https://redis.io/commands/role)
    public func role<T: FromRedisValue>() async throws -> T { try await Cmd("ROLE").query(self) }
    /// Remove and get the last elements in a list
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of elements returned
    /// # History
    /// - 6.2.0, Added the `count` argument.
    /// # Documentation
    /// view the docs for [RPOP](https://redis.io/commands/rpop)
    public func rpop<T: FromRedisValue>(_ key: String, _ count: Int? = nil) async throws -> T {
        try await Cmd("RPOP").arg(key.to_redis_args()).arg(count.to_redis_args()).query(self)
    }
    /// Remove the last element in a list, prepend it to another list and return it
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [RPOPLPUSH](https://redis.io/commands/rpoplpush)
    public func rpoplpush<T: FromRedisValue>(_ source: String, _ destination: String) async throws -> T {
        try await Cmd("RPOPLPUSH").arg(source.to_redis_args()).arg(destination.to_redis_args()).query(self)
    }
    /// Append one or multiple elements to a list
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
    /// # History
    /// - 2.4.0, Accepts multiple `element` arguments.
    /// # Documentation
    /// view the docs for [RPUSH](https://redis.io/commands/rpush)
    public func rpush<T: FromRedisValue>(_ key: String, _ element: String...) async throws -> T {
        try await Cmd("RPUSH").arg(key.to_redis_args()).arg(element.to_redis_args()).query(self)
    }
    /// Append an element to a list, only if the list exists
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
    /// # History
    /// - 4.0.0, Accepts multiple `element` arguments.
    /// # Documentation
    /// view the docs for [RPUSHX](https://redis.io/commands/rpushx)
    public func rpushx<T: FromRedisValue>(_ key: String, _ element: String...) async throws -> T {
        try await Cmd("RPUSHX").arg(key.to_redis_args()).arg(element.to_redis_args()).query(self)
    }
    /// Add one or more members to a set
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1) for each element added, so O(N) to add N elements when the command is called with multiple arguments.
    /// # History
    /// - 2.4.0, Accepts multiple `member` arguments.
    /// # Documentation
    /// view the docs for [SADD](https://redis.io/commands/sadd)
    public func sadd<T: FromRedisValue>(_ key: String, _ member: String...) async throws -> T {
        try await Cmd("SADD").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Synchronously save the dataset to disk
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the total number of keys in all databases
    /// # Documentation
    /// view the docs for [SAVE](https://redis.io/commands/save)
    public func save<T: FromRedisValue>() async throws -> T { try await Cmd("SAVE").query(self) }
    /// Incrementally iterate the keys space
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection.
    /// # History
    /// - 6.0.0, Added the `TYPE` subcommand.
    /// # Documentation
    /// view the docs for [SCAN](https://redis.io/commands/scan)
    public func scan<T: FromRedisValue>(_ cursor: Int, _ pattern: String? = nil, count: Int? = nil, type: String? = nil)
        async throws -> T
    {
        try await Cmd("SCAN").arg(cursor.to_redis_args()).arg(pattern.to_redis_args()).arg(count.to_redis_args()).arg(
            type.to_redis_args()
        ).query(self)
    }
    /// Get the number of members in a set
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SCARD](https://redis.io/commands/scard)
    public func scard<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("SCARD").arg(key.to_redis_args()).query(self)
    }
    /// A container for Lua scripts management commands
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [SCRIPT](https://redis.io/commands/script)
    public func script<T: FromRedisValue>() async throws -> T { try await Cmd("SCRIPT").query(self) }
    /// Subtract multiple sets
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the total number of elements in all given sets.
    /// # Documentation
    /// view the docs for [SDIFF](https://redis.io/commands/sdiff)
    public func sdiff<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("SDIFF").arg(key.to_redis_args()).query(self)
    }
    /// Subtract multiple sets and store the resulting set in a key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the total number of elements in all given sets.
    /// # Documentation
    /// view the docs for [SDIFFSTORE](https://redis.io/commands/sdiffstore)
    public func sdiffstore<T: FromRedisValue>(_ destination: String, _ key: String...) async throws -> T {
        try await Cmd("SDIFFSTORE").arg(destination.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    /// Change the selected database for the current connection
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SELECT](https://redis.io/commands/select)
    public func select<T: FromRedisValue>(_ index: Int) async throws -> T {
        try await Cmd("SELECT").arg(index.to_redis_args()).query(self)
    }
    /// A container for Sentinel commands
    /// # Available since
    /// 2.8.4
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [SENTINEL](https://redis.io/commands/sentinel)
    public func sentinel<T: FromRedisValue>() async throws -> T { try await Cmd("SENTINEL").query(self) }
    /// Set the string value of a key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 2.6.12, Added the `EX`, `PX`, `NX` and `XX` options.
    /// - 6.0.0, Added the `KEEPTTL` option.
    /// - 6.2.0, Added the `GET`, `EXAT` and `PXAT` option.
    /// - 7.0.0, Allowed the `NX` and `GET` options to be used together.
    /// # Documentation
    /// view the docs for [SET](https://redis.io/commands/set)
    public func set<T: FromRedisValue>(
        _ key: String, _ value: String, _ condition: SetCondition? = nil, expiration: SetExpiration? = nil,
        options: SetOptions? = nil
    ) async throws -> T {
        try await Cmd("SET").arg(key.to_redis_args()).arg(value.to_redis_args()).arg(condition.to_redis_args()).arg(
            expiration.to_redis_args()
        ).arg(options.to_redis_args()).query(self)
    }
    public enum SetCondition: ToRedisArgs {
        case NX
        case XX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .NX: out.append("NX".data(using: .utf8)!)
            case .XX: out.append("XX".data(using: .utf8)!)
            }
        }
    }
    public enum SetExpiration: ToRedisArgs {
        case EX(Int)
        case PX(Int)
        case EXAT(Int64)
        case PXAT(Int64)
        case KEEPTTL
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .EX(let int):
                out.append("EX".data(using: .utf8)!)
                int.write_redis_args(out: &out)
            case .PX(let int):
                out.append("PX".data(using: .utf8)!)
                int.write_redis_args(out: &out)
            case .EXAT(let int64):
                out.append("EXAT".data(using: .utf8)!)
                int64.write_redis_args(out: &out)
            case .PXAT(let int64):
                out.append("PXAT".data(using: .utf8)!)
                int64.write_redis_args(out: &out)
            case .KEEPTTL: out.append("KEEPTTL".data(using: .utf8)!)
            }
        }
    }
    public struct SetOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let GET = SetOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.GET) { out.append("GET".data(using: .utf8)!) }
        }
    }
    /// Sets or clears the bit at offset in the string value stored at key
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SETBIT](https://redis.io/commands/setbit)
    public func setbit<T: FromRedisValue>(_ key: String, _ offset: Int, _ value: Int) async throws -> T {
        try await Cmd("SETBIT").arg(key.to_redis_args()).arg(offset.to_redis_args()).arg(value.to_redis_args()).query(
            self)
    }
    /// Set the value and expiration of a key
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SETEX](https://redis.io/commands/setex)
    public func setex<T: FromRedisValue>(_ key: String, _ seconds: Int, _ value: String) async throws -> T {
        try await Cmd("SETEX").arg(key.to_redis_args()).arg(seconds.to_redis_args()).arg(value.to_redis_args()).query(
            self)
    }
    /// Set the value of a key, only if the key does not exist
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SETNX](https://redis.io/commands/setnx)
    public func setnx<T: FromRedisValue>(_ key: String, _ value: String) async throws -> T {
        try await Cmd("SETNX").arg(key.to_redis_args()).arg(value.to_redis_args()).query(self)
    }
    /// Overwrite part of a string at key starting at the specified offset
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1), not counting the time taken to copy the new string in place. Usually, this string is very small so the amortized complexity is O(1). Otherwise, complexity is O(M) with M being the length of the value argument.
    /// # Documentation
    /// view the docs for [SETRANGE](https://redis.io/commands/setrange)
    public func setrange<T: FromRedisValue>(_ key: String, _ offset: Int, _ value: String) async throws -> T {
        try await Cmd("SETRANGE").arg(key.to_redis_args()).arg(offset.to_redis_args()).arg(value.to_redis_args()).query(
            self)
    }
    /// Synchronously save the dataset to disk and then shut down the server
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) when saving, where N is the total number of keys in all databases when saving data, otherwise O(1)
    /// # History
    /// - 7.0.0, Added the `NOW`, `FORCE` and `ABORT` modifiers.
    /// # Documentation
    /// view the docs for [SHUTDOWN](https://redis.io/commands/shutdown)
    public func shutdown<T: FromRedisValue>(_ nosaveSave: ShutdownNosavesave? = nil, options: ShutdownOptions? = nil)
        async throws -> T
    { try await Cmd("SHUTDOWN").arg(nosaveSave.to_redis_args()).arg(options.to_redis_args()).query(self) }
    public enum ShutdownNosavesave: ToRedisArgs {
        case NOSAVE
        case SAVE
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .NOSAVE: out.append("NOSAVE".data(using: .utf8)!)
            case .SAVE: out.append("SAVE".data(using: .utf8)!)
            }
        }
    }
    public struct ShutdownOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let NOW = ShutdownOptions(rawValue: 1 << 0)
        static let FORCE = ShutdownOptions(rawValue: 1 << 1)
        static let ABORT = ShutdownOptions(rawValue: 1 << 2)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.NOW) { out.append("NOW".data(using: .utf8)!) }
            if self.contains(.FORCE) { out.append("FORCE".data(using: .utf8)!) }
            if self.contains(.ABORT) { out.append("ABORT".data(using: .utf8)!) }
        }
    }
    /// Intersect multiple sets
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N*M) worst case where N is the cardinality of the smallest set and M is the number of sets.
    /// # Documentation
    /// view the docs for [SINTER](https://redis.io/commands/sinter)
    public func sinter<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("SINTER").arg(key.to_redis_args()).query(self)
    }
    /// Intersect multiple sets and return the cardinality of the result
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N*M) worst case where N is the cardinality of the smallest set and M is the number of sets.
    /// # Documentation
    /// view the docs for [SINTERCARD](https://redis.io/commands/sintercard)
    public func sintercard<T: FromRedisValue>(_ numkeys: Int, _ limit: Int? = nil, key: String...) async throws -> T {
        try await Cmd("SINTERCARD").arg(numkeys.to_redis_args()).arg(limit.to_redis_args()).arg(key.to_redis_args())
            .query(self)
    }
    /// Intersect multiple sets and store the resulting set in a key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N*M) worst case where N is the cardinality of the smallest set and M is the number of sets.
    /// # Documentation
    /// view the docs for [SINTERSTORE](https://redis.io/commands/sinterstore)
    public func sinterstore<T: FromRedisValue>(_ destination: String, _ key: String...) async throws -> T {
        try await Cmd("SINTERSTORE").arg(destination.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    /// Determine if a given value is a member of a set
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SISMEMBER](https://redis.io/commands/sismember)
    public func sismember<T: FromRedisValue>(_ key: String, _ member: String) async throws -> T {
        try await Cmd("SISMEMBER").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Make the server a replica of another instance, or promote it as master.
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SLAVEOF](https://redis.io/commands/slaveof)
    public func slaveof<T: FromRedisValue>(_ host: String, _ port: Int) async throws -> T {
        try await Cmd("SLAVEOF").arg(host.to_redis_args()).arg(port.to_redis_args()).query(self)
    }
    /// A container for slow log commands
    /// # Available since
    /// 2.2.12
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [SLOWLOG](https://redis.io/commands/slowlog)
    public func slowlog<T: FromRedisValue>() async throws -> T { try await Cmd("SLOWLOG").query(self) }
    /// Get all the members in a set
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the set cardinality.
    /// # Documentation
    /// view the docs for [SMEMBERS](https://redis.io/commands/smembers)
    public func smembers<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("SMEMBERS").arg(key.to_redis_args()).query(self)
    }
    /// Returns the membership associated with the given elements for a set
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N) where N is the number of elements being checked for membership
    /// # Documentation
    /// view the docs for [SMISMEMBER](https://redis.io/commands/smismember)
    public func smismember<T: FromRedisValue>(_ key: String, _ member: String...) async throws -> T {
        try await Cmd("SMISMEMBER").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Move a member from one set to another
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [SMOVE](https://redis.io/commands/smove)
    public func smove<T: FromRedisValue>(_ source: String, _ destination: String, _ member: String) async throws -> T {
        try await Cmd("SMOVE").arg(source.to_redis_args()).arg(destination.to_redis_args()).arg(member.to_redis_args())
            .query(self)
    }
    /// Sort the elements in a list, set or sorted set
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N+M*log(M)) where N is the number of elements in the list or set to sort, and M the number of returned elements. When the elements are not sorted, complexity is O(N).
    /// # Documentation
    /// view the docs for [SORT](https://redis.io/commands/sort)
    public func sort<T: FromRedisValue>(
        _ key: String, _ pattern: String? = nil, offsetCount: SortOffsetcount? = nil, order: SortOrder? = nil,
        destination: String? = nil, options: SortOptions? = nil, GET: String?...
    ) async throws -> T {
        try await Cmd("SORT").arg(key.to_redis_args()).arg(pattern.to_redis_args()).arg(offsetCount.to_redis_args())
            .arg(order.to_redis_args()).arg(destination.to_redis_args()).arg(options.to_redis_args()).arg(
                GET.to_redis_args()
            ).query(self)
    }
    public struct SortOffsetcount: ToRedisArgs {
        let offset: Int
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            offset.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
    }
    public enum SortOrder: ToRedisArgs {
        case ASC
        case DESC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASC: out.append("ASC".data(using: .utf8)!)
            case .DESC: out.append("DESC".data(using: .utf8)!)
            }
        }
    }
    public struct SortOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let ALPHA = SortOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.ALPHA) { out.append("ALPHA".data(using: .utf8)!) }
        }
    }
    /// Sort the elements in a list, set or sorted set. Read-only variant of SORT.
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N+M*log(M)) where N is the number of elements in the list or set to sort, and M the number of returned elements. When the elements are not sorted, complexity is O(N).
    /// # Documentation
    /// view the docs for [SORT_RO](https://redis.io/commands/sort-ro)
    public func sort_ro<T: FromRedisValue>(
        _ key: String, _ pattern: String? = nil, offsetCount: SortRoOffsetcount? = nil, order: SortRoOrder? = nil,
        options: SortRoOptions? = nil, GET: String?...
    ) async throws -> T {
        try await Cmd("SORT_RO").arg(key.to_redis_args()).arg(pattern.to_redis_args()).arg(offsetCount.to_redis_args())
            .arg(order.to_redis_args()).arg(options.to_redis_args()).arg(GET.to_redis_args()).query(self)
    }
    public struct SortRoOffsetcount: ToRedisArgs {
        let offset: Int
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            offset.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
    }
    public enum SortRoOrder: ToRedisArgs {
        case ASC
        case DESC
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .ASC: out.append("ASC".data(using: .utf8)!)
            case .DESC: out.append("DESC".data(using: .utf8)!)
            }
        }
    }
    public struct SortRoOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let ALPHA = SortRoOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.ALPHA) { out.append("ALPHA".data(using: .utf8)!) }
        }
    }
    /// Remove and return one or multiple random members from a set
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// Without the count argument O(1), otherwise O(N) where N is the value of the passed count.
    /// # History
    /// - 3.2.0, Added the `count` argument.
    /// # Documentation
    /// view the docs for [SPOP](https://redis.io/commands/spop)
    public func spop<T: FromRedisValue>(_ key: String, _ count: Int? = nil) async throws -> T {
        try await Cmd("SPOP").arg(key.to_redis_args()).arg(count.to_redis_args()).query(self)
    }
    /// Post a message to a shard channel
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of clients subscribed to the receiving shard channel.
    /// # Documentation
    /// view the docs for [SPUBLISH](https://redis.io/commands/spublish)
    public func spublish<T: FromRedisValue>(_ shardchannel: String, _ message: String) async throws -> T {
        try await Cmd("SPUBLISH").arg(shardchannel.to_redis_args()).arg(message.to_redis_args()).query(self)
    }
    /// Get one or multiple random members from a set
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// Without the count argument O(1), otherwise O(N) where N is the absolute value of the passed count.
    /// # History
    /// - 2.6.0, Added the optional `count` argument.
    /// # Documentation
    /// view the docs for [SRANDMEMBER](https://redis.io/commands/srandmember)
    public func srandmember<T: FromRedisValue>(_ key: String, _ count: Int? = nil) async throws -> T {
        try await Cmd("SRANDMEMBER").arg(key.to_redis_args()).arg(count.to_redis_args()).query(self)
    }
    /// Remove one or more members from a set
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the number of members to be removed.
    /// # History
    /// - 2.4.0, Accepts multiple `member` arguments.
    /// # Documentation
    /// view the docs for [SREM](https://redis.io/commands/srem)
    public func srem<T: FromRedisValue>(_ key: String, _ member: String...) async throws -> T {
        try await Cmd("SREM").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Incrementally iterate Set elements
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection..
    /// # Documentation
    /// view the docs for [SSCAN](https://redis.io/commands/sscan)
    public func sscan<T: FromRedisValue>(_ key: String, _ cursor: Int, _ pattern: String? = nil, count: Int? = nil)
        async throws -> T
    {
        try await Cmd("SSCAN").arg(key.to_redis_args()).arg(cursor.to_redis_args()).arg(pattern.to_redis_args()).arg(
            count.to_redis_args()
        ).query(self)
    }
    /// Listen for messages published to the given shard channels
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of shard channels to subscribe to.
    /// # Documentation
    /// view the docs for [SSUBSCRIBE](https://redis.io/commands/ssubscribe)
    public func ssubscribe<T: FromRedisValue>(_ shardchannel: String...) async throws -> T {
        try await Cmd("SSUBSCRIBE").arg(shardchannel.to_redis_args()).query(self)
    }
    /// Get the length of the value stored in a key
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [STRLEN](https://redis.io/commands/strlen)
    public func strlen<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("STRLEN").arg(key.to_redis_args()).query(self)
    }
    /// Listen for messages published to the given channels
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the number of channels to subscribe to.
    /// # Documentation
    /// view the docs for [SUBSCRIBE](https://redis.io/commands/subscribe)
    public func subscribe<T: FromRedisValue>(_ channel: String...) async throws -> T {
        try await Cmd("SUBSCRIBE").arg(channel.to_redis_args()).query(self)
    }
    /// Get a substring of the string stored at a key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the length of the returned string. The complexity is ultimately determined by the returned length, but because creating a substring from an existing string is very cheap, it can be considered O(1) for small strings.
    /// # Documentation
    /// view the docs for [SUBSTR](https://redis.io/commands/substr)
    public func substr<T: FromRedisValue>(_ key: String, _ start: Int, _ end: Int) async throws -> T {
        try await Cmd("SUBSTR").arg(key.to_redis_args()).arg(start.to_redis_args()).arg(end.to_redis_args()).query(self)
    }
    /// Add multiple sets
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the total number of elements in all given sets.
    /// # Documentation
    /// view the docs for [SUNION](https://redis.io/commands/sunion)
    public func sunion<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("SUNION").arg(key.to_redis_args()).query(self)
    }
    /// Add multiple sets and store the resulting set in a key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(N) where N is the total number of elements in all given sets.
    /// # Documentation
    /// view the docs for [SUNIONSTORE](https://redis.io/commands/sunionstore)
    public func sunionstore<T: FromRedisValue>(_ destination: String, _ key: String...) async throws -> T {
        try await Cmd("SUNIONSTORE").arg(destination.to_redis_args()).arg(key.to_redis_args()).query(self)
    }
    /// Stop listening for messages posted to the given shard channels
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N) where N is the number of clients already subscribed to a shard channel.
    /// # Documentation
    /// view the docs for [SUNSUBSCRIBE](https://redis.io/commands/sunsubscribe)
    public func sunsubscribe<T: FromRedisValue>(_ shardchannel: String?...) async throws -> T {
        try await Cmd("SUNSUBSCRIBE").arg(shardchannel.to_redis_args()).query(self)
    }
    /// Swaps two Redis databases
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(N) where N is the count of clients watching or blocking on keys from both databases.
    /// # Documentation
    /// view the docs for [SWAPDB](https://redis.io/commands/swapdb)
    public func swapdb<T: FromRedisValue>(_ index1: Int, _ index2: Int) async throws -> T {
        try await Cmd("SWAPDB").arg(index1.to_redis_args()).arg(index2.to_redis_args()).query(self)
    }
    /// Internal command used for replication
    /// # Available since
    /// 1.0.0
    /// # Documentation
    /// view the docs for [SYNC](https://redis.io/commands/sync)
    public func sync<T: FromRedisValue>() async throws -> T { try await Cmd("SYNC").query(self) }
    /// Return the current server time
    /// # Available since
    /// 2.6.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [TIME](https://redis.io/commands/time)
    public func time<T: FromRedisValue>() async throws -> T { try await Cmd("TIME").query(self) }
    /// Alters the last access time of a key(s). Returns the number of existing keys specified.
    /// # Available since
    /// 3.2.1
    /// # Time complexity
    /// O(N) where N is the number of keys that will be touched.
    /// # Documentation
    /// view the docs for [TOUCH](https://redis.io/commands/touch)
    public func touch<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("TOUCH").arg(key.to_redis_args()).query(self)
    }
    /// Get the time to live for a key in seconds
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 2.8.0, Added the -2 reply.
    /// # Documentation
    /// view the docs for [TTL](https://redis.io/commands/ttl)
    public func ttl<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("TTL").arg(key.to_redis_args()).query(self)
    }
    /// Determine the type stored at key
    /// # Available since
    /// 1.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [TYPE](https://redis.io/commands/type)
    public func type<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("TYPE").arg(key.to_redis_args()).query(self)
    }
    /// Delete a key asynchronously in another thread. Otherwise it is just as DEL, but non blocking.
    /// # Available since
    /// 4.0.0
    /// # Time complexity
    /// O(1) for each key removed regardless of its size. Then the command does O(N) work in a different thread in order to reclaim memory, where N is the number of allocations the deleted objects where composed of.
    /// # Documentation
    /// view the docs for [UNLINK](https://redis.io/commands/unlink)
    public func unlink<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("UNLINK").arg(key.to_redis_args()).query(self)
    }
    /// Stop listening for messages posted to the given channels
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N) where N is the number of clients already subscribed to a channel.
    /// # Documentation
    /// view the docs for [UNSUBSCRIBE](https://redis.io/commands/unsubscribe)
    public func unsubscribe<T: FromRedisValue>(_ channel: String?...) async throws -> T {
        try await Cmd("UNSUBSCRIBE").arg(channel.to_redis_args()).query(self)
    }
    /// Forget about all watched keys
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [UNWATCH](https://redis.io/commands/unwatch)
    public func unwatch<T: FromRedisValue>() async throws -> T { try await Cmd("UNWATCH").query(self) }
    /// Wait for the synchronous replication of all the write commands sent in the context of the current connection
    /// # Available since
    /// 3.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [WAIT](https://redis.io/commands/wait)
    public func wait<T: FromRedisValue>(_ numreplicas: Int, _ timeout: Int) async throws -> T {
        try await Cmd("WAIT").arg(numreplicas.to_redis_args()).arg(timeout.to_redis_args()).query(self)
    }
    /// Watch the given keys to determine execution of the MULTI/EXEC block
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(1) for every key.
    /// # Documentation
    /// view the docs for [WATCH](https://redis.io/commands/watch)
    public func watch<T: FromRedisValue>(_ key: String...) async throws -> T {
        try await Cmd("WATCH").arg(key.to_redis_args()).query(self)
    }
    /// Marks a pending message as correctly processed, effectively removing it from the pending entries list of the consumer group. Return value of the command is the number of messages successfully acknowledged, that is, the IDs we were actually able to resolve in the PEL.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1) for each message ID processed.
    /// # Documentation
    /// view the docs for [XACK](https://redis.io/commands/xack)
    public func xack<T: FromRedisValue>(_ key: String, _ group: String, _ id: String...) async throws -> T {
        try await Cmd("XACK").arg(key.to_redis_args()).arg(group.to_redis_args()).arg(id.to_redis_args()).query(self)
    }
    /// Appends a new entry to a stream
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1) when adding a new entry, O(N) when trimming where N being the number of entries evicted.
    /// # History
    /// - 6.2.0, Added the `NOMKSTREAM` option, `MINID` trimming strategy and the `LIMIT` option.
    /// - 7.0.0, Added support for the `<ms>-*` explicit ID form.
    /// # Documentation
    /// view the docs for [XADD](https://redis.io/commands/xadd)
    public func xadd<T: FromRedisValue>(
        _ key: String, _ trim: XaddTrim? = nil, idOrAuto: XaddIdorauto, _ options: XaddOptions? = nil,
        fieldValue: XaddFieldvalue...
    ) async throws -> T {
        try await Cmd("XADD").arg(key.to_redis_args()).arg(trim.to_redis_args()).arg(idOrAuto.to_redis_args()).arg(
            options.to_redis_args()
        ).arg(fieldValue.to_redis_args()).query(self)
    }
    public struct XaddTrim: ToRedisArgs {
        let strategy: Strategy
        let asdasdad: Asdasdad
        let threshold: String
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            strategy.write_redis_args(out: &out)
            asdasdad.write_redis_args(out: &out)
            threshold.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
        public enum Strategy: ToRedisArgs {
            case MAXLEN
            case MINID
            public func write_redis_args(out: inout [Data]) {
                switch self {
                case .MAXLEN: out.append("MAXLEN".data(using: .utf8)!)
                case .MINID: out.append("MINID".data(using: .utf8)!)
                }
            }
        }
        public enum Asdasdad: ToRedisArgs {
            case equal
            case approximately
            public func write_redis_args(out: inout [Data]) {
                switch self {
                case .equal: out.append("=".data(using: .utf8)!)
                case .approximately: out.append("~".data(using: .utf8)!)
                }
            }
        }
    }
    public enum XaddIdorauto: ToRedisArgs {
        case auto_id
        case ID(String)
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .auto_id: out.append("*".data(using: .utf8)!)
            case .ID(let string): string.write_redis_args(out: &out)
            }
        }
    }
    public struct XaddOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let NOMKSTREAM = XaddOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.NOMKSTREAM) { out.append("NOMKSTREAM".data(using: .utf8)!) }
        }
    }
    public struct XaddFieldvalue: ToRedisArgs {
        let field: String
        let value: String
        public func write_redis_args(out: inout [Data]) {
            field.write_redis_args(out: &out)
            value.write_redis_args(out: &out)
        }
    }
    /// Changes (or acquires) ownership of messages in a consumer group, as if the messages were delivered to the specified consumer.
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(1) if COUNT is small.
    /// # History
    /// - 7.0.0, Added an element to the reply array, containing deleted entries the command cleared from the PEL
    /// # Documentation
    /// view the docs for [XAUTOCLAIM](https://redis.io/commands/xautoclaim)
    public func xautoclaim<T: FromRedisValue>(
        _ key: String, _ group: String, _ consumer: String, _ minIdleTime: String, _ start: String, _ count: Int? = nil,
        options: XautoclaimOptions? = nil
    ) async throws -> T {
        try await Cmd("XAUTOCLAIM").arg(key.to_redis_args()).arg(group.to_redis_args()).arg(consumer.to_redis_args())
            .arg(minIdleTime.to_redis_args()).arg(start.to_redis_args()).arg(count.to_redis_args()).arg(
                options.to_redis_args()
            ).query(self)
    }
    public struct XautoclaimOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let JUSTID = XautoclaimOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.JUSTID) { out.append("JUSTID".data(using: .utf8)!) }
        }
    }
    /// Changes (or acquires) ownership of a message in a consumer group, as if the message was delivered to the specified consumer.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(log N) with N being the number of messages in the PEL of the consumer group.
    /// # Documentation
    /// view the docs for [XCLAIM](https://redis.io/commands/xclaim)
    public func xclaim<T: FromRedisValue>(
        _ key: String, _ group: String, _ consumer: String, _ minIdleTime: String, _ ms: Int? = nil,
        unixTimeMilliseconds: Int64? = nil, count: Int? = nil, options: XclaimOptions? = nil, id: String...
    ) async throws -> T {
        try await Cmd("XCLAIM").arg(key.to_redis_args()).arg(group.to_redis_args()).arg(consumer.to_redis_args()).arg(
            minIdleTime.to_redis_args()
        ).arg(ms.to_redis_args()).arg(unixTimeMilliseconds.to_redis_args()).arg(count.to_redis_args()).arg(
            options.to_redis_args()
        ).arg(id.to_redis_args()).query(self)
    }
    public struct XclaimOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let FORCE = XclaimOptions(rawValue: 1 << 0)
        static let JUSTID = XclaimOptions(rawValue: 1 << 1)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.FORCE) { out.append("FORCE".data(using: .utf8)!) }
            if self.contains(.JUSTID) { out.append("JUSTID".data(using: .utf8)!) }
        }
    }
    /// Removes the specified entries from the stream. Returns the number of items actually deleted, that may be different from the number of IDs passed in case certain IDs do not exist.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1) for each single item to delete in the stream, regardless of the stream size.
    /// # Documentation
    /// view the docs for [XDEL](https://redis.io/commands/xdel)
    public func xdel<T: FromRedisValue>(_ key: String, _ id: String...) async throws -> T {
        try await Cmd("XDEL").arg(key.to_redis_args()).arg(id.to_redis_args()).query(self)
    }
    /// A container for consumer groups commands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [XGROUP](https://redis.io/commands/xgroup)
    public func xgroup<T: FromRedisValue>() async throws -> T { try await Cmd("XGROUP").query(self) }
    /// A container for stream introspection commands
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// Depends on subcommand.
    /// # Documentation
    /// view the docs for [XINFO](https://redis.io/commands/xinfo)
    public func xinfo<T: FromRedisValue>() async throws -> T { try await Cmd("XINFO").query(self) }
    /// Return the number of entries in a stream
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [XLEN](https://redis.io/commands/xlen)
    public func xlen<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("XLEN").arg(key.to_redis_args()).query(self)
    }
    /// Return information and entries from a stream consumer group pending entries list, that are messages fetched but never acknowledged.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(N) with N being the number of elements returned, so asking for a small fixed number of entries per call is O(1). O(M), where M is the total number of entries scanned when used with the IDLE filter. When the command returns just the summary and the list of consumers is small, it runs in O(1) time; otherwise, an additional O(N) time for iterating every consumer.
    /// # History
    /// - 6.2.0, Added the `IDLE` option and exclusive range intervals.
    /// # Documentation
    /// view the docs for [XPENDING](https://redis.io/commands/xpending)
    public func xpending<T: FromRedisValue>(_ key: String, _ group: String, _ filters: XpendingFilters? = nil)
        async throws -> T
    {
        try await Cmd("XPENDING").arg(key.to_redis_args()).arg(group.to_redis_args()).arg(filters.to_redis_args())
            .query(self)
    }
    public struct XpendingFilters: ToRedisArgs {
        let minIdleTime: Int
        let start: String
        let end: String
        let count: Int
        let consumer: String
        public func write_redis_args(out: inout [Data]) {
            out.append("IDLE".data(using: .utf8)!)
            minIdleTime.write_redis_args(out: &out)
            start.write_redis_args(out: &out)
            end.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
            consumer.write_redis_args(out: &out)
        }
    }
    /// Return a range of elements in a stream, with IDs matching the specified IDs interval
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(N) with N being the number of elements being returned. If N is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1).
    /// # History
    /// - 6.2.0, Added exclusive ranges.
    /// # Documentation
    /// view the docs for [XRANGE](https://redis.io/commands/xrange)
    public func xrange<T: FromRedisValue>(_ key: String, _ start: String, _ end: String, _ count: Int? = nil)
        async throws -> T
    {
        try await Cmd("XRANGE").arg(key.to_redis_args()).arg(start.to_redis_args()).arg(end.to_redis_args()).arg(
            count.to_redis_args()
        ).query(self)
    }
    /// Return never seen elements in multiple streams, with IDs greater than the ones reported by the caller for each stream. Can block.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// For each stream mentioned: O(N) with N being the number of elements being returned, it means that XREAD-ing with a fixed COUNT is O(1). Note that when the BLOCK option is used, XADD will pay O(M) time in order to serve the M clients blocked on the stream getting new data.
    /// # Documentation
    /// view the docs for [XREAD](https://redis.io/commands/xread)
    public func xread<T: FromRedisValue>(_ count: Int? = nil, milliseconds: Int? = nil, streams: XreadStreams)
        async throws -> T
    {
        try await Cmd("XREAD").arg(count.to_redis_args()).arg(milliseconds.to_redis_args()).arg(streams.to_redis_args())
            .query(self)
    }
    public struct XreadStreams: ToRedisArgs {
        let key: String
        let id: String
        public func write_redis_args(out: inout [Data]) {
            key.write_redis_args(out: &out)
            id.write_redis_args(out: &out)
        }
    }
    /// Return new entries from a stream using a consumer group, or access the history of the pending entries for a given consumer. Can block.
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// For each stream mentioned: O(M) with M being the number of elements returned. If M is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1). On the other side when XREADGROUP blocks, XADD will pay the O(N) time in order to serve the N clients blocked on the stream getting new data.
    /// # Documentation
    /// view the docs for [XREADGROUP](https://redis.io/commands/xreadgroup)
    public func xreadgroup<T: FromRedisValue>(
        _ groupConsumer: XreadgroupGroupconsumer, _ count: Int? = nil, milliseconds: Int? = nil,
        streams: XreadgroupStreams, _ options: XreadgroupOptions? = nil
    ) async throws -> T {
        try await Cmd("XREADGROUP").arg(groupConsumer.to_redis_args()).arg(count.to_redis_args()).arg(
            milliseconds.to_redis_args()
        ).arg(streams.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public struct XreadgroupGroupconsumer: ToRedisArgs {
        let group: String
        let consumer: String
        public func write_redis_args(out: inout [Data]) {
            group.write_redis_args(out: &out)
            consumer.write_redis_args(out: &out)
        }
    }
    public struct XreadgroupStreams: ToRedisArgs {
        let key: String
        let id: String
        public func write_redis_args(out: inout [Data]) {
            key.write_redis_args(out: &out)
            id.write_redis_args(out: &out)
        }
    }
    public struct XreadgroupOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let NOACK = XreadgroupOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.NOACK) { out.append("NOACK".data(using: .utf8)!) }
        }
    }
    /// Return a range of elements in a stream, with IDs matching the specified IDs interval, in reverse order (from greater to smaller IDs) compared to XRANGE
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(N) with N being the number of elements returned. If N is constant (e.g. always asking for the first 10 elements with COUNT), you can consider it O(1).
    /// # History
    /// - 6.2.0, Added exclusive ranges.
    /// # Documentation
    /// view the docs for [XREVRANGE](https://redis.io/commands/xrevrange)
    public func xrevrange<T: FromRedisValue>(_ key: String, _ end: String, _ start: String, _ count: Int? = nil)
        async throws -> T
    {
        try await Cmd("XREVRANGE").arg(key.to_redis_args()).arg(end.to_redis_args()).arg(start.to_redis_args()).arg(
            count.to_redis_args()
        ).query(self)
    }
    /// An internal command for replicating stream values
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(1)
    /// # History
    /// - 7.0.0, Added the `entries_added` and `max_deleted_entry_id` arguments.
    /// # Documentation
    /// view the docs for [XSETID](https://redis.io/commands/xsetid)
    public func xsetid<T: FromRedisValue>(
        _ key: String, _ lastId: String, _ entriesAdded: Int? = nil, maxDeletedEntryId: String? = nil
    ) async throws -> T {
        try await Cmd("XSETID").arg(key.to_redis_args()).arg(lastId.to_redis_args()).arg(entriesAdded.to_redis_args())
            .arg(maxDeletedEntryId.to_redis_args()).query(self)
    }
    /// Trims the stream to (approximately if '~' is passed) a certain size
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(N), with N being the number of evicted entries. Constant times are very small however, since entries are organized in macro nodes containing multiple entries that can be released with a single deallocation.
    /// # History
    /// - 6.2.0, Added the `MINID` trimming strategy and the `LIMIT` option.
    /// # Documentation
    /// view the docs for [XTRIM](https://redis.io/commands/xtrim)
    public func xtrim<T: FromRedisValue>(_ key: String, _ trim: XtrimTrim) async throws -> T {
        try await Cmd("XTRIM").arg(key.to_redis_args()).arg(trim.to_redis_args()).query(self)
    }
    public struct XtrimTrim: ToRedisArgs {
        let strategy: Strategy
        let asdasdad: Asdasdad
        let threshold: String
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            strategy.write_redis_args(out: &out)
            asdasdad.write_redis_args(out: &out)
            threshold.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
        public enum Strategy: ToRedisArgs {
            case MAXLEN
            case MINID
            public func write_redis_args(out: inout [Data]) {
                switch self {
                case .MAXLEN: out.append("MAXLEN".data(using: .utf8)!)
                case .MINID: out.append("MINID".data(using: .utf8)!)
                }
            }
        }
        public enum Asdasdad: ToRedisArgs {
            case equal
            case approximately
            public func write_redis_args(out: inout [Data]) {
                switch self {
                case .equal: out.append("=".data(using: .utf8)!)
                case .approximately: out.append("~".data(using: .utf8)!)
                }
            }
        }
    }
    /// Add one or more members to a sorted set, or update its score if it already exists
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(log(N)) for each item added, where N is the number of elements in the sorted set.
    /// # History
    /// - 2.4.0, Accepts multiple elements.
    /// - 3.0.2, Added the `XX`, `NX`, `CH` and `INCR` options.
    /// - 6.2.0, Added the `GT` and `LT` options.
    /// # Documentation
    /// view the docs for [ZADD](https://redis.io/commands/zadd)
    public func zadd<T: FromRedisValue>(
        _ key: String, _ condition: ZaddCondition? = nil, comparison: ZaddComparison? = nil,
        options: ZaddOptions? = nil, scoreMember: ZaddScoremember...
    ) async throws -> T {
        try await Cmd("ZADD").arg(key.to_redis_args()).arg(condition.to_redis_args()).arg(comparison.to_redis_args())
            .arg(options.to_redis_args()).arg(scoreMember.to_redis_args()).query(self)
    }
    public enum ZaddCondition: ToRedisArgs {
        case NX
        case XX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .NX: out.append("NX".data(using: .utf8)!)
            case .XX: out.append("XX".data(using: .utf8)!)
            }
        }
    }
    public enum ZaddComparison: ToRedisArgs {
        case GT
        case LT
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .GT: out.append("GT".data(using: .utf8)!)
            case .LT: out.append("LT".data(using: .utf8)!)
            }
        }
    }
    public struct ZaddOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let CH = ZaddOptions(rawValue: 1 << 0)
        static let INCR = ZaddOptions(rawValue: 1 << 1)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.CH) { out.append("CH".data(using: .utf8)!) }
            if self.contains(.INCR) { out.append("INCR".data(using: .utf8)!) }
        }
    }
    public struct ZaddScoremember: ToRedisArgs {
        let score: Double
        let member: String
        public func write_redis_args(out: inout [Data]) {
            score.write_redis_args(out: &out)
            member.write_redis_args(out: &out)
        }
    }
    /// Get the number of members in a sorted set
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [ZCARD](https://redis.io/commands/zcard)
    public func zcard<T: FromRedisValue>(_ key: String) async throws -> T {
        try await Cmd("ZCARD").arg(key.to_redis_args()).query(self)
    }
    /// Count the members in a sorted set with scores within the given values
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(log(N)) with N being the number of elements in the sorted set.
    /// # Documentation
    /// view the docs for [ZCOUNT](https://redis.io/commands/zcount)
    public func zcount<T: FromRedisValue>(_ key: String, _ min: Double, _ max: Double) async throws -> T {
        try await Cmd("ZCOUNT").arg(key.to_redis_args()).arg(min.to_redis_args()).arg(max.to_redis_args()).query(self)
    }
    /// Subtract multiple sorted sets
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(L + (N-K)log(N)) worst case where L is the total number of elements in all the sets, N is the size of the first set, and K is the size of the result set.
    /// # Documentation
    /// view the docs for [ZDIFF](https://redis.io/commands/zdiff)
    public func zdiff<T: FromRedisValue>(_ numkeys: Int, _ options: ZdiffOptions? = nil, key: String...) async throws
        -> T
    {
        try await Cmd("ZDIFF").arg(numkeys.to_redis_args()).arg(options.to_redis_args()).arg(key.to_redis_args()).query(
            self)
    }
    public struct ZdiffOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHSCORES = ZdiffOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHSCORES) { out.append("WITHSCORES".data(using: .utf8)!) }
        }
    }
    /// Subtract multiple sorted sets and store the resulting sorted set in a new key
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(L + (N-K)log(N)) worst case where L is the total number of elements in all the sets, N is the size of the first set, and K is the size of the result set.
    /// # Documentation
    /// view the docs for [ZDIFFSTORE](https://redis.io/commands/zdiffstore)
    public func zdiffstore<T: FromRedisValue>(_ destination: String, _ numkeys: Int, _ key: String...) async throws -> T
    {
        try await Cmd("ZDIFFSTORE").arg(destination.to_redis_args()).arg(numkeys.to_redis_args()).arg(
            key.to_redis_args()
        ).query(self)
    }
    /// Increment the score of a member in a sorted set
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(log(N)) where N is the number of elements in the sorted set.
    /// # Documentation
    /// view the docs for [ZINCRBY](https://redis.io/commands/zincrby)
    public func zincrby<T: FromRedisValue>(_ key: String, _ increment: Int, _ member: String) async throws -> T {
        try await Cmd("ZINCRBY").arg(key.to_redis_args()).arg(increment.to_redis_args()).arg(member.to_redis_args())
            .query(self)
    }
    /// Intersect multiple sorted sets
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N*K)+O(M*log(M)) worst case with N being the smallest input sorted set, K being the number of input sorted sets and M being the number of elements in the resulting sorted set.
    /// # Documentation
    /// view the docs for [ZINTER](https://redis.io/commands/zinter)
    public func zinter<T: FromRedisValue>(
        _ numkeys: Int, _ aggregate: ZinterAggregate? = nil, options: ZinterOptions? = nil, key: String...,
        weight: Int?...
    ) async throws -> T {
        try await Cmd("ZINTER").arg(numkeys.to_redis_args()).arg(aggregate.to_redis_args()).arg(options.to_redis_args())
            .arg(key.to_redis_args()).arg(weight.to_redis_args()).query(self)
    }
    public enum ZinterAggregate: ToRedisArgs {
        case SUM
        case MIN
        case MAX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .SUM: out.append("SUM".data(using: .utf8)!)
            case .MIN: out.append("MIN".data(using: .utf8)!)
            case .MAX: out.append("MAX".data(using: .utf8)!)
            }
        }
    }
    public struct ZinterOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHSCORES = ZinterOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHSCORES) { out.append("WITHSCORES".data(using: .utf8)!) }
        }
    }
    /// Intersect multiple sorted sets and return the cardinality of the result
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(N*K) worst case with N being the smallest input sorted set, K being the number of input sorted sets.
    /// # Documentation
    /// view the docs for [ZINTERCARD](https://redis.io/commands/zintercard)
    public func zintercard<T: FromRedisValue>(_ numkeys: Int, _ limit: Int? = nil, key: String...) async throws -> T {
        try await Cmd("ZINTERCARD").arg(numkeys.to_redis_args()).arg(limit.to_redis_args()).arg(key.to_redis_args())
            .query(self)
    }
    /// Intersect multiple sorted sets and store the resulting sorted set in a new key
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N*K)+O(M*log(M)) worst case with N being the smallest input sorted set, K being the number of input sorted sets and M being the number of elements in the resulting sorted set.
    /// # Documentation
    /// view the docs for [ZINTERSTORE](https://redis.io/commands/zinterstore)
    public func zinterstore<T: FromRedisValue>(
        _ destination: String, _ numkeys: Int, _ aggregate: ZinterstoreAggregate? = nil, key: String..., weight: Int?...
    ) async throws -> T {
        try await Cmd("ZINTERSTORE").arg(destination.to_redis_args()).arg(numkeys.to_redis_args()).arg(
            aggregate.to_redis_args()
        ).arg(key.to_redis_args()).arg(weight.to_redis_args()).query(self)
    }
    public enum ZinterstoreAggregate: ToRedisArgs {
        case SUM
        case MIN
        case MAX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .SUM: out.append("SUM".data(using: .utf8)!)
            case .MIN: out.append("MIN".data(using: .utf8)!)
            case .MAX: out.append("MAX".data(using: .utf8)!)
            }
        }
    }
    /// Count the number of members in a sorted set between a given lexicographical range
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// O(log(N)) with N being the number of elements in the sorted set.
    /// # Documentation
    /// view the docs for [ZLEXCOUNT](https://redis.io/commands/zlexcount)
    public func zlexcount<T: FromRedisValue>(_ key: String, _ min: String, _ max: String) async throws -> T {
        try await Cmd("ZLEXCOUNT").arg(key.to_redis_args()).arg(min.to_redis_args()).arg(max.to_redis_args()).query(
            self)
    }
    /// Remove and return members with scores in a sorted set
    /// # Available since
    /// 7.0.0
    /// # Time complexity
    /// O(K) + O(N*log(M)) where K is the number of provided keys, N being the number of elements in the sorted set, and M being the number of elements popped.
    /// # Documentation
    /// view the docs for [ZMPOP](https://redis.io/commands/zmpop)
    public func zmpop<T: FromRedisValue>(_ numkeys: Int, _ sdfsdf: ZmpopSdfsdf, _ count: Int? = nil, key: String...)
        async throws -> T
    {
        try await Cmd("ZMPOP").arg(numkeys.to_redis_args()).arg(sdfsdf.to_redis_args()).arg(count.to_redis_args()).arg(
            key.to_redis_args()
        ).query(self)
    }
    public enum ZmpopSdfsdf: ToRedisArgs {
        case MIN
        case MAX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .MIN: out.append("MIN".data(using: .utf8)!)
            case .MAX: out.append("MAX".data(using: .utf8)!)
            }
        }
    }
    /// Get the score associated with the given members in a sorted set
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N) where N is the number of members being requested.
    /// # Documentation
    /// view the docs for [ZMSCORE](https://redis.io/commands/zmscore)
    public func zmscore<T: FromRedisValue>(_ key: String, _ member: String...) async throws -> T {
        try await Cmd("ZMSCORE").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Remove and return members with the highest scores in a sorted set
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(log(N)*M) with N being the number of elements in the sorted set, and M being the number of elements popped.
    /// # Documentation
    /// view the docs for [ZPOPMAX](https://redis.io/commands/zpopmax)
    public func zpopmax<T: FromRedisValue>(_ key: String, _ count: Int? = nil) async throws -> T {
        try await Cmd("ZPOPMAX").arg(key.to_redis_args()).arg(count.to_redis_args()).query(self)
    }
    /// Remove and return members with the lowest scores in a sorted set
    /// # Available since
    /// 5.0.0
    /// # Time complexity
    /// O(log(N)*M) with N being the number of elements in the sorted set, and M being the number of elements popped.
    /// # Documentation
    /// view the docs for [ZPOPMIN](https://redis.io/commands/zpopmin)
    public func zpopmin<T: FromRedisValue>(_ key: String, _ count: Int? = nil) async throws -> T {
        try await Cmd("ZPOPMIN").arg(key.to_redis_args()).arg(count.to_redis_args()).query(self)
    }
    /// Get one or multiple random elements from a sorted set
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N) where N is the number of elements returned
    /// # Documentation
    /// view the docs for [ZRANDMEMBER](https://redis.io/commands/zrandmember)
    public func zrandmember<T: FromRedisValue>(_ key: String, _ options: ZrandmemberOptions? = nil) async throws -> T {
        try await Cmd("ZRANDMEMBER").arg(key.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public struct ZrandmemberOptions: ToRedisArgs {
        let count: Int
        let options: Options
        public func write_redis_args(out: inout [Data]) {
            count.write_redis_args(out: &out)
            options.write_redis_args(out: &out)
        }
        struct Options: OptionSet, ToRedisArgs {
            public let rawValue: Int
            public init(rawValue: Int) { self.rawValue = rawValue }
            static let WITHSCORES = Options(rawValue: 1 << 0)
            public func write_redis_args(out: inout [Data]) {
                if self.contains(.WITHSCORES) { out.append("WITHSCORES".data(using: .utf8)!) }
            }
        }
    }
    /// Return a range of members in a sorted set
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements returned.
    /// # History
    /// - 6.2.0, Added the `REV`, `BYSCORE`, `BYLEX` and `LIMIT` options.
    /// # Documentation
    /// view the docs for [ZRANGE](https://redis.io/commands/zrange)
    public func zrange<T: FromRedisValue>(
        _ key: String, _ start: String, _ stop: String, _ sortby: ZrangeSortby? = nil,
        offsetCount: ZrangeOffsetcount? = nil, options: ZrangeOptions? = nil
    ) async throws -> T {
        try await Cmd("ZRANGE").arg(key.to_redis_args()).arg(start.to_redis_args()).arg(stop.to_redis_args()).arg(
            sortby.to_redis_args()
        ).arg(offsetCount.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public enum ZrangeSortby: ToRedisArgs {
        case BYSCORE
        case BYLEX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .BYSCORE: out.append("BYSCORE".data(using: .utf8)!)
            case .BYLEX: out.append("BYLEX".data(using: .utf8)!)
            }
        }
    }
    public struct ZrangeOffsetcount: ToRedisArgs {
        let offset: Int
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            offset.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
    }
    public struct ZrangeOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let REV = ZrangeOptions(rawValue: 1 << 0)
        static let WITHSCORES = ZrangeOptions(rawValue: 1 << 1)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.REV) { out.append("REV".data(using: .utf8)!) }
            if self.contains(.WITHSCORES) { out.append("WITHSCORES".data(using: .utf8)!) }
        }
    }
    /// Return a range of members in a sorted set, by lexicographical range
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
    /// # Documentation
    /// view the docs for [ZRANGEBYLEX](https://redis.io/commands/zrangebylex)
    public func zrangebylex<T: FromRedisValue>(
        _ key: String, _ min: String, _ max: String, _ offsetCount: ZrangebylexOffsetcount? = nil
    ) async throws -> T {
        try await Cmd("ZRANGEBYLEX").arg(key.to_redis_args()).arg(min.to_redis_args()).arg(max.to_redis_args()).arg(
            offsetCount.to_redis_args()
        ).query(self)
    }
    public struct ZrangebylexOffsetcount: ToRedisArgs {
        let offset: Int
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            offset.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
    }
    /// Return a range of members in a sorted set, by score
    /// # Available since
    /// 1.0.5
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
    /// # History
    /// - 2.0.0, Added the `WITHSCORES` modifier.
    /// # Documentation
    /// view the docs for [ZRANGEBYSCORE](https://redis.io/commands/zrangebyscore)
    public func zrangebyscore<T: FromRedisValue>(
        _ key: String, _ min: Double, _ max: Double, _ offsetCount: ZrangebyscoreOffsetcount? = nil,
        options: ZrangebyscoreOptions? = nil
    ) async throws -> T {
        try await Cmd("ZRANGEBYSCORE").arg(key.to_redis_args()).arg(min.to_redis_args()).arg(max.to_redis_args()).arg(
            offsetCount.to_redis_args()
        ).arg(options.to_redis_args()).query(self)
    }
    public struct ZrangebyscoreOffsetcount: ToRedisArgs {
        let offset: Int
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            offset.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
    }
    public struct ZrangebyscoreOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHSCORES = ZrangebyscoreOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHSCORES) { out.append("WITHSCORES".data(using: .utf8)!) }
        }
    }
    /// Store a range of members from sorted set into another key
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements stored into the destination key.
    /// # Documentation
    /// view the docs for [ZRANGESTORE](https://redis.io/commands/zrangestore)
    public func zrangestore<T: FromRedisValue>(
        _ dst: String, _ src: String, _ min: String, _ max: String, _ sortby: ZrangestoreSortby? = nil,
        offsetCount: ZrangestoreOffsetcount? = nil, options: ZrangestoreOptions? = nil
    ) async throws -> T {
        try await Cmd("ZRANGESTORE").arg(dst.to_redis_args()).arg(src.to_redis_args()).arg(min.to_redis_args()).arg(
            max.to_redis_args()
        ).arg(sortby.to_redis_args()).arg(offsetCount.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public enum ZrangestoreSortby: ToRedisArgs {
        case BYSCORE
        case BYLEX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .BYSCORE: out.append("BYSCORE".data(using: .utf8)!)
            case .BYLEX: out.append("BYLEX".data(using: .utf8)!)
            }
        }
    }
    public struct ZrangestoreOffsetcount: ToRedisArgs {
        let offset: Int
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            offset.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
    }
    public struct ZrangestoreOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let REV = ZrangestoreOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.REV) { out.append("REV".data(using: .utf8)!) }
        }
    }
    /// Determine the index of a member in a sorted set
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(log(N))
    /// # Documentation
    /// view the docs for [ZRANK](https://redis.io/commands/zrank)
    public func zrank<T: FromRedisValue>(_ key: String, _ member: String) async throws -> T {
        try await Cmd("ZRANK").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Remove one or more members from a sorted set
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(M*log(N)) with N being the number of elements in the sorted set and M the number of elements to be removed.
    /// # History
    /// - 2.4.0, Accepts multiple elements.
    /// # Documentation
    /// view the docs for [ZREM](https://redis.io/commands/zrem)
    public func zrem<T: FromRedisValue>(_ key: String, _ member: String...) async throws -> T {
        try await Cmd("ZREM").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Remove all members in a sorted set between the given lexicographical range
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
    /// # Documentation
    /// view the docs for [ZREMRANGEBYLEX](https://redis.io/commands/zremrangebylex)
    public func zremrangebylex<T: FromRedisValue>(_ key: String, _ min: String, _ max: String) async throws -> T {
        try await Cmd("ZREMRANGEBYLEX").arg(key.to_redis_args()).arg(min.to_redis_args()).arg(max.to_redis_args())
            .query(self)
    }
    /// Remove all members in a sorted set within the given indexes
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
    /// # Documentation
    /// view the docs for [ZREMRANGEBYRANK](https://redis.io/commands/zremrangebyrank)
    public func zremrangebyrank<T: FromRedisValue>(_ key: String, _ start: Int, _ stop: Int) async throws -> T {
        try await Cmd("ZREMRANGEBYRANK").arg(key.to_redis_args()).arg(start.to_redis_args()).arg(stop.to_redis_args())
            .query(self)
    }
    /// Remove all members in a sorted set within the given scores
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements removed by the operation.
    /// # Documentation
    /// view the docs for [ZREMRANGEBYSCORE](https://redis.io/commands/zremrangebyscore)
    public func zremrangebyscore<T: FromRedisValue>(_ key: String, _ min: Double, _ max: Double) async throws -> T {
        try await Cmd("ZREMRANGEBYSCORE").arg(key.to_redis_args()).arg(min.to_redis_args()).arg(max.to_redis_args())
            .query(self)
    }
    /// Return a range of members in a sorted set, by index, with scores ordered from high to low
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements returned.
    /// # Documentation
    /// view the docs for [ZREVRANGE](https://redis.io/commands/zrevrange)
    public func zrevrange<T: FromRedisValue>(
        _ key: String, _ start: Int, _ stop: Int, _ options: ZrevrangeOptions? = nil
    ) async throws -> T {
        try await Cmd("ZREVRANGE").arg(key.to_redis_args()).arg(start.to_redis_args()).arg(stop.to_redis_args()).arg(
            options.to_redis_args()
        ).query(self)
    }
    public struct ZrevrangeOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHSCORES = ZrevrangeOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHSCORES) { out.append("WITHSCORES".data(using: .utf8)!) }
        }
    }
    /// Return a range of members in a sorted set, by lexicographical range, ordered from higher to lower strings.
    /// # Available since
    /// 2.8.9
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
    /// # Documentation
    /// view the docs for [ZREVRANGEBYLEX](https://redis.io/commands/zrevrangebylex)
    public func zrevrangebylex<T: FromRedisValue>(
        _ key: String, _ max: String, _ min: String, _ offsetCount: ZrevrangebylexOffsetcount? = nil
    ) async throws -> T {
        try await Cmd("ZREVRANGEBYLEX").arg(key.to_redis_args()).arg(max.to_redis_args()).arg(min.to_redis_args()).arg(
            offsetCount.to_redis_args()
        ).query(self)
    }
    public struct ZrevrangebylexOffsetcount: ToRedisArgs {
        let offset: Int
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            offset.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
    }
    /// Return a range of members in a sorted set, by score, with scores ordered from high to low
    /// # Available since
    /// 2.2.0
    /// # Time complexity
    /// O(log(N)+M) with N being the number of elements in the sorted set and M the number of elements being returned. If M is constant (e.g. always asking for the first 10 elements with LIMIT), you can consider it O(log(N)).
    /// # History
    /// - 2.1.6, `min` and `max` can be exclusive.
    /// # Documentation
    /// view the docs for [ZREVRANGEBYSCORE](https://redis.io/commands/zrevrangebyscore)
    public func zrevrangebyscore<T: FromRedisValue>(
        _ key: String, _ max: Double, _ min: Double, _ offsetCount: ZrevrangebyscoreOffsetcount? = nil,
        options: ZrevrangebyscoreOptions? = nil
    ) async throws -> T {
        try await Cmd("ZREVRANGEBYSCORE").arg(key.to_redis_args()).arg(max.to_redis_args()).arg(min.to_redis_args())
            .arg(offsetCount.to_redis_args()).arg(options.to_redis_args()).query(self)
    }
    public struct ZrevrangebyscoreOffsetcount: ToRedisArgs {
        let offset: Int
        let count: Int
        public func write_redis_args(out: inout [Data]) {
            offset.write_redis_args(out: &out)
            count.write_redis_args(out: &out)
        }
    }
    public struct ZrevrangebyscoreOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHSCORES = ZrevrangebyscoreOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHSCORES) { out.append("WITHSCORES".data(using: .utf8)!) }
        }
    }
    /// Determine the index of a member in a sorted set, with scores ordered from high to low
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(log(N))
    /// # Documentation
    /// view the docs for [ZREVRANK](https://redis.io/commands/zrevrank)
    public func zrevrank<T: FromRedisValue>(_ key: String, _ member: String) async throws -> T {
        try await Cmd("ZREVRANK").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Incrementally iterate sorted sets elements and associated scores
    /// # Available since
    /// 2.8.0
    /// # Time complexity
    /// O(1) for every call. O(N) for a complete iteration, including enough command calls for the cursor to return back to 0. N is the number of elements inside the collection..
    /// # Documentation
    /// view the docs for [ZSCAN](https://redis.io/commands/zscan)
    public func zscan<T: FromRedisValue>(_ key: String, _ cursor: Int, _ pattern: String? = nil, count: Int? = nil)
        async throws -> T
    {
        try await Cmd("ZSCAN").arg(key.to_redis_args()).arg(cursor.to_redis_args()).arg(pattern.to_redis_args()).arg(
            count.to_redis_args()
        ).query(self)
    }
    /// Get the score associated with the given member in a sorted set
    /// # Available since
    /// 1.2.0
    /// # Time complexity
    /// O(1)
    /// # Documentation
    /// view the docs for [ZSCORE](https://redis.io/commands/zscore)
    public func zscore<T: FromRedisValue>(_ key: String, _ member: String) async throws -> T {
        try await Cmd("ZSCORE").arg(key.to_redis_args()).arg(member.to_redis_args()).query(self)
    }
    /// Add multiple sorted sets
    /// # Available since
    /// 6.2.0
    /// # Time complexity
    /// O(N)+O(M*log(M)) with N being the sum of the sizes of the input sorted sets, and M being the number of elements in the resulting sorted set.
    /// # Documentation
    /// view the docs for [ZUNION](https://redis.io/commands/zunion)
    public func zunion<T: FromRedisValue>(
        _ numkeys: Int, _ aggregate: ZunionAggregate? = nil, options: ZunionOptions? = nil, key: String...,
        weight: Int?...
    ) async throws -> T {
        try await Cmd("ZUNION").arg(numkeys.to_redis_args()).arg(aggregate.to_redis_args()).arg(options.to_redis_args())
            .arg(key.to_redis_args()).arg(weight.to_redis_args()).query(self)
    }
    public enum ZunionAggregate: ToRedisArgs {
        case SUM
        case MIN
        case MAX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .SUM: out.append("SUM".data(using: .utf8)!)
            case .MIN: out.append("MIN".data(using: .utf8)!)
            case .MAX: out.append("MAX".data(using: .utf8)!)
            }
        }
    }
    public struct ZunionOptions: OptionSet, ToRedisArgs {
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        static let WITHSCORES = ZunionOptions(rawValue: 1 << 0)
        public func write_redis_args(out: inout [Data]) {
            if self.contains(.WITHSCORES) { out.append("WITHSCORES".data(using: .utf8)!) }
        }
    }
    /// Add multiple sorted sets and store the resulting sorted set in a new key
    /// # Available since
    /// 2.0.0
    /// # Time complexity
    /// O(N)+O(M log(M)) with N being the sum of the sizes of the input sorted sets, and M being the number of elements in the resulting sorted set.
    /// # Documentation
    /// view the docs for [ZUNIONSTORE](https://redis.io/commands/zunionstore)
    public func zunionstore<T: FromRedisValue>(
        _ destination: String, _ numkeys: Int, _ aggregate: ZunionstoreAggregate? = nil, key: String..., weight: Int?...
    ) async throws -> T {
        try await Cmd("ZUNIONSTORE").arg(destination.to_redis_args()).arg(numkeys.to_redis_args()).arg(
            aggregate.to_redis_args()
        ).arg(key.to_redis_args()).arg(weight.to_redis_args()).query(self)
    }
    public enum ZunionstoreAggregate: ToRedisArgs {
        case SUM
        case MIN
        case MAX
        public func write_redis_args(out: inout [Data]) {
            switch self {
            case .SUM: out.append("SUM".data(using: .utf8)!)
            case .MIN: out.append("MIN".data(using: .utf8)!)
            case .MAX: out.append("MAX".data(using: .utf8)!)
            }
        }
    }
}
