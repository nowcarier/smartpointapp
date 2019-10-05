<?php
require_once('db.php');
$query = 'SELECT `points` FROM `users` WHERE Kritsana Prasit';
$stm = $db->prepare($query);
$stm->execute();
$row = $stm->fetch(PDO::FETCH_ASSOC);
$data = json_encode($row);
echo $data;
?>


