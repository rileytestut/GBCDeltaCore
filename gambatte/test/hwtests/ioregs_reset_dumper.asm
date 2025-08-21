.size 8000

.text@100
	jp lbegin

.data@143
	80 00 00 00 03 00 01

.text@150
lbegin:
	ldff a, (44)
	cmp a, 91
	jrnz lbegin
	ldff a, (40)
	xor a, 80
	ldff(40), a
	ld a, 0a
	ld(0000), a
	ld hl, a000
	ld de, ff00
	ld b, 46
	xor a, a
lclear_FF00toFF45:
	ld(de), a
	inc e
	dec b
	jrnz lclear_FF00toFF45
	inc e
	ld b, 0e
lclear_FF47toFF54:
	ld(de), a
	inc e
	dec b
	jrnz lclear_FF47toFF54
	inc e
	ld b, 2a
lclear_FF56toFF7F:
	ld(de), a
	inc e
	dec b
	jrnz lclear_FF56toFF7F
	call ldump_ioports
	xor a, a
	ld(0000), a
	ldff a, (40)
	xor a, 80
	ldff(40), a
	jp lprint_a

.text@1800
ldump_ioports:
	ld de, ff00
	ld b, 80
ldump_ioports_loop:
	ld a, (de)
	inc e
	ld(hl++), a
	dec b
	jrnz ldump_ioports_loop
	ret

.text@7000
lprint_a:
	push af
	ld b, 91
	call lwaitly_b
	xor a, a
	ldff(40), a
	ld bc, 7a00
	ld hl, 8000
	ld d, 00
lprint_copytiles:
	ld a, (bc)
	inc bc
	ld(hl++), a
	dec d
	jrnz lprint_copytiles
	pop af
	ld b, a
	srl a
	srl a
	srl a
	srl a
	ld(9800), a
	ld a, b
	and a, 0f
	ld(9801), a
	ld a, c0
	ldff(47), a
	ld a, 80
	ldff(68), a
	ld a, ff
	ldff(69), a
	ldff(69), a
	ldff(69), a
	ldff(69), a
	ldff(69), a
	ldff(69), a
	xor a, a
	ldff(69), a
	ldff(69), a
	ld a, 91
	ldff(40), a
lprint_limbo:
	jr lprint_limbo

.text@7400
lwaitly_b:
	ld c, 44
lwaitly_b_loop:
	ldff a, (c)
	cmp a, b
	jrnz lwaitly_b_loop
	ret

.data@7a00
	00 00 7f 7f 41 41 41 41
	41 41 41 41 41 41 7f 7f
	00 00 08 08 08 08 08 08
	08 08 08 08 08 08 08 08
	00 00 7f 7f 01 01 01 01
	7f 7f 40 40 40 40 7f 7f
	00 00 7f 7f 01 01 01 01
	3f 3f 01 01 01 01 7f 7f
	00 00 41 41 41 41 41 41
	7f 7f 01 01 01 01 01 01
	00 00 7f 7f 40 40 40 40
	7e 7e 01 01 01 01 7e 7e
	00 00 7f 7f 40 40 40 40
	7f 7f 41 41 41 41 7f 7f
	00 00 7f 7f 01 01 02 02
	04 04 08 08 10 10 10 10
	00 00 3e 3e 41 41 41 41
	3e 3e 41 41 41 41 3e 3e
	00 00 7f 7f 41 41 41 41
	7f 7f 01 01 01 01 7f 7f
	00 00 08 08 22 22 41 41
	7f 7f 41 41 41 41 41 41
	00 00 7e 7e 41 41 41 41
	7e 7e 41 41 41 41 7e 7e
	00 00 3e 3e 41 41 40 40
	40 40 40 40 41 41 3e 3e
	00 00 7e 7e 41 41 41 41
	41 41 41 41 41 41 7e 7e
	00 00 7f 7f 40 40 40 40
	7f 7f 40 40 40 40 7f 7f
	00 00 7f 7f 40 40 40 40
	7f 7f 40 40 40 40 40 40

