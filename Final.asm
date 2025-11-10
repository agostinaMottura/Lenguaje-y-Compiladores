include C:\asm\macros2.asm
include C:\asm\number.asm
.MODEL LARGE
.386
.STACK 200h

.DATA
    z                                        dd       ?
    x                                        dd       ?
    areaMax                                  dd       ?
    _2                                       dd       2.0
    _3P8                                     dd       3.8
    _0                                       dd       0.0
    _4P0                                     dd       4.0
    _12                                      dd       12.0
    _2P5                                     dd       2.5
    _3                                       dd       3.0
    @var_aux_area_triangulo_a                dd       ?
    _6                                       dd       6.0
    @var_aux_area_triangulo_b                dd       ?
    @var_aux_area_triangulo_maxima           dd       ?


.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV ES,AX

FLD _2
FSTP z
FLD _3P8
FSTP x
FLD _0
FLD _12
FMUL
FSTP @aux_area_a_primer_termino_a
FLD _4P0
FLD _3
FMUL
FSTP @aux_area_a_primer_termino_b
FLD _2P5
FLD x
FMUL
FSTP @aux_area_a_primer_termino_c
FLD @aux_area_a_primer_termino_a
FLD @aux_area_a_primer_termino_b
FADD
FLD @aux_area_a_primer_termino_c
FADD
FSTP @area_a_primer_termino
FLD x
FLD _4P0
FMUL
FSTP @aux_area_a_segundo_termino_a
FLD _12
FLD _2P5
FMUL
FSTP @aux_area_a_segundo_termino_b
FLD _3
FLD _0
FMUL
FSTP @aux_area_a_segundo_termino_c
FLD @aux_area_a_segundo_termino_a
FLD @aux_area_a_segundo_termino_b
FADD
FLD @aux_area_a_segundo_termino_c
FADD
FSTP @area_a_segundo_termino
FLD @area_a_primer_termino
FLD @area_a_segundo_termino
FSUB
FABS
FLD _2
FDIV
FSTP @var_aux_area_triangulo_a
FLD x
FLD _0
FMUL
FSTP @aux_area_a_primer_termino_a
FLD _6
FLD _2
FMUL
FSTP @aux_area_a_primer_termino_b
FLD z
FLD _0
FMUL
FSTP @aux_area_a_primer_termino_c
FLD @aux_area_a_primer_termino_a
FLD @aux_area_a_primer_termino_b
FADD
FLD @aux_area_a_primer_termino_c
FADD
FSTP @area_a_primer_termino
FLD _0
FLD _6
FMUL
FSTP @aux_area_a_segundo_termino_a
FLD _0
FLD z
FMUL
FSTP @aux_area_a_segundo_termino_b
FLD _2
FLD x
FMUL
FSTP @aux_area_a_segundo_termino_c
FLD @aux_area_a_segundo_termino_a
FLD @aux_area_a_segundo_termino_b
FADD
FLD @aux_area_a_segundo_termino_c
FADD
FSTP @area_a_segundo_termino
FLD @area_a_primer_termino
FLD @area_a_segundo_termino
FSUB
FABS
FLD _2
FDIV
FSTP @var_aux_area_triangulo_b
FLD @var_aux_area_triangulo_b
FLD @var_aux_area_triangulo_a
FCOM
FSTSW AX
SAHF
JB etiqueta_0
FLD @var_aux_area_triangulo_a
FSTP @var_aux_area_triangulo_maxima
JMP etiqueta_1
etiqueta_0:
FLD @var_aux_area_triangulo_b
FSTP @var_aux_area_triangulo_maxima
etiqueta_1:
FLD @var_aux_area_triangulo_maxima
FSTP areaMax

MOV AX,4C00H
INT 21H
END START
