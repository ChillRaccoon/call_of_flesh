var/global/list/

/obj/structure/stalker/modification_table
	name = "modification table"
	desc = "�������, ����, �� ������� ����� �������������� ������ � �������."
	eng_desc = "Minecraft table."
	icon = 'icons/stalker/decor.dmi'
	var/obj/item/modificated = null
	density = 1
	anchored = 1

/datum/modification
	var/name = "modification"
	var/cost = 5000
	var/desc = "��� ����������&#x44F;."
	var/eng_desc = "This is modification"

/datum/modification/head
	name = "helmet modification"
	desc = "��� ����������&#x44F;. ��&#x44F; �����."
	eng_desc = "This is helmet modification."
	var/list/armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/datum/modification/head/nightvision
	name = "Nightvision I"
	cost = 15000
	desc = "���������� ������ ������� ������&#x44F; ������� ��������&#x44F;."
	eng_desc = ""

/datum/modification/suit
	name = "suit modification"
	desc = "��� ����������&#x44F;. ��&#x44F; �������."
	eng_desc = "This is suit modification."
	var/list/armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/datum/modification/gun
	name = "gun modification"
	desc = "��� ����������&#x44F;. ��&#x44F; �����&#x44F;."
	eng_desc = "This is gun modification."