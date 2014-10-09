# Learning Activity JSON Serialization Format
-------------------------------------------

Below is provided as reference for the JSON messages the Extractor is currently sending.  This is draft state as pulled out of the Extractor code and not from the Redis queues.  See planned changes at bottom of document.

## Page View Event

{
  api_key: "5bdde140-4f60-11e4-916c-0800200c9a66",
  username: 123,
  site_uuid: "3bdde140-4f60-11e4-916c-0800200c9aff",
  verb: "viewed",
  action: {
    time: "1M32S",
    page_title: "Math Lesson 101"
  },
  url: "http://learning.null/math-lesson-101",
  page_title: "Math Lesson 101",
  captured_at: "2014-09-08T23:05:50-04:00"
};

## Click Event

{
  api_key: "5bdde140-4f60-11e4-916c-0800200c9a66",
  username: 123,
  site_uuid: "3bdde140-4f60-11e4-916c-0800200c9aff",
  verb: 'clicked',
  action: {
    url: "http://learning.null/math-lesson-102"
  },
  url: "http://learning.null/math-lesson-101",
  captured_at: "2014-09-08T23:05:50-04:00"
};

## Extract Event

{
  api_key: "5bdde140-4f60-11e4-916c-0800200c9a66",
  username: 123,
  site_uuid: "3bdde140-4f60-11e4-916c-0800200c9aff",
  verb: 'extracted',
  action: {
    html: "<div>block of html</div>"
  },
  url: "http://learning.null/math-lesson-101",
  captured_at: "2014-09-08T23:05:50-04:00"
};


--------------

## Planned Changes

1.)  Change "username" to "user_id" in all message payloads.
2.)  Remove duplicate page title out of page view event.
3.)  Verify all changes and format from Redis queue, actual JSON messages.