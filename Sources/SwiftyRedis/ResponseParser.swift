//
//  File.swift
//  
//
//  Created by Michael Van straten on 12.07.22.
//

import Foundation

class RedisResponseParser {
    private var response: Data
    
    init(parse toParseData: Data = Data()) {
        self.response = toParseData
    }
    
    func parse_response(_ toParseData: Data) throws -> RedisValue {
        response = toParseData
        return try parse_value()
    }
    
    func parse_value() throws -> RedisValue {
        if let firstByte = response.popFirst() {
            switch firstByte {
            case RedisRESP.SimpleString:
                return .SimpleString(try parse_next_line())
            case RedisRESP.BulkString:
                return try parse_bulk_string()
            case RedisRESP.Int:
                return try parse_int()
            case RedisRESP.Array:
                return try parse_array()
            case RedisRESP.Error:
                throw try parse_error()
            default:
                throw RedisError.InvalidResponseError
            }
        } else {
            throw RedisError.InvalidResponseError
        }
    }
    
    func parse_next_line() throws -> String {
        if let startOfNextCRLF = response.startOfNextCRLF {
            if let line = String(data: response.popN(count: Int64(startOfNextCRLF)), encoding: .utf8) {
                disgard_crlf_token()
                return line
            } else {
                throw RedisError.InvalidUTF8
            }
        } else {
            throw RedisError.InvalidResponseError
        }
    }
    
    func parse_error() throws -> RedisError {
        if let error = String(data: response, encoding: .utf8) {
            return RedisError(parse: error)
        } else {
            throw RedisError.InvalidResponseError
        }
    }
    
    func parse_int() throws -> RedisValue {
        if let value = Int64(try parse_next_line()) {
            return .Int(value)
        } else {
            throw RedisError.WithDescription(.TypeError, "Expected integer, got garbage")
        }
    }
    
    func parse_bulk_string() throws -> RedisValue {
        if case .Int(let length) = try parse_int() {
            if length < 0  {
                return .Nil
            } else {
                if let value = String(data: response.popN(count: length), encoding: .utf8) {
                    disgard_crlf_token()
                    return .BulkString(value)
                } else {
                    throw RedisError.InvalidUTF8
                }
            }
        } else {
            unreachable()
        }
    }
    
    func parse_array() throws -> RedisValue {
        if case .Int(let length) = try parse_int() {
            if length < 0  {
                return .Nil
            } else if length == 0 {
                return .Array([])
            } else {
                return .Array(try (1...length).map({ _ in try parse_value() }))
            }
        } else {
            unreachable()
        }
    }
    
    @discardableResult
    func disgard_crlf_token() -> Data {
        return response.popN(count: Int64(RedisRESP.CRLF.count))
    }
}

extension Data {
    var startOfNextCRLF: Int? {
        guard
            let range = self.firstRange(of: RedisRESP.CRLF)
        else { return nil }
        return range.lowerBound - self.indices.lowerBound
    }
    
    mutating func popN(count: Int64) -> Data {
        if count <= 0 {
            return Data()
        } else {
            return Data((1...count).map( {_ in self.popFirst()} ).compactMap( { $0 } ))
        }
    }
}

// https://github.com/nvzqz/Unreachable/blob/master/Sources/Unreachable.swift
@inline(__always)
func unreachable() -> Never {
    return unsafeBitCast((), to: Never.self)
}
