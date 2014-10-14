require "bunny"

abort "Usage: #{$0} [binding key]" if ARGV.empty?

conn = Bunny.new
conn.start

ch  = conn.create_channel
x   = ch.topic("v1")
q   = ch.queue("", :exclusive => true)

ARGV.each do |severity|
  q.bind(x, :routing_key => severity)
end

puts " [*] Waiting for logs. To exit press CTRL+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts " [x] #{delivery_info.routing_key}: #{ body }"
  end
rescue Interrupt => _
  ch.close
  conn.close
end