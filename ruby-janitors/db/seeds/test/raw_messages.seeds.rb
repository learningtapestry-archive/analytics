#id,status,api_key,email,action,url,html,date_captured,date_created,date_updated

RawMessage.create(
  :api_key=>'api_key_1',
  :status=>'READY',
  :email=>'foo@bar.com',
  :action=>'GET',
  :html=>'<html><body><a href="foo">link</a></body></html>',
  :date_captured=>Time::now)
RawMessage.create(
  :api_key=>'api_key_2',
  :status=>'READY',
  :email=>'bar@bar.com',
  :action=>'GET',
  :html=>'<html><body><a href="bar">link</a></body></html>',
  :date_captured=>Time::now)
