;;;
;;; outputs hexidecimal number from DX register
;;;

print_hex:
    pusha                           ; save all registers
    xor cx, cx                      ; set counter to ZERO

    .loop:
        cmp cx, 4                   ; is this an end?
        je .loop_end
        ; convert DX values to HEX values
        mov ax, dx
        and ax, 0x000f              ; 0x000f
        add al, 0x30                ; get ascii number of letter value
        cmp al, 0x39                ; 0x39 is '9'(nine) in ascii
                                    ; is hex value 0-9?
        jle .mov_to_bx
        add al, 0x7                 ; make al inside 'A' - 'F'


        .mov_to_bx:
            ; move ascii character into BX string
            mov bx, __c_hex_string + 5  ; base address of __c_hex_string + length of string
            sub bx, cx                  ; subtract counter
            mov [bx], al                ; 
            ror dx, 4                   ; rotate right by four(4) bits
                                        ; (e.g: 0x12ab -> 0xb12a -> 0xab12 -> 0x2ab1 -> 0x12ab)

            inc cx                      ; inc counter value
            jmp .loop                   ; loop for the next hex digit in DX

    .loop_end:
        mov bx, __c_hex_string
        call puts
        popa                        ; load all registers back
        ret

__c_hex_string:     db '0x0000', 0
