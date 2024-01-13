def get_version_list [name: string]: nothing -> list<string> {
    return (
        http get $"https://api.github.com/repos/($name)/releases"
        | get html_url           # get list of release urls
        | par-each { |result|
            $result
            | split row "/"      # split the URL on slashes i.e. "sometool/release/1.2.3"
            | last               # grab the version number
            | str replace "v" "" # remove the v
        }
    )
}

open ($env.FILE_PWD | path join "versions.toml")
    | get tools
    | transpose name current_version
    | par-each { |tool|
        {
            name: $tool.name
            current: $tool.current_version,
            latest: (get_version_list $tool.name | semver sort | last),
        }
    }
