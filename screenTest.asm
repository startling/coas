; ==== DISPLAY TEST

.org 0x000

.macro  crash
_targ:  ADD PC, _targ - _ref
_ref:
.endmacro

.proc
reset:  JSR setup_screen
        SET B, 0
        SET A, 0xC900
_loop:  SET [B+screen], A
        ADD B, 1
        ADD A, 1
        SET C, A
        AND C, 0x80
        ADD A, C
        IFN B, 0x180
            SET PC, _loop
        crash
.endproc

.proc
setup_screen:
        HWN I
_loop:  SUB I, 1
        IFU I, 0
            SET PC, POP

        HWQ I

        ; Locate a LEM-1802
        IFN A, $f615
        IFN B, $7349
        IFN C, $1802
            SET PC, _loop
        
        ; Set screen mapping
        SET A, 0
        SET B, screen
        HWI I

        ; Set character mapping
        SET A, 1
        SET B, char
        HWI I
        SET A, 4
        SET B, char
        HWI I
        
        SET PC, _loop
.endproc

screen: .bss 0x180
char:   .bss 0x100
