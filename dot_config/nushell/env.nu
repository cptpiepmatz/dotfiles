mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu
# This needs to be a string.
# Otherwise this does not work.
$env.PIP_REQUIRE_VIRTUALENV = "true"

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu