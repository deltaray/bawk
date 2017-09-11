
# Function for determining IPv4 or IPv6
# Based on the format.
function address_type(address) {
    if (index(address, ".")) {
        type = "v4"
    } else if (index(address, ":")) {
        type = "v6"
    } else {
        type = ""
    }
    return type
}


