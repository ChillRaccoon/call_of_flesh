/obj/item/weapon/gun/projectile/revolver/bm16  // ������������
	name = "BM-16"
	desc = "��������� ����� - ������������. �������� ������, � ����� ��� ��&#255; �����."
	icon_state = "bm16"
	item_state = "bm16"
	w_class = 4
	force = 15
	flags = CONDUCT
	slot_flags = SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot/stalker/bm16
	recoil = 1
	durability = 150
	sawn_desc = "����������� ���������� � ����� ����� ����������, �� ���������� ������ � ������� ���. ���� �� ����� ��������������� ����� �����&#255; � ��������."
	randomspread = 0
	spread = 12
	damagelose = 0.3
	distro = 25
	fire_sound = 'sound/stalker/weapons/bm16_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/obrez_load.ogg'
	opensound = 'sound/stalker/weapons/unload/obrez_open.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'

/obj/item/weapon/gun/projectile/revolver/bm16/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		//playsound(user, loadsound, 50, 1)
		chamber_round()
	if(istype(A, /obj/item/weapon/melee/energy))
		var/obj/item/weapon/melee/energy/W = A
		if(W.active)
			sawoff(user)
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/gun/energy/plasmacutter))
		sawoff(user)

/obj/item/weapon/gun/projectile/revolver/bm16/attack_self(mob/living/user)
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		CB.loc = get_turf(src.loc)
		CB.update_icon()
		num_unloaded++
	if (num_unloaded)
		playsound(user, opensound, 50, 1)
		user << "<span class='notice'>You break open \the [src] and unload [num_unloaded] shell\s.</span>"
	else
		user << "<span class='warning'>[src] is empty!</span>"

/obj/item/weapon/gun/projectile/revolver/bm16/toz34  //  ����������
	name = "TOZ-34"
	desc = "�������������� ������������ ��������� ����� � ����������� �������������� ��������. ������ ��������������� � ����� ����� �� �������������� ��������� ����� - '����������'."
	icon_state = "toz34"
	item_state = "toz34"
	recoil = 0.6
	force = 15
	durability = 150
	spread = 6
	damagelose = 0.15
	distro = 10

/obj/item/weapon/gun/projectile/shotgun/chaser  //  Winchester 1300
	name = "Chaser-13"
	desc = "��������������� �������� ����� ������������� ������������, ��������� ��&#255; ���������&#255; � ����� ����������&#255;���� ������&#255;� � �����������&#255; ������� ����������. ��� ������ �������� ��������������� ���������."
	icon_state = "chaser"
	item_state = "chaser"
	durability = 100
	slot_flags = SLOT_BELT|SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot/chaser
	recoil = 0.8
	w_class = 4
	randomspread = 0
	spread = 10
	force = 15
	damagelose = 0.3
	distro = 16
	//fire_sound = 'sound/stalker/weapons/winchester1300_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/chaser_load.ogg'
	pumpsound = 'sound/stalker/weapons/pump/chaser_pump.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'

/obj/item/weapon/gun/projectile/revolver/bm16/sawnoff
	name = "sawn-off BM-16"
	desc = "����������� ���������� � ����� ����� ����������, �� ���������� ������ � ������� ���. ���� �� ����� ��������������� ����� �����&#255; � ��������."
	sawn_state = SAWN_OFF
	item_state = "gun"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 3
	durability = 75
	force = 15
	spread = 20
	recoil = 2.5
	damagelose = 0.45
	distro = 35

/obj/item/weapon/gun/projectile/revolver/bm16/sawnoff/New()
	..()
	update_icon()

/obj/item/weapon/gun/projectile/shotgun/spsa
	name = "SPAS-14"
	desc = "��������������� �������������� �������� ������������ ���������&#255; � ������������ �����������&#255; ������� ������&#255; ���&#255;. ������������� ��� �� ������ �������� �� �������&#255;, ���������� ������&#255;���&#255; � �������� �������������� ������� �����&#255; ������� � ��������� ������������� �����. ���������&#255; ������� ���������� � ����������� ���������. �������&#255; �� ������� �����, ������� ���������� � ������� ����, �������� �����&#255;��� � ���� ��� ����������� �������� ������ ������ ��������."
	icon_state = "spsa"	//����� ��������
	item_state = "spsa" //����� ��������
	durability = 150
	slot_flags = SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot/spsa
	recoil = 0.6
	w_class = 4
	randomspread = 0
	spread = 8
	force = 15
	damagelose = 0.35
	distro = 12
	fire_sound = 'sound/stalker/weapons/spsa_shot.ogg'
	loadsound = 'sound/stalker/weapons/load/spsa_load.ogg'
	pumpsound = 'sound/stalker/weapons/pump/spsa_pump.ogg'
	drawsound = 'sound/stalker/weapons/draw/shotgun_draw.ogg'
