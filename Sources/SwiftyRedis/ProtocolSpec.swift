//
//  File.swift
//  
//
//  Created by Michael Van straten on 12.07.22.
//

import Foundation

/// Swift representation of [RESP protocol description](https://redis.io/docs/reference/protocol-spec/#resp-protocol-description) constants.
/// ## Redis Protocol RESP
public struct RedisRESP {
    /// Different parts of the protocol are always terminated with "\r\n" (CRLF).
    public static let CRLF = [UInt8(13), UInt8(10)]
    /// Simple Strings, the first byte of the reply is "+"
    public static let SimpleString = UInt8(ascii: "+")
    /// Errors, the first byte of the reply is "-"
    public static let Error = UInt8(ascii: "-")
    /// Integers, the first byte of the reply is ":"
    public static let Int = UInt8(ascii: ":")
    /// Bulk Strings, the first byte of the reply is "$"
    public static let BulkString = UInt8(ascii: "$")
    /// Arrays, the first byte of the reply is "*"
    public static let Array = UInt8(ascii: "*")
}
