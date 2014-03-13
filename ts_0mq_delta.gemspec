$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ts_0mq_delta/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ts_0mq_delta"
  s.version     = Ts0mqDelta::VERSION
  s.authors     = ["Justin McNally"]
  s.email       = ["justin@kohactive.com"]
  s.homepage    = "http://www.kohactive.com"
  s.summary     = "Do deltas over øMQ"
  s.description = "ThinkingSphinx deltas with øMQ"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.3"
  s.add_dependency "ffi-rzmq"
  s.add_dependency "redis"

  s.add_development_dependency "sqlite3"
end
