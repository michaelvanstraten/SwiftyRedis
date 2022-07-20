//
//  File.swift
//  
//
//  Created by Michael Van straten on 11.07.22.
//

import Network

public class RedisClient {
    /// As RedisClient initialized to connect to localhost:6379 without using TLS. This can be used for easier development.
    public static let LOCALHOST = RedisClient(.init("localhost"))
    
    let host: NWEndpoint.Host
    let port: NWEndpoint.Port
    let params: NWParameters
    let database: UInt
    let username: String?
    let password: String?
    
    /// Initialize the RedisClient struct without connecting to the underling endpoint. Use the ``RedisClient/get_connection()`` method to connect to the endpoint.
    /// - Parameters:
    ///   - host: A name or address that identifies the redis server endpoint.
    ///   - port: The port number on which to connect to the redis server.
    ///   - params: Used if connection needs to be established over TLS or some other protocol.
    ///   - database: If this is not equal to zero the client will change to the specified database using the ``RedisConnection/select(index:)`` method before the connection is returned.
    ///   - username: If this and the `password` is `Some` the client will try to authenticate with the redis server using the ``RedisConnection/auth(username:password:)`` method before the connection is returned.
    ///   - password: Password to use when authenticating.
    public init(
        _ host: NWEndpoint.Host,
        port: NWEndpoint.Port = .init(integerLiteral: 6379),
        params: NWParameters = .tcp,
        database: UInt = 0,
        username: String? = nil,
        password: String? = nil
    ) {
        self.host = host
        self.port = port
        self.params = params
        self.database = database
        self.username = username
        self.password = password
    }
    
    /// Instructs the client to actually connect to redis and returns a connection object.
    /// The connection object can be used to send commands to the server.
    public func get_connection() async throws -> RedisConnection {
        let actual_connection = create_redis_connection()
        try await connect_to_redis(con: actual_connection)
        let redis_connection = RedisConnection(actual_connection)
        if self.database != 0 {
            let _: String = try await redis_connection.select(index: Int(self.database))
        }
        if let username = self.username, let password = self.password {
            let _: String = try await redis_connection.auth(username: username, password: password)
        }
        return redis_connection
    }
    
    private func create_redis_connection() -> NWConnection {
        return NWConnection(
            host: host,
            port: port,
            using: params
        )
    }
    
    private func connect_to_redis(con: NWConnection) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error> ) in
            con.stateUpdateHandler = { newState in
                switch newState {
                case .waiting(let error), .failed(let error):
                    con.stateUpdateHandler = nil
                    continuation.resume(throwing: RedisError.NWError(error))
                case .ready:
                    con.stateUpdateHandler = nil
                    continuation.resume()
                case .cancelled:
                    con.restart()
                default:
                    break
                }
            }
            con.start(queue: DispatchQueue(label: "redis-updates"))
        }
    }
}
