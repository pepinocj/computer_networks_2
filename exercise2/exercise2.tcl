set ns [new Simulator]

#trace file
set tf [open out.tr w]
$ns trace-all $tf

#nam tracefile
set nf [open out.nam w]
$ns namtrace-all $nf

proc finish {} {
	#finalize trace files
	global ns nf tf
	$ns flush-trace
	close $tf
	close $nf exit 0
}

array set nodes {} 
array set routers {} 
for {set i 0} {$i < 6} {incr i} {
	set nodes($i) [$ns node]
} 

for {set i 0} {$i < 2} {incr i} {
	set routers($i) [$ns node]
} 

for {set i 2} {$i < 6} {incr i} {
	if {$i % 2} {
		$ns duplex-link $routers(0) $nodes($i) 10Mb 10ms DropTail
	} else {
		$ns duplex-link $routers(1) $nodes($i) 10Mb 10ms DropTail
	}
}
 

$ns duplex-link $routers(0) $routers(1) 10Mb 10ms DropTail
$ns queue-limit $routers(0) $routers(1) 20

array set agents {}
array set sinks {}

for {set i 0} {$i < 3} {incr i} {
	set agents($i) [new Agent/TCP]
	$agents($i) set packetSize_ 552
	$agents($i) set window_ 60
	$agents($i) set fid_ $i
	set sinks($i) [new Agent/TCPSink]
} 

for {set i 2} {$i < 6} {incr i} {
	if {$i % 2} {
		set k [expr $i/2 - 1]
		puts $k
		$ns attach-agent $nodes($i) $sinks($k)
	} else {
		set k [expr $i/2 - 1]
		puts $k
		$ns attach-agent $nodes($i) $agents($k)
	}
}


for {set i 0} {$i < 3} {incr i} {
	$ns connect $agents($i) $sinks($i)
}

array set ftp {}

for {set i 0} {$i < 3} {incr i} {
	set ftp($i) [new Application/FTP]
	$ftp($i) attach-agent $agents($i)
}


$ns at 0.1 "$ftp(0) start"
$ns at 0.4 "$ftp(1) start"
$ns at 0.7 "$ftp(2) start"
$ns at 19.1 "$ftp(0) stop"
$ns at 19.5 "$ftp(1) stop"
$ns at 19.7 "$ftp(2) stop"

$ns at 19.8 "finish"

$ns run
