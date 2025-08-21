.size 8000

.data@0
	01

.text@48
	jp lstatint

.data@9c
	02 03 04 05

.text@100
	jp lbegin

.data@143
	c0 00 00 00 1a 00 03

.text@150
lbegin:
	ld b, 90
	call lwaitly_b
	ld a, 0a
	ld(0000), a
	ld hl, fe00
	ld c, 20
	ld a, 10
lbegin_fill_oam00to1f:
	ld(hl++), a
	dec c
	jrnz lbegin_fill_oam00to1f
	ld c, 80
	ld a, a0
lbegin_fill_oam20to9f:
	ld(hl++), a
	dec c
	jrnz lbegin_fill_oam20to9f
	ld b, 90
	call lwaitly_b
	ld hl, c09f
	ld c, a0
	ld a, 10
lbegin_fill_wram00to9f:
	dec c
	ld(hl--), a
	jrnz lbegin_fill_wram00to9f
	ld a, 10
	ld(fe9c), a
	ld a, 02
	ldff(45), a
	ld a, 40
	ldff(41), a
	xor a, a
	ldff(0f), a
	ld a, 02
	ldff(ff), a
	ei

.text@1000
lstatint:
	nop

.text@1077
	ld a, c0
	ldff(46), a

.text@10b4
	ldff a, (41)
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

