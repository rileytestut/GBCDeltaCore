.size 8000

.text@100
	jp lbegin

.data@143
	80

.text@150
lbegin:
	ld b, 3e
	ld c, 01
lwaitreset:
	dec b
	jrnz lwaitreset
	dec c
	jrnz lwaitreset
	nop
	xor a, a
	ldff(26), a
	ld a, 80
	ldff(26), a
	ld a, 77
	ldff(24), a
	ld a, 22
	ldff(25), a
	ld a, 00
	ldff(16), a
	ld a, 09
	ldff(17), a
	ld a, 00
	ldff(18), a
	ld a, 87
	ldff(19), a
	ld b, eb
	ld c, 0f
lwait:
	dec b
	jrnz lwait
	dec c
	jrnz lwait
	nop
	nop
	ld a, 08
	ldff(17), a
limbo:
	jr limbo

