//
//  File.swift
//  
//
//  Created by Michael Van straten on 06.07.22.
//

import Foundation

/// The redis value enum parsed from a redis reply.
/// Note that Error values are not returned, the corresponding function throws a ``RedisError`` in the case one is returned from redis.
public indirect enum RedisValue: Equatable {
    /// Simple Strings are used to transmit non binary-safe strings with minimal overhead. For example, many Redis commands reply with just "OK" on success.
    case SimpleString(String)
    /// Integer response from server, nothing special. However, the returned integer is guaranteed to be in the range of a signed 64-bit integer.
    case Int(Int64)
    /// Bulk Strings are used in order to represent a single binary-safe string up to 512 MB in length.
    case BulkString(String)
    /// Signals the non-existence of a value
    case Nil
    /// Certain Redis commands, that return collections of elements to the client, use Arrays as their replies, this the corresponding return case.
    case Array(Array<RedisValue>)
}
