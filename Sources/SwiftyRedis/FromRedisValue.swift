//
//  File.swift
//  
//
//  Created by Michael Van straten on 11.07.22.
//

import Foundation

public protocol FromRedisValue {
    /// Given a ``RedisValue`` this attempts to convert it into the given
    /// destination type. If that fails because it's not compatible an
    /// appropriate error is generated.
    init(_ value: RedisValue) throws
}

extension String: FromRedisValue {
    public init(_ value: RedisValue) throws {
        switch value {
        case .SimpleString(let string), .BulkString(let string):
            self = string
        default:
            throw RedisError.make_invalid_type_error(detail: "Response type not string compatible.")
        }
    }
}

extension Float64: FromRedisValue {
    public init(_ value: RedisValue) throws {
        switch value {
        case .BulkString(let string), .SimpleString(let string):
            if let float = Float64(string) {
                self = float
            } else {
                throw RedisError.make_invalid_type_error(detail: "Could not convert from string.")
            }
        case .Int(let int):
            self = Float64(int)
        default:
            throw RedisError.make_invalid_type_error(detail: "Response type not convertible to float.")
        }
    }
}

extension Float32: FromRedisValue {
    public init(_ value: RedisValue) throws {
        switch value {
        case .BulkString(let string), .SimpleString(let string):
            if let float = Float(string) {
                self = float
            } else {
                throw RedisError.make_invalid_type_error(detail: "Could not convert from string.")
            }
        case .Int(let int):
            self = Float32(int)
        default:
            throw RedisError.make_invalid_type_error(detail: "Response type not convertible to float.")
        }
    }
}

@available(macOS 11.0, *)
extension Float16: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = Float16(try Int(value))
    }
}

extension Int64: FromRedisValue {
    public init(_ value: RedisValue) throws {
        switch value {
        case .BulkString(let string), .SimpleString(let string):
            if let int = Int64(string) {
                self = int
            } else {
                throw RedisError.make_invalid_type_error(detail: "Could not convert from string.")
            }
        case .Int(let int):
            self = int
        default:
            throw RedisError.make_invalid_type_error(detail: "Response type not convertible too int.")
        }
    }
}

extension Int: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = Int(try Int64(value))
    }
}

extension Int32: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = Int32(try Int(value))
    }
}

extension Int16: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = Int16(try Int(value))
    }
}


extension UInt64: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = UInt64(try Int(value))
    }
}

extension UInt32: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = UInt32(try Int(value))
    }
}

extension UInt16: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = UInt16(try Int(value))
    }
}

extension Array: FromRedisValue where Element: FromRedisValue {
    public init(_ value: RedisValue) throws {
        switch value {
        case .Array(let array):
            self = try array.map( { value in try Element.init(value) } )
        default:
            throw RedisError.make_invalid_type_error(detail: "Response type not array compatible.")
        }
    }
}

extension Set: FromRedisValue where Element: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = Set(try Array<Element>.init(value))
    }
}

extension Optional: FromRedisValue where Wrapped: FromRedisValue {
    public init(_ value: RedisValue) throws {
        switch value {
        case .Nil:
            self = nil
        default:
            self = try Wrapped.init(value)
        }
    }
}

extension RedisValue: FromRedisValue {
    public init(_ value: RedisValue) throws {
        self = value
    }
}

extension Bool: FromRedisValue {
    public init(_ value: RedisValue) throws {
        switch value {
        case .Int(let int):
            self = int != 0
        case .BulkString(let string), .SimpleString(let string):
            if string == "1" {
                self = true
            } else if string == "0" {
                self = false
            } else {
                throw RedisError.make_invalid_type_error(detail: "Could not convert from string.")
            }
        case .Nil:
            self = false
        case .Array(_):
            throw RedisError.make_invalid_type_error(detail: "Response type not bool compatible.")
        }
    }
}
