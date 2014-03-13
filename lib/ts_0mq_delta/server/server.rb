require 'rubygems'
require 'ffi-rzmq'

module Ts0mqDelta
  class Server

    def shutdown!
      Thread.kill(@workthread)
      [@subscriber].each do |socket|
        socket.close
      end
      @ctx.terminate
    end

    def log(msg)
      puts msg
    end

    def work_test(publisher)
      #loop do
        topic = "test"
        payload = "hello world"
        publisher.send_string(topic, ZMQ::SNDMORE)
        publisher.send_string(payload, ZMQ::SNDMORE)
        publisher.send_string(publisher.identity)
      #end
    end


    def work_job(subscriber)
      loop do
        topic = ''
        subscriber.recv_string(topic)

        body = ''
        subscriber.recv_string(body) if subscriber.more_parts?

        identity = ''
        subscriber.recv_string(identity) if subscriber.more_parts?
        log "subscriber received topic [#{topic}], body [#{body}], identity [#{identity}]"
        model, id = body.split("::")

        # Invalidate with redis!

        add_to_redis_delta(model, id)

      end

    end

    # Probably will get moved outside of the server.
    def add_to_redis_delta(model, id)

    end
    

    # End external

    def init!(port=5555)
      link = "tcp://127.0.0.1:#{port}"

      begin
        @ctx = ZMQ::Context.new
        @subscriber = @ctx.socket(ZMQ::SUB)
        @subscriber.bind(link)
      rescue ContextError => e
        STDERR.puts "Failed to allocate context or socket!"
        log "Failed to allocate context or socket!"
        raise
      end

      @subscriber.setsockopt(ZMQ::SUBSCRIBE, 'ts_delta')


      log "TS_Delta Server started, listening on #{link}"



      @workthread = Thread.new{ work_job(@subscriber) }



      trap("INT") { log "SIGINT: Shutting down....."; @stoploop = true;}
      loop do
        sleep(1)
        break if @stoploop == true
      end

      shutdown!


    end
  end
end