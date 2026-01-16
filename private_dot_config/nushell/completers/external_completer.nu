# external_completer.nu
# External shell completion integration for Nushell
# For more information, see: https://www.nushell.sh/cookbook/external_completers.html#putting-it-all-together

source carapace_completer.nu
source fish_completer.nu

let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        # carapace doesn't have completions for psql
        psql => $fish_completer
        _ => $carapace_completer
    } | do $in $spans
}
