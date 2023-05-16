;;; pretty basic boot sector.

 __b_loop:
   jmp __b_loop                  ; infinite jump

   times 510-($-$$) db 0         ; pads bytes until 510'th byte reached

   dw 0xaa55                     ; BIOS magic number for boot 'fingerprint'
