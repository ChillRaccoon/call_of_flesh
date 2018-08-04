/obj/structure/stalker/modification_table
	name = "modification table"
	desc = "�������, ����, �� ������� ����� �������������� ������ � �������."
	eng_desc = "Craft the diamond pickaxe."
	icon = 'icons/stalker/decor.dmi'
	var/obj/item/modificated = null
	density = 1
	anchored = 1

/datum/data/modification
	name = "modification"
	var/cost = 5000
	var/desc = "��� ����������&#255;."
	var/eng_desc = "This is modification"

/datum/data/modification/clothing
	name = "clothing modification"
	desc = "You shouldn't see this."
	eng_desc = "You shouldn't see this."
	var/list/add_armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/datum/data/modification/clothing/head
	name = "helmet modification"
	desc = "��� ���������&#255; ��&#255; �����."
	eng_desc = "This is helmet modification."

/datum/data/modification/clothing/head/nightvision
	name = "Nightvision I Gen"
	cost = 12000
	desc = "��������� ������� ������� ������&#255; ������� ��������&#255;."
	eng_desc = ""
	add_armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

/datum/data/modification/clothing/suit
	name = "suit modification"
	desc = "��� ����������&#255; ��&#255; �������."
	eng_desc = "This is suit modification."

/datum/data/modification/gun
	name = "gun modification"
	desc = "��� ����������&#255; ��&#255; �����&#255;."
	eng_desc = "This is gun modification."