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
	close $nf
	
	exit 0
}


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n0 $n4 10Mb 10ms DropTail
$ns duplex-link $n0 $n6 10Mb 10ms DropTail

$ns duplex-link $n0 $n1 10Mb 10ms DropTail

$ns duplex-link $n1 $n3 10Mb 10ms DropTail
$ns duplex-link $n1 $n5 10Mb 10ms DropTail
$ns duplex-link $n1 $n7 10Mb 10ms DropTail
$ns queue-limit $n0 $n1 20

set tcp1 [new Agent/TCP/Newreno]
set tcp2 [new Agent/TCP/Newreno]
set tcp3 [new Agent/TCP/Newreno]

set sink1 [new Agent/TCPSink]
set sink2 [new Agent/TCPSink]
set sink3 [new Agent/TCPSink]

$ns attach-agent $n2 $tcp1
$ns attach-agent $n4 $tcp2
$ns attach-agent $n6 $tcp3

$ns attach-agent $n3 $sink1
$ns attach-agent $n5 $sink2
$ns attach-agent $n7 $sink3

$tcp1 set packetSize_ 552
$tcp2 set packetSize_ 552
$tcp3 set packetSize_ 552

$tcp1 set window_ 60
$tcp2 set window_ 60
$tcp3 set window_ 60

$tcp1 set fid_ 1
$tcp2 set fid_ 2
$tcp3 set fid_ 3

$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
$ns connect $tcp3 $sink3

set ftp1 [new Application/FTP]
set ftp2 [new Application/FTP]
set ftp3 [new Application/FTP]

$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2
$ftp3 attach-agent $tcp3

$ns at 0.1 "$ftp1 start"
$ns at 0.4 "$ftp2 start"
$ns at 0.7 "$ftp3 start"
$ns at 19.1 "$ftp1 stop"
$ns at 19.5 "$ftp2 stop"
$ns at 19.7 "$ftp3 stop"

$ns at 19.8 "finish"

$ns run
