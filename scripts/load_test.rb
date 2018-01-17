#!/usr/bin/env ruby

threads = []

3.times do
  threads << Thread.new do
    3.times do
      system "phantomjs #{__dir__}/analytics_request.js"
      sleep(1)
    end
  end
end

threads.each do |t|
  t.join
end
