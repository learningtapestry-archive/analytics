<?php

	$connectionString = "pgsql:host=amazon-free.cath2wp0uca8.us-east-1.rds.amazonaws.com;port=5432;dbname=learntac;user=learntac;password=learn00tac!!";
	$messageDirectory = "/var/www/learntaculous/mock-php-host/api/v1/statements/data/"; //important this ends with a slash

	$connectionSuccess = false;
	$connection = null;

	try {
		$connection = new PDO($connectionString);
		$connectionSuccess = true; // if we don't connect, we'll get an exception, otherwise let's assume we're connected.
	} catch (Exception $e) {
		print_r($e);
		//TODO:  log an error - can't connect to database
	}

	if ($connectionSuccess) {
		processJsonFiles($messageDirectory, $connection);
	}

	echo "\n---- Finished ----\n";

	function processJsonFiles($messageDirectory, &$connection) { 
		
		$files = scandir($messageDirectory);
		$lastFile = "";

		foreach ($files as $file) {
			try {	
				if (substr(strtolower($file), -5) == ".json") {
					$fileContents = file_get_contents($messageDirectory . $file, "r");
					$jsonStatement = json_decode($fileContents);

					if (is_object($jsonStatement)) {
						$user_id = $jsonStatement->user->email;
						$action_name = $jsonStatement->user->action->id;
						$source_url = $jsonStatement->user->url->id;

						$value_string = null;
						$value_timestamp = null;
						$value_integer = null;
						$value_float = null;
						$value_interval = null;

						switch ($action_name) {
							case "verbs/viewed":
								$value_interval = $jsonStatement->user->action->value->time;
								echo "viewed\n";
							break;
							case "verbs/quoted":
								$value_string = $jsonStatement->user->action->value->quote;
								$value_float = floatval($jsonStatement->user->action->value->price);
								echo "quoted\n";
							break;
							case "verbs/clicked":
								$value_string = $jsonStatement->user->action->value->url;
								echo "clicked\n";
							break;
							default:
							break;
						}

						insertRow($connection, $user_id, $action_name, $source_url, $value_string, $value_timestamp, $value_integer, $value_float, $value_interval);
					}
				}
			} catch (Exception $e) {
	    			echo 'Caught exception: ',  $e->getMessage(), "\n";
			}
		}

		foreach (array_filter(glob("$messageDirectory\/*.json") ,"is_file") as $f) {
  			rename ($f, $f . ".done");
		}
	}

	function insertRow(&$connection, $user_id, $action_name, $source_url, $value_string, $value_timestamp, $value_integer, $value_float, $value_interval) {
		$statement = $connection->prepare("INSERT INTO actions (user_id, action_name, source_url, value_string, value_timestamp, value_integer, value_float, value_interval) 
											VALUES 
											(:user_id, :action_name, :source_url, :value_string, :value_timestamp, :value_integer, :value_float, :value_interval)");

		$statement->bindValue(":user_id", $user_id, PDO::PARAM_STR);
		$statement->bindValue(":action_name", $action_name, PDO::PARAM_STR);
		$statement->bindValue(":source_url", $source_url, PDO::PARAM_STR);
		$statement->bindValue(":value_string", $value_string, PDO::PARAM_STR);
		$statement->bindValue(":value_timestamp", $value_timestamp, PDO::PARAM_STR);
		$statement->bindValue(":value_integer", $value_integer, PDO::PARAM_INT);
		$statement->bindValue(":value_float", $value_float, PDO::PARAM_STR);
		$statement->bindValue(":value_interval", $value_interval, PDO::PARAM_STR);

		// :user_id, :action_name, :source_url, :value_string, :value_timestamp, :value_integer, :value_float, :value_interval
		//print_r($parameterArray);

		$success = $statement->execute();
		
		if ($success) {
			echo "Success\n";
			echo $connection->lastInsertId();
		} else {
			echo "Error\n";
			print_r($connection->errorInfo());
		}

		echo "\n";
	}

	function markFileProcessed($filename) {
		if (file_exists($filename)) {
			rename($filename, $filename . ".done");
		}
	}

?>
