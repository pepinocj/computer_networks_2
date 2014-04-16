
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

# Arrivals of sessions follow a Poisson process.
# set the beginning time of next transfer from source and attributes
# update the number of flows
for {set i 1} {$i <=$NodeNb} {incr i } {
    set t [$ns now]
    for {set j 1} {$j<=$NumberFlows} {incr j } {
        set addedTime [$time_svar value]
	set t [expr $t + $addedTime]
        set tcpsrc($i,$j) [new Agent/TCP/Newreno]
	$tcpsrc($i,$j) set starts $t
	$tcpsrc($i,$j) set sess $j
	$tcpsrc($i,$j) set node $i
	$tcpsrc($i,$j) set size [expr [$size_svar value]]
	$ns at [$tcpsrc($i,$j) set starts] "$ftp($i,$j) send [$tcpsrc($i,$j) set size]"
	$ns at [$tcpsrc($i,$j) set starts] "countFlows $i 1"
    }
}


$ns at 0.1 "$ftp start"
$ns at 9.9 "$ftp stop"
$ns at 10.0 "finish"

$ns run
