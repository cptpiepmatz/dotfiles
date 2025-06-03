#!/usr/bin/env nu

def main [--toggle] {
    match $toggle {
        true => {toggle}
        false => {run}
    }
}

const event_file = path self | str replace "color-scheme.nu" "color-scheme.event"

def current [] {
    dconf read /org/gnome/desktop/interface/color-scheme | from yml
}

def run [] {
    touch $event_file

    let handler = {
        let color_scheme = (current)
        print ({
            "text": $color_scheme, 
            "alt": $color_scheme, 
            "tooltip": $color_scheme,
            "class": $color_scheme
        } | to json --raw)
    }

    do $handler
    watch $event_file --quiet $handler 
}

def toggle [] {
    let update = match (current) {
        "default" => '"prefer-dark"',
        "prefer-dark" => '"prefer-light"',
        "prefer-light" => '"prefer-dark"',
        $unexpected => {
            print $"unexpected update value ($unexpected)"
            exit 1
        }
    }

    dconf write /org/gnome/desktop/interface/color-scheme $update
    $update | save $event_file -f
}
