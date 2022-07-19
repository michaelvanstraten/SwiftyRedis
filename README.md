# SwiftyRedis

SwiftyRedis is a high level async redis library for Swift. It is partially rewritten and heavily inspired by the [redis-rs](https://github.com/redis-rs/redis-rs) rust crate. It provides convenient access to all Redis functionality through a very flexible but low-level API. It has a customizable type conversion protocol so that any operation can return results in just the type you are expecting. This makes for a very pleasant development experience.

## Basic usage 
```swift
let client = RedisClient(.init("localhost"))
let connection = try await client.get_connection()

let value: String = try await connection.hget("myhash", "field1")
```

## Documentation

The Documentation is available [here](https://michaelvanstraten.github.io/SwiftyRedis/documentation/swiftyredis/) or under the link in the about section on the right.

## Contribution

I personally use xcode and vs-code for this project but i think any other IDE will also do as long as the [swift compiler](https://www.swift.org/getting-started/) is installed.

### Autogen

Do to the fact that redis offers 240 (stand july 2022) commands i wrote a small python script which generates the corresponding functions for us. The script automatically pulls the latest updates from the [redis github repo](https://github.com/redis/redis) and parses the json files specifying every command, located under `src/commands`, into a Swift implementation. 

To rerun the auto-generation execute the `generate-commands.py` script located in the `Sources/Autogen` directory. The resulting Swift files will be located in the `Sources/SwiftyRedis/Autogen/Commands` directory. This should automatically implement new commands that were not present at this point in time.

If anything goes wrong and the script doesn't implement a commands correctly, you can specify the name of the function in the `commands_to_ignore.json` file located in the `Sources/Autogen/config` directory. Important to note is that you must specify the function name that would be generated not the name of the command, this is for eas of development purposes so you don't have to lookup the actual command name.


There is also a `formatting_config.json` file located in the `Sources/Autogen/config` directory. This file holds a configuration which is passed to [swift-format](https://github.com/apple/swift-format) which is is responsible for formatting the generated Swift files.



