//
//  ResponseParserTests.swift
//  SwiftyRedis
//
//  Created by Michael Van straten on 12.07.22.
//

import XCTest
@testable import SwiftyRedis

final class ResponseParserTests: XCTestCase {
    let parser = RedisResponseParser()
    
    func test_simple_string() throws {
        XCTAssertEqual(
            try parser.parse_response("+OK\r\n".data(using: .utf8)!),
            .SimpleString("OK")
        )
    }
    
    func test_errors() throws {
        XCTAssertThrowsError(try parser.parse_response("-ERR unknown command 'helloworld'".data(using: .utf8)!)) {
            XCTAssertEqual(
                RedisError.WithDescriptionAndDetail(
                    .ResponseError,
                    "An error was signalled by the server",
                    "unknown command 'helloworld'"
                ),
                $0 as! RedisError
            )
        }
        
        XCTAssertThrowsError(try parser.parse_response(Data())) {
            XCTAssertEqual(
                RedisError.WithDescription(.ResponseError, "Invalid response from server"),
                $0 as! RedisError
            )
        }
    }
    
    func test_integers() throws {
        XCTAssertEqual(
            try parser.parse_response(":420\r\n".data(using: .utf8)!),
            .Int(420)
        )
    }
    
    func test_bulk_strings() throws {
        XCTAssertEqual(
            try parser.parse_response("$5\r\nhello\r\n".data(using: .utf8)!),
            .BulkString("hello")
        )
    }
    
    func test_arrays() throws {
        XCTAssertEqual(
            try parser.parse_response("*2\r\n$5\r\nhello\r\n$5\r\nworld\r\n".data(using: .utf8)!),
            .Array([.BulkString("hello"), .BulkString("world")])
        )
    }
    
    func test_null_elements_in_arrays() throws {
        XCTAssertEqual(
            try parser.parse_response("*3\r\n$5\r\nhello\r\n$-1\r\n$5\r\nworld\r\n".data(using: .utf8)!),
            .Array([.BulkString("hello"), .Nil, .BulkString("world")])
        )
    }
}
