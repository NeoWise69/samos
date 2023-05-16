;;; 
;;; basic useful functions for messing with strings
;;; 

;; outputs single character from AL register
putc:
   mov ah, 0x0e
   int 0x10
   ret

;; outputs string from BX register address
puts:
   mov ah, 0x0e
   mov al, [bx]                  ; get character value from current address of bx
   cmp al, 0                     ; print NULL-TERMINATED strings
   je .puts_end                  ; exit if we're at the end for a string, otherwise...
   int 0x10                      ; output character
   add bx, 1                     ; advance an address of bx
   jmp puts
   .puts_end:
      ret
