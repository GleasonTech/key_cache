# frozen_string_literal: true

module KeyCache
  ##
  # KeyCache::Cache
  #
  # Description
  #
  # This modules is an Rails Concern which provides a simple mechanism for
  # caching values in redis.
  #
  # Arguments
  #
  #   key: key value to store the location. Use "/" to define segments and ":"
  #        to define segements that you want to be replaced by values returned
  #        from methods in your class
  #
  #   value: When saving the record, this method will be called to get the value
  #          to store in Redis.
  #
  #   method: defines a method which can be called to get the value of the
  #           stored Redis key
  #
  # Usage
  #
  # class SomeModel < ApplicationRecord
  #   include KeyCache::Cache
  #
  #   cache_key key: "some_model/:id",
  #             value: :some_attribute,
  #             method: :some_model_cache
  # end
  #
  # s = SomeModel.save!(some_value: "this value")
  #
  # s.some_attribute
  # > this value
  #
  # s.some_attribute_key
  # > some_model/:id
  #
  # s.some_attribute_redis_key
  # > some_model:1
  #
  # s.save_some_attribute # Saves key to Redis
  #
  # s.destroy_some_attribute # Deletes key from Redis
  #
  # s.destory # Delete record and redis key
  module Cache
    extend ActiveSupport::Concern

    class_methods do
      def cache_key(options = {})
        key = options.fetch(:key)
        value = options.fetch(:value)
        method = options.fetch(:method)

        class_eval <<-METHOD, __FILE__, __LINE__ + 1
          def #{method}
            Redis.current.get(cache_key_decode("#{key}"))
          end

          def #{method}_key
            "#{key}"
          end

          def #{method}_redis_key
            cache_key_decode("#{key}")
          end

          def save_#{method}
            Redis.current.set(cache_key_decode("#{key}"), self.send("#{value.to_sym}"))
          end

          after_save :save_#{method}

          def destroy_#{method}
            Redis.current.del(cache_key_decode("#{key}"))
          end

          after_destroy :destroy_#{method}
        METHOD
      end
    end

    def cache_key_decode(key)
      key_parts = key.split('/')
      key_parts.map! do |v|
        v.match(/^:/) ? send(v.tr(':', '')) : v
      end
      key_parts.join(':')
    end
  end
end
