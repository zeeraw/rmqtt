require "bunny"

conn = Bunny.new
conn.start

ch   = conn.create_channel
x    = ch.topic("v1")
key  = ARGV.shift || "#"
msg  = ARGV.empty? ? "Hello World!" : ARGV.join(" ")

x.publish(msg, :routing_key => key)
puts " [x] #{key}: #{msg}"

conn.close