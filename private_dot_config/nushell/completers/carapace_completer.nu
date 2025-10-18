# carapace_completer.nu
# Carapace shell completion integration for Nushell
# For more information, see: https://www.nushell.sh/cookbook/external_completers.html#putting-it-all-together

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}
