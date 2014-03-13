require 'ffi-rzmq'

module ThinkingSphinx
  module Deltas
    class ZmqDelta < ThinkingSphinx::Deltas::DefaultDelta
      def initialize(adapter, options = {})
        @adapter, @options = adapter, options
      end

      def zmq_publisher
        return @publisher if @publisher
        port = 5555
        link = "tcp://127.0.0.1:#{port}"
        @ctx ||= ZMQ::Context.new
        @publisher ||= @ctx.socket(ZMQ::PUB)
        @publisher.setsockopt(ZMQ::LINGER, 100)
        @publisher.connect(link)
        @publisher.identity = "delta-app"
        sleep(1) # have to wait 1 cycle to use socket?
        @publisher
      end

      def send_delta_update(instance)
        Thread.new {
          topic = "ts_delta"
          payload = "#{instance.class.name}::#{instance.id}"
          zmq_publisher.send_string(topic, ZMQ::SNDMORE)
          zmq_publisher.send_string(payload, ZMQ::SNDMORE)
          zmq_publisher.send_string(zmq_publisher.identity)
          zmq_publisher.close
        }
      end


      def toggle(instance)
        send_delta_update(instance)
      end

      def toggled?(instance)
        puts instance.inspect
      end

      def clause(delta_source = false)
        return nil unless delta_source
         "id IN (1,2,3)"
      end
      def reset_query
        ""
      end
      def delete(index, instance)
        broadcast_delete(index, instance)
      end
      def broadcast_delete(index, instance)
        puts index.inspect
        puts instance.inspect
      end
    end
  end
end