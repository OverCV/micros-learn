    .include"m2560def.inc"

    .org(0x0000)
    RJMP    main

    .org(INT0addr)
    RJMP    rsi_0

    .org(INT1addr)
    RJMP    rsi_1

    ; Se realizará una calculadora cual operará entradas de datos de 04 bits, el Puerto A será el encargado de recibir los datos de entrada y el Puerto C será el encargado de mostrar la operación entre los datos en A como salida.
    ; Los datos de entrada serán de 04 bits, los cuales serán divididos en dos nibbles, ahora mediante interrupciones externas desde INT0 e INT1 se seleccionará la operación a efectuar. Las operaciones a realizar serán: suma (00), resta (01), and (10) y or (11).

main:
    ; Entrada: Puerto A (2 datos de 4 bits)
    LDI     R16,    0x00
    OUT     DDRA,   R16

    ; Salida: Puerto C
    LDI     R16,    0xFF    ; 0011 1111
    OUT     DDRC,   R16

    ; Habilitamos interrupciones globales
    SEI

    ; Habilitar interrupciones (INT_1, INT_0)
    ; [X X X X .INT3 INT2 INT1 INT0]
    ; [X X X X .   0    0    1    1] => HEX:03
    LDI     R17,    0x03
    OUT     EIMSK,  R17

    ; Configurar con flanco de subida (bits 0, 1 activos)
    ; [INT3 INT2 INT1 INT0]
    ; [  00   01.  10   11]
    LDI     R18,    0x01
    STS     EICRA,  R18
    LDI     R20,    0x00

loop:
    IN      R17,    PINA    ; Data bits (4)
    ; Limpiamos R19 para compararlo sus 2 bits más significantes
    ANDI    R19,    0xC0

    MOV     R18,    R17     ; R18 <- yyyy xxxx
    SWAP    R17             ; R17 <- xxxx yyyy
    ANDI    R17,    0x0F    ; R17 <- 0000 xxxx
    ANDI    R18,    0x0F    ; R18 <- 0000 yyyy
    ; ! acá quedó

    CPI     R20,    0x00    ; (R17 == 0000)
    BREQ    addop

    CPI     R20,    0x40    ; (R17 == 0100)
    BREQ    subop

    CPI     R20,    0x80    ; (R17 == 1000)
    BREQ    andop

    CPI     R20,    0xC0    ; (R17 == 1100)
    BREQ    orop

addop:
    ADD     R17,    R18
    OUT     PORTC,  R17

    RJMP    loop

subop:
    SUB     R17,    R18
    OUT     PORTC,  R17

    RJMP    loop

andop:
    AND     R17,    R18
    OUT     PORTC,  R17

    RJMP    loop

orop:
    OR      R17,    R18
    OUT     PORTC,  R17

    RJMP    loop

rsi_0:
    ;  routine service interruption
    LDI     R19,    0x40
    EOR     R20,    R19
    RETI ; Return Interruption

rsi_1:
    LDI     R19,    0x80
    EOR     R20,    R19
    RETI