# Learntaculous Project Timeline

## Pre-Mid August 2014

### Goal:  prototype basic concepts

- [DONE] Agreement on overall system architecture
- [DONE] Prototype Chrome JS Extension, modifed to capture wholesale HTML blocks
- [DONE] Standup development server:  Nginx, Redis, Postgres, Ruby 1.9; automatic updates, etc.
- [DONE] Developed Nginx+Lua+Redis inbound message collector
- [DONE] Performance tested inbound message collector, small box, 3k+ message/sec (10k messages)
- [DONE] Testing of Chrome JS Extension with Codecademy, proven to submit 14k messages (page views and clicks)

## Mid-End August 2014

### Goal:  End to end concept functional

- [DONE] Finish Redis to Postgres queue janitor
- [IN-PROCESS, refactor] Deliver Postgres HTML info extractor janitor (http://nokogiri.org/)
- Standup basic web interface (http://startbootstrap.com/template-overviews/sb-admin/)

## Early-Mid September 2014

### Goal:  Solidify the code base

- [DONE] Focus on building unit testing
- [DONE] Implement continuous integration system (short term, CruiseControl.rb)
- Enhance Chome JS extension:  process Oauth2, get custom site list with extract cues, local storage/remote dequeue, event chaining
- User authentication and Oauth2 (both for Chorme extension and web login)
- Develop admin panel to for HTML info extraction

## Mid-End September 2014

### Goal:  Pilot readiness

- Handful of users, with handful of sites, to generate test data
- Enhance dashboard based on what we're finding as valuable information (or lack of valuable information)
- Increase system logging and monitoring infrastructure
- Test, test, test
- If bandwidth, wire up alerting janitor