.size 8000

.text@48
	jp lstatint

.text@100
	jp lbegin

.data@143
	c0

.text@150
lbegin:
	ld a, 00
	ldff(ff), a
	ld a, 30
	ldff(00), a
	ld a, 01
	ldff(4d), a
	stop, 00
	ld a, ff
	ldff(45), a
	ld b, 91
	call lwaitly_b
	ld hl, fe00
	ld d, 10
	ld a, d
	ld(hl++), a
	ld a, 0c
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 0e
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 1c
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 1e
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 2c
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 2e
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 3c
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 3e
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 4c
	ld(hl++), a
	inc l
	inc l
	ld a, d
	ld(hl++), a
	ld a, 4e
	ld(hl++), a
	ld a, 40
	ldff(41), a
	ld a, 02
	ldff(ff), a
	xor a, a
	ldff(0f), a
	ei
	ld a, 01
	ldff(45), a
	ld c, 41
	ld a, 93
	ldff(40), a

.text@1000
lstatint:
	nop

.text@1095
	ldff a, (c)
	and a, 03
	jp lprint_a

.text@7000
lprint_a:
	push af
	ld b, 91
	call lwaitly_b
	xor a, a
	ldff(40), a
	pop af
	ld(9800), a
	ld bc, 7a00
	ld hl, 8000
	ld d, a0
lprint_copytiles:
	ld a, (bc)
	inc bc
	ld(hl++), a
	dec d
	jrnz lprint_copytiles
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

