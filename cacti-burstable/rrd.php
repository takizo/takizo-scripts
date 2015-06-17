<?php 
include ('/usr/local/share/cacti/lib/rrd.php');
include ('/usr/local/share/cacti/lib/functions.php');
include ('/usr/local/share/cacti/include/global.php');

$conn = mysql_connect("localhost", "cacti", "cactidevel");

if (!$conn) {
    echo "Unable to connect to DB: " . mysql_error();
    exit;
}
  
if (!mysql_select_db("cacti")) {
    echo "Unable to select mydbname: " . mysql_error();
    exit;
}

//$sql = "SELECT local_data_id, name_cache FROM data_template_data WHERE name_cache like '%ME0%' limit 3";
$sql = "SELECT local_data_id, name_cache FROM data_template_data WHERE name_cache like '%ME0%'";

$result = mysql_query($sql);

if (!$result) {
    echo "Could not successfully run query ($sql) from DB: " . mysql_error();
    exit;
}

if (mysql_num_rows($result) == 0) {
    echo "No rows found, nothing to print so am exiting";
    exit;
}



while ($row = mysql_fetch_assoc($result)) {
	$graph_name = $row['name_cache'];

	
	$start_time 	= 1298908800; 
	$end_time 	= 1301587140;

	$inout_data = rrdtool_function_fetch($row['local_data_id'], $start_time, $end_time);

	$max_in = 0;
	$max_out = 0;

	$max_in_count = 1;
	$max_out_count = 1;

	$max_in_total = 0;
	$max_out_total = 0;

	$average_division = $end_time - $start_time;

	if(!empty($inout_data))
	{
		foreach ($inout_data['values'][0] as $row)
		{
			$max_in_total += ($row * 8 * 7200 );

			if ($row >= $max_in) {
				$max_in = $row;
			}
		}


		foreach ($inout_data['values'][1] as $row)
		{
			$max_out_total += ($row * 8 * 7200);

			if ($row >= $max_out) {
				$max_out = $row; 
			}
		}
	}

	$max_in = $max_in * 8 / 1000 / 1000;
	$max_out = $max_out * 8 / 1000 / 1000;
	$max_in_avg = ($max_in_total / $average_division / 1000 / 1000);
	$max_out_avg = ($max_out_total / $average_division / 1000 / 1000);

	echo "$graph_name,$max_in_avg,$max_out_avg,$max_in,$max_out\n";
}
?>
