;;; pretty basic boot sector.

;; print AL character with BIOS interrupt
[org 0x7c00]

   ;;; READ FILE TABLE AT 0x1000
   ;; setup ES:BX registers to address kernel code
   mov bx, 0x1000                   ; load sector to mem at 0x1000
   mov es, bx                       ; es = 0x1000
   mov bx, 0x0000                   ; es:bs = 0x1000:0

   ;; setup DX register for disk loading
   mov dh, 0x00                        ; head 0
   mov dl, 0x00                        ; drive 0
   mov ch, 0x00                        ; cylinder 0
   mov cl, 0x02                        ; starting sector to read from the disk

read_disk1:
   mov ah, 0x02
   mov al, 0x01
   int 0x13

   jc read_disk1

   ;;; READ KERNEL AT 0x2000
   ;; setup ES:BX registers to address kernel code
   mov bx, 0x2000                   ; load sector to mem at 0x2000
   mov es, bx                       ; es = 0x2000
   mov bx, 0x0000                   ; es:bs = 0x2000:0

   ;; setup DX register for disk loading
   mov dh, 0x00                        ; head 0
   mov dl, 0x00                        ; drive 0
   mov ch, 0x00                        ; cylinder 0
   mov cl, 0x03                        ; starting sector to read from the disk

read_disk2:
   mov ah, 0x02
   mov al, 0x01
   int 0x13


   jc read_disk2

   ;; reset segment registers for RAM
   mov ax, 0x2000
   mov ds, ax
   mov es, ax
   mov fs, ax
   mov gs, ax
   mov ss, ax

   jmp 0x2000:0x0

   ;; boot sector magic
   times 510-($-$$) db 0         ; pads bytes until 510'th byte reached
   dw 0xaa55                     ; BIOS magic number for boot 'fingerprint'


