//
//  File.swift
//  
//
//  Created by Michael Van straten on 05.07.22.
//

import Foundation

/**
A command acts as a builder interface to creating encoded redis
requests.  This allows you to easily assemble a packed command
by chaining arguments together.

## Basic example:
```swift
var hset = Cmd("HSET")
    .arg("myhash")
    .arg("field1")
    .arg("Hello"
    .arg("field2"
    .arg("1")
```
*/
public class Cmd {
    private var args: Array<Data> = Array()
    
    init(_ name: String? = nil) {
        if let name = name {
            self.arg(name)
        }
    }
    
    /// Appends an argument to the command. The argument passed must
    /// be a type that conforms to ``ToRedisArgs``. Most primitive types as
    /// well as Arrays of primitive types conform to it.
    @discardableResult
    public func arg<T: ToRedisArgs>(_ arg: T) -> Self {
        arg.write_redis_args(out: &self.args)
        return self
    }
    
    /// Sends the command as query to the connection and converts the result to the target redis value.
    /// This is the general way how you can retrieve data.
    public func query<T: FromRedisValue>(_ con: RedisConnection) async throws -> T {
        let value = try await con.request_packed_cmd(pack_command())
        return try T.init(value)
    }
    
    /// This is a shortcut to ``Cmd/query(_:)`` that does not return a ``RedisValue`` and will throw if the query fails because of an error.
    /// This is mainly useful in examples and for simple commands like setting keys.
    public func execute(_ con: RedisConnection) async throws {
        let _: String = try await query(con)
    }
    
    internal func pack_command() -> Data {
        var packed_cmd = Data()
        
        packed_cmd.append(contentsOf: [RedisRESP.Array])
        packed_cmd.append(contentsOf: String(args.count).data(using: .utf8)!)
        packed_cmd.append(contentsOf: RedisRESP.CRLF)
        
        for arg in args {
            packed_cmd.append(contentsOf: [RedisRESP.BulkString])
            packed_cmd.append(contentsOf: String(arg.count).data(using: .utf8)!)
            packed_cmd.append(contentsOf: RedisRESP.CRLF)
            
            packed_cmd.append(contentsOf: arg)
            packed_cmd.append(contentsOf: RedisRESP.CRLF)
        }
        
        return packed_cmd
    }
}
