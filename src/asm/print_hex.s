;;;
;;; outputs hexidecimal number from DX register
;;;
%include 'src/asm/string.s'

print_hex:
    pusha                           ; save all registers
    xor cx, cx                      ; set counter to ZERO

    .loop:
        cmp cx, 4                   ; is this an end?
        je .loop_end
        ; convert DX values to HEX values
        mov ax, dx
        and ax, 0x000f              ; 0x000f
        cmp al, 0x39                ; 0x39 is '9'(nine) in ascii
                                    ; is hex value 0-9?
        jle .mov_to_bx

        .mov_to_bx:


        ; move ascii character into BX string

    .loop_end:
        popa                        ; load all registers back
        ret

__c_hex_string:     db '0x0000', 0
