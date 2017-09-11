/^#/ {
    if ($0~/^#separator/) {
        FS=" "
        bro_log_separator=FS
        FS=bro_log_separator
    } else if ($0~/^#set_separator/) {
        bro_log_set_separator=$2
    } else if ($0~/^#empty_field/) {
        bro_log_empty_field=$2
    } else if ($0~/^#unset_field/) {
        bro_log_unset_field=$2

    # When we're on the fields header, read each columns value
    # in and set an index in an array for later reference.
    } else if ($0~/^#path/) {
        bro_log_path=$2
    } else if ($0~/^#open/) {
        bro_log_open_time=$2
    } else if ($0~/^#close/) {
        bro_log_close_time=$2
        # Set our FS back to the default.
        FS=" "
    } else if ($0~/^#fields/) {
        # First clear any current bro array in case we're reading through multiple logs.
        delete bro
        for (i=2; i<=NF; i++) {
            bro[$i]=i-1
        };
    }

    # Finally, skip any futher processing.
    next;
}


