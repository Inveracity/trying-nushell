# Usage:
# use arch; arch

# Conversion table to align output to one of "arm64, amd64"
const lookup = {
    "amd64": "amd64",
    "x86_64": "amd64",
}

# Get architecture from system
export def main []: nothing -> string {
    if (is_windows) {
        get_windows_architecture
    }

    if (is_linux) {
        let res = get_linux_architecture | lines | first
        $lookup | transpose key value | where key == $res | get value.0
    }
}

def is_windows []: nothing -> bool {
    sys | get host.long_os_version | str contains --ignore-case "windows"
}

def get_windows_architecture []: nothing -> string {
    ^powershell -c "$env:PROCESSOR_ARCHITECTURE" | str downcase
}

def is_linux []: nothing -> bool {
    sys | get host.long_os_version | str contains --ignore-case "linux"
}

def get_linux_architecture []: nothing -> string {
    ^arch
}
