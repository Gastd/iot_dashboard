<?php
    $node = $_POST["node"];
    $lat = $_POST["lat"];
    $lon = $_POST["lon"];
    $Write = $lat . "," . $lon . "\n";
    $file_name = "node" . $node . ".txt";
    print("Printing in file " . $node . ".txt")
    print("the values lat:" . $lat . " and lon:" . $lon)
    file_put_contents($file_name, $Write);
?>
