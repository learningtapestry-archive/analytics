lt-redis-091914.zip is the test data test used to originally build the /lib/janitors/redis_postgres_sites_mover.rb. It has a bunch of invalid messages (outside of current LT extension format) in the back of the queue, more valid messages in the front.  (Good for testing....)

lt-redis-092414.zip is a snapshot from 9/24/14.  Those messages should all be valid format from data collected in the past few days.

Steps to load:

1. sudo service redis-server stop
1. unzip dump.rdb to /var/lib/redis
1. chown redis:vboxsf dump.rdb
1. sudo service redis-server start

http://redisdesktop.com/ is very helpful in confirming / viewing the message, without popping the messages off the stack.