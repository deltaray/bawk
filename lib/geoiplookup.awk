# Copyright 2017 Mark Krenz <mkrenz@iu.edu>
#    This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


BEGIN {
    _geoipcachefile_=ENVIRON["HOME"] "/.bawk-geoip-cache"
    # Check that the geoiplookup binary is available.
    if (system("[ -x /usr/bin/geoiplookup ]")) {
        print "FATAL: No geoiplookup executable found." > "/dev/stderr"
        _noending_=1
        exit(1)
    }

    _oldfs_=FS
    FS=" "
    while(( getline < _geoipcachefile_ ) > 0 ) {
        _geoipcachearr_[$1] = $2;
    }
    FS=_oldfs_

}

function geoip(_ip_) {
 _addrtype_ = addrtype(_ip_)
 if (_addrtype_ == "") { # Check that this is a valid IP address first
    print "FATAL: Attempt to geoip lookup on non-IP address on line " NR " of file " FILENAME    
    _noending_=1
    exit(2)
 }
 if (_geoipcachearr_[_ip_]) {
     _countrycode_=_geoipcachearr_[_ip_]
 } else {
     if (_addrtype_ == "v6") {
        _command_="geoiplookup6 " _ip_
     } else {
        _command_="geoiplookup " _ip_
     }
     _command_ | getline _result_
     close(_command_)
     if (_result_~/,/) { # The valid lines of geoiplookup have a , in them, but this check should be imrpoved.
        _countrycode_=substr(_result_,24,2)
     } else {
        _countrycode_="-"
     }
     _geoipcachearr_[_ip_]=_countrycode_
 }
 return _countrycode_
}



END {
    if (!_noending_) {
        system("cp /dev/null " _geoipcachefile_)
        for (_ip_ in _geoipcachearr_) {
            print _ip_ " " _geoipcachearr_[_ip_] >> _geoipcachefile_
        } 
    }
}

