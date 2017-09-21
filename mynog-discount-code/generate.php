<?php
function generateRandomString($length = 11) {
    $characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = 'IXNOGCONF-';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}



for ($d=0; $d<100; $d++)
{
	echo generateRandomString(5)."\n";
}
?>
