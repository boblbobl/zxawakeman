'' -------------------------------------------------------------------------
''                    Mojon Twins' F O U R S P R I T E R
'' -------------------------------------------------------------------------
'' Simple 16x16 sprite library, char-wise movement w/background preservation
'' -------------------------------------------------------------------------
'' Copyleft 2009 / 2010 The Mojon Twins.
'' Pergre�ado por na_th_an
'' -------------------------------------------------------------------------
'' Use/modify as you like. You may want to try Fourspriter MK3 by Britlion,
'' which works differently and is really faster. Check ZX Basic forums at
'' http://www.boriel.com/forum/viewtopic.php?f=14&t=400
'' -------------------------------------------------------------------------

'' -------------------------------------------------------------------------
'' Version story
'' -------------------------------------------------------------------------
'' Versi�n 1.0 :: Complete functionality, uses GDU
'' Versi�n 1.1 :: Uses the CHARS system var (23606+256*23607+256).
'' Versi�n 2.0 :: Complete recode for faster functionality.
'' Versi�n 2.1 :: Inhouse version, now embedded in a BAS file for ZX Basic
''                Uses a custom variable to locate graphics data, CHARS no
''                longer needed. BASIC/asm interaction with ideas from
''                Britlion's version.
'' -------------------------------------------------------------------------

Sub fsp21MoveSprite (n As uByte, x As uByte, y As uByte)
	' Moves sprite #n to new coordinates (x, y)

	Dim dataBlock As uInteger
	
	' 50 * n = 48 * n + 2 * n = 32 * n + 16 * n + 2 * n = (n << 5) + (n << 4) + (n << 1)
	dataBlock = (n << 5) + (n << 4) + (n << 1) + @fsp21DataPool
	Poke dataBlock + 2, x
	Poke dataBlock + 3, y
End Sub

Sub fsp21ColourSprite (n As uByte, attr1 As uByte, attr2 As uByte, attr3 As uByte, attr4 As uByte)
	' Colours sprite #n
	
	Dim dataBlock As uInteger
	
	' 50 * n = 48 * n + 2 * n = 32 * n + 16 * n + 2 * n = (n << 5) + (n << 4) + (n << 1)
	dataBlock = (n << 5) + (n << 4) + (n << 1) + @fsp21DataPool
	Poke dataBlock + 42, attr1
	Poke dataBlock + 43, attr2
	Poke dataBlock + 44, attr3
	Poke dataBlock + 45, attr4
End Sub

Sub fsp21SetGfxSprite (n As uByte, char1 As uByte, char2 As uByte, char3 As uByte, char4 As uByte)
	' Sets sprite #n's four characters
	
	Dim dataBlock As uInteger
	
	' 50 * n = 48 * n + 2 * n = 32 * n + 16 * n + 2 * n = (n << 5) + (n << 4) + (n << 1)
	dataBlock = (n << 5) + (n << 4) + (n << 1) + @fsp21DataPool
	Poke dataBlock + 6, char1
	Poke dataBlock + 7, char2
	Poke dataBlock + 8, char3
	Poke dataBlock + 9, char4
End Sub

Sub fsp21ActivateSprite (n As uByte)
	' Activates sprite #n
		
	Dim dataBlock As uInteger
	
	' 50 * n = 48 * n + 2 * n = 32 * n + 16 * n + 2 * n = (n << 5) + (n << 4) + (n << 1)
	dataBlock = (n << 5) + (n << 4) + (n << 1) + @fsp21DataPool
	Poke dataBlock, 1
End Sub

Sub fsp21DeactivateSprite (n As uByte)
	' Activates sprite #n
		
	Dim dataBlock As uInteger
	
	' 50 * n = 48 * n + 2 * n = 32 * n + 16 * n + 2 * n = (n << 5) + (n << 4) + (n << 1)
	dataBlock = (n << 5) + (n << 4) + (n << 1) + @fsp21DataPool
	Poke dataBlock, 0
End Sub

Sub fsp21DuplicateCoordinatesSprite (n As uByte)
	' Does CX = X and CY = Y for Sprite #n, used when defining the sprite.
	
	Dim dataBlock As uInteger
	
	' 50 * n = 48 * n + 2 * n = 32 * n + 16 * n + 2 * n = (n << 5) + (n << 4) + (n << 1)
	dataBlock = (n << 5) + (n << 4) + (n << 1) + @fsp21DataPool
	Poke dataBlock + 4, Peek (dataBlock + 2)
	Poke dataBlock + 5, Peek (dataBlock + 3)
End Sub

Sub fsp21SetGfxAddress (address As uInteger)
	' Sets the address where graphics data is read.
	
	Dim dataBlock As uInteger
	
	dataBlock = @fsp21DataPool + 200
	Poke uInteger dataBlock, address
End Sub

Sub Fastcall fsp21InitSprites ()
	' Calls init_sprite routine in fsp 2.1
	
	Asm
		call init_sprites
	End asm
End Sub

Sub FastCall fsp21BorraSprites ()
	' Calls borra_sprites routine in fsp 2.1
	
	Asm
		call borra_sprites
	End Asm
End Sub

Sub FastCall fsp21PintaSprites ()
	' Calls pinta_sprites routine in fsp 2.1
	
	Asm
		call pinta_sprites
	End Asm
End Sub

Sub FastCall fsp21UpdateCoordinates ()
	' Calls upd_coord routine in fsp 2.1
	
	Asm
		call upd_coord
	End Asm
End Sub

Sub FastCall fsp21UpdateSprites ()
	' Calls upd_sprites routine in fsp 2.1
	' Basicly makes changes. Erases sprites, stores background, and repaints them
	
	Asm
		call upd_sprites
	End Asm
End Sub

'' ---------------------------------------------------------------------------
'' End of BASIC interface. Now the core code.
'' ---------------------------------------------------------------------------

Sub FastCall fsp21DummyContainer ()

	' This sub is not executable, just contains the ASM code and variables
	' which is called/modified from within other Subs in this module.

fsp21DataPool:
	Asm
		;; Aqu� vienen todos los datos. Se pokean desde BASIC
		
		datap:                              ; Cada bloque ocupa 50 bytes.
		
		;; Las etiquetas empleadas m�s abajo son puramente orientativas y no se
		;; emplean desde el c�digo. Sin embargo, aparecer�n en un archivo de tabla
		;; de s�mbolos, lo cual puede resultar �til si no se tiene ganas de calcular
		;; cosas.
		
		;; Sprite 1
		
		act1:       defb    0               ; Define si el sprite est� activo
		flags1:     defb    0               ; Por ahora sin uso.
		x_pos1:     defb    0               ; Posici�n X en chars.
		y_pos1:     defb    0               ; Posici�n Y en chars.
		cx_pos1:    defb    0               ; Anterior posici�n X en chars.
		cy_pos1:    defb    0               ; Anterior posici�n Y en chars.
		udg1:       defb    0, 0, 0, 0      ; Los cuatro CHAR del primer sprite.
		buffer1:    defs    32, 0           ; Buffer de lo que hab�a en la pantalla.
		attrs1:     defb    7, 7, 7, 7      ; Cuatro atributos
		buffatrs1:  defs    4, 0            ; Buffer de los atributos
		
		;; Sprite 2
		
		act2:       defb    0               ; Define si el sprite est� activo
		flags2:     defb    0               ; Por ahora sin uso.
		x_pos2:     defb    0               ; Posici�n X en chars.
		y_pos2:     defb    0               ; Posici�n Y en chars.
		cx_pos2:    defb    0               ; Anterior posici�n X en chars.
		cy_pos2:    defb    0               ; Anterior posici�n Y en chars.
		udg2:       defb    0, 0, 0, 0      ; Los cuatro CHAR del segundo sprite.
		buffer2:    defs    32, 0           ; Buffer de lo que hab�a en la pantalla.
		attrs2:     defb    7, 7, 7, 7      ; Cuatro atributos
		buffatrs2:  defs    4, 0            ; Buffer de los atributos
		
		;; Sprite 3
		
		act3:       defb    0               ; Define si el sprite est� activo
		flags3:     defb    0               ; Por ahora sin uso.
		x_pos3:     defb    0               ; Posici�n X en chars.
		y_pos3:     defb    0               ; Posici�n Y en chars.
		cx_pos3:    defb    0               ; Anterior posici�n X en chars.
		cy_pos3:    defb    0               ; Anterior posici�n Y en chars.
		udg3:       defb    0, 0, 0, 0      ; Los cuatro CHAR del tercer sprite.
		buffer3:    defs    32, 0           ; Buffer de lo que hab�a en la pantalla.
		attrs3:     defb    7, 7, 7, 7      ; Cuatro atributos
		buffatrs3:  defs    4, 0            ; Buffer de los atributos
		
		;; Sprite 4
		
		act4:       defb    0               ; Define si el sprite est� activo
		flags4:     defb    0               ; Por ahora sin uso.
		x_pos4:     defb    0               ; Posici�n X en chars.
		y_pos4:     defb    0               ; Posici�n Y en chars.
		cx_pos4:    defb    0               ; Anterior posici�n X en chars.
		cy_pos4:    defb    0               ; Anterior posici�n Y en chars.
		udg4:       defb    0, 0, 0, 0      ; Los cuatro CHAR del cuarto sprite.
		buffer4:    defs    32, 0           ; Buffer de lo que hab�a en la pantalla.
		attrs4:     defb    7, 7, 7, 7      ; Cuatro atributos
		buffatrs4:  defs    4, 0            ; Buffer de los atributos
		
		;; Where to extract graphics data
		
		setAddrLsb:	defb	0
		setAddrMsb: defb 	0
		
		;; General y guarro, que todav�a estoy empezando:
		
		xpos:       defb    0
		ypos:       defb    0
		cxpos:      defb    0
		cypos:      defb    0
		
		;; ---------------------------------------------------------------------------
		;; rutina init_sprites
		;; ---------------------------------------------------------------------------
		
		;; Primero tendremos que llamar a esta funci�n que escribe lo que haya en
		;; en fondo en el buffer de cada sprite.
		
		init_sprites:
		
		            ld      de, datap       ; Apuntamos a la zona de datos
		
		            ld      b,  4           ; 4 iteraciones
		init_loop:  push    bc
		
		            ;; Primero vemos si el sprite est� activo
		            ld      a,  (de)
		            cp      0
		            jr      z,  init_adv    ; Si no est� activo, nos lo saltamos
		            inc     de
		            
		            ;; Por ahora nos saltamos los flags
		            inc     de              ; Ahora DE->X
		            
		            ;; Obtenemos las coordenadas X e Y
		            ld      hl, xpos        ; HL->XPOS
		            ex      de, hl          ; Cambiamos HL por DE. Ahora DE->XPOS, HL->X
		            ldi                     ; XPOS = X; DE->YPOS, HL->Y
		            ldi                     ; YPOS = Y; DE->YPOS+1, HL->Y+1
		            ex      de, hl          ; Deshacemos el cambio. Ahora DE->Y+1=CX
		            
		            ; Nos saltamos CX y CY:
		            inc     de              ; Ahora DE->CY
		            inc     de              ; Ahora DE->UDG
		            
		            ;; Tenemos en nuestras variables XPOS e YPOS las coordenadas.
		            ;; Ahora tenemos que copiar los cuatro chars del bitmap al buffer
		            
		            ;; Avanzamos DE al buffer, para ello nos saltamos los 4 UDG
		            inc     de
		            inc     de
		            inc     de
		            inc     de              ; Ahora DE->BUFFER
		            
		            call scr2buf
		                
		            ;; Ahora DE->ATTRS. Hay que avanzar hasta BUFATRS, 4 bytes m�s all�
		            inc     de
		            inc     de
		            inc     de
		            inc     de
		            
		            ;; reposicionamos las coordenadas xpos e ypos restando 1 a cada una:
		            
		            ; xpos --
		            ld      hl, xpos
		            dec     (hl)
		            
		            ; ypos --
		            inc     hl
		            dec     (hl)
		            
		            ; Calculamos la direcci�n de los atributos en HL
		            call    getatraddr      ; HL->atributos, DE->buffer_atributos
		            
		            ;; Copiamos los cuatro atributos
		            ldi                     ; Primer car�cter
		            ldi                     ; Segundo car�cter
		            ld      bc, 30
		            add     hl, bc
		            ldi                     ; Tercer car�cter
		            ldi                     ; Cuarto car�cter
		            
		            ; Ahora DE apunta al principio del siguiente sprite.
		
		init_nxt:   pop     bc
		            djnz    init_loop
		            
		            ret
		            
		init_adv:   ld      hl, 50          ; Sumamos 50 a de y seguimos
		            add     hl, de
		            ex      de, hl
		            jp      init_nxt
		
		;; ---------------------------------------------------------------------------
		;; rutina borra_sprites
		;; ---------------------------------------------------------------------------
		            
		;; Esta rutina restaura el fondo almacenado en los sprites en las coordenadas
		;; CX,CY (anteriores coordenadas)
		            
		borra_sprites:
		
		            ld      de, datap       ; Apuntamos a la zona de datos
		
		            ld      b,  4           ; 4 iteraciones
		borra_loop: push    bc
		
		            ;; Primero vemos si el sprite est� activo
		            ld      a,  (de)
		            cp      0
		            jr      z,  borra_adv   ; Si no est� activo, nos lo saltamos
		            inc     de
		            
		            ;; Por ahora nos saltamos los flags
		            inc     de              ; Ahora DE->X
		            
		            ;; Obtenemos las coordenadas CX y CY
		            inc     de              ; Nos saltamos X, ahora DE->Y
		            inc     de              ; Nos saltamos Y, ahora DE->CX
		            ld      hl, xpos        ; HL->XPOS
		            ex      de, hl          ; Cambiamos HL por DE. Ahora DE->XPOS, HL->CX
		            ldi                     ; XPOS = CX; DE->YPOS, HL->CY
		            ldi                     ; YPOS = CY; DE->YPOS+1, HL->CY+1
		            ex      de, hl          ; Deshacemos el cambio. Ahora DE->CY+1=UDG
		            
		            ;; Tenemos en nuestras variables XPOS e YPOS las coordenadas.
		            ;; Ahora tenemos que copiar los cuatro chars del buffer al bitmap
		            
		            ;; Avanzamos DE al buffer, para ello nos saltamos los 4 UDG
		            inc     de
		            inc     de
		            inc     de
		            inc     de              ; Ahora DE->BUFFER
		            
		            call buf2scr
		            
		            ;; Ahora DE->ATTRS. Hay que avanzar hasta BUFATRS, 4 bytes m�s all�
		            inc     de
		            inc     de
		            inc     de
		            inc     de
		            
		            ;; reposicionamos las coordenadas xpos e ypos restando 1 a cada una:
		            
		            ; xpos --
		            ld      hl, xpos
		            dec     (hl)
		            
		            ; ypos --
		            inc     hl
		            dec     (hl)
		            
		            ; Calculamos la direcci�n de los atributos en HL
		            call    getatraddr      ; HL->atributos, DE->buffer_atributos
		            
		            ;; Copiamos los cuatro atributos
		            ex      de, hl          ; HL->buffer_atributos, DE->atributos
		            ldi                     ; Primer car�cter
		            ldi                     ; Segundo car�cter
		            ex      de, hl          
		            ld      bc, 30
		            add     hl, bc
		            ex      de, hl          
		            ldi                     ; Tercer car�cter
		            ldi                     ; Cuarto car�cter
		            ex      de, hl          ; DE vuelve a apuntar a los datos...
		            
		            ; Ahora DE apunta al principio del siguiente sprite.            
		
		borra_nxt:  pop     bc
		            djnz    borra_loop
		            
		            ret
		            
		borra_adv:  ld      hl, 50          ; Sumamos 50 a de y seguimos
		            add     hl, de
		            ex      de, hl
		            jp      borra_nxt
		
		;; ---------------------------------------------------------------------------
		;; rutina pinta_sprites
		;; ---------------------------------------------------------------------------
		            
		;; Esta rutina restaura pinta los chars especificados en la tabla UDG
		;; En las coordenadas X, Y del sprite
		            
		pinta_sprites:
		
		            ld      de, datap       ; Apuntamos a la zona de datos
		
		            ld      b,  4           ; 4 iteraciones
		pinta_loop: push    bc
		
		            ;; Primero vemos si el sprite est� activo
		            ld      a,  (de)
		            cp      0
		            jr      z,  pinta_adv   ; Si no est� activo, nos lo saltamos
		            inc     de
		            
		            ;; Por ahora nos saltamos los flags
		            inc     de              ; Ahora DE->X
		            
		            ;; Obtenemos las coordenadas X e Y
		            ld      hl, xpos        ; HL->XPOS
		            ex      de, hl          ; Cambiamos HL por DE. Ahora DE->XPOS, HL->X
		            ldi                     ; XPOS = X; DE->YPOS, HL->Y
		            ldi                     ; YPOS = Y; DE->YPOS+1, HL->Y+1
		            ex      de, hl          ; Deshacemos el cambio. Ahora DE->Y+1=CX
		            
		            ; Nos saltamos CX y CY:
		            inc     de              ; Ahora DE->CY
		            inc     de              ; Ahora DE->UDG
		            
		            ;; DE->UDG. Ahora hay que pintar los cuatro car�cteres indexados ah�.
		            
		            call    char2scr
		            
		            ;; DE->BUFFER. Tenemos que saltarnos 32 bytes para acceder
		            ;; a los atributos del sprite:
		            
		            ld      hl, 32
		            add     hl, de
		            ex      de, hl          ; Ahora DE->ATTRS
		            
		            ;; Pintamos los 4 atributos
		            
		            ;; reposicionamos las coordenadas xpos e ypos restando 1 a cada una:
		            
		            ; xpos --
		            ld      hl, xpos
		            dec     (hl)
		            
		            ; ypos --
		            inc     hl
		            dec     (hl)
		            
		            ; Calculamos la direcci�n de los atributos en HL
		            call    getatraddr      ; HL->atributos, DE->ATTRS
		            
		            ;; Copiamos los cuatro atributos
		            ;ex      de, hl          ; HL->ATTRS, DE->atributos
		            ;ldi                     ; Primer car�cter
		            ;ldi                     ; Segundo car�cter
		            ;ex      de, hl          
		            ;ld      bc, 30
		            ;add     hl, bc
		            ;ex      de, hl          ; HL->ATTRS, DE->atributos
		            ;ldi                     ; Tercer car�cter
		            ;ldi                     ; Cuarto car�cter
		            ;ex      de, hl          ; DE vuelve a apuntar a los datos...
		            
		            ;; Efecto dandaresco: s�lo imprimimos bright/ink
		            ;; pero tomamos el paper que haya.
		            
		            ;; ---------------------------------------------------------------
		            
		            ; 1
		            ld		a, (hl)			; a<- atributo en pantalla
		            and		56				; 00111000 (nos quedamos con PAPER)
		            ld		b, a
		            ld		a, (de)
		            and		199				; 11000111 (quitamos el PAPER)
		            or		b				; Le pegamos el paper que hab�a
		            ld		(hl), a			; escribimos
		            inc		hl
		            inc		de				; siguiente
		            
		            ; 2
		            ld		a, (hl)			; a<- atributo en pantalla
		            and		56				; 00111000 (nos quedamos con PAPER)
		            ld		b, a
		            ld		a, (de)
		            and		199				; 11000111 (quitamos el PAPER)
		            or		b				; Le pegamos el paper que hab�a
		            ld		(hl), a			; escribimos
		            inc		de
		            ld		bc, 31
		            add		hl, bc			
		            
		            ; 3
		            ld		a, (hl)			; a<- atributo en pantalla
		            and		56				; 00111000 (nos quedamos con PAPER)
		            ld		b, a
		            ld		a, (de)
		            and		199				; 11000111 (quitamos el PAPER)
		            or		b				; Le pegamos el paper que hab�a
		            ld		(hl), a			; escribimos
		            inc		hl
		            inc		de				; siguiente
		            
		            ; 4
		            ld		a, (hl)			; a<- atributo en pantalla
		            and		56				; 00111000 (nos quedamos con PAPER)
		            ld		b, a
		            ld		a, (de)
		            and		199				; 11000111 (quitamos el PAPER)
		            or		b				; Le pegamos el paper que hab�a
		            ld		(hl), a			; escribimos
		            inc		hl
		            inc		de				; siguiente
		            
		            ;; ---------------------------------------------------------------
		            
		            ;; Avanzamos DE hasta el siguiente car�cter:
		            inc     de
		            inc     de
		            inc     de
		            inc     de
		            
		            ; Ahora DE apunta al principio del siguiente sprite.
		
		pinta_nxt:  pop     bc
		            djnz    pinta_loop
		            
		            ret
		            
		pinta_adv:  ld      hl, 50          ; Sumamos 50 a de y seguimos
		            add     hl, de
		            ex      de, hl
		            jp      pinta_nxt
		
		;; ---------------------------------------------------------------------------
		;; rutina upd_coord
		;; ---------------------------------------------------------------------------
		            
		;; Esta rutina hace CX = X, CY = Y.
		            
		upd_coord:  ld      de, datap       ; Apuntamos a la zona de datos
		            ld      hl, datap       ; Apuntamos a la zona de datos
		
		            ld      b,  4           ; 4 iteraciones
		upd_loop:   push    bc
		
		            inc     hl
		            inc     hl              ; HL->X
		            inc     de
		            inc     de
		            inc     de
		            inc     de              ; DE->CX
		            ldi                     ; CX=X; HL->Y, DE->CY
		            ldi                     ; CY=Y; HL->CX, DE->UDG
		            
		            ; avanzar hasta el siguiente sprite:
		            
		            ;; DE = DATAP+6, sumamos 44
		            
		            ld      hl, 44
		            add     hl, de
		            ld      d,  h
		            ld      e,  l
		
		            ; Ahora DE apunta al principio del siguiente sprite.
		
		upd_nxt:    pop     bc
		            djnz    upd_loop
		            
		            ret
		
		;; ---------------------------------------------------------------------------
		;; rutina upd_sprites
		;; ---------------------------------------------------------------------------
		            
		;; Esta rutina llama a las cuatro anteriores para hacer la animaci�n
		;; sincronizando con el retrazo
		
		upd_sprites:
					halt
		            call    borra_sprites
		            call    init_sprites
		            call    pinta_sprites
		            call    upd_coord
		            ret
		            
		;; ---------------------------------------------------------------------------
		;; subrutinas
		;; ---------------------------------------------------------------------------
		                            
		;; Esta subrutina copia el rect�ngulo del bitmap al buffer apuntado por DE.
		                
		scr2buf:    call    getscraddr      ; HL = Direcci�n en el bitamp de XPOS,YPOS
		
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            
		            ; xpos++
		            ld      hl, xpos
		            inc     (hl)		          
		            
		            ;; Segundo char
		            call    getscraddr      ; HL = Direcci�n en el bitamp de XPOS,YPOS
		
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            
		            ; xpos--
		            ld      hl, xpos
		            dec     (hl)
		            
		            ; ypos++
		            inc     hl
		            inc     (hl)
		            
		            ;; Tercer char
		            call    getscraddr      ; HL = Direcci�n en el bitamp de XPOS,YPOS
		
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            
		            ; xpos++
		            ld      hl, xpos
		            inc     (hl)
		            
		            ;; Cuarto char
		            call    getscraddr      ; HL = Direcci�n en el bitamp de XPOS,YPOS
		
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            ld      a,  (hl)
		            ld      (de), a
		            inc     h
		            inc     de
		            
		            ret
		
		;; Esta subrutina copia el buffer apuntado por DE al bitmap 
		                
		buf2scr:    ;; Primer char
		            call    getscraddr      ; HL = Direcci�n en el bitamp de XPOS,YPOS
		
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            
		            ; xpos++
		            ld      hl, xpos
		            inc     (hl)
		            
		            ;; Segundo char
		            call    getscraddr      ; HL = Direcci�n en el bitamp de XPOS,YPOS
		
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            
		            ; xpos--
		            ld      hl, xpos
		            dec     (hl)
		            
		            ; ypos++
		            inc     hl
		            inc     (hl)
		            
		            ;; Tercer char
		            call    getscraddr      ; HL = Direcci�n en el bitamp de XPOS,YPOS
		
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            
		            ; xpos++
		            ld      hl, xpos
		            inc     (hl)
		            
		            ;; Cuarto char
		            call    getscraddr      ; HL = Direcci�n en el bitamp de XPOS,YPOS
		
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            
		            ret
		        
		;; Esta rutina apunta los chars en el buffer apuntado por DE a pantalla.
		                
		char2scr:   ;; Primer car�cter
		
		            ld      a, (de)         ; En A el # del car�cter
		            push    de              ; Nos guardamos DE para luego
		            call    getcharaddr     ; En HL tenemos la direcci�n del car�cter
		            ex      de, hl          ; En DE tenemos la direcci�n del car�cter
		            call    getscraddr      ; En HL tenemos la direcci�n en pantalla
		            
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a         ; Copiamos los 8 bytes del char
		                        
		            pop     de              ; Restauramos de
		            inc     de              ; Siguiente char
		            
		            ; xpos++
		            ld      hl, xpos
		            inc     (hl)
		            
		            ;; Segundo car�cter
		            
		            ld      a, (de)         ; En A el # del car�cter
		            push    de              ; Nos guardamos DE para luego
		            call    getcharaddr     ; En HL tenemos la direcci�n del car�cter
		            ex      de, hl          ; En DE tenemos la direcci�n del car�cter
		            call    getscraddr      ; En HL tenemos la direcci�n en pantalla
		            
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a         ; Copiamos los 8 bytes del char
		            
		            pop     de              ; Restauramos de
		            inc     de              ; Siguiente char
		            
		            ; xpos--
		            ld      hl, xpos
		            dec     (hl)
		            
		            ; ypos ++
		            inc     hl
		            inc     (hl)
		            
		            ;; Tercer car�cter
		            
		            ld      a, (de)         ; En A el # del car�cter
		            push    de              ; Nos guardamos DE para luego
		            call    getcharaddr     ; En HL tenemos la direcci�n del car�cter
		            ex      de, hl          ; En DE tenemos la direcci�n del car�cter
		            call    getscraddr      ; En HL tenemos la direcci�n en pantalla
		            
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a         ; Copiamos los 8 bytes del char
		            
		            pop     de              ; Restauramos de
		            inc     de              ; Siguiente char
		        
		            ; xpos++
		            ld      hl, xpos
		            inc     (hl)
		            
		            ;; Cuarto car�cter
		            
		            ld      a, (de)         ; En A el # del car�cter
		            push    de              ; Nos guardamos DE para luego
		            call    getcharaddr     ; En HL tenemos la direcci�n del car�cter
		            ex      de, hl          ; En DE tenemos la direcci�n del car�cter
		            call    getscraddr      ; En HL tenemos la direcci�n en pantalla
		            
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a
		            inc     h
		            inc     de
		            ld      a,  (de)
		            ld      (hl), a         ; Copiamos los 8 bytes del char
		            
		            pop     de              ; Restauramos de
		            inc     de              ; Fin de los UDG
		            
		            ret
		                
		;; Esta subrutina devuelve en HL la direcci�n de memoria de las coordenadas
		;; XPOS,YPOS. Inspirado por c�digo de Bloodbaz.
		                
		getscraddr: ld      a,  (xpos)
		            and     31
		            ld      l,  a
		            ld      a,  (ypos)
		            ld      c,  a
		            and     24
		            add     a,  64
		            ld      h,  a
		            ld      a,  c
		            and     7
		            rrca
		            rrca
		            rrca
		            or      l
		            ld      l,  a
		            
		            ret
		
		;; Esta subrutina devuelve en HL la direcci�n de memoria del atributo en las
		;; coordenadas XPOS,YPOS. Jonnathan Cauldwell ?
		            
		getatraddr: ld      a,  (ypos)      ; Cogemos y
		            rrca
		            rrca
		            rrca                    ; La multiplicamos por 32
		            ld      l,  a           ; nos lo guardamos en l
		            and     3               ; ponemos una mascarita 00000011
		            add     a,  88          ; 88 * 256 = 22528, aqu� empieza el tema
		            ld      h,  a           ; Hecho el bite superior.
		            ld      a,  l           ; Nos volvemos a traer y * 32
		            and     224             ; Mascarita 11100000
		            ld      l,  a           ; Lo volvemos a poner en l
		            ld      a,  (xpos)      ; Cogemos x
		            add     a,  l           ; Le sumamos lo que ten�amos antes.
		            ld      l,  a           ; Listo. Ya tenemos en HL la direcci�n.
		            
		            ret
		            
		;; Esta subrutina calcula la posici�n de memoria del car�cter en A
		;; y la devuelve en HL. Pepito Grillo en pijama.
		                        
		getcharaddr:
		
		            ld      b,  a
		            
		            ld      a,  (setAddrLsb)
		            ld      e,  a
		            
		            ld      a,  (setAddrMsb)
		            ld      d,  a
		            ld      a,  b
		            
		            ld      h,  0
		            ld      l,  a
		            add     hl, hl
		            add     hl, hl
		            add     hl, hl
		            add     hl, de
		            
		            ret
	End Asm
End Sub
