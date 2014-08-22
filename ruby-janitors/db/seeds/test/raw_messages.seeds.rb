#id,status,api_key,email,action,url,html,date_captured,date_created,date_updated
RawMessage.create(
  :status=>'READY',
  :email=>'foo@bar.com',
  :action=>'GET',
  :html=>'<html><body></body></html>',
  :date_captured=>Time::now)
