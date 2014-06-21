<?php

	$messageDirectory = "/Users/jason/Desktop/messages/";
	$files = scandir($messageDirectory);

	foreach ($files as $file) {
		try {	
			if (substr(strtolower($file), -5) == ".json") {
				$fileContents = file_get_contents($messageDirectory . $file, "r");
				$jsonStatement = json_decode($fileContents);

				if (is_object($jsonStatement)) {
					$email = $jsonStatement->user->email;
					$url = $jsonStatement->user->url->id;
					$action = $jsonStatement->user->action->id;

					$valueString = null;
					$valueInteger = null;
					$valueFloat = null;
					$valueDateTime = null;

					switch ($action) {
						case "verbs/viewed":
							$valueString = $jsonStatement->user->action->value->time;
							echo "viewed\n";
						break;
						case "verbs/quoted":
							//print_r($jsonStatement->user);
							$valueString = $jsonStatement->user->action->value->quote;
							$valueFloat = floatval($jsonStatement->user->action->value->price);
							echo "quoted\n";
						break;
						case "verbs/clicked":
							$valueString = $jsonStatement->user->action->value->url;
							echo "clicked\n";
						break;
						default:
						break;
					}

				}

				echo $valueString; echo "\n";
				echo $valueInteger; echo "\n";
				echo $valueFloat; echo "\n";
				echo $valueDateTime; echo "\n";


				//print_r($jsonStatement);
			}
		} catch (Exception $e) {
    		echo 'Caught exception: ',  $e->getMessage(), "\n";
		}
	}

	echo "\n";
	echo "---- Finished ----";
	echo "\n";
?>
