nasm src/boot/boot.s -o bin/sec_boot.bin
nasm src/kern/kernel.s -o bin/sec_kernel.bin
cat ./bin/sec_boot.bin ./bin/sec_kernel.bin > bin/samos.bin