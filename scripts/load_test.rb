#!/usr/bin/env ruby

threads = []

50.times do
  sleep(1)

  threads << Thread.new do
    system "phantomjs #{__dir__}/analytics_request.js"
    sleep(1.111)
  end
end

threads.each do |t|
  t.join
end
