# ``SwiftyRedis/RedisClient``

The client acts as connector to the redis server. By itself it does not
do much other than providing a convenient way to fetch a connection from
it. 

## Example

```swift
let client = RedisClient(.init("localhost"))
let connection = try await client.get_connection()
```
