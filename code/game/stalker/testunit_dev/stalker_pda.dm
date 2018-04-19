var/global/list/obj/item/device/stalker_pda/KPKs = list()
var/global/lentahtml = ""

/obj/item/device/stalker_pda
	name = "KPK"
	desc = "A portable device, used to communicate with other stalkers."
	icon = 'icons/stalker/device_new.dmi'
	icon_state = "kpk_off"
	item_state = "electronic"
	w_class = 1

	var/mode = 1
	var/show_title = 0
	var/mainhtml = ""
	var/ratinghtml =""
	var/list/access = list()

	//�������
	var/owner = null
	var/registered_name = null
	var/sid = null
	var/rotation = "front"
	var/faction_s = "��������"
	var/rating = 0
	var/reputation = 0
	var/money = 0
	var/obj/item/weapon/photo/photo_owner_front = new()
	var/obj/item/weapon/photo/photo_owner_west = new()
	var/obj/item/weapon/photo/photo_owner_back = new()
	var/obj/item/weapon/photo/photo_owner_east = new()
	var/password = null
	var/hacked = 0
	var/activated = 0
	var/rep_color_s = "#ffe100"
	var/rep_name_s = "����������&#x44F;"
	var/rank_name_s = "�������"
	//var/isregistered = 0

	//�����
	var/lenta_sound = 1
	var/last_lenta = 0
	var/lenta_id = 0
	var/msg_name = "message"
	var/max_length = 10
	slot_flags = SLOT_ID

	//�������
	var/sortBy = "rating"
	var/order = 1
	var/lastlogin = 0

/datum/asset/simple/kpk
	assets = list(
		"kpk_background.png"	= 'icons/stalker/kpk.png',
		"nodata.png"			= 'icons/stalker/nodata.png',
		"photo_0"				= 'icons/stalker/sidor.png'
	)


/obj/item/device/stalker_pda/New()
	..()
	return

/obj/item/device/stalker_pda/MouseDrop(atom/over_object)
	if(iscarbon(usr) || isdrone(usr)) //all the check for item manipulation are in other places, you can safely open any storages as anything and its not buggy, i checked
		var/mob/M = usr

		if(!M.restrained() && !M.stat)
			if(loc != usr || (loc && loc.loc == usr))
				return

			if(over_object)
				switch(over_object.name)
					if("r_hand")
						if(!M.unEquip(src))
							return
						M.put_in_r_hand(src)
					if("l_hand")
						if(!M.unEquip(src))
							return
						M.put_in_l_hand(src)
				add_fingerprint(usr)

/obj/item/device/stalker_pda/attack_hand(mob/living/user)
	if(src.loc == user)
		attack_self(user)
		user.set_machine(src)
	else
		..()

/obj/item/device/stalker_pda/attack_self(mob/user)
	for(var/datum/data/record/sk in data_core.stalkers)
		var/mob/living/carbon/human/H = user
		if(H.sid == sk.fields["sid"])
			set_owner_info(sk)
			sk.fields["lastlogin"] = world.time

	icon_state = "kpk_on"
	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/kpk)
	assets.send(user)

	user.set_machine(src)
	mainhtml ="<html> \
	\
	<style>\
	a:link {color: #607D8B;}\
	a:visited {color: #607D8B;}\
	a:active {color: #607D8B;}\
	a:hover {background-color: #9E9E9E;}\
	a {text-decoration: none;}\
	body {\
	background-image: url('kpk_background.png');\
	padding-top: 18px;\
	padding-left: 35px;\
	}\
	table {\
	    background: #131416;\
	    padding: 15px;\
	    margin-bottom: 10px;\
	    color: #afb2a1;\
	}\
	\
	#table-bottom1 {\
		background: #2e2e38;\
		padding-top: 5px;\
		padding-bottom: 5px;\
	}\
	#table-center1 {\
   	position: relative;\
    background: #2e2e38;\
	padding-top: 5px;\
    padding-bottom: 5px;\
    bottom: 100px;\
	}\
	#table-center2 {\
   	position: relative;\
    background: #2e2e38;\
    bottom: 0px;\
	}\
	#table-lenta {\
	background: #9E9E9E;\
	}\
	div.relative {\
    position: relative;\
    width: 250px;\
    height: 200px;\
    top: 70px;\
    }\
    \
    #lenta {\
    background: #2e2e38;\
    color: white;\
    padding: 5px;\
    width: 449px;\
    height: 190px;\
    overflow: auto;\
    border: 1px solid #ccc;\
    word-wrap: break-word;\
	}\
	p.lentamsg {\
	margin: 0px;\
	word-wrap: break-word;\
    }\
	#navbar {\
	overflow: hidden;\
	background-color: #099;\
	position: fixed;\
	top: 0;\
	width: 100%;\
	padding-top: 3px;\
	padding-bottom: 3px;\
	padding-left: 20px;\
	}\
	#navbar a {\
	float: left;\
	display: block;\
	color: #666;\
	text-align: center;\
	padding-right: 20px;\
	text-decoration: none;\
	font-size: 17px;\
	}\
	#navbar a:hover {\
	background-color: #ddd;\
	color: black;\
	}\
	#navbar a.active {\
	background-color: #4CAF50;\
	color: white;\
	}\
	#ratingimg {\
    vertical-align:middle;\
	}\
	.main {\
	}\
	.main img {\
	height: auto;\
	}\
	.button {\
	  width: 300px;\
	  height: 60px;\
	}\
	</style>"
	if (!owner || !password)
		mainhtml +="\
		<body>\
		<table border=0 height=\"314\" width=\"455\">\
		<tr>\
		<td valign=\"top\" align=\"center\">\
	    <div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div><br>\
	    <div class=\"relative\" align=\"center\">������� ������</div>\
		</td>\
		</tr>\
		<tr>\
		<td colspan=\"2\" align=\"center\" id=\"table-center1\" height=60>\
				| <a style=\"color:#c10000;\" href='byond://?src=\ref[src];choice=password_input'>_______________</a> |<br>\
		<div align=\"center\"></div>\
		</td>\
		</tr>"
	else

		if (user != owner && hacked == 0)
			mainhtml +="\
			\
			<body>\
			\
			<table border=0 height=\"314\" width=\"455\">\
			<tr>\
			<td align=\"left\" width=200>\
			<div style=\"overflow: hidden; height: 200px; width: 180px;\" ><img height=80 width=80 border=4 src=photo_front><img height=80 width=80 border=4 background src=photo_side></div>\
			</td>\
			<td valign=\"top\" align=\"left\">\
			 <div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div><br>\
			 <b>��&#x44F;:</b> [registered_name]<br><br>\
			 <b>�����������:</b> [faction_s]<br><br>\
			 <b>����:</b> [rating]<br><br>\
			 <b>��������&#x44F;:</b> <font color=\"[rep_color_s]\">[rep_name_s]</font>\
			</td>\
			</tr>\
			\
			<tr>\
			<td colspan=\"2\" align=\"center\" id=\"table-bottom1\" height=60>\
				| <a style=\"color:#c10000;\" href='byond://?src=\ref[src];choice=password_check'>� ������� �������� - ������� ������</a> |<br>\
			<div align=\"center\"></div>\
			</td>\
			</tr>"
		else
			switch(mode)

		//�������

				if(1)
					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
					<tr>\
					<td valign=\"top\" align=\"left\">\
					<div align=\"right\"><a style=\"color:#c10000;\" align=\"center\" href='byond://?src=\ref[src];choice=exit'>\[����� �� ��������\]</a><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
					<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=rotate'>��������� ���� ������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=make_avatar'>������� ���� ������&#x44F;</a> | </div>\
					</td>\
					</tr>\
					<tr valign=\"top\">\
	                <td>\
                    \
					<table>\
                    \
	                <tr>\
                    <td style=\"text-align: center;\" valign=\"top\" align=\"left\" width=90 height=90>\
					<img style=\"margin-left: auto; margin-right: auto;\" height=80 width=80 border=4 src=photo_[rotation]>\
					<br>\
                    </td>\
                    <td>\
					\
                     <b>��&#x44F;:</b> [registered_name]<br>\
                     <b>�����������:</b> [faction_s]<br>\
                     <b>����:</b> [rank_name_s] ([rating])<br>\
                     <b>��������&#x44F;:</b> <font color=\"[rep_color_s]\">[rep_name_s] ([reputation])</font><br>\
                     <b>������ �� �����:</b> [money] �.<br>\
					\
                    </td>\
                    </tr>\
                    \
                    </table>\
                    \
                    \
                    </td>\
                    </tr>\
                    \
					<tr>\
					<td colspan=\"1\" align=\"center\" id=\"table-bottom1\" height=60>\
						| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>\
					<div align=\"center\"></div>\
					</td>\
					</tr>"

		//����������

				if(2)
					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
					<tr>\
					<td align=\"left\" width=200>\
					\
					</td>\
					</tr>\
					\
					<tr>\
					<td colspan=\"2\" align=\"center\" id=\"table-bottom1\" height=60>\
						| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>\
					<div align=\"center\"></div>\
					</td>\
					</tr>"

		//�������

				if(3)
					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
					<tr>\
					<td valign=\"top\" align=\"left\">\
					<div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
					<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=refresh_rating'>�������� ������ ���������</a> | </div>\
					</td>\
					</tr>\
					<tr valign=\"top\">\
	                <td>\
					<div id= \"lenta\">\
					[ratinghtml]\
	             	</div>\
	                \
	                </td>\
					</tr>\
					<tr>\
					<td colspan=\"1\" align=\"center\" id=\"table-bottom1\" height=60>\
						| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>\
					<div align=\"center\"></div>\
					</td>\
					</tr>"

					/*
					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
					<tr>\
					<td valign=\"top\" align=\"left\">\
					<div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
					<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=refresh_rating'>�������� ������ ���������</a> | </div>\
					<div id=\"lenta\">\
					<span id='maintable_data_archive'>\
					<table id='maintable_data' style=\"text-align:center;\" border=\"1\" cellspacing=\"0\" width=\"100%\">\
					<tr>\
					<th><A href='?src=\ref[src];choice=Sorting;sort=name'>��&#x44F;</A></th>\
					<th><A href='?src=\ref[src];choice=Sorting;sort=rating'>�������</A></th>\
					<th><A href='?src=\ref[src];choice=Sorting;sort=rating'>��������&#x44F;</A></th>\
					<th><A href='?src=\ref[src];choice=Sorting;sort=faction'>�����������</A></th>\
					</tr>\
					[ratinghtml]</div>\
					</td>\
					</tr>\
					\
					<tr>\
					<td colspan=\"2\" align=\"center\" id=\"table-bottom1\" height=60>\
						| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>\
					<div align=\"center\"></div>"
					*/

		//�����

				if(4)
					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
					<tr>\
					<td valign=\"top\" align=\"left\">\
					<div align=\"right\"><a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
					<div align = \"center\" > | <a href='byond://?src=\ref[src];choice=lenta_add'>�������� � �����</a> | <a href='byond://?src=\ref[src];choice=lenta_sound'>���/���� �������� ������</a> |</div>\
					</td>\
					</tr>\
					<tr style=\"border: 0px;\" valign=\"top\">\
	                <td style=\"border: 0px;\">\
					<div id=\"lenta\">"
					mainhtml +="[lentahtml]\
					</div>\
					</td>\
					</tr>\
					\
					<tr>\
					<td colspan=\"1\" align=\"center\" id=\"table-bottom1\" height=60>\
						| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>\
					<div align=\"center\"></div>\
					</td>\
					</tr>"

		//�����
				if(5)
					mainhtml +="\
					<body>\
					\
					<table border=0 height=\"314\" width=\"455\">\
					<tr>\
					<td valign=\"top\" align=\"left\">\
					<div align=\"right\">\
					<a href='byond://?src=\ref[src];choice=title'>\[-\]</a> <a href='byond://?src=\ref[src];choice=close'>\[X\]</a></div>\
					<div align = \"center\">\
					| <a href='byond://?src=\ref[src];choice=zoom' onclick=\"zoomin()\"> Zoom In</a> | \
					<a href='byond://?src=\ref[src];choice=zoom' onclick=\"zoomout()\"> Zoom Out</a> | \
					</div>\
					</td>\
					</tr>\
					<tr valign=\"top\">\
	                <td>\
					<div id=\"lenta\">\
					<div class=\"main\">"
					if(user.z != 1)
						mainhtml += "<img id=\"map\" height=415 width=415 src=minimap_[user.z].png>"
					else
						mainhtml += "<img id=\"map\" height=415 width=415 src=nodata.png>"
					mainhtml +="\
					</div>\
					</div>\
					</td>\
					</tr>\
					<tr>\
					<td colspan=\"2\" align=\"center\" id=\"table-bottom1\" height=60>\
						| <a href='byond://?src=\ref[src];choice=1'>�������</a> | <a href='byond://?src=\ref[src];choice=2'>�����������&#x44F;</a> | <a href='byond://?src=\ref[src];choice=3'>�������</a> | <a href='byond://?src=\ref[src];choice=4'>�����</a> | <a href='byond://?src=\ref[src];choice=5'>�����</a> |<br>\
					<div align=\"center\"></div>\
					</td>\
					</tr>"


	mainhtml +="\
	</table>\
	<script>\
	function zoomin(){\
	    var myImg = document.getElementById(\"map\");\
	    var currWidth = myImg.clientWidth;\
	    if(currWidth >= 1015) return false;\
	     else{\
	        myImg.style.width = (currWidth + 200) + \"px\";\
	    } \
	}\
	function zoomout(){\
	    var myImg = document.getElementById(\"map\");\
	    var currWidth = myImg.clientWidth;\
	    if(currWidth <= 415) return false;\
		 else{\
	        myImg.style.width = (currWidth - 200) + \"px\";\
	    }\
	}\
	</script>\
	</body>\
	\
	</html>"
	if(show_title)
		user << browse(mainhtml, "window=mainhtml;size=568x388;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=1")
	else
		user << browse(mainhtml, "window=mainhtml;size=568x388;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=0")

	//625x305
	//<div style=\"overflow: hidden; height: 200px; width: 180px;\" ><img height=200 width=200 src=\"http://www.clubstalker.ru/images/resize/photo/640x480/de573c3358fd4160fe545f04b864fd69.jpg\"></div>\
	//background: #000000;\

	//padding: 15px;\
	//margin-bottom: 10px;\

/obj/item/device/stalker_pda/Topic(href, href_list)
	..()

	//var/mob/living/U = usr
	var/mob/living/carbon/human/H = usr
	var/isregistered = 0
	if(usr.canUseTopic(src))
		add_fingerprint(H)
		H.set_machine(src)
		switch(href_list["choice"])
			if("title")
				if(show_title)
					H << browse(mainhtml, "window=mainhtml;size=568x388;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=0")
					show_title = 0
				else
					H << browse(mainhtml, "window=mainhtml;size=568x388;border=0;can_resize=0;can_close=0;can_minimize=0;titlebar=1")
					show_title = 1

			if("close")
				icon_state = "kpk_off"
				H.unset_machine()
				hacked = 0
				H << browse(null, "window=mainhtml")
				return

			if("password_input")
				var/t = message_input(H, "password", 10)

				if(t)
					for(var/datum/data/record/sk in data_core.stalkers)
						if(sk.fields["sid"] == H.sid)
							isregistered = 1
					if(!isregistered)
						password = t
						var/pass = password

						data_core.manifest_inject(H, pass)

						var/datum/job/J = SSjob.GetJob(H.job)
						access = J.get_access()

						registered_name = H.real_name
						owner = H
						sid = H.sid
						activated = 1

						var/image = get_id_photo(H)
						var/obj/item/weapon/photo/owner_photo_front = new()
						var/obj/item/weapon/photo/owner_photo_west = new()
						var/obj/item/weapon/photo/owner_photo_east = new()
						var/obj/item/weapon/photo/owner_photo_back = new()

						owner_photo_front.photocreate(null, icon(image, dir = SOUTH))
						owner_photo_west.photocreate(null, icon(image, dir = WEST))
						owner_photo_east.photocreate(null, icon(image, dir = EAST))
						owner_photo_back.photocreate(null, icon(image, dir = NORTH))

						H << "<B>������ � ���</B>: <span class='danger'>\"[pass]\"</span>"
						H.mind.store_memory("<b>������ � ���</b>: \"[pass]\"")
						KPKs += src
						KPK_mobs += H

						for(var/datum/data/record/sk in data_core.stalkers)
							if(H.sid == sk.fields["sid"])
								set_owner_info(sk)
					else
						for(var/datum/data/record/sk in data_core.stalkers)
							if(sk.fields["sid"] == H.sid)
								if(sk.fields["pass"] == t)
									password = t
									var/datum/job/J = SSjob.GetJob(H.job)
									access = J.get_access()

									registered_name = H.real_name
									faction_s = sk.fields["faction"]
									rating = sk.fields["rating"]
									owner = H
									sid = H.sid
									activated = 1

									var/image = get_id_photo(H)
									var/obj/item/weapon/photo/owner_photo_front = new()
									var/obj/item/weapon/photo/owner_photo_west = new()
									var/obj/item/weapon/photo/owner_photo_east = new()
									var/obj/item/weapon/photo/owner_photo_back = new()

									owner_photo_front.photocreate(null, icon(image, dir = SOUTH))
									owner_photo_west.photocreate(null, icon(image, dir = WEST))
									owner_photo_east.photocreate(null, icon(image, dir = EAST))
									owner_photo_back.photocreate(null, icon(image, dir = NORTH))

									KPKs += src

									set_owner_info(sk)
								else
									H << "<span class='warning'>�������� ������.</span>"
				else
					H << "<span class='warning'>��� ������ �� ��������. ������� ������ ��� ���.</span>"

			if("exit")
				registered_name = null
				faction_s = null
				rating = null
				owner = null
				money = 0
				photo_owner_front = null
				photo_owner_west = null
				photo_owner_east = null
				photo_owner_back = null
				KPKs -= src
				hacked = 0
				password = null
				activated = 0

			if("password_check")
				var/t = message_input(H, "password", 10)
				if(t == password)
					//hacked = 1
					hacked = 0
					H << "<span class='warning'>�� �� �������� ���.</span>"
				else
					H << "<span class='warning'>�������� ������.</span>"

			if("rotate")
				switch(rotation)
					if ("front")
						rotation = "west"
					if("west")
						rotation = "back"
					if("back")
						rotation = "east"
					if("east")
						rotation = "front"

			if("make_avatar")
				make_avatar(H)
				for(var/datum/data/record/sk in data_core.stalkers)
					if(H.sid == sk.fields["sid"])
						set_owner_info(sk)

			if("lenta_add")
				//if(money>=0 && lenta_cooldown == 0)
				var/t = message_input(H, "message", 250)
				if(!t)
					H << "<span class='warning'>������� ���������.</span>"
				else
					if ( !(last_lenta && world.time < last_lenta + 450) )
						last_lenta = world.time

						add_lenta_message(src, sid, registered_name, faction_s, t)

					else
						var/lefttime = round((450 + last_lenta - world.time)/10)
						var/ending = ""
						switch (lefttime % 10)
							if(2 to 4)
								ending = "�"
							if(1)
								ending = "�"
						H << "<span class='warning'>�� ������� ��������� ��������� ��������� ����� [round((450 + last_lenta - world.time)/10)] ������[ending].</span>"

			if("lenta_sound")
				lenta_sound = !lenta_sound
				if(lenta_sound)
					H << "<span class='notice'>���� ���������&#255; � ��������&#255;� � ����� �������.</span>"
				else
					H << "<span class='notice'>���� ���������&#255; � ��������&#255;� � ����� ��������.</span>"

			if("refresh_rating")
				ratinghtml = ""
				if(!isnull(data_core.stalkers))
					refresh_rating(H)

			if("zoom")
				return

			if("1")			//�������
				for(var/datum/data/record/sk in data_core.stalkers)
					if(H.sid == sk.fields["sid"])
						set_owner_info(sk)

				mode = 1

			if("2")			//������������
				mode = 2

			if("3")			//�������
				if(!isnull(data_core.stalkers))
					refresh_rating(H)
				mode = 3

			if("4")			//�����
				for(var/datum/data/record/R in data_core.stalkers)
					if(R.fields["lastlogin"] + 18000 <= world.time)
						var/sid_p = R.fields["sid"]
						var/obj/item/weapon/photo/P1 = R.fields["photo_front"]
						H << browse_rsc(P1.img, "photo_[sid_p]")
				mode = 4

			if("5")			//�����
				SSminimap.sendMinimaps(H)
				mode = 5

		usr.set_machine(src)
		updateSelfDialog()
		return
	else
		hacked = 0
		H.unset_machine()
		H << browse(null, "window=mainhtml")

/obj/item/device/stalker_pda/proc/message_input(mob/living/U = usr, msg_name, max_length)
	var/t = sanitize_russian(stripped_input(U, "Please enter the [msg_name]", name, null, max_length), 1)
	if (!t)
		return
	if (!in_range(src, U) && loc != U)
		return
	if(!U.canUseTopic(src))
		return
	return t

/proc/add_lenta_message(var/obj/item/device/stalker_pda/KPK_owner, var/sid_owner, var/name_owner, var/faction_owner, msg, selfsound = 0)
	//var/n = registered_name//R.fields["name"]
	//var/sid_p = sid//R.fields["sid"]
	var/factioncolor = "#afb2a1"

	for(var/obj/item/device/stalker_pda/KPK in KPKs)
		show_lenta_message(KPK_owner, KPK, sid_owner, name_owner, faction_owner, msg)

	switch(faction_owner)
		if("�������")
			factioncolor = "#8c8c8c"
		if("��������")
			factioncolor = "#ff7733"
		if("�������")
			factioncolor = "#3399ff"
		if("����")
			factioncolor = "#ff4d4d"

	lentahtml = "<table  style=\"margin-top: 0px; margin-bottom: 5px; border: 0px; background: #2e2e38;\">\
	<tr style=\"border: 0px solid black;\">\
    <td style=\"border: 0px solid black; vertical-align: top; background: #2e2e38;\" width=32 height=32>\
	<img id=\"ratingbox\" style=\"background: #2e2e38; border: 1px solid black;\" height=32 width=32 src=photo_[sid_owner]>\
    </td>\
    \
    <td width=386 height=32 align=\"top\" style=\"background: #131416; border: 0px; text-align:left; vertical-align: top;\">\
	\
	<p class=\"lentamsg\"><b><font color = \"[factioncolor]\">[name_owner]\[[faction_owner]\]</font></b>:<br><font color = \"#afb2a1\">[msg]</font></p>\
    \
    </td>\
    \
    </tr>\
    </table>" + lentahtml

/proc/show_lenta_message(var/obj/item/device/stalker_pda/KPK_owner, var/obj/item/device/stalker_pda/KPK, var/sid_owner, var/name_owner, var/faction_owner, msg, selfsound = 0)

	var/mob/living/carbon/C = null

	/*
	if(sid_owner)
		for(var/datum/data/record/sk in data_core.stalkers)
			if(sk.fields["sid"] == sid_owner)
				var/obj/item/weapon/photo/P1 = sk.fields["photo_front"]
				C << browse_rsc(P1.img, "photo_[sid_owner].png")
	*/


	if(KPK.loc && isliving(KPK.loc))
		C = KPK.loc
	if(C && C.stat != UNCONSCIOUS)

		var/factioncolor = "#ff7733"
		switch(faction_owner)
			if("�������")
				factioncolor = "#8c8c8c"
			if("��������")
				factioncolor = "#ff7733"
			if("�������")
				factioncolor = "#3399ff"
			if("����")
				factioncolor = "#ff4d4d"

		C << russian_html2text("<p>\icon[KPK]<b><font color=\"[factioncolor]\">[name_owner]\[[faction_owner]\]:</font></b><br><font color=\"#006699\"> \"[msg]\"</font></p>")
		if(KPK_owner)
			if((KPK != KPK_owner || selfsound) && KPK.lenta_sound == 1)
				C << sound('sound/stalker/pda/sms.ogg', volume = 30)
		else
			if(KPK.lenta_sound)
				C << sound('sound/stalker/pda/sms.ogg', volume = 30)

/obj/item/device/stalker_pda/proc/refresh_rating(var/mob/living/carbon/human/H)
	var/count = 0
	ratinghtml = ""

	for(var/datum/data/record/R in sortRecordNum(data_core.stalkers, "rating", -1))
		var/obj/item/weapon/photo/P1 = R.fields["photo_front"]
		var/sid_p = R.fields["sid"]
		H << browse_rsc(P1.img, "photo_[sid_p]")
		var/n = R.fields["name"]
		var/r = text2num(R.fields["rating"])
		var/rep = R.fields["reputation"]
		var/f = R.fields["faction_s"]
		count++

		var/rep_color
		switch(R.fields["reputation"])
			if(AMAZING to INFINITY)
				rep = "���� �����"
				rep_color = "#00abdb" //#00abdb
			if(VERYGOOD to AMAZING)
				rep = "����� ������&#x44F;"
				rep_color = "#b6ff38" //#6ddb00
			if(GOOD to VERYGOOD)
				rep = "������&#x44F;"
				rep_color = "#daff21" //#b6db00
			if(NEUTRAL to GOOD)
				rep = "����������&#x44F;"
				rep_color = "#ffe100" //#ffb200
			if(BAD to NEUTRAL)
				rep = "�����&#x44F;"
				rep_color = "#ff6b3a" //#db5700
			if(VERYBAD to BAD)
				rep = "����� �����&#x44F;"
				rep_color = "#db2b00" //#db2b00
			if(DISGUSTING)
				rep = "�����"
				rep_color = "#7c0000"

		var/rank_name
		switch(r)
			if(ZONE_LEGEND to INFINITY)
				rank_name = "������� ����"
			if(MASTER to ZONE_LEGEND)
				rank_name = "������"
			if(VETERAN to MASTER)
				rank_name = "�������"
			if(EXPERT to VETERAN)
				rank_name = "�������"
			if(NEWBIE to EXPERT)
				rank_name = "�������"

		if(R.fields["lastlogin"] + 12000 >= world.time)
			ratinghtml += "<table style=\"margin-top: 0px; margin-bottom: 5px;\">\
					<tr style=\"border: 1px solid black;\">\
	                \
	                <td width=64 height=64 align=\"top\">\
					<img id=\"ratingbox\" height=64 width=64 src=photo_[sid_p]>\
	                </td>\
	                \
	                <td height=64 width=354 align=\"top\" style=\"text-align:left;vertical-align: top;\">\
	         		\
	                <b>\[[count]\]</b> [n] ([f])<br>\
					<b>�������:</b> [rank_name] ([r])<br>\
	                <b>���������:</b> <font color=\"[rep_color]\">[rep]</font><br>\
	                \
	                </td>\
	                \
	                </tr>\
	                </table>"
	/*������ �������
		ratinghtml += "<tr style=#2e2e38>\
		<td><img id=\"ratingimg\" height=24 width=24 border=1 src=photo_[sid_p]>[n]</td>\
		<td>[r]</td>\
		<td style=[background]>[rep]</td>\
		<td>[f]</td></tr>"
	ratinghtml += "</table></span>"
	*/

	return ratinghtml

/obj/item/device/stalker_pda/proc/make_avatar(var/mob/living/carbon/human/H)
	var/datum/outfit/avatar = new /datum/outfit

	if(H.w_uniform)
		avatar.uniform 		= H.w_uniform.type
	if(H.wear_suit)
		avatar.suit 		= H.wear_suit.type
	if(H.back)
		avatar.back			= H.back.type
	if(H.belt)
		avatar.belt 		= H.belt.type
	if(H.gloves)
		avatar.gloves		= H.gloves.type
	if(H.shoes)
		avatar.shoes		= H.shoes.type
	if(H.head)
		avatar.head			= H.head.type
	if(H.wear_mask)
		avatar.mask			= H.wear_mask.type
	if(H.glasses)
		avatar.glasses		= H.glasses.type
	if(H.s_store)
		avatar.suit_store	= H.s_store.type
	if(H.r_hand && !istype(H.r_hand ,/obj/item/device/stalker_pda))
		avatar.r_hand		= H.r_hand.type
	if(H.l_hand && !istype(H.l_hand ,/obj/item/device/stalker_pda))
		avatar.l_hand		= H.l_hand.type

	if(avatar.uniform == null || avatar.shoes == null)
		H << "<span class='warning'>��� ����� ������ ������ � ������� ����� ���, ��� ������ ����������!</span>"
	else
		var/image = get_avatar(H, avatar)

		var/obj/item/weapon/photo/photo_owner_front = new()
		var/obj/item/weapon/photo/photo_owner_west = new()
		var/obj/item/weapon/photo/photo_owner_east = new()
		var/obj/item/weapon/photo/photo_owner_back = new()

		photo_owner_front.photocreate(null, icon(image, dir = SOUTH))
		photo_owner_west.photocreate(null, icon(image, dir = WEST))
		photo_owner_back.photocreate(null, icon(image, dir = NORTH))
		photo_owner_east.photocreate(null, icon(image, dir = EAST))

		for(var/datum/data/record/sk in data_core.stalkers)
			if(H.sid == sk.fields["sid"])
				sk.fields["photo_front"]	= photo_owner_front
				sk.fields["photo_west"]		= photo_owner_west
				sk.fields["photo_east"] 	= photo_owner_east
				sk.fields["photo_back"] 	= photo_owner_back
				return

/obj/item/device/stalker_pda/proc/get_avatar(var/mob/living/carbon/human/H, var/datum/outfit/avatar)
	var/datum/preferences/P = H.client.prefs
	return get_flat_human_icon(null, avatar, P)

/obj/item/device/stalker_pda/proc/set_owner_info(var/datum/data/record/sk)
	var/obj/item/weapon/photo/P1 = sk.fields["photo_front"]
	var/obj/item/weapon/photo/P2 = sk.fields["photo_west"]
	var/obj/item/weapon/photo/P3 = sk.fields["photo_east"]
	var/obj/item/weapon/photo/P4 = sk.fields["photo_back"]

	usr << browse_rsc(P1.img, "photo_front")
	usr << browse_rsc(P2.img, "photo_west")
	usr << browse_rsc(P3.img, "photo_east")
	usr << browse_rsc(P4.img, "photo_back")

	faction_s	= sk.fields["faction_s"]
	rating		= sk.fields["rating"]
	money		= sk.fields["money"]
	reputation	= sk.fields["reputation"]

	switch(sk.fields["reputation"])
		if(AMAZING to INFINITY)
			rep_name_s = "���� �����"
			rep_color_s = "#00abdb" //#00abdb
		if(VERYGOOD to AMAZING)
			rep_name_s = "����� ������&#x44F;"
			rep_color_s = "#b6ff38" //#6ddb00
		if(GOOD to VERYGOOD)
			rep_name_s = "������&#x44F;"
			rep_color_s = "#daff21" //#b6db00
		if(NEUTRAL to GOOD)
			rep_name_s = "����������&#x44F;"
			rep_color_s = "#ffe100" //#ffb200
		if(BAD to NEUTRAL)
			rep_name_s = "�����&#x44F;"
			rep_color_s = "#ff6b3a" //#db5700
		if(DISGUSTING to VERYBAD)
			rep_name_s = "����� �����&#x44F;"
			rep_color_s = "#db2b00" //#db2b00
		if(DISGUSTING)
			rep_name_s = "�����"
			rep_color_s = "#7c0000"

	switch(sk.fields["rating"])
		if(ZONE_LEGEND to INFINITY)
			rank_name_s = "������� ����"
		if(MASTER to ZONE_LEGEND)
			rank_name_s = "������"
		if(VETERAN to MASTER)
			rank_name_s = "�������"
		if(EXPERT to VETERAN)
			rank_name_s = "�������"
		if(NEWBIE to EXPERT)
			rank_name_s = "�������"