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

/^#/ {
    if ($0~/^#separator/) {
        FS=" "
        _log_separator=FS
        FS=_log_separator
    } else if ($0~/^#set_separator/) {
        _log_set_separator=$2
    } else if ($0~/^#empty_field/) {
        _log_empty_field=$2
    } else if ($0~/^#unset_field/) {
        _log_unset_field=$2

    # When we're on the fields header, read each columns value
    # in and set an index in an array for later reference.
    } else if ($0~/^#path/) {
        _log_path=$2
    } else if ($0~/^#open/) {
        _log_open_time=$2
    } else if ($0~/^#close/) {
        _log_close_time=$2
        # Set our FS back to the default.
        FS=" "
    } else if ($0~/^#fields/) {
        # First clear any current bro array in case we're reading through multiple logs.
        delete _b
        for (_i_=2; _i_<=NF; _i_++) {
            _b[$_i_]=_i_-1
        };
    }

    # Finally, skip any futher processing.
    next;
}


