//
//  File.swift
//  
//
//  Created by Michael Van straten on 05.07.22.
//

import Foundation
import Network

/// Represents an error which could accrue when interacting with redis.
/// ## Overview
/// If the response parser encounters and error while parsing or it notices that the response is a redis error, this type gets thrown.
public enum RedisError: Error, Equatable {
    /// Encountering an error response which containers an error kind but no detail this case will be chosen.
    /// Incase the data returned from the socket cloud not be decode as UTF-8 or the first byte of the response is not a valid type indicator this case also gets chosen.
    case WithDescription(ErrorKind, String)
    /// If an error as well some details to this error gets returned from redis this case will be chosen.
    case WithDescriptionAndDetail(ErrorKind, String, String)
    /// If the returned value is detected as an error but it can't be correlated to any of the known redis error an error with an redis extension is assumed
    case ExtensionError(String, String)
    /// Wrapped error of the underling socket connection
    case NWError(NWError)
    
    internal init(parse errorResponse: String) {
        let desc = "An error was signalled by the server"
        let pieces = errorResponse.split(separator: " ", maxSplits: 1)
        let code = String(pieces.first ?? "Unknown redis error response encountered")
        if let kind = ErrorKind(piece: code) {
            if let detail = pieces.last {
                self = .WithDescriptionAndDetail(kind, desc, String(detail))
            } else {
                self = .WithDescription(kind, desc)
            }
        } else {
            self = .ExtensionError(code, String(pieces.last ?? "Unknown extension error encountered"))
        }
    }
    
    public static let InvalidResponseError = RedisError.WithDescription(.ResponseError, "Invalid response from server")
    public static let InvalidUTF8 = RedisError.WithDescription(.TypeError, "Invalid UTF-8")
    
    public static func make_invalid_type_error(detail: String) -> RedisError {
        return RedisError.WithDescriptionAndDetail(.TypeError, "Response was of incompatible type", detail)
    }
}

/// An enum of all known redis error kinds.
public enum ErrorKind: Equatable {
    /// The server generated an invalid response.
    case ResponseError
    /// The authentication with the server failed.
    case AuthenticationFailed
    /// Operation failed because of a type mismatch.
    case TypeError
    /// A script execution was aborted.
    case ExecAbortError
    /// The server cannot response because it's loading a dump.
    case BusyLoadingError
    /// A script that was requested does not actually exist.
    case NoScriptError
    /// An error that was caused because the parameter to the
    /// client were wrong.
    case InvalidClientConfig
    /// Raised if a key moved to a different node.
    case Moved
    /// Raised if a key moved to a different node but we need to ask.
    case Ask
    /// Raised if a request needs to be retried.
    case TryAgain
    /// Raised if a redis cluster is down.
    case ClusterDown
    /// A request spans multiple slots.
    case CrossSlot
    /// A cluster master is unavailable.
    case MasterDown
    /// This kind is returned if the redis error is one that is
    /// not native to the system.  This is usually the case if
    /// the cause is another error.
    case IoError
    /// An error raised that was identified on the client before execution.
    case ClientError
    /// An extension error.  This is an error created by the server
    /// that is not directly understood by the library.
    case ExtensionError
    /// Attempt to write to a read-only server.
    case ReadOnly
    
    internal init?(piece: String) {
        switch piece {
        case "ERR":
            self = .ResponseError
        case "EXECABORT":
            self = .ExecAbortError
        case "LOADING":
            self = .BusyLoadingError
        case "NOSCRIPT":
            self = .NoScriptError
        case "MOVED":
            self = .Moved
        case "ASK":
            self = .Ask
        case "TRYAGAIN":
            self = .TryAgain
        case "CLUSTERDOWN":
            self = .ClusterDown
        case "CROSSSLOT":
            self = .CrossSlot
        case "MASTERDOWN":
            self = .MasterDown
        case "READONLY":
            self = .ReadOnly
        default:
            return nil
        }
    }
}
