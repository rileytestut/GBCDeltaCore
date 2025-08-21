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
	80 00 00 00 1b 00 03

.text@150
lbegin:
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
	ld(hl), a
	inc l
	dec c
	jrnz lbegin_fill_oam
	ld c, 44
	ld b, 90
lbegin_waitly90_2:
	ldff a, (c)
	cmp a, b
	jrnz lbegin_waitly90_2
	ld hl, 809f
	ld a, a0
lbegin_set_vram00to9f:
	dec a
	ld(hl--), a
	jrnz lbegin_set_vram00to9f
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
	ld a, 80
	ldff(46), a
	ld c, 44
	ld b, 91
lstatint_waitly91:
	ldff a, (c)
	cmp a, b
	jrnz lstatint_waitly91
	xor a, a
	ldff(40), a
	ld hl, fe9f
	ld de, a0a0
lstatint_dump_oam_to_sram:
	ld a, (hl)
	dec l
	dec e
	ld(de), a
	jrnz lstatint_dump_oam_to_sram
	xor a, a
	ld(0000), a

