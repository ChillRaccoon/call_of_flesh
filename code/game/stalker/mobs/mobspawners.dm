/obj/effect/spawner/lootdrop/stalker/mobspawner
	name = "mob spawner"
	cooldown = 1000

/obj/effect/spawner/lootdrop/stalker/mobspawner/SpawnLoot(enable_cooldown = 1)
	sleep(10)
	if(loot && loot.len)
		for(var/k = 0, k < CanSpawn(), k++)
			if(!loot.len) return
			var/lootspawn = pickweight(loot)
			if(lootspawn)
				var/turf/T = get_turf(src)
				for(var/mob/living/carbon/human/H in view(7, T))
					SpawnLoot()
					return
				var/mob/living/M = new lootspawn(T)
				spawned_loot.Add(M)
				//RandomMove(M)
		if(!enable_cooldown)
			SpawnLoot()
		else
			spawn(cooldown)
				SpawnLoot()

/obj/effect/spawner/lootdrop/stalker/mobspawner/CanSpawn()
	var/count = 0
	for(var/mob/living/M in spawned_loot)
		if(M && M.stat != 2)
			count++
		else
			spawned_loot.Remove(M)
	var/r = Clamp(lootcount - count, 0, lootcount)
	return r

/obj/effect/spawner/lootdrop/stalker/mobspawner/flesh_spawner
	name = "flesh mutant"
	lootcount = 2
	radius = 10 //������ �������� ����
	cooldown = 6000 //���-�� ����� * 1000 - �� ���������
	loot = list(/mob/living/simple_animal/hostile/mutant/flesh = 100)

/obj/effect/spawner/lootdrop/stalker/mobspawner/dog_spawner
	name = "dog mutant"
	lootcount = 2
	radius = 10 //������ �������� ����
	cooldown = 6000 //���-�� ����� * 1000 - �� ���������
	loot = list(/mob/living/simple_animal/hostile/mutant/dog = 100)

/obj/effect/spawner/lootdrop/stalker/mobspawner/kaban_spawner
	name = "kaban mutant"
	lootcount = 1
	radius = 10 //������ �������� ����
	cooldown = 6000 //���-�� ����� * 1000 - �� ���������
	loot = list(/mob/living/simple_animal/hostile/mutant/kaban = 100)

/obj/effect/spawner/lootdrop/stalker/mobspawner/snork_spawner
	name = "snork mutant"
	lootcount = 1
	radius = 1
	cooldown = 9000
	loot = list(/mob/living/simple_animal/hostile/mutant/snork = 100)