<?php

$error = 0;
$successMessage = '';


if ($_POST['Submit'] == 'Send')
{
  $reURL = 'https://www.google.com/recaptcha/api/siteverify';
  $reSecret   = 'your secret key here';
  $reResponse = $_POST['g-recaptcha-response'];
  $reSubmission = json_decode(file_get_contents($reURL."?secret=".$reSecret."&response=".$reResponse), true);

	if($_POST['name'] == '')
  {
  	$error = 1;
    $errormessage[] = 'Name Field is empty';
  }

	if($_POST['phone'] == '')
  {
  	$error = 1;
      $errormessage[] = 'Phone Field is empty';
  }

  if($_POST['message'] == '')
  {
  	$error = 1;
    $errormessage[] = 'Message Field is empty';
  }

  if($reSubmission['success'] != 1)
  {
    $error = 1;
    $errormessage[] = 'Recaptcha failed to verify';
  }

  if($error != 1)
  {
  	$successMessage = 'Thank you, we will contact you shortly.';

    $message = 'Name: '. $_POST['name']."\n\n";
    $message .= 'Phone: '. $_POST['phone']."\n\n";
    $message .= "\n\n".$_POST['message']."\n\n";

    mail('no-reply@noreplied.com', 'Inquiry Form: Noreplied.com', $message);
  }
}
?>


<html>
<head>
<title>Sample reCaptcha PHP Form</title>

<!-- Include reCaptcha Script in HEAD -->
<script src='https://www.google.com/recaptcha/api.js'></script>

</head>

<body>

<?php
// Display Error Message(s)
if($error == 1)
{
  foreach ($errormessage as $l)
  {
    echo '<font color="red">'.$l.'</font>'."<br />";
  }
}

// Display Success Message
if(!empty($successMessage))
{
  echo '<font color="green">'.$successMessage.'</font>'."<br />";
}
?>


  <form method="post" action="/">
  <div>
    Name:
    <input name="name" type="text" size="30">
  </div>

  <div>
    Mobile:
    <input name="phone" type="text" size="30">
  </div>

  <div>
    Email:
    <input name="email" type="text" size="30">
  </div>

  <div>
    Message:
    <textarea name="message" cols="40" rows="4" ></textarea>
  </div>

  <div class="g-recaptcha" data-sitekey="Put in your Site Key here"></div>

  <div>
    <input name="Submit" type="submit" id="Send" value="Submit" />
  </div>
  </form>
</body>
</html>
