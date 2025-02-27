// Stuff for O.Chem
// Fossil fuels, volatile organics, fats and fucky solvents can go here

/datum/reagent/organic
	name = "crude organic fluid"
	id = "organic"
	description = "An unknown soup of organic chemicals with an oily sheen."
	taste = "earthy"
	fluid_r = 20
	fluid_g = 50
	fluid_b = 0
	transparency = 220
	value = 3
	viscosity = 0.95
	hunger_value = -0.1
	thirst_value = -0.1
	random_chem_blacklisted = 1 //this is pobably temporarily 1 just so I can work out the details

	hambrein // an extract of hamburgris
		name = "hambrein"
		id = "hambrein"
		description = "A colorless, odorless alcohol derrived from hamburgris."
		taste = "neutral"
		fluid_r = 230
		fluid_g = 230
		fluid_b = 230
		transparency = 50
		viscosity = 0.3
		depletion_rate = 0.2

		on_mob_life(var/mob/M, var/mult = 1)
			if(!M) M = holder.my_atom
			if(prob(45))
				M.HealDamage("All", 1 * mult, 0)
			if(M.bodytemperature < M.base_body_temp)
				M.bodytemperature = min(M.base_body_temp, M.bodytemperature+(5 * mult))
			..()
			if(prob(25))
				holder.add_reagent(pick("hambrinol","hambroxide"), depletion_rate * mult)
			return


	hambrinol // an oxidative product of hambrein
		name = "hambrinol"
		id = "hambrinol"
		description = "A powerfully musky aromatic compound."
		taste = "musky"
		fluid_r = 230
		fluid_g = 215
		fluid_b = 150
		transparency = 50
		viscosity = 0.4
		depletion_rate = 0.05

		on_mob_life(var/mob/M, var/mult = 1)
			if(!M) M = holder.my_atom
			//make critters around this dork attack the dork. that's how it do.
			..()


	hambroxide // another oxidative product of hambrein
		name = "hambroxide"
		id = "hambroxide"
		description = "An overwhelmingly meaty aromatic compound."
		taste = "hambery"
		fluid_r = 230
		fluid_g = 230
		fluid_b = 230
		transparency = 100
		viscosity = 0.3
		depletion_rate = 0.05
		overdose = 2 //very small overdose threshold, but really it just makes you puke it all up
		var/other_purgative = "hambrinol"

		do_overdose(severity, mob/M, mult)
			boutput(M, "<span class='alert'>You feel overwhelmed by the powerful fragrance.</span>")
			M.setStatus("stunned", max(M.getStatusDuration("stunned"), 20))
			M.setStatus("weakened", max(M.getStatusDuration("weakened"), 20))
			if(prob(25*severity))
				var/amount = holder.get_reagent_amount(src.id)
				var/other_amount = holder.get_reagent_amount(src.other_purgative)
				for(var/mob/O in viewers(M, null))
					O.show_message(text("<span class='alert'>[] vomits on the floor profusely!</span>", M), 1)
				playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
				var/obj/decal/cleanable/C = make_cleanable(/obj/decal/cleanable/vomit,M.loc)
				C.reagents.add_reagent("[src.id]", amount)
				C.reagents.add_reagent("[other_purgative]", other_amount)
				holder.remove_reagent("[src.id]", amount)
				holder.remove_reagent("[other_purgative]", other_amount)
			..()

		on_mob_life(var/mob/M, var/mult = 1)
			if(!M) M = holder.my_atom

			..()
