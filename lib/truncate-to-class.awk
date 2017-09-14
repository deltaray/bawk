
# These are just some useful functions for truncating an IP to its seperate dotted quads.
# This is kind of an old idea, but its nice to be able to remove the last part(s) of a dotted
# quad and compare just the first parts.


function getclass (_maxdots_, _ip_) {
    if (addrtype(_ip_) != "v4") {
        # Right now let's just return the input if its not IPv4.
        return _ip_
    }
    _dotcount_ = 0
    _returnstring_ = ""
    for (_i_ = 1; _i_ < length(_ip_); _i_++) {
        _c_ = substr(_ip_,_i_, 1);
        if (_c_ == ".") {
            _dotcount_++
            if (_dotcount_ == _maxdots_) {
                return _returnstring_
            }
        }
        _returnstring_ = _returnstring_ _c_
    }
    return _returnstring_
}

function classC(_ip_) { 
    return getclass(3,_ip_)
}

function classB(_ip_) { 
    return getclass(2,_ip_)
}

function classA(_ip_) { 
    return getclass(1,_ip_)
}

