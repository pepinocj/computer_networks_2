set ns [new Simulator]

#trace file
set tf [open simplified.tr w]
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

set lan_nodes_0 [$ns node]
set lan_nodes_1 [$ns node]
set lan_router [$ns node]
set modem_uplink [$ns node]
set modem_downlink [$ns node]
set telenet_network [$ns node]
set kul_servers [$ns node]
set internet_servers [$ns node]

$ns duplex-link $lan_nodes_0 $lan_router 10Mb 10ms DropTail
$ns duplex-link $lan_nodes_1 $lan_router 10Mb 10ms DropTail

$ns duplex-link $lan_router $modem_uplink 10Mb 0.2ms DropTail

$ns simplex-link $modem_uplink $modem_downlink 256Kb 0.2ms DropTail
$ns simplex-link $modem_downlink $modem_uplink 4Mb 0.2ms DropTail

$ns duplex-link $modem_downlink $telenet_network 100Mb 0.3ms DropTail

$ns duplex-link $telenet_network $kul_servers 100Mb 0.3ms DropTail
$ns duplex-link $telenet_network $internet_servers 100Mb 0.3ms DropTail


# TCP connection, KUL server is agent, node 1 is sink
set tcp_agent [new Agent/TCP]
$tcp_agent set fid_ 1
set tcp_sink [new Agent/TCPSink]

$ns attach-agent $kul_servers $tcp_agent
$ns attach-agent $lan_nodes_1 $tcp_sink

$ns connect $tcp_agent $tcp_sink


set ftp [new Application/FTP]
$ftp set type_ FTP
$ftp attach-agent $tcp_agent
$ftp set window_ 80

$ns at 0.1 "$ftp start"
$ns at 9.9 "$ftp stop"
$ns at 10.0 "finish"

$ns run
