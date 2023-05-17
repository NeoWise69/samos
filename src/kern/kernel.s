    ;;;
    ;;; kernel.s: pretty basic 'kernel' loaded from boot.s
    ;;;
    
    ;; set video mode
    mov ah, 0x00                  ; int 0x10 + ah=0x00 -> set video mode
    mov al, 0x03                  ; set mode
    int 0x10

    ;; change color palette (light blue)
    mov ah, 0x0b
    mov bh, 0x00
    mov bl, 0x09
    int 0x10

    mov si, string
    call puts

    mov si, newline
    call puts

    ;; end program
    hlt                             ; halt the cpu

%include 'src/asm/string.s'
%include 'src/asm/print_hex.s'

string: db 'kernel loaded.', 0
newline: db 0xa, 0xd, 0

    ;; sector padding magic
    times 512-($-$$) db 0           ; pads bytes until 510'th byte reached