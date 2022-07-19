# ``SwiftyRedis/FromRedisValue``

This Protocol is used to convert a redis value into a more appropriate
type. While a ``RedisValue`` can represent any response that comes
back from the redis server, usually you want to map this into something
that works better in swift. For instance you might want to convert the
return value into a `String` or an integer.

## Overview

This Protocol is well supported throughout the package and you can
implement it for your own types if you want.
