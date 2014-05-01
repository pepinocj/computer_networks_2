set ns [new Simulator]

#trace file
set tf [open /dev/stdout w]
$ns trace-all $tf

#nam tracefile
set nf [open simplified.nam w]
$ns namtrace-all $nf

proc finish {} {
	#finalize trace files
	global ns nf tf
	$ns flush-trace
	close $tf
	close $nf 
	exit 0
}

set n 50
array set lan_nodes {}
set lan_router [$ns node]
set modem_uplink [$ns node]
set modem_downlink [$ns node]
set telenet_network [$ns node]
set kul_servers [$ns node]
set internet_servers [$ns node]

for {set i 0} {$i < $n} {incr i} {
	set lan_nodes($i) [$ns node]
        $ns duplex-link $lan_nodes($i) $lan_router 10Mb 10ms DropTail
}

$ns duplex-link $lan_router $modem_uplink 10Mb 0.2ms DropTail

$ns simplex-link $modem_uplink $modem_downlink 2MB 0.2ms DropTail
$ns simplex-link $modem_downlink $modem_uplink 40Mb 0.2ms DropTail

$ns duplex-link $modem_downlink $telenet_network 100Mb 0.3ms DropTail

$ns duplex-link $telenet_network $kul_servers 100Mb 0.3ms DropTail
$ns duplex-link $telenet_network $internet_servers 100Mb 0.3ms DropTail


# TCP connection,  node 0 is agent, Internet server is sink
array set tcp_agents {}
array set tcp_sinks {}

for {set i 0} {$i < $n} {incr i} {
    set tcp_agents($i) [new Agent/TCP]
    $ns attach-agent $kul_servers $tcp_agents($i)
    set tcp_sinks($i) [new Agent/TCPSink]
    $tcp_sinks($i) set fid_ $i
    $ns attach-agent $lan_nodes($i) $tcp_sinks($i)
    $ns connect $tcp_agents($i) $tcp_sinks($i)
}

# UDP connection,  node 0 is agent, Internet server is sink
array set udp_agents {}
set udp_sink [new Agent/Null]
$ns attach-agent $internet_servers $udp_sink

for {set i 0} {$i < $n} {incr i} {
    set udp_agents($i) [new Agent/UDP]
    $udp_agents($i) set fid_ $i
    $ns attach-agent $lan_nodes($i) $udp_agents($i)
    $ns connect $udp_agents($i) $udp_sink
}


array set ftp {}
for {set i 0} {$i < $n} {incr i} {
    set ftp($i) [new Application/FTP]
    $ftp($i) set type_ FTP
    $ftp($i) attach-agent $tcp_agents($i)
    $ftp($i) set packetSize_ 1500
    $ftp($i) set window_ 80
}

array set cbr {}
for {set i 0} {$i < $n} {incr i} {
    set cbr($i) [new Application/Traffic/CBR]
    $cbr($i) set type_ CBR
    $cbr($i) attach-agent $udp_agents($i)
    $cbr($i) set packetSize_ 1500
}


set rng1 [new RNG]
$rng1 next-substream
# Random times in two second interval
set time_svar [new RandomVariable/Uniform]
$time_svar set avg_ 5.0
$time_svar use-rng $rng1
$time_svar set min_ 0.1
$time_svar set max_ 10.0

set rng2 [new RNG]
$rng2 next-substream
# Random times in two second interval
set duration_svar [new RandomVariable/Uniform]
$duration_svar set avg_ 2.0
$duration_svar use-rng $rng2
$duration_svar set min_ 0.1
$duration_svar set max_ 5.0

for {set i 0} {$i < $n} {incr i} {
    set time [expr [$time_svar value]]
    set duration [expr [$duration_svar value]]
    $ns at $time "$ftp($i) start"
    $ns at [expr $time + $duration] "$ftp($i) stop"
}

for {set i 0} {$i < $n} {incr i} {
    set time [expr [$time_svar value]]
    set duration [expr [$duration_svar value]]
    $ns at $time "$cbr($i) start"
    $ns at [expr $time + $duration] "$cbr($i) stop"
}


# for {set i 0} {$i < 10} {incr i} {
#     $ns at 0.1 "$ftp($i) start"
#     $ns at 3.0 "$cbr($i) start"
#     $ns at 6.0 "$cbr($i) stop"
#     $ns at 9.9 "$ftp($i) stop"
# }

$ns at 10.0 "finish"

$ns run
