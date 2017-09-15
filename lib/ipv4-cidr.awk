
# Turn an IPv4 address into its decimal equivilent for easier processing.
function ipv4_2_dec(_addr_) {
    if (addrtype(_addr_) != "v4") {
        return 0
    }

    split(_addr_, _octets_, ".")

    _dec_addr_ = _octets_[1]*2^24 + _octets_[2]*2^16 + _octets_[3]*2^8 + _octets_[4]
    return int(_dec_addr_)
}



# Determine if the address _addr_ is inside the _cidr_ netblock
function addr_in_cidr(_addr_,_cidr_) {
    if (_cidr_ !~ /\//) { # Return false if _cidr_ doesn't have a slash. Not a complete check. Must fix.
        return 0
    }
    if (addrtype(_addr_) != "v4") { # For now don't handle non-ipv4 addresses.
        return 0
    }
   
    split(_cidr_, _cidrparts_, "/")
    _cidrnet_ = _cidrparts_[1]
    _cidrmask_ = _cidrparts_[2]

    _addrdec_ = ipv4_2_dec(_addr_)
    _cidrnetdec_ = ipv4_2_dec(_cidrnet_)

    if (_addrdec_ > _cidrnetdec_ && _addrdec_ < (_cidrnetdec_ + 2^(32-_cidrmask_))) {
        return 1
    } else {
        return 0
    }
}
