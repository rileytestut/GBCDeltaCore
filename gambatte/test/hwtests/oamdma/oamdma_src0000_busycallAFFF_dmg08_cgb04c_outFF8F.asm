.size 8000

.text@48
	jp ff80

.data@9c
	02 03 04 05

.text@100
	jp lbegin

.data@143
	80 00 00 00 1a 00 03

.text@200
	ld c, 26
	ld a, 00
	ldff(46), a
lwaitdma:
	dec c
	jrnz lwaitdma
	ld sp, afff
	call ldummytarget
ldummytarget:
	ld a, (fe9d)
	ld b, a
	ld a, (fe9e)
	ld c, a
	jp lprint_bc

.text@150
lbegin:
	ld bc, 0200
	ld hl, ff80
	ld d, 40
lcopydmaroutine:
	ld a, (bc)
	ld(hl++), a
	inc c
	cmp a, cd
	jrnz lcopydmaroutine_notcall
	ld a, l
	inc a
	inc a
	ld(hl++), a
	ld a, h
	ld(hl++), a
	inc c
	inc c
lcopydmaroutine_notcall:
	dec d
	jrnz lcopydmaroutine
	ld b, 90
	call lwaitly_b
	ld a, 0a
	ld(0000), a
	ld bc, fe00
	ld d, a0
	ld a, 06
lfill_oam:
	ld(bc), a
	inc c
	dec d
	jrnz lfill_oam
	ld a, 90
	ldff(45), a
	ld a, 40
	ldff(41), a
	xor a, a
	ldff(0f), a
	ld a, 02
	ldff(ff), a
	ei
	halt

.text@7000
lprint_bc:
	push bc
	ld b, 90
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
	pop bc
	ld a, b
	srl a
	srl a
	srl a
	srl a
	ld(9800), a
	ld a, b
	and a, 0f
	ld(9801), a
	ld a, c
	srl a
	srl a
	srl a
	srl a
	ld(9802), a
	ld a, c
	and a, 0f
	ld(9803), a
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
	ldff(43), a
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

