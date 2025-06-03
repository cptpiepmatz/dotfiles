$env.config.buffer_editor = "micro"

# Aliases
# alias clip = clip.exe

# Starship
source ~/.cache/starship/init.nu

source ~/.cache/carapace/init.nu

# Custom Modules
# source ~/.nu/python.nu
# source ~/.nu/azul-java.nu
# source ~/.nu/nu_scripts/modules/formats/from-env.nu

# Plugin Config
$env.config.plugins.highlight.theme = "Monokai Extended Origin"

# set NU_OVERLAYS with overlay list, useful for starship prompt
$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append {|| 
  let nu_overlays = (overlay list | slice 1.. | str join ", ")
  if ($nu_overlays | str length | into bool) {
    $env.NU_OVERLAYS = $nu_overlays
  } else {
    $env.NU_OVERLAYS = null
  }
})

let secrets = open ~/secrets.nuon | transpose dir env
$env.known_secrets = []
$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append {||
  for secret in $env.known_secrets {
    hide-env $secret
  }

  $env.known_secrets = []
  $env.NU_KNOWN_SECRETS = null

  for entry in $secrets {
    if (pwd | path expand | str starts-with $entry.dir) {
      load-env $entry.env
      $env.known_secrets ++= ($entry.env | columns)
    }
  }

  if ($env.known_secrets | is-not-empty) {
    $env.NU_KNOWN_SECRETS = $env.known_secrets | each {"• " + $in} | str join "\n"
  }
})

$env.VIRTUAL_ENV_DISABLE_PROMPT = true

$env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge {
    "SOME_ENV": {
        from_string: { |s| print "running from_string"; $s }
        to_string: { |v| print "running to_string"; $v }
    }
}

def --env cdr [] {
  cd (^git rev-parse --show-toplevel)
}
