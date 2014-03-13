require 'rubygems'
require 'ffi-rzmq'
require 'ts_0mq_delta/server/server.rb'


module Ts0mqDelta
  class Runner
    def run!
      server.init!
    end
    def server
      @server ||= Ts0mqDelta::Server.new
    end
  end
end
