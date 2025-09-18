#!/usr/bin/env nu

globalprotect show --details
| str trim
| lines 
| parse "{key}: {value}"
| transpose -rd
| {
    "text": $in."Gateway Name",
    "tooltip": $in."Assigned IP Address"
}
| to json --raw 
