use download.nu
use archive.nu extract

const outdir = "out/"
const url = "https://github.com/nushell/nushell/releases/download/0.89.0/nu-0.89.0-x86_64-linux-gnu-full.tar.gz"

if not ($outdir | path exists) {
    mkdir $outdir
}

print "downloading!"
let downloaded_archive = download --path $outdir $url

print "extracting!"
extract $downloaded_archive

print "done!"
