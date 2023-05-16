;;; pretty basic boot sector.

;; BIOS interrupts:
;; 0x10 - print ah

;; print AL character with BIOS interrupt
[org 0x7c00]

   ;; set video mode
   mov ah, 0x00                  ; int 0x10 + ah=0x00 -> set video mode
   mov al, 0x03                  ; set mode
   int 0x10

   ;; change color palette (light blue)
   mov ah, 0x0b
   mov bh, 0x00
   mov bl, 0x09
   int 0x10

   ;; output strings
   mov ah, 0x0e                  ; request BIOS ah to 0x0e (teletype output)

   mov bx, string
   call puts
   mov bx, string2
   call puts
   mov bx, string
   call puts

   mov bx, string_h
   call puts
   mov dx, 0x12ab
   call print_hex

   jmp $                         ; infinite jump

%include 'src/asm/print_hex.s'

string: db '===============================================================================', 0xa, 0xd, 0
string2: db 'first ever output!', 0xa, 0xd, 'booting kernel...', 0xa, 0xd, 0
string_h: db 'hex: ', 0


   times 510-($-$$) db 0         ; pads bytes until 510'th byte reached
   dw 0xaa55                     ; BIOS magic number for boot 'fingerprint'


