# encoding: utf-8
require 'ts_0mq_delta/redis-connection'
module Ts0mqDelta



  def self.configure_client
    yield self
  end

  def self.redis(&block)
    raise ArgumentError, "requires a block" if !block
    @redis ||= Ts0mqDelta::RedisConnection.create(@hash || {})
    @redis.with(&block)
  end

  def self.redis=(hash)
    return @redis = hash if hash.is_a?(ConnectionPool)

    if hash.is_a?(Hash)
      @hash = hash
    else
      raise ArgumentError, "redis= requires a Hash or ConnectionPool"
    end
  end


  def self.load_json(string)
    JSON.parse(string)
  end

  def self.dump_json(object)
    JSON.generate(object)
  end


  def self.poll_interval=(interval)
    self.options[:poll_interval] = interval
  end

  def self.error_handlers
    self.options[:error_handlers]
  end

end