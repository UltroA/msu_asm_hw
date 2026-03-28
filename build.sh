#!/bin/bash
echo "ARG: $1"
die()
{
    if [ $# -gt 0 ]; then
        echo >&2 "$*"
    fi
    exit 1
}

# CLion передает полный путь к текущему файлу
if [ $# -ne 1 ]; then
    die "Usage: $0 <asm-file>"
fi

prog_path="$1"
prog_dir="$(dirname "$prog_path")"
prog_file="$(basename "$prog_path")"
basename="${prog_file%.*}"

if [ "$basename" = "$prog_file" ]; then
    die "You must use file extension!"
fi

cd "$prog_dir" || die "Cannot cd to file directory"

osname=$(uname -s) || die
nasm_opts=(-g)

case $(echo "$osname" | tr '[:upper:]' '[:lower:]') in
    *cygwin*)
        systype=CYGWIN
        objformat=win32
        nasm_opts+=(--prefix _)
        ;;
    *linux*|*freebsd*)
        systype=UNIX
        objformat=elf32
        ;;
    *darwin*)
        systype=DARWIN
        objformat=macho32
        nasm_opts+=(--prefix _)
        ;;
    *)
        die "Unsupported OS '$osname'"
        ;;
esac

nasm_opts+=(-f "$objformat" "-D$systype")

macro_o=/tmp/_asm_build_$$.o
prog_o="${basename}.o"
prog_bin="${basename}"

trap 'rm -f "$macro_o" "$prog_o"' EXIT

bundle=$(cd "$(dirname "$0")" && pwd -P) || die
nasm_opts+=(-I "$bundle")

echo ">>> Building $prog_file"

gcc -c -g -Wfatal-errors -fno-pie -m32 -o "$macro_o" "${bundle}/macro.c" || die
nasm "${nasm_opts[@]}" -o "$prog_o" "$prog_file" || die
gcc -no-pie -m32 -o "$prog_bin" "$prog_o" "$macro_o" || die

echo ">>> Running $prog_bin"
echo "----------------------"
./"$prog_bin"