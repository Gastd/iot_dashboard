<?php
    $node = $_POST["node"];
    $lat = $_POST["lat"];
    $lon = $_POST["lon"];
    $Write = $lat . "," . $lon . "\n";
    $file_name = "node" . $node . ".txt";
    file_put_contents($file_name, $Write);
?>
