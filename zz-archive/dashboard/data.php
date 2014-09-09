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
		$sql = "SELECT * FROM vw_users_hits;";

		$first = true;

    	foreach ($connection->query($sql) as $row) {

    		if ($first) {
	    		foreach ($row as $key=>$value) {
	    			if (!is_numeric($key)) {
		    			echo $key;
		    			echo "\t";
	    			}
	    		}
	    		echo "\n";
	    		foreach ($row as $key=>$value) {
	    			if (!is_numeric($key)) {
		    			echo $value;
		    			echo "\t";
	    			}
	    		}
	    		$first = false;    			
    		} else {
				foreach ($row as $key=>$value) {
    			if (!is_numeric($key)) {
	    			echo $value;
	    			echo "\t";
    				}
	    		}
    		}

    		echo "\n";
//    		echo "<br/>";
    	}
	}
?>
