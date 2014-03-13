require 'connection_pool'
require 'redis'
require 'uri'

module Ts0mqDelta
  class RedisConnection
    class << self

      def create(options={})
        url = options[:url] || determine_redis_provider
        if url
          options[:url] = url
        end

        # need a connection for Fetcher and Retry
        size = options[:size] || 5
        pool_timeout = options[:pool_timeout] || 1

        puts (options)

        ConnectionPool.new(:timeout => pool_timeout, :size => size) do
          build_client(options)
        end
      end

      private

      def build_client(options)
        namespace = options[:namespace]

        client = Redis.new client_opts(options)
        if namespace
          require 'redis/namespace'
          Redis::Namespace.new(namespace, :redis => client)
        else
          client
        end
      end

      def client_opts(options)
        opts = options.dup
        if opts[:namespace]
          opts.delete(:namespace)
        end

        if opts[:network_timeout]
          opts[:timeout] = opts[:network_timeout]
          opts.delete(:network_timeout)
        end

        opts[:driver] = opts[:driver] || 'ruby'

        opts
      end


      def determine_redis_provider
        ENV[ENV['REDIS_PROVIDER'] || 'REDIS_URL']
      end

    end
  end
end