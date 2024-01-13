export def main [
    url: string, # a valid URL
    --path: path # a path to download a file to
] {
    let filename = $url | split row "/" | last
    let outpath = $path | path join $filename

    if ($outpath | path exists) {
        return $outpath
    }

    http get --max-time 3600 $url | save $outpath

    return $outpath
}
