; assemble with ml.exe
.model  small

.stack

.data
CMOSA   equ     070h            ; cmos addr sel
CMOSD   equ     071h            ; cmos data r/w

.code
vector  segment use16 at 0FFFFh
reset   label   far
vector  ends

main    proc
        cli
        mov     ah, 0Dh         ; ah = 0xd (reset disk)
        int     21h
        mov     al, 08Fh        ; cmos shutdown status reg, enable nmi
        out     CMOSA, al
        xor     ax, ax          ; 0 = soft reset or unexpected reset
        out     CMOSD, al
        ; inform bios that this is a soft reboot
        ; by writing the value 0x1234 to 0x472
        mov     ax, 040h
        mov     ds, ax
        mov     bx, 072h
        mov     word ptr [bx], 01234h
        ; now jump to the reset vector at 0xffff0
        jmp     reset
main    endp
        end     main
