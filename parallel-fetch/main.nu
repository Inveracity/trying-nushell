def latest [name: string]: nothing -> string {
    return (
        http get $"https://api.github.com/repos/($name)/releases"
            | get html_url # get list of release urls
            | first # since they are ordered by latest release first, grab the top one
            | split row "/" # split the URL on slashes i.e. "sometool/release/1.2.3"
            | last  # and grab the version number
            | str replace "v" "" # remove v's from version numbers
    )
}

open ($env.FILE_PWD | path join "versions.toml")
    | get tools
    | transpose key value
    | par-each { |it|
        {
            name: $it.key,
            current: $it.value,
            latest: (latest $it.key),
        }
    }
