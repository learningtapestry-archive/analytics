<?php

	$connectionString = "pgsql:host=localhost;port=5432;dbname=learntac;user=jason";

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
		$sql = "SELECT * FROM actions ORDER BY insert_date";

    	foreach ($connection->query($sql) as $row) {
    		print_r($row);a
    	}
	}
?>
