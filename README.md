# KeyCache::Cache

## Description

This modules is an Rails Concern which provides a simple mechanism for
caching values in redis.

## Arguments

*key*: key value to store the location. Use "/" to define segments and ":"
to define segments that you want to be replaced by values returned from methods in your class

*value*: When saving the record, this method will be called to get the value to store in Redis.

*method*: defines a method which can be called to get the value of the stored Redis key

## Usage

```ruby
class SomeModel < ApplicationRecord
  include KeyCache::Cache

  cache_key key: "some_model/:id",
            value: :some_attribute,
            method: some_model_cache
end

s = SomeModel.save!(some_value: "this value")

s.some_attribute
# > this value

s.some_attribute_key
# > some_model/:id

s.some_attribute_redis_key
# > some_model:1

s.save_some_attribute # Saves key to Redis

s.destroy_some_attribute # Deletes key from Redis

s.destory # Delete record and redis key
```
