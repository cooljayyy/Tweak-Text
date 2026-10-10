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

	DebugPrintA("[cjl_ttext]: Setup");
	level thread TTextRoundSwitch_Handler(); //Executes each round end.
	level.tstrings = []; //Order-dependent.
	level.tanchors = [];
	level.ttexts = [];

	level.tstrings_clear_cap = 100; //129-max, ~124-fair (with no hitches), ~100-safe (with hitches).

	if (level.ttext_mode == 2)
	{
		level.tstrings_cap = (465 - (6 * level.teams.size)); //Uncached + cached run-time strings accounted for.
		if (!IsDefined(game["roundsplayed"]) || game["roundsplayed"] == 0)
			CSStump_Clear(); //Executes only first round.

		CSStump_Push(); //Executes each round.
	}
	else
	{
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
	maps\mp\gametypes\_globallogic_utils::RegisterPostRoundEvent(::TTextRoundSwitch_CB);
}
	/**<************************************************************
		- level.onroundswitch callback usage is infeasible as it
		  pertains to "switch sides" not round switch.
	 ***************************************************************/

TTextRoundSwitch_CB()
{
	if (_Round_WasLast()) //Skip final round to preserve any custom map vote UI.
		return;

	DebugPrintA("[cjl_ttext]: Round switch pops");
	CSAnchor_Pops(); //Required regardless of maximum mode.
	wait 0.05; //Prevents reliable command cycle-out.
}
	/**<************************************************************
		- level.onroundswitch callback usage is infeasible as it
		  pertains to "switch sides" not round switch.
	 ***************************************************************/

TText_Evaluate(string)
{
	DebugPrintA("[cjl_ttext]: Text evaluate (" + level.tstrings.size + "/" + level.tstrings_cap + ", " + level.ttext_mode + ", " + level.tanchors.size + ", " + string + ")");

	if (level.tstrings.size >= level.tstrings_cap)
	{
		//  Clear Config-strings
		// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
		CSAnchor_Pops();

		//  Reapply Text Strings
		// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
		level.tstrings = [];
		level.tstrings[level.tanchors[0]] = true; //Preserve first anchor string.
		DebugPrintA("[cjl_ttext]: Reapply strings");

		for (i = 0; i < level.ttexts.size; i ++)
		{
			text = level.ttexts[i];
			AssertXA((level.tstrings.size < level.tstrings_cap), ("CJL - Too many concurrent tstrings: " + level.tstrings.size)); //Exit if reapplied strings exceed limit.

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
	AssertXA(IsDefined(string), "CJL - Undefined string.");
	AssertXA((string.size < 256), "CJL - Exceeded text character limit: " + string.size + "/255.");
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
	text.label = istring(string);
}
	/**<************************************************************
		- .label must be a localized string, of which can be
		  specified either using "&" prefix or istring() cast.
		- Note localized strings cannot be used as array keys or
		  concatenated.
	 ***************************************************************/

TTextLabel_Get(text)
{
	return text.label;
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


//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//██ Config-strings
//██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

CSStump_Clear()
{
	DebugPrintA("[cjl_ttext]: Stump clear (" + game["roundsplayed"] + "/" + _RoundCount_Get() + ")");
	anchor = NewHUDElem();
	anchor SetText(&"MP_HALFTIME"); //Localized string operator "&" is essential.
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
	DebugPrintA("[cjl_ttext]: Stump push");
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

	DebugPrintA("[cjl_ttext]: Head clear");
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
	DebugPrintA("[cjl_ttext]: Anchor clear (" + idx + ")");
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
	DebugPrintA("[cjl_ttext]: Anchor push (" + level.tstrings.size + "/" + level.tstrings_cap + ", " + level.tanchors.size + ", " + string + ")");
	level.tanchors[level.tanchors.size] = string;
	SetDvar("ttext_head", string);
}

CSAnchor_Pop()
{
	DebugPrintA("[cjl_ttext]: Anchor pop (" + level.tanchors.size + ", " + level.tanchors[(level.tanchors.size - 1)] + ")");
	idx = (level.tanchors.size - 1);
	CSAnchor_Clear(idx);
	level.tanchors[idx] = undefined; //Sequential decrement is essential.
	wait 0.05; //Prevents reliable command cycle-out.
}

CSAnchor_Pops()
{
	DebugPrintA("[cjl_ttext]: Anchor pops (" + level.tstrings.size + "/" + level.tstrings_cap + "/" + level.tstrings_clear_cap + ", " + level.tanchors.size + ")");

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
	DebugPrintA("[cjl_ttext]: String push (" + string + ")");
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

AssertXA(condition, message)
{
	if (IsDefined(condition) && condition)
		return;

	AssertMsg(message); //Prints to console when developer dvar enabled.
	println(message); //Prints to console.
	SetDvar("ui_errorTitle", "Error"); //Sets UI error.
	SetDvar("ui_errorMessage", message);
	ExitLevel();
}

DebugPrintA(message)
{
	if (GetDvarInt("debug"))
		println(message);
}

_Array_Contains(array, value)
{
	return IsInArray(array, value);
}

_Session_IsForceEnded()
{
    return (level.forcedend || (level.hostforcedend && !maps\mp\gametypes\_globallogic::HostIdledOut()));
}

_Session_IsRoundBased()
{
    return (level.roundlimit != 1 && level.roundwinlimit != 1);
}

_RoundCount_Get()
{
    return (IsDefined(level.roundlimit) ? level.roundlimit : 0);
}

_Round_WasLast()
{
    return (!_Session_IsRoundBased() || maps\mp\_utility::WasLastRound());
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

	DebugPrintA("[cjl_ttext]: Config-strings overflow test");

	if (_Session_IsRoundBased())
	{
		SetGametypeSetting("prematchperiod", 0);
		SetGametypeSetting("preroundperiod", 0);
		SetGametypeSetting("timeLimit", 1);
	}
	else
		SetGametypeSetting("timeLimit", 0);

	TText_Setup();
	if (level.players.size == 0) level waittill("connected"); //Prevents reliable command cycle-out.
	texts = [];
	n = 30;

	for (i = 0; i < n; i ++) //n text elements.
	{
		texts[i] = NewHUDElem();
		texts[i].x = (100 + (10 * i));
		texts[i].y = (5 + (10 * i));
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
	level Endon("game_ended");

	DebugPrintA("[cjl_ttext]: UI limit test");
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