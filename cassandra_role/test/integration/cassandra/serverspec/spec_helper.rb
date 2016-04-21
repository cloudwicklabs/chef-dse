# Encoding: utf-8

require 'serverspec'

RSpec.configure do |c|
  c.before :all do
    set :backend, :exec
    set :path, '/usr/sbin:/bin/sh:/sbin:/usr/local/sbin:$PATH'
  end
end
