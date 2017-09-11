
BEGIN {
    # Check that the geoiplookup binary is available.
    if (system("[ -x /usr/bin/geoiplookup ]")) {
        print "FATAL: No geoiplookup executable found." > "/dev/stderr"
        noending=1
        exit(1)
    }

    OLDFS=FS
    FS=" "
    while(( getline < "/tmp/geoipbroawkcache" ) > 0 ) {
#        print "Reading in line for ip " $1 " from cache file"
        geoipcachearr[$1] = $2;
    }
    FS=OLDFS

}

function geoip(ip) {
 if (geoipcachearr[ip]) {
#     print "cache hit on " ip
     countrycode=geoipcachearr[ip]
 } else {
     command="geoiplookup " ip
     command | getline result
     runcount++
     close(command)
     if (result~/,/) { # All the valid responses have a , in them. ;-)
        countrycode=substr(result,24,2)
     } else {
        countrycode="-"
     }
     geoipcachearr[ip]=countrycode
 }
 return countrycode
}



END {
    if (!noending) {
        #print "Ran geoip " runcount " times";
        system("cp /dev/null /tmp/geoipbroawkcache")
        for (ip in geoipcachearr) {
            print ip " " geoipcachearr[ip] >>"/tmp/geoipbroawkcache"
        } 
    }
}

