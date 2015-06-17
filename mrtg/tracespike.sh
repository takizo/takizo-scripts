#!/opt/local/bin/perl

# Detect traffic spike at what time 
# To troubleshoot MRTG graph plotting error

open FILE, "transit.log.new";
my @routerlogs = <FILE>;

foreach my $routerlog (@routerlogs)
{
	
	my @data = split(' ', $routerlog);
	if ($data[1] > 500000000)	{	
	print scalar localtime($data[0]), " ## ", $data[1], " ## ", $data[0], "\n";
	}
}

print scalar localtime(1309160700);
