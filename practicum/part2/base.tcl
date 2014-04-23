
set ns [new Simulator]

#trace file
set tf [open simplified.tr w]
$ns trace-all $tf

#log file
set logger [open logger.tr w]

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


array set lan_nodes {}
array set internet_nodes {}
set router [$ns node]
set modem [$ns node]


for {set i 0} {$i < 2} {incr i} {
	set lan_nodes($i) [$ns node]
        $ns duplex-link $lan_nodes($i) $router 10Mb 10ms DropTail
}

$ns duplex-link $router $modem 10Mb 10ms DropTail
$ns queue-limit $router $modem 20

for {set i 0} {$i < 2} {incr i} {
	set internet_nodes($i) [$ns node]
        $ns duplex-link $internet_nodes($i) $modem 10Mb 10ms DropTail
}


# TCP connection, KUL server is agent, node 1 is sink
set tcp_agent [new Agent/TCP]
$tcp_agent set fid_ 1
$tcp_agent set window_ 80
set tcp_sink [new Agent/TCPSink]

$ns attach-agent $internet_nodes(0) $tcp_agent
$ns attach-agent $lan_nodes(0) $tcp_sink

$ns connect $tcp_agent $tcp_sink

# FTP app
set ftp [new Application/FTP]
$ftp set type_ FTP
$ftp attach-agent $tcp_agent


## Crazy burst traffic simulator


# Generators for random size of files.
set rep 1
set rng1 [new RNG]
set rng2 [new RNG]
for {set i 0} {$i < $rep} {incr i} {
    $rng1 next-substream
    $rng2 next-substream
}

# Random size of files to transmit
set size_svar [new RandomVariable/Pareto]
$size_svar set avg_ 150000
$size_svar set shape_ 1.5
$size_svar use-rng $rng1

# Random times in two second interval
set time_svar [new RandomVariable/Exponential]
$time_svar set avg_ 0.05
$time_svar use-rng $rng2
# We now define the beginning times of transfers and the transfer sizes

#pg90 and 54

# Number of sources
set NodeNb 3
# Number of flows per source node
set NumberFlows 40
# TCP Sources , destinations , connections
for { set i 1} { $i <= $NodeNb } { incr i } {
	for { set j 1} { $j <= $NumberFlows } { incr j } {
		set tcpsrc($i,$j) [new Agent/TCP/Newreno]
		set tcp_snk($i,$j) [new Agent/TCPSink]
		set k [expr $i * $NumberFlows + $j];
		$tcpsrc($i,$j) set fid_ $k
		$tcpsrc($i,$j) set window_ 2000
		$ns attach-agent $internet_nodes(1) $tcp_snk($i,$j)
		$ns attach-agent $lan_nodes(1) $tcpsrc($i,$j)
		$ns connect $tcpsrc($i,$j) $tcp_snk($i,$j)
		set ftp_array($i,$j) [$tcpsrc($i,$j) attach-source FTP]
		} 
	}


#doodoocaca
# Arrivals of sessions follow a Poisson process.
# set the beginning time of next transfer from source and attributes
# update the number of flows
for {set i 1} {$i <=$NodeNb} {incr i } {
    set t [expr $i * 5.0]
    for {set j 1} {$j<=$NumberFlows} {incr j } {
	set size [expr [$size_svar value]]
	$ns at $t "$ftp_array($i,$j) send $size"
        set addedTime [$time_svar value]
	set t [expr $t + $addedTime]
	puts "$t"
    }
}

# Printing the window size

proc printWindow {} {
	global ns tcp_agent logger
	set time 1
	set now [ $ns now ]
	set cwnd [ $tcp_agent set cwnd_ ]
	set ssthresh [ $tcp_agent set ssthresh_ ]
	puts $logger "$cwnd $ssthresh"
	$ns at [expr $now + $time] "printWindow" 
}

$ns at 0.1 "printWindow"
$ns at 0.1 "$ftp start"
$ns at 9.9 "$ftp stop"
$ns at 10.0 "finish"
$ns run
