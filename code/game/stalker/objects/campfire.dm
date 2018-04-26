/client/var/campfireplaying = 0

/obj/machinery/campfire
	name = "Campfire"
	desc = "�� ������ ������� ����� � �&#255;���� ����."
	icon = 'icons/stalker/stalker.dmi'
	icon_state = "campfire0"
	anchored = 1
	var/firecolor = "#FFAA33"
	var/sound_playing = 0
	var/list/trapped = new/list()
	var/cooldown = 5 					//������� � ��������
	var/incooldown = 0
	var/on = 0
	var/wood = 500
	var/list/mob/living/carbon/campers = list()
	var/KOSTIL = 0

/obj/machinery/campfire/New()
	..()
	set_light(4, 1, firecolor)
	spawn(10)
		set_light(0, 1, firecolor)
	SSmachine.processing.Remove(src)

/obj/machinery/campfire/Destroy()
	for (var/client/C in campers)
		C.campfireplaying = 0
		C << sound(null, 0, 0 , 5, 80)
		campers -= C

	SSmachine.processing.Remove(src)
	..()

obj/machinery/campfire/barrel
	name = "barrel"
	icon = 'icons/stalker/bochka.dmi'
	icon_state = "barrel0"
	density = 1

/obj/machinery/campfire/attack_hand(mob/user)
	..()
	if(on && !KOSTIL)
		user.visible_message("<span class='notice'>[user] ����� ������ �����...</span>", "<span class='notice'>�� ������ ������ �����...</span>")
		KOSTIL = 1

		if(!do_after(user, 10, 1, src))
			KOSTIL = 0
			return

		KOSTIL = 0

		user.visible_message("<span class='green'>[user] ������� �����.</span>", "<span class='green'>�� �������� �����.</span>")
		desc = "����� � ����� ����� �������� ������. ����� ������ �������� ��� ����������."

		on = !on
		update_icon()
		set_light(0)

		for (var/client/C in campers)
			C.campfireplaying = 0
			C << sound(null, 0, 0 , 5, 80)
			campers -= C

		SSmachine.processing.Remove(src)

/obj/machinery/campfire/update_icon()
	icon_state = "campfire[on]"
	update_state()
	return

/obj/machinery/campfire/barrel/update_icon()
	icon_state = "barrel[on]"
	update_state()
	return

/obj/machinery/campfire/proc/update_state()
	if(on)
		if(!sound_playing)
			sound_playing = 1

	else if(!on)
		sound_playing = 0

/obj/machinery/campfire/proc/RefreshSound()

	for(var/mob/M in view(5, src))
		if(!M || !M.client)
			continue

		if(!M.client.campfireplaying)
			M.client.campfireplaying = 1
			campers += M.client
			M << sound('sound/stalker/objects/campfire.ogg', 1, 0 , 5, 80)

	for (var/client/C in campers)
		if(!C)
			campers -= C
			continue

		if(!on || !(C.mob in view(5, src)))
			C.campfireplaying = 0
			C << sound(null, 0, 0 , 5, 80)
			campers -= C
			continue

		if(istype(C.mob, /mob/living/carbon/human) && C.mob.buckled)
			var/mob/living/carbon/human/H = C.mob
			H.adjustStaminaLoss(-10)
			H.adjustCloneLoss(-0.5)
			H.adjustBruteLoss(-0.5)
			H.adjustFireLoss(-0.5)
			H.adjustToxLoss(-0.5)

obj/machinery/campfire/process()
	if(!on)
		SSmachine.processing.Remove(src)
		return
	src.RefreshSound()
	//if(!on || (stat & BROKEN))
	//	return
	//if(on)
		/*
		if(src.wood > 750)
			set_light(5, 1, firecolor)
		else
			if(src.wood > 500)
				set_light(4, 1, firecolor)
			else
				if(src.wood > 250)
					set_light(3, 1, firecolor)
				else
					if(src.wood > 0)
						set_light(2, 1, firecolor)
		*/
	/*
	if(wood < 0)
		on = FALSE
		update_icon()
	*/

/obj/machinery/campfire/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/stack/sheet/mineral/wood))
		var/target_charge = src.wood + 250
		if(target_charge > 1000)
			if(on)
				user << "����� ����� ���������� &#255;���."
			else
				user << "� ������ ���������� ����."
		else
			if(on)
				user << "�� ��������� ���� � �����. ����� ����� ������ &#255;���."
			else
				user << "�� ��������� ���� � �����."
			src.wood = target_charge
	else
		if(I.burn_state == 1)
			if(!on)
				on = !on
				usr.visible_message("[usr] ��������� �����.", "<span class='notice'>�� �������� �����.</span>")
				desc = "�� ������ ������� ���� � �&#255;���� ����."
				update_icon()
				set_light(4, 1, firecolor)
				spawn(10)
					set_light(0, 1, firecolor)
					set_light(4, 1, firecolor)
				SSmachine.processing |= src
		else
			if(istype(I, /obj/item/weapon/match))
				var/obj/item/weapon/match/M = I
				if(M.lit == 1 && !on)
					on = !on
					usr.visible_message("[usr] ��������� �����.", "<span class='notice'>�� �������� �����.</span>")
					update_icon()
					desc = "�� ������ ������� ���� � �&#255;���� ����."
					set_light(4, 1, firecolor)
					spawn(10)
						set_light(0, 1, firecolor)
						set_light(4, 1, firecolor)
					SSmachine.processing |= src
				else
					if(M.lit == 0 && on)
						M.fire_act()
			else
				if(istype(I, /obj/item/weapon/lighter))
					var/obj/item/weapon/lighter/L = I
					if(L.lit == 1 && !on)
						on = !on
						usr.visible_message("[usr] ��������� �����.", "<span class='notice'>�� �������� �����.</span>")
						update_icon()
						desc = "�� ������ ������� ���� � �&#255;���� ����."
						set_light(4, 1, firecolor)
						spawn(10)
							set_light(0, 1, firecolor)
							set_light(4, 1, firecolor)
						SSmachine.processing |= src

				else
					if(on)
						I.fire_act()

/obj/machinery/campfire/Crossed(atom/A)
	if(istype(A,/mob))
		src.trapped.Add(A)
		if(src.trapped.len >= 1 && !incooldown)
			src.Think()
	return

obj/machinery/campfire/Uncrossed(atom/A)
	if(istype(A,/mob))
		var/mob/M = A
		src.trapped.Remove(M)
	return

obj/machinery/campfire/proc/Think()
	for(var/A in src.trapped)

		if(!istype(A, /mob))
			return

		var/mob/M = A

		if(on)
			M.fire_act()

		src.incooldown = 1

		///////////////////////
		sleep(src.cooldown * 10)
		///////////////////////

		src.incooldown = 0
		if(src.trapped.len >= 1)
			src.Think()

	return