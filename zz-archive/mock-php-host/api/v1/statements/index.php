<?php

if ($_SERVER['REQUEST_METHOD'] == "POST") {
  $postdata = file_get_contents("php://input");
  $path = "./data/";
  $filename = str_replace(".", "", microtime(true)) . ".json";
  file_put_contents($path . $filename,$postdata);
  echo $filename;
} else {
  header("HTTP/1.0 404 Not Found");
  echo "not found";
}

?>
