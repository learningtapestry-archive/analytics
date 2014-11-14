<?php
// Check for empty fields
if (empty($_POST['email']) || empty($_POST['message']))
   { echo "Invalid arguments"; return false; }

$email_address = $_POST['email'];
$message = $_POST['message'];
	
// Create the email and send the message
$to = "admins@learningtapestry.com";
$email_subject = "Learning Tapestry Website Contact Form";
$email_body = "You have received a new message from your website contact form.\n\n"."Here are the details:\n\nEmail: $email_address\n\nMessage:\n\n$message";
$headers = "From: noreply@learningtapestry.com\n";
$headers .= "Reply-To: $email_address";	
mail($to,$email_subject,$email_body,$headers);
return true;			
?>