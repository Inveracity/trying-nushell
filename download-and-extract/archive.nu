# Copied and modified from https://github.com/nushell/nushell/pull/11010#issuecomment-1804275523

def "path parse" []: path -> record<extension: string, parent: string> {
    let tokens = $in | path expand | path split
    let filename = $tokens | last
    let parent = $tokens | range ..(-2) | path join
    let extension = (
        if ($filename | str contains "tar.") {
            $filename | split row "." | last 2 | str join "."
        } else {
            $filename | split row "." | last 1 | str join "."
        }
    )

    return {
        extension: $extension
        parent: $parent
    }
}

export def extract [archive: string]: nothing -> nothing {
    if not ($archive | path exists) {
        error make {
            msg: $"(ansi red_bold)file_not_found(ansi reset)"
            label: {
                text: "no such file or directory"
            }
        }
    }

    if ($archive | path type) != "file" {
        error make {
            msg: $"(ansi red_bold)archive_not_a_file(ansi reset)"
            label: {
                text: $"expected a file, found a ($archive | path type)"
            }
        }
    }

    match ($archive | path parse | get extension) {
        "zip" => { ^unzip $archive },
        "tar" => { ^tar xf $archive },
        "tar.gz" => { ^tar xzf $archive -C ($archive | path parse | get parent) },
        "tar.bz2" => { ^tar xjf $archive },
        "tar.xz" => { ^tar xf $archive },
        "tar.zst" => { ^tar xf $archive },
        "tgz" => { ^tar xzf $archive },
        "tbz2" => { ^tar xjf $archive },
        "bz2" => { ^bunzip2 $archive },
        "rar" => { ^unrar x $archive },
        "gz" => { ^gunzip $archive },
        "Z" => { ^uncompress $archive },
        "7z" => { ^7z x $archive },
        "deb" => { ^ar x $archive },
        $format => {
            error make {
                msg: $"(ansi red_bold)unknown_archive_format(ansi reset)"
                label: {
                    text: $"($format) is not a supported archive format"
                }
            }
        },
    }
}
