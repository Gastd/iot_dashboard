<?php
    $Temp = $_POST["temperature"];
    $Humidity = $_POST["humidity"];
    $Write = "<p>Temperature : " . $Temp . " Celsius </p>" . "<p>Humidity : " . $Humidity . " % </p>";
    file_put_contents('sensor.html', $Write);
?>
