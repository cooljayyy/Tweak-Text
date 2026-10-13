/*                         dP oo
						   88
.d8888b. .d8888b. .d8888b. 88 dP .d8888b. dP    dP
88'  `"" 88'  `88 88'  `88 88 88 88'  `88 88    88
88.  ... 88.  .88 88.  .88 88 88 88.  .88 88.  .88
`88888P' `88888P' `88888P' dP 88 `88888P8 `8888P88
							  88               .88
							  dP           d8888P */

//███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
//██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██▄▄▄██
//-------------------------------------------------------------------------------------------------------------------------------
//   🔨 Functions
//
//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//██ Tweak-Text
//██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

TText_Setup()
{
	if (IsDefined(level.ttexts)) //Prevents re-invocation.
		return;
	if (!IsDefined(level.ui_acount))
		level.ui_acount = 0;

	//#ifdef PL && (T6 || T5 || T4)
	//if (1) return; //Plutonium uses SetTextUnlimited() instead.
	//#endif

	if (!IsDefined(level.ttext_mode) || (level.ttext_mode > 1 && _RoundCount_Get() > 1))
		level.ttext_mode = 0;

	_DebugPrint("[cjl_ttext]: Setup");
	level thread TTextRoundSwitch_Handler(); //Executes each round end.
	level.tstrings = []; //Order-dependent.
	level.tanchors = [];
	level.ttexts = [];

	#ifdef T6 && MP
	level.tstrings_clear_cap = 100; //129-max, ~124-fair (with no hitches), ~100-safe (with hitches).
	#elifdef T6 && ZM
	level.tstrings_clear_cap = 100; //127-max, ~126-fair, ~100-safe.
	#elifdef T5 && MP
	level.tstrings_clear_cap = 60; //~60-safe (with hitches).
	#elifdef T5 && SP
	level thread RoundCounter_Handler();
	#elifdef T4
	level.tstrings_clear_cap = 60; //~60-safe (with hitches).
	#elifdef IW5
	level.tstrings_clear_cap = 60; //~60-safe (with hitches).
	#elifdef IW4
	wait 0.05; //Wait for load-time configstrings to populate (IW4 only).
	level.tstrings_clear_cap = 60; //~60-safe (with hitches).
	#elifdef IW3
	level.tstrings_clear_cap = 60; //~60-safe (with hitches).
	#endif

	if (level.ttext_mode == 2)
	{
		#ifdef T6 && MP
		level.tstrings_cap = (465 - (6 * level.teams.size)); //Uncached + cached run-time strings accounted for.
		#elifdef T6 && ZM
		level.tstrings_cap = 433; //Uncached + cached run-time strings accounted for.
		#elifdef T5 && MP
		level.tstrings_cap = 914; //Uncached + cached run-time
		level.tstrings_cap = 695; //Uncached + cached run-time strings accounted for.
		#elifdef T5 && SP
		level.tstrings_cap = 695; //Uncached + cached run-time strings accounted for.

		if (!IsDefined(level.ttext_stump))
		{
			ttext_stump["zombietron"] = &"GAME_GET_TO_COVER";                 //Dead Ops Arcade
			ttext_stump["frontend"]   = &"FRONTEND_PRESS_BUTTON_TO_SIT_DOWN"; //Main Menu
			if (!IsDefined(ttext_stump[GetDvar("mapname")])) level.ttext_stump = &"ZOMBIE_WEAPONCOSTAMMO";
			else level.ttext_stump = ttext_stump[GetDvar("mapname")];
		}
		#elifdef T4 && MP
		level.tstrings_cap = 765; //Uncached + cached run-time strings accounted for.
		#elifdef T4 && SP
		level.tstrings_cap = 1005; //Uncached + cached run-time strings accounted for.

		if (!IsDefined(level.ttext_stump))
		{
			ttext_stump["nazi_zombie_prototype"] = &"ZOMBIE_WEAPONCOSTAMMO";          //Nacht Der Untoten
			ttext_stump["nazi_zombie_asylum"]    = &"ZOMBIE_BETTY_ALREADY_PURCHASED"; //Verrückt
			ttext_stump["nazi_zombie_sumpf"]     = &"ZOMBIE_BETTY_HOWTO";             //Shi No Numa
			ttext_stump["nazi_zombie_factory"]   = &"ZOMBIE_FLAMES_UNAVAILABLE";      //Der Riese
			if (!IsDefined(ttext_stump[GetDvar("mapname")])) level.ttext_stump = &"ZOMBIE_WEAPONCOSTAMMO";
			else level.ttext_stump = ttext_stump[GetDvar("mapname")]; //Note some localized strings are reused trigger strings.
		}
		#elifdef IW5
		level.tstrings_cap = 411; //*Approximate* uncached + cached run-time strings accounted for.
		#elifdef IW4
		level.tstrings_cap = 411; //*Approximate* uncached + cached run-time strings accounted for.
		#elifdef IW3
		level.tstrings_cap = 823; //*Approximate* uncached + cached run-time strings accounted for.
		#endif
		if (!IsDefined(game["roundsplayed"]) || game["roundsplayed"] == 0)
			CSStump_Clear(); //Executes only first round.

		CSStump_Push(); //Executes each round.
	}
	else
	{
		#ifdef T6 && MP
		tstrings_cap["tdm"]       = 63; //Team Deathmatch
		tstrings_cap["dm"]        = 63; //Free-for-All
		tstrings_cap["dom"]       = 47; //Domination
		tstrings_cap["dem"]       = 50; //Demolition
		tstrings_cap["conf"]      = 62; //Kill Confirmed
		tstrings_cap["koth"]      = 50; //Hardpoint
		tstrings_cap["hq"]        = 52; //Headquarters
		tstrings_cap["ctf"]       = 41; //Capture the Flag
		tstrings_cap["sd"]        = 47; //Search & Destroy
		tstrings_cap["oneflag"]   = 34; //One Flag CTF
		tstrings_cap["hctdm"]     = 63; //Hardcore Team Deathmatch
		tstrings_cap["hcdm"]      = 63; //Hardcore Free for All
		tstrings_cap["hcdom"]     = 47; //Hardcore Domination
		tstrings_cap["hcdem"]     = 50; //Hardcore Demolition
		tstrings_cap["hcconf"]    = 62; //Hardcore Kill Confirmed
		tstrings_cap["hckoth"]    = 50; //Hardcore Hardpoint
		tstrings_cap["hchq"]      = 52; //Hardcore Headquarters
		tstrings_cap["hcctf"]     = 41; //Hardcore Capture the Flag
		tstrings_cap["hcsd"]      = 47; //Hardcore Search & Destroy
		tstrings_cap["hconeflag"] = 34; //Hardcore One Flag CTF
		tstrings_cap["gun"]       = 57; //Gun Game
		tstrings_cap["oic"]       = 60; //One in the Chamber
		tstrings_cap["shrp"]      = 57; //Sharpshooter
		tstrings_cap["sas"]       = 59; //Sticks and Stones
		if (!IsDefined(tstrings_cap[level.gametype])) level.tstrings_cap = 30; //Custom gametypes.
		else level.tstrings_cap = (tstrings_cap[level.gametype] + (Is_PC() ? -8 : -6) + (IsDefined(level.stringpatch) ? 173 : 0)); //Uncached run-time strings accounted for.
		/**<************************************************************
			- Uncached run-time strings: 7x General, 1x First Anchor.
			- Cached run-time strings: 38x General.
			- Config-strings capacity: 511.
		 ***************************************************************/
		#elifdef T6 && ZM
		tstrings_cap["zm_transit"]["transit"]["zclassic"]    = 253; //(282) //Tranzit - Classic
		tstrings_cap["zm_transit"]["transit"]["zstandard"]   = 300; //(324) //Bus Depot - Survival
		tstrings_cap["zm_transit"]["town"]["zstandard"]      = 292; //(316) //Town - Survival
		tstrings_cap["zm_transit"]["town"]["zgrief"]         = 294; //(323) //Town - Grief
		tstrings_cap["zm_transit"]["farm"]["zstandard"]      = 292; //(316) //Farm - Survival
		tstrings_cap["zm_transit"]["farm"]["zgrief"]         = 294; //(323) //Farm - Grief
		tstrings_cap["zm_transit_dr"]["diner"]["zcleansed"]  = 314; //(344) //Diner - Turned
		tstrings_cap["zm_nuked"]["nuked"]["zstandard"]       = 297; //(321) //Nuketown - Survival
		tstrings_cap["zm_highrise"]["rooftop"]["zclassic"]   = 290; //(316) //Die Rise - Classic
		tstrings_cap["zm_prison"]["prison"]["zclassic"]      = 286; //(326) //Mob of the Dead - Classic
		tstrings_cap["zm_prison"]["cellblock"]["zgrief"]     = 309; //(338) //Cell Block - Grief
		tstrings_cap["zm_buried"]["processing"]["zclassic"]  = 277; //(306) //Buried - Classic
		tstrings_cap["zm_buried"]["processing"]["zgrief"]    = 298; //(327) //Buried - Grief
		tstrings_cap["zm_buried"]["processing"]["zcleansed"] = 295; //(325) //Buried - Turned
		tstrings_cap["zm_buried"]["street"]["zgrief"]        = 284; //(313) //Borough - Grief
		tstrings_cap["zm_buried"]["street"]["zcleansed"]     = 295; //(325) //Borough - Turned
		tstrings_cap["zm_tomb"]["tomb"]["zclassic"]          = 262; //(300) //Origins - Classic
		if (!IsDefined(tstrings_cap[GetDvar("mapname")][GetDvar("ui_zm_mapstartlocation")][GetDvar("g_gametype")])) level.tstrings_cap = 111; //Custom maps/gametypes.
		else level.tstrings_cap = tstrings_cap[GetDvar("mapname")][GetDvar("ui_zm_mapstartlocation")][GetDvar("g_gametype")]; //Uncached run-time strings accounted for.
		/**<************************************************************
			- Uncached run-time strings: 23x General, 5x Grief,
		      6x Turned, 5x Tranzit, 0x Nuketown, 2x Die Rise,
		      16x Mob of the Dead, 5x Buried, 14x Origins,
		      1x First Anchor.
			- Cached run-time strings: 38x General.
			- Config-strings capacity: 511.
			- ui_zm_gamemodegroup has no effect on string cap.
	 	 ***************************************************************/
		#elifdef T5 && MP
		tstrings_cap["tdm"]  = 722; //Team Deathmatch
		tstrings_cap["dm"]   = 722; //Free-for-All
		tstrings_cap["sd"]   = 708; //Search & Destroy
		tstrings_cap["dom"]  = 709; //Domination
		tstrings_cap["koth"] = 713; //Headquarters
		tstrings_cap["dem"]  = 709; //Demolition
		tstrings_cap["ctf"]  = 705; //Capture the Flag
		tstrings_cap["sab"]  = 710; //Sabotage
		tstrings_cap["gun"]  = 716; //Gun Game
		tstrings_cap["oic"]  = 719; //One in the Chamber
		tstrings_cap["shrp"] = 717; //Sharpshooter
		tstrings_cap["hlnd"] = 718; //Sticks and Stones
		if (!IsDefined(tstrings_cap[level.gametype])) level.tstrings_cap = 623; //Custom gametypes.
		else level.tstrings_cap = (tstrings_cap[level.gametype] - 10); //Uncached run-time strings accounted for.
		/**<************************************************************
			- Uncached run-time strings: 9x General, 1x First Anchor.
			- Cached run-time strings: 98x General.
			  Includes PLUTONIUM_UI_MP_CONNECTED.
			- Config-strings capacity: 1023.
		 ***************************************************************/
		#elifdef T5 && SP
		tstrings_cap["zombie_theater"]        = 896;  //(899)  //Kino Der Toten
		tstrings_cap["zombie_pentagon"]       = 895;  //(898)  //"Five"
		tstrings_cap["zombietron"]            = 697;  //(1011) //Dead Ops Arcade
		tstrings_cap["zombie_cosmodrome"]     = 897;  //(900)  //Ascension
		tstrings_cap["zombie_coast"]          = 894;  //(897)  //Call of the Dead
		tstrings_cap["zombie_temple"]         = 896;  //(900)  //Shangri-La
		tstrings_cap["zombie_moon"]           = 887;  //(893)  //Moon
		tstrings_cap["zombie_cod5_prototype"] = 911;  //(914)  //Nacht Der Untoten
		tstrings_cap["zombie_cod5_asylum"]    = 899;  //(913)  //Verrückt
		tstrings_cap["zombie_cod5_sumpf"]     = 905;  //(909)  //Shi No Numa
		tstrings_cap["zombie_cod5_factory"]   = 905;  //(910)  //Der Riese
		tstrings_cap["frontend"]              = 1001; //(1010) //Main Menu
		if (!IsDefined(tstrings_cap[GetDvar("mapname")])) level.tstrings_cap = 723; //Custom maps.
		else level.tstrings_cap = tstrings_cap[GetDvar("mapname")]; //Uncached run-time strings accounted for.
		/**<************************************************************
			- Uncached run-time strings: 2x General, 0x Kino Der Toten,
			  0x "Five", 311x Dead Ops Arcade, 0x Ascension,
			  0x Call of the Dead, 1x Shangri-La, 3x Moon,
			  0x Nacht Der Untoten, 1x Verrückt, 1x Shi No Numa,
			  2x Der Riese, 6x Main Menu, 1x First Anchor.
			- Cached run-time strings: 10x General. 4x Moon.
			  Includes PLUTONIUM_UI_MP_CONNECTED.
			  Dead Ops Arcade pushes a string for each round (255).
			- Config-strings capacity: 1023.
		 ***************************************************************/
		#elifdef T4 && MP
		tstrings_cap["tdm"]  = 855; //Team Deathmatch
		tstrings_cap["koth"] = 845; //Headquarters
		tstrings_cap["twar"] = 832; //War
		tstrings_cap["ctf"]  = 843; //Capture the Flag
		tstrings_cap["dm"]   = 855; //Free-for-All
		tstrings_cap["dom"]  = 847; //Domination
		tstrings_cap["sd"]   = 841; //Search and Destroy
		tstrings_cap["sab"]  = 842; //Sabotage
		if (!IsDefined(tstrings_cap[level.gametype])) level.tstrings_cap = 723; //Custom gametypes.
		else level.tstrings_cap = (tstrings_cap[level.gametype] - 121); //Uncached run-time strings accounted for (except only 1/3 of challenges).
		/**<************************************************************
			- Uncached run-time strings: 3x General, 1x Rank,
			  348x Challenges.
			  1x First Anchor.
			- Cached run-time strings: 137x General.
			  Includes PLUTONIUM_UI_MP_CONNECTED.
			- Config-strings capacity: 1023.
		 ***************************************************************/
		#elifdef T4 && SP
		tstrings_cap["nazi_zombie_prototype"] = 906; //(914) //Nacht Der Untoten
		tstrings_cap["nazi_zombie_asylum"]    = 893; //(901) //Verrückt
		tstrings_cap["nazi_zombie_sumpf"]     = 896; //(904) //Shi No Numa
		tstrings_cap["nazi_zombie_factory"]   = 884; //(892) //Der Riese
		if (!IsDefined(tstrings_cap[GetDvar("mapname")])) level.tstrings_cap = 723; //Custom maps.
		else level.tstrings_cap = tstrings_cap[GetDvar("mapname")]; //Uncached run-time strings accounted for.
		/**<************************************************************
			- Uncached run-time strings: 6x General, 1x Der Riese,
			  1x First Anchor.
			- Cached run-time strings: 10x General.
			  Includes PLUTONIUM_UI_MP_CONNECTED.
			- Config-strings capacity: 1023.
		 ***************************************************************/
		#elifdef IW5
		tstrings_cap["dm"]     = 209; //Free-for-All
		tstrings_cap["war"]    = 208; //Team Deathmatch
		tstrings_cap["sd"]     = 195; //Search and Destroy
		tstrings_cap["sab"]    = 196; //Sabotage
		tstrings_cap["dom"]    = 208; //Domination
		tstrings_cap["koth"]   = 200; //Headquarters
		tstrings_cap["ctf"]    = 192; //Capture the Flag
		tstrings_cap["dd"]     = 192; //Demolition
		tstrings_cap["conf"]   = 209; //Killed Confirmed
		tstrings_cap["tdef"]   = 203; //Team Defender
		tstrings_cap["grnd"]   = 206; //Drop Zone
		tstrings_cap["tjugg"]  = 208; //Team Juggernaut
		tstrings_cap["jugg"]   = 208; //Juggernaut
		tstrings_cap["gun"]    = 208; //Gun Game
		tstrings_cap["infect"] = 207; //Infected
		tstrings_cap["oic"]    = 209; //One in the Chamber
		if (!IsDefined(tstrings_cap[level.gametype])) level.tstrings_cap = 111; //Custom gametypes.
		else level.tstrings_cap = (tstrings_cap[level.gametype] - 100); //*Approximate* uncached run-time strings accounted for.
		/**<************************************************************
			- Uncached run-time strings: General ?x, 1x First Anchor.
			- Cached run-time strings: ?x General.
			- Config-strings capacity: 511.
			- @todo Factor exact uncached/cached run-time string limits.
		 ***************************************************************/
		#elifdef IW4
		tstrings_cap["dm"]      = 312; //Free-for-All
		tstrings_cap["war"]     = 311; //Team Deathmatch
		tstrings_cap["sd"]      = 298; //Search and Destroy
		tstrings_cap["sab"]     = 299; //Sabotage
		tstrings_cap["dom"]     = 311; //Domination
		tstrings_cap["koth"]    = 303; //Headquarters
		tstrings_cap["ctf"]     = 295; //Capture the Flag
		tstrings_cap["dd"]      = 295; //Demolition
		tstrings_cap["vip"]     = 309; //VIP (Cut)
		tstrings_cap["gtnw"]    = 311; //Global Thermonuclear War (Cut)
		tstrings_cap["oneflag"] = 300; //One Flag CTF (Cut)
		tstrings_cap["arena"]   = 303; //Arena (Cut)
		tstrings_cap["conf"]    = 312; //Killed Confirmed (IW4x)
		tstrings_cap["gun"]     = 309; //Gun Game (IW4x)
		tstrings_cap["infect"]  = 309; //Infected (IW4x)
		if (!IsDefined(tstrings_cap[level.gametype])) level.tstrings_cap = 211; //Custom gametypes.
		else level.tstrings_cap = (tstrings_cap[level.gametype] - 100); //*Approximate* uncached run-time strings accounted for.
		/**<************************************************************
			- Uncached run-time strings: General ?x, 1x First Anchor.
			- Cached run-time strings: ?x General.
			- Config-strings capacity: 511 (600 IW4x).
			- @todo Factor exact uncached/cached run-time string limits.
		 ***************************************************************/
		#elifdef IW3
		tstrings_cap["koth"] = 595; //Headquarters
		tstrings_cap["war"]  = 604; //Team Deathmatch
		tstrings_cap["sab"]  = 593; //Sabotage
		tstrings_cap["sd"]   = 590; //Search and Destroy
		tstrings_cap["dom"]  = 596; //Domination
		tstrings_cap["dm"]   = 604; //Free-for-All
		tstrings_cap["ctf"]  = 604; //Capture the Flag (Cut)
		if (!IsDefined(tstrings_cap[level.gametype])) level.tstrings_cap = 423; //Custom gametypes.
		else level.tstrings_cap = (tstrings_cap[level.gametype] - 100); //*Approximate* uncached run-time strings accounted for.
		/**<************************************************************
			- Uncached run-time strings: General ?x, 1x First Anchor.
			- Cached run-time strings: ?x General.
			- Config-strings capacity: 1023.
			- @todo Factor exact uncached/cached run-time string limits.
	 	 ***************************************************************/
		#endif

		if (level.ttext_mode == 0) //Guarded prevents redundant string in moderate mode.
		{
			CSHead_Clear();
			level.tstrings_cap = Min(level.tstrings_cap, level.tstrings_clear_cap);
		}
	}
}
	/**<************************************************************s
		- Call in init() non-threaded after load-time
		  config-strings have populated (PrecacheString()).
	 ***************************************************************/

TTextRoundSwitch_Handler()
{
	#ifdef T6
	maps\mp\gametypes\_globallogic_utils::RegisterPostRoundEvent(::TTextRoundSwitch_CB);
	#elifdef T5 && MP
	maps\mp\gametypes\_globallogic_utils::RegisterPostRoundEvent(::TTextRoundSwitch_CB);
	#else
		#ifdef T4 && MP
		level waittill("game_ended");
		level.teambalance = true; //Temporarily re-enables "roundSwitching" notify.
		level waittill("roundSwitching");
		level.teambalance = GetDvarInt("scr_teambalance");
		#elifdef IW5 || IW4 || IW3
		level waittill("restarting");
		#endif

		if (_Round_WasLast()) //Skip final round to preserve any custom map vote UI.
			return;

		_DebugPrint("[cjl_ttext]: Round switch pops");
		CSAnchor_Pops(); //Required regardless of maximum mode.
	#endif
}
	/**<************************************************************
		- level.onroundswitch callback usage is infeasible as it
		  pertains to "switch sides" not round switch.
	 ***************************************************************/

#ifdef T6 || T5
TTextRoundSwitch_CB()
{
	if (_Round_WasLast()) //Skip final round to preserve any custom map vote UI.
		return;

	_DebugPrint("[cjl_ttext]: Round switch pops");
	CSAnchor_Pops(); //Required regardless of maximum mode.
	wait 0.05; //Prevents reliable command cycle-out.
}
	/**<************************************************************
		- level.onroundswitch callback usage is infeasible as it
		  pertains to "switch sides" not round switch.
	 ***************************************************************/
#endif

TText_Evaluate(string)
{
	_DebugPrint("[cjl_ttext]: Text evaluate (" + level.tstrings.size + "/" + level.tstrings_cap + ", " + level.ttext_mode + ", " + level.tanchors.size + ", " + string + ")");

	if (level.tstrings.size >= level.tstrings_cap)
	{
		//  Clear Config-strings
		// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
		CSAnchor_Pops();

		//  Reapply Text Strings
		// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
		level.tstrings = [];
		level.tstrings[level.tanchors[0]] = true; //Preserve first anchor string.
		_DebugPrint("[cjl_ttext]: Reapply strings");

		for (i = 0; i < level.ttexts.size; i ++)
		{
			text = level.ttexts[i];
			_AssertX((level.tstrings.size < level.tstrings_cap), ("CJL - Too many concurrent tstrings: " + level.tstrings.size)); //Exit if reapplied strings exceed limit.

			if (text.alpha > 0 && IsDefined(text.string)) //Visible text only.
			{
				if ((level.tstrings.size % level.tstrings_clear_cap) == 0 && !_Array_Contains(level.tanchors, text.string)) //Recreate anchors and guard duplicates.
					CSAnchor_Push(text.string);
				if (TTextLabel_Get(text) != 0) //Label strings.
					text.label = text.string;
				else //Text strings.
					text SetText(text.string);

				level.tstrings[text.string] = true;
			}
		}
	}

	//  Anchor
	// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
	else if ((level.tstrings.size % level.tstrings_clear_cap) == 0 && !_Array_Contains(level.tanchors, string))
		CSAnchor_Push(string);
}
	/**<************************************************************
	   - Anchor duplicates are guarded for cases where previous
		 anchor string is reused whilst level.tstrings.size is % 0.
	   - First anchor string is re-pushed to level.tstrings after
		 clearing as it never leaves config-strings array and must
		 be counted.
	 ***************************************************************/

TText_Create(text)
{
	if (IsDefined(text.owner))
	{
		if (!IsDefined(text.owner.ui_acount)) text.owner.ui_acount = 0;
		text.archived = (text.archived && ((text.owner.ui_acount + level.ui_acount) < 31));
    	if (text.archived) text.owner.ui_acount ++;
	}
    else
    {
    	text.archived = (text.archived && level.ui_acount < 31);
    	if (text.archived) level.ui_acount ++;
	}

	//#ifdef PL && (T6 || T5 || T4)
	//if (1) return;
	//#endif
	text.idx = level.ttexts.size; //Used for text deletion.
	level.ttexts[level.ttexts.size] = text;
}
	/**<************************************************************
	   - Auto-archiving factors both level and player elements
	     sharing same archive pools and fills "archived"
	     pool first before overflow into "unarchived" pool.
	     Elements already set to "unarchived" are ignored.
	     OC elements are excluded from archive count.
	   - .idx naming is used instead of .index to prevent conflict
	     with OC scripts that use the latter.
	   - Idea of invoking TText_Setup() here is infeasible as such
		 MUST be invoked on first server frame.
	 ***************************************************************/

TText_Delete(text)
{
	if (!IsDefined(text.idx)) //Skip if not tweak-text.
	{
		text Destroy();
		return;
	}
	if (text.archived)
	{
		if (IsDefined(text.owner))
			text.owner.ui_acount --;
		else
			level.ui_acount --;
	}

	//#ifdef PL && (T6 || T5 || T4)
	//if (1) return;
	//#endif
	eidx = (level.ttexts.size - 1);
	level.ttexts[text.idx] = level.ttexts[eidx]; //Remove-swap.
	level.ttexts[text.idx].idx = text.idx;
	level.ttexts[eidx] = undefined; //Decrements array.size.
	text Destroy();
}
	/**<************************************************************
		- Remove-swap method is faster than ArrayRemoveIndex().
	 ***************************************************************/

TText_Set(text, string)
{
	_AssertX(IsDefined(string), "CJL - Undefined string.");
	_AssertX((string.size < 256), "CJL - Exceeded text character limit: " + string.size + "/255.");
	text.string = string; //Store preserved copy of string.
	//#ifdef PL && (T6 || T5 || T4)
	//text SetTextUnlimited(string);
	//if (1) return;
	//#endif
	TText_Evaluate(string);
	text SetText(string);
	level.tstrings[string] = true;
}
	/**<************************************************************
		- String is pushed to level.tstrings only if unique.
		- Key array is used to circumvent otherwise using
		  _Array_Contains() which is performance expensive.
		- Order of operations here was carefully chosen for
		  maximum efficiency and logical cohesion
		  (vacancy first check).
		- Executing TText_Evaluate() before applying string
		  prevents otherwise redundantly checking to not apply
		  string twice when clearing occurs inside said function.

		  Current              | Alternative
		  ---------------------|---------------------------
		  └───TText_Evaluate() | └───tstring push
		  └───SetText()        | └───if (TText_Evaluate())
		  └───tstring push     |     └───SetText()

	 ***************************************************************/

TTextNumber_Set(text, number)
{
	text.label = &""; //Label is never used.
		///@todo ^^^ Maybe able to use 0 instead.
	text SetValue(number);
}
	/**<************************************************************
		- Empty label enables distinguishing "text number" elements
		  apart from other labels.
	 ***************************************************************/

TTextLabel_Set(text, string, string_tidx)
{
	//#ifdef PL && (T6 || T5 || T4)
	//#else
	TText_Evaluate(string);
	level.tstrings[string] = true;
	//#endif
	#ifdef T6
	text.label = istring(string);
	#else
	text.label = string_tidx;
	#endif
}
	/**<************************************************************
		- .label must be a localized string, of which can be
		  specified either using "&" prefix or istring() cast.
		- Note localized strings cannot be used as array keys or
		  concatenated.
	 ***************************************************************/

TTextLabel_Get(text)
{
	#ifdef T6 || T5 || T4
	return text.label;
	#else
	return ((text.label != undefined) ? text.label : 0);
	#endif
}
	/**<************************************************************
		- .label is zero by default in T4/5/6 and undefined in
		  IW3/4/5.
		- Variable fields are evaluated before being passed to
		  functions in IW3/4/5 and thus cannot be checked with
		  IsDefined() without a run-time error.
	 ***************************************************************/

TTextLabelNumber_Set(text, number)
{
	text SetValue(number);
}
	/**<************************************************************
		- TTextLabel_Set() must be used first.
	 ***************************************************************/

TTextAlpha_Set(text, alpha)
{
	//#ifdef PL && (T6 || T5 || T4)
	//#else
	if (alpha > 0.0 && text.alpha == 0.0 && text.label == 0 && IsDefined(text.string))
		TText_Set(text, text.string);

	//#endif
	text.alpha = alpha;
}
	/**<************************************************************
		- Invisible text elements (.alpha = 0) are excluded from
		  string application and thus are reapplied here when
		  set visible again.
	    - Labels are excluded from string reapplication.
	    - .label is always 0 in T4/5/6 for run-time strings.
	    - .string is undefined when TextNumber_Set() is only used.
	 ***************************************************************/

#ifdef T5 && SP
RoundCounter_Handler()
{
	level waittill("begin_spawning"); //Essential anchor as load times vary.

	if (IsDefined(level.chalk_hud2))
		level.chalk_hud2 Destroy();
}
	/**<************************************************************
		- Fixes round counter bug after clearing config-strings.
	 ***************************************************************/
#endif

//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//██ Config-strings
//██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

CSStump_Clear()
{
	_DebugPrint("[cjl_ttext]: Stump clear (" + game["roundsplayed"] + "/" + _RoundCount_Get() + ")");
	anchor = NewHUDElem();
	#ifdef ((T5 || T4) && SP)
	anchor SetText(level.ttext_stump);
	#elifdef T4 && MP
	anchor SetText(&"PERKS_UAV_JAMMER"); //Localized string operator "&" is essential.
	#else
	anchor SetText(&"MP_HALFTIME"); //Localized string operator "&" is essential.
	#endif
	anchor ClearAllTextAfterHUDElem();
	anchor Destroy();
}
	/**<************************************************************
		- Clears entire config-strings array.
		- Must be executed within first few server frames to work
		  otherwise reliable command cycle-out occurs.
		- Must be executed after load-time config-strings are pushed
		 (inside init()) to clear them.
		- Doesn't work for fast_restart.
		- "MP_HALFTIME" is always the first config-string in
		   T6, T5MP, T4ZM, IW6, IW5, IW4, IW3.
		- "stump" refers to the first string in config-strings that
		  remains after clearing.
	 ***************************************************************/

CSStump_Push()
{
	_DebugPrint("[cjl_ttext]: Stump push");
	level.tanchors[0] = "§STUMP";
	level.tstrings["§STUMP"] = true;
}
	/**<************************************************************
		- Makes stump the first anchor for additional config-strings
		  space when using maximum mode.
		- Localized string operator "&" cannot be stored in array
		  as it breaks array size.
	 ***************************************************************/

CSHead_Clear()
{
	if (GetDvar("ttext_head") == "")
		return;

	_DebugPrint("[cjl_ttext]: Head clear");
	CSAnchor_Push(GetDvar("ttext_head")); //Re-register head from previous match if present.
	CSAnchor_Clear((level.tanchors.size - 1));
	level.tstrings[level.tanchors[0]] = true; //Re-register head string.
}
	/**<************************************************************
		- Used by minimum mode to clear previous round's
		  config-strings on match start to enable fast_restart to
		  work without overflow. Note head unavoidably persists for
		  all subsequent matches.
		- "head" refers to last anchor in config-strings that
		  remains after clearing.
		- Note there is no official methods for distinguishing
		  whether map_restart or fast_restart occurred.
	 ***************************************************************/

CSAnchor_Clear(idx)
{
	_DebugPrint("[cjl_ttext]: Anchor clear (" + idx + ")");
	anchor = NewHUDElem();
	anchor SetText(level.tanchors[idx]);
	anchor ClearAllTextAfterHUDElem();
	anchor Destroy();
}
	/**<************************************************************
		- Reassigns existing config-string to a temporary hudelem to
		  clear "all after it" which preserves hudelem slots.
	 ***************************************************************/

CSAnchor_Push(string)
{
	_DebugPrint("[cjl_ttext]: Anchor push (" + level.tstrings.size + "/" + level.tstrings_cap + ", " + level.tanchors.size + ", " + string + ")");
	level.tanchors[level.tanchors.size] = string;
	SetDvar("ttext_head", string);
}

CSAnchor_Pop()
{
	_DebugPrint("[cjl_ttext]: Anchor pop (" + level.tanchors.size + ", " + level.tanchors[(level.tanchors.size - 1)] + ")");
	idx = (level.tanchors.size - 1);
	CSAnchor_Clear(idx);
	level.tanchors[idx] = undefined; //Sequential decrement is essential.
	wait 0.05; //Prevents reliable command cycle-out.
}

CSAnchor_Pops()
{
	_DebugPrint("[cjl_ttext]: Anchor pops (" + level.tstrings.size + "/" + level.tstrings_cap + "/" + level.tstrings_clear_cap + ", " + level.tanchors.size + ")");

	for (i = (level.tanchors.size - 1); i > 0; i --)
		CSAnchor_Pop();

	if (level.ttext_mode == 2)
		CSStump_Clear(); //Required when stump is anchor #0.
	else
		CSAnchor_Clear(0);
}
	/**<************************************************************
		- First anchor never leaves config-strings array.
		- First anchor is cleared separately to preserve
		  level.tanchors entry (as it never leaves config-strings)
		  and to avoid flicker otherwise caused by wait() usage
		  which isn't required for first anchor.
		- Idea of otherwise reapplying strings between each pop
		  to circumvent flicker is infeasible as level.ttexts is
		  not ordered by string index.
	 ***************************************************************/

/*CS_ClearA()
{
	strings = Array(&"MP_HALFTIME", &"MP_PLUS", &"SCORE_HQ_CAPTURE_KILL",
		&"KILLSTREAK_MISSILE_SWARM_NOT_AVAILABLE"
	); //Samples are 100 entries apart.

	for (i = (strings.size - 1); i >= 0; i --)
	{
		anchor = NewHUDElem();
		anchor SetText(strings[i]);
		anchor ClearAllTextAfterHUDElem();
		anchor Destroy();
		wait 0.05; //Prevents reliable command cycle-out.
	}
}*/
	/**<************************************************************
		- Clears entire config-strings array mid-match without
		  incurring reliable command cycle-out.
		- Doesn't work for fast_restart.
	 ***************************************************************/

/*CSString_Push(string)
{
	_DebugPrint("[cjl_ttext]: String push (" + string + ")");
	anchor = NewHUDElem();
	anchor SetText(string);
	anchor Destroy();
}*/
	/**<************************************************************
		- Pushes arbitrary string to config-strings.
		- String is omitted from tstrings array as usage of
	      localized strings corrupts key arrays.
	 ***************************************************************/

//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//██ Imports
//██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

_AssertX(condition, message)
{
	if (IsDefined(condition) && condition)
		return;

	AssertMsg(message); //Prints to console when developer dvar enabled.
	PrintLn(message); //Prints to console.
	SetDvar("ui_errorTitle", "Error"); //Sets UI error.
	SetDvar("ui_errorMessage", message);
	ExitLevel();
}

_DebugPrint(message)
{
	if (GetDvarInt("debug"))
		println(message);
}

_Array_Contains(array, value)
{
	#ifdef T6
	return IsInArray(array, value);
	#else
	foreach (item in array)
    {
        if (item == value)
            return true;
    }

	return false;
	#endif
}

_Session_IsForceEnded()
{
	#ifdef IW5 || IW4
    return (level.forcedend || (level.hostforcedend && !maps\mp\gametypes\_gamelogic::HostIdledOut()));
	#else //T6, T5, T4, IW3
    return (level.forcedend || (level.hostforcedend && !maps\mp\gametypes\_globallogic::HostIdledOut()));
    #endif
}

_Session_IsRoundBased()
{
	#ifdef T6
    return (level.roundlimit != 1 && level.roundwinlimit != 1);
    #else
    return (IsDefined(level.roundlimit) && (level.roundlimit != 1)); //Works for ZM too.
    #endif
}

_RoundCount_Get()
{
	#ifdef IW5 || IW4
	return maps\mp\_utility::GetWatchedDvar("roundlimit");
	#else
    return (IsDefined(level.roundlimit) ? level.roundlimit : 0);
    #endif
}

_Round_WasLast()
{
	#ifdef T6 || T5 || IW5
    return (!_Session_IsRoundBased() || maps\mp\_utility::WasLastRound());
    #elifdef T4
	return (!_Session_IsRoundBased() || _Session_IsForceEnded() || maps\mp\gametypes\_globallogic::HitRoundLimit() || maps\mp\gametypes\_globallogic::HitScoreLimit());
	#endif
}

//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//██ Analysis
//██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

CSOverflow_Test()
{
	//#ifdef MP
	//level Endon("game_ended");
	//#else
	//level Endon("end_game");
	//#endif

	_DebugPrint("[cjl_ttext]: Config-strings overflow test");

	#ifdef T6
	if (_Session_IsRoundBased())
	{
		SetGametypeSetting("prematchperiod", 0);
		SetGametypeSetting("preroundperiod", 0);
		SetGametypeSetting("timeLimit", 1);
	}
	else
		SetGametypeSetting("timeLimit", 0);
	#elifdef MP
	if (_Session_IsRoundBased())
	{
		SetDvar("scr_game_prematchperiod", 0);
		SetDvar("scr_" + GetDvar("g_gametype") + "_timelimit", 1);
	}
	else
		SetDvar("scr_" + GetDvar("g_gametype") + "_timelimit", 0);
	#endif

	TText_Setup();
	if (level.players.size == 0) level waittill("connected"); //Prevents reliable command cycle-out.
	texts = [];
	n = 30; //n text elements.

	for (i = 0; i < n; i ++)
	{
		texts[i] = NewHUDElem();
		#ifdef T4 || IW5 || IW4
		texts[i].fontscale = 1.0; //Essential for text to display (IW3, IW4, IW5, T4).
		#elifdef IW3
		texts[i].fontscale = 1.4;
		#endif
		texts[i].x = (100 + (10 * i));
		texts[i].y = (5 + (10 * i));
		texts[i].archived = (i < 31);
		TText_Create(texts[i]);
	}
	for (i = 0; i < 2147483647; i ++)
	{
		for (j = 0; j < n; j ++)
			TText_Set(texts[j], ("SOT " + j + " " + i)); //texts[j] SetText(("SOT " + j + " " + i)); //texts[j] SetTextUnlimited(("SOT " + j + " " + i));

		wait 0.05;
	}
}
	/**<************************************************************
		- Call in init().
		- Suceptible to server command overflow on
		  round switch + hitching.
	 ***************************************************************/

UILimit_Test()
{
	#ifdef MP
	level Endon("game_ended");
	#else
	level Endon("end_game");
	#endif

	_DebugPrint("[cjl_ttext]: UI limit test");
	texts = [];

	for (i = 0; i < 64; i ++) //Must be < string limit.
	{
		texts[i] = NewHUDElem();
		texts[i].elemtype = "font";
		texts[i].font = "default";
		texts[i].fontscale = 1.0;
		texts[i].horzalign = "user_left";
		texts[i].vertalign = "user_top";
		texts[i].alignx = "left";
		texts[i].aligny = "top";
		texts[i].x = (40 * (i / 40));
		texts[i].y = (10 * (i % 40));
		texts[i].color = ((i < 31) ? (1.0, 1.0, 0.0) : (1.0, 1.0, 1.0));
		texts[i].alpha = 1.0;
		texts[i].archived = (i < 31);
		texts[i].sort = 5.0;
		texts[i] SetText("Text: " + i);
	}
}
	/**<************************************************************
		- Call in init().
	 ***************************************************************/