    .include    "m328Pdef.inc"

    .org        (0x0000)
    RJMP    main

    .org        (0x002E)        ; TIMER0 OVF
    RJMP    rsi_0

    ; Diseño de programa cual hace cuenta de 8 bits por el puerto B.
    ; Incrementa mediante el interrupción del Timer0 (reloj interno + pre-escalamiento).
main:
    SEI                         ; Inicializar interrupciones

    LDI     R17,    0x80
    LDI     R16,    0xFF
    OUT     DDRL,   R16         ; PU - Salida

    ; Inicializar puntero de pila
    OUT     SPH,    R17
    OUT     SPL,    R16

    LDI     R0,     0x00        ; Mostrar valor inicial
    OUT     PORTA,  R0

    LDI     R1,     0x05        ; MAX Pre-Scaler (0b101) clkI/O/1024 (from prescaler)
    OUT     TCCR0B, R1          ; Pre-Scaler selection

    STS     TIMSK0, R20         ; Timer/Counter Interrupt Mask Register

    LDI     R21,    0x00        ; Valor Contador (Cuenta interna del timer)
    OUT     TCNT0,  R21         ; Acá almacena la cuenta

    ; R21 cuenta los ciclos del oscilador, de forma que al desbordarse genera interrupción para incremento en contador

loop:
    RJMP    loop

rsi_0:
    INC     R0                  ; Este conteo es distinto al de R21.
    OUT     PORTA,  R0          ; Cuenta externa (vía led)
    RETI