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

    mov si, horline
    call puts    
    mov si, usage
    call puts

get_input:
    mov di, cmd
    ; push di                         ; store SI state on stack to get user input command
keyloop:
    ;; get user input
    xor ax, ax                      ; ah=al=0x00
    int 0x16                        ; BIOS interrupt get keystroke, character goes into AL
    ;; output it to screen
    mov ah, 0x0e                    ; 
    cmp al, 0x0d                    ; did user hit 'return' key?
    je run_cmd
    int 0x10                        ; print pressed key
    mov [di], al
    inc di
    jmp keyloop                     ; loop for next user input

run_cmd:
    mov si, newline
    call puts
    mov byte[di], 0
    mov al, [cmd]
    cmp al, 'e'
    je dead_end
    cmp al, 'f'
    jne .not_found
    mov si, success
    call puts
    mov si, newline
    call puts
    jmp get_input

    .not_found:
        mov si, failure
        call puts
        mov si, newline
        call puts
        jmp get_input


dead_end:
    mov si, exit_msg
    call puts
    cli                             ; clear interrupts
    hlt                             ; halt the cpu

%include 'src/asm/string.s'
%include 'src/asm/print_hex.s'

horline: db '================================================================================', 0
string: db 'SamOS kernel loaded!', 0x0a, 0x0d, 'starting up..', 0
usage: db 'usage: ', 0xa, 0xd, 'f) load filetable (browser) ', 0x0a, 0x0d, 0
success: db 'success!', 0
failure: db 'failure!', 0
newline: db 0xa, 0xd, 0
exit_msg: db 'exiting...(halt)', 0
cmd: db ''

    ;; sector padding magic
    times 512-($-$$) db 0           ; pads bytes until 510'th byte reached