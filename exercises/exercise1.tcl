set ns [new Simulator]

#trace file
set tf [open oef.out.tr w]
$ns trace-all $tf

#nam tracefile
set nf [open oef.out.nam w]
$ns namtrace-all $nf

proc finish {} {
	#finalize trace files
	global ns nf tf
	$ns flush-trace
	close $tf
	close $nf
	
	exec nam oef.out.nam &
	exit 0
}


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail

#Setup a UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n0 $udp

set null [new Agent/Null]
$ns attach-agent $n2 $null
$ns connect $udp $null
$udp set fid_ 2

#Setup another UDP connection
set udp2 [new Agent/UDP]
$ns attach-agent $n2 $udp2

set null2 [new Agent/Null]
$ns attach-agent $n0 $null2
$ns connect $udp2 $null2
$udp2 set fid_ 1

#Setup a CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packetSize_ 1500
$cbr set rate_ 10Mb
$cbr set random_ false



#Setup another CBR over UDP connection
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set packetSize_ 1500
$cbr2 set rate_ 5Mb
$cbr2 set random_ false

$ns at 0.1 "$cbr start"
$ns at 10.1 "$cbr stop"
$ns at 0.1 "$cbr2 start"
$ns at 10.1 "$cbr2 stop"


$ns run
