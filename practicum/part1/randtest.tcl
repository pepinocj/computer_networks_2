proc random_sorted_tuple {range} {
    array set tuple {}
    set tuple(1) [eval {$range * rand()}]
    set tuple(2) [eval {$range * rand()}]
    
    return lsort tuple
}

for {set i 0} {$i < 10} {incr i} {
    set times [random_sorted_tuple 10.0]
    puts $times

    set times [random_sorted_tuple 10.0]
    puts $times
}
