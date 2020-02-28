<?php
    $lat = $_POST["lat"];
    $lon = $_POST["lon"];
    $Write = $lat . "," . $lon . "\n";
    file_put_contents('node1.txt', $Write);
?>
