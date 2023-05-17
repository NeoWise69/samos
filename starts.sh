cd bin

if [[ "$OSTYPE" == "msys" ]]; then
    bochs -q 'display_library: win32'
else
    bochs -q 'display_library: sdl2'
fi

cd ..