;;; 
;;; basic useful functions for messing with strings
;;; 

;; outputs single character from AL register
putc:
   ; here idt that we're required with saving registers
   ; because all operations works with immutable registers.
   mov ah, 0x0e
   int 0x10
   ret

;; outputs string from BX register address
puts:
   pusha
   .step:
      mov ah, 0x0e
      mov al, [bx]                  ; get character value from current address of bx
      cmp al, 0                     ; print NULL-TERMINATED strings
      je .puts_end                  ; exit if we're at the end for a string, otherwise...
      int 0x10                      ; output character
      add bx, 1                     ; advance an address of bx
      jmp .step
      .puts_end:
         popa
         ret
