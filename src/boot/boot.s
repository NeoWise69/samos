;;; pretty basic boot sector.

;; print AL character with BIOS interrupt
[org 0x7c00]

   ;; setup ES:BX registers to address kernel code
   mov bx, 0x1000                   ; load sector to mem at 0x1000
   mov es, bx                       ; es = 0x1000
   mov bx, 0x0000                   ; es:bs = 0x1000:0

   ;; setup DX register for disk loading
   mov dh, 0x00                        ; head 0
   mov dl, 0x00                        ; drive 0
   mov ch, 0x00                        ; cylinder 0
   mov cl, 0x02                        ; starting sector to read from the disk

read_disk:
   mov ah, 0x02
   mov al, 0x01
   int 0x13

   jc read_disk

   ;; reset segment registers for RAM
   mov ax, 0x1000
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov gs, ax
   mov ss, ax

   jmp 0x1000:0x00

%include 'src/asm/string.s'
%include 'src/asm/disk_load.s'

   ;; boot sector magic
   times 510-($-$$) db 0         ; pads bytes until 510'th byte reached
   dw 0xaa55                     ; BIOS magic number for boot 'fingerprint'


