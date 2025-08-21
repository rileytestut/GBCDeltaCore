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
	ld a, 00
	ldff(ff), a
	ld a, 30
	ldff(00), a
	ld a, 01
	ldff(4d), a
	stop, 00
	ld c, 44
	ld b, 90
lbegin_waitly90:
	ldff a, (c)
	cmp a, b
	jrnz lbegin_waitly90
	ld a, 0a
	ld(0000), a
	ld hl, fe00
	ld c, a0
	ld a, a0
lbegin_fill_oam:
	ld(hl++), a
	dec c
	jrnz lbegin_fill_oam
	ld c, 44
	ld b, 90
lbegin_waitly90_2:
	ldff a, (c)
	cmp a, b
	jrnz lbegin_waitly90_2
	ld hl, c1ff
	ld a, 00
lbegin_set_c1xx:
	ld(hl--), a
	inc a
	jrnz lbegin_set_c1xx
lbegin_set_c0xx:
	dec a
	ld(hl--), a
	jrnz lbegin_set_c0xx
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

.text@1000
lstatint:
	ld a, c0
	ldff(51), a
	xor a, a
	ldff(52), a
	ldff(54), a
	ld a, 80
	ldff(53), a
	ld c, 55
	ld a, c0
	ldff(46), a
	ld a, 13
	ldff(c), a
	nop
	nop
	nop
	nop
	nop
	ld c, 44
	ld b, 96
lstatint_waitly96:
	ldff a, (c)
	cmp a, b
	jrnz lstatint_waitly96
	xor a, a
	ldff(40), a
	ld hl, feff
	ld de, a000
lstatint_dump_oam_to_sram:
	ld a, (hl--)
	dec e
	ld(de), a
	jrnz lstatint_dump_oam_to_sram
	xor a, a
	ld(0000), a

