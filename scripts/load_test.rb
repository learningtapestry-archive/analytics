#!/usr/bin/env ruby

threads = []

5.times do
  sleep(1)

  threads << Thread.new do
    100.times do
      system "phantomjs #{__dir__}/analytics_request.js"
      sleep(1)
    end
  end
end

threads.each do |t|
  t.join
end
