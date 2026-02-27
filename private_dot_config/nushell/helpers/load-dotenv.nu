def --env load-dotenv [file: string = ".env.local"] {
  print $"📁 Loading environment variables from ($file)..."
  let env_vars = open $file
    | lines
    | where {|line| not ($line | str starts-with '#') and ($line | str trim | is-not-empty)}
    | each {|line| $line | split row --number 2 "="}
    | where {|parts| ($parts | length) == 2}
    | reduce --fold {} {|parts, acc| 
        let key = $parts | get 0 | str trim
        let value = $parts | get 1 | str trim | str replace -a '"' ''
        print $"  🔧 Setting ($key)"
        $acc | insert $key $value
      }
  load-env $env_vars
  print "✅ Environment variables loaded successfully"
}
