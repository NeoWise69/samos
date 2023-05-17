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

    mov si, horline
    call puts    
    mov si, string
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
    cmp al, 'r'
    je w_reboot
    cmp al, 'f'
    je filebrowser
    jmp .not_found

    .not_found:
        mov si, failure
        call puts
        mov si, newline
        call puts
        jmp get_input

filebrowser:
    ;;; clear screen
    ;; set video mode
    mov ah, 0x00                  ; int 0x10 + ah=0x00 -> set video mode
    mov al, 0x03                  ; set mode
    int 0x10
    ;; change color palette (light blue)
    mov ah, 0x0b
    mov bh, 0x00
    mov bl, 0x09
    int 0x10

    ;; output header
    mov si, horline
    call puts
    mov si, filebrowser_head
    call puts
    mov si, newline
    call puts

    ;; load file table string from it's memory at 0x1000, and output it all
    xor cx, cx
    mov ax, 0x1000                  ; move file table location into SI
    mov es, ax
    xor bx, bx
    mov ah, 0x0e

    .loop:
        inc bx
        mov al, [es:bx]
        cmp al, '}'                 ; is this end of table?
        je .stop
        cmp al, '-'                 ; is this sector# of element
        je .sec_num_loop
        cmp al, ','                 ; is this between table elements
        je .advance_next
        inc cx                      ; increment counter
        int 0x10
        jmp .loop

    .sec_num_loop:
        cmp cx, 21
        je .loop
        mov al, ' '
        int 0x10
        inc cx
        jmp .sec_num_loop

    .advance_next:
        xor cx, cx                  ; reset counter
        mov al, 0xa
        int 0x10
        mov al, 0xd
        int 0x10
        jmp .loop

    .stop:
        mov al, 0xa
        int 0x10
        mov al, 0xd
        int 0x10
        jmp get_input


w_reboot:
    jmp 0xffff:0x00

dead_end:
    cli                             ; clear interrupts
    hlt                             ; halt the cpu

%include 'src/asm/string.s'
%include 'src/asm/print_hex.s'

horline: db '================================================================================', 0
string: db 'kernS!', 0x0a, 0x0d, 0
usage: db 'usage: ', 0xa, 0xd, 'f) filebrowser', 0x0a, 0x0d, 'r) reboot', 0xa, 0xd, 0
success: db 'success!', 0
failure: db 'failure!', 0
newline: db 0xa, 0xd, 0
filebrowser_head: db '=== file/program ======== sector ===============================================', 0
cmd: db ''

    ;; sector padding magic
    times 512-($-$$) db 0           ; pads bytes until 510'th byte reached