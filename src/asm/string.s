;;; 
;;; basic useful functions for messing with strings
;;; 

;; outputs single character from AL register
putc:
   ; here idt that we're required with saving registers
   ; because all operations works with immutable registers.
   mov ah, 0x0e                  ; request BIOS ah to 0x0e (teletype output)
   int 0x10
   ret

;; outputs string from SI register address
puts:
   pusha
   mov ah, 0x0e                  ; request BIOS ah to 0x0e (teletype output)
   mov bh, 0x00
   mov bl, 0x07
   .step:
      mov al, [si]                  ; get character value from current address of bx
      cmp al, 0                     ; print NULL-TERMINATED strings
      je .puts_end                  ; exit if we're at the end for a string, otherwise...
      int 0x10                      ; output character
      add si, 1                     ; advance an address of bx
      jmp .step
      .puts_end:
         popa
         ret
