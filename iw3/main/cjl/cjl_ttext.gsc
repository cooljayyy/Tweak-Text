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
	if (IsDefined(level.tstrings)) //Prevents re-invocation.
		return;
	if (!IsDefined(level.ui_acount))
		level.ui_acount = 0;
	if (!IsDefined(level.ttext_mode) ||
	   (level.ttext_mode > 1 && IsDefined(level.roundlimit) && level.roundlimit > 1))
		level.ttext_mode = 0;

	DebugPrint("[tweak-text]: Setup");
	level thread TTextRoundSwitch_Handler(); //Executes each round end.
	level.tstrings_clear_cap = 60; //~60-safe (with hitches).
	level.tstrings = []; //Order-dependent.
	level.tanchors = [];
	level.ttexts = [];

	if (level.ttext_mode == 2)
	{
		if (game["roundsplayed"] == 0)
			CSStump_Clear(); //Executes only first round.

		CSStump_Push(); //Executes each round.
		level.tstrings_cap = 823; //*Approximate* uncached + cached run-time strings accounted for.
	}
	else
	{
		tstrings_cap["koth"] = 595; //Headquarters
		tstrings_cap["war"]  = 604; //Team Deathmatch
		tstrings_cap["sab"]  = 593; //Sabotage
		tstrings_cap["sd"]   = 590; //Search and Destroy
		tstrings_cap["dom"]  = 596; //Domination
		tstrings_cap["dm"]   = 604; //Free-for-All
		tstrings_cap["ctf"]  = 604; //Capture the Flag (Cut)
		if (!IsDefined(tstrings_cap[level.gametype])) level.tstrings_cap = 423; //Custom gametypes.
		else level.tstrings_cap = (tstrings_cap[level.gametype] - 100); //*Approximate* uncached run-time strings accounted for.

		if (level.ttext_mode == 0) //Guarded prevents redundant string in moderate mode.
		{
			CSHead_Clear();
			level.tstrings_cap = Min(level.tstrings_cap, level.tstrings_clear_cap);
		}
	}
}
	/**<************************************************************
		- Uncached run-time strings: General ?x, 1x First Anchor.
		- Cached run-time strings: ?x General.
		- Config-strings capacity: 1023.
		- Call in init() non-threaded after load-time
		  config-strings have populated (PrecacheString()).
		- @todo Specify console string limits.
		- @todo Factor exact uncached/cached run-time string limits.
	 ***************************************************************/

TTextRoundSwitch_Handler()
{
	level waittill("restarting");

	if (_Round_WasFinal()) //Skip final round to preserve any custom map vote UI.
		return;

	DebugPrint("[tweak-text]: Round switch pops");
	CSAnchor_Pops(); //Required regardless of maximum mode.
}
	/**<************************************************************
		- level.onroundswitch callback usage is infeasible as it
		  pertains to "switch sides" not round switch.
	 ***************************************************************/

TText_Evaluate(string)
{
	DebugPrint("[tweak-text]: Text evaluate (" + level.tstrings.size + "/" + level.tstrings_cap + ", " + level.ttext_mode + ", " + level.tanchors.size + ", " + string + ")");

	if (level.tstrings.size >= level.tstrings_cap)
	{
		//  Clear Config-strings
		// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
		CSAnchor_Pops();

		//  Reapply Text Strings
		// ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
		level.tstrings = [];
		level.tstrings[level.tanchors[0]] = true; //Preserve first anchor string.
		DebugPrint("[tweak-text]: Reapply strings");

		for (i = 0; i < level.ttexts.size; i ++)
		{
			text = level.ttexts[i];
			AssertX((level.tstrings.size < level.tstrings_cap), ("CJL - Too many concurrent tstrings: " + level.tstrings.size)); //Exit if reapplied strings exceed limit.

			if (text.alpha > 0 && IsDefined(text.string)) //Visible text only.
			{
				if ((level.tstrings.size % level.tstrings_clear_cap) == 0 && !_Array_Contains(level.tanchors, text.string)) //Recreate anchors and guard duplicates.
					CSAnchor_Push(text.string);
				if (text.label != 0) //Label strings.
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

	eidx = (level.ttexts.size - 1);
	level.ttexts[text.idx] = level.ttexts[eidx]; //Remove-swap.
	level.ttexts[text.idx].idx = text.idx;
	level.ttexts[eidx] = undefined; //Decrements array.size.
	level.ui_acount --;
	text Destroy();
}
	/**<************************************************************
		- Remove-swap method is faster than ArrayRemoveIndex().
	 ***************************************************************/

TText_Set(text, string)
{
	AssertX((string.size < 256), "CJL - Exceeded text character limit: 255.");
	TText_Evaluate(string);
	text SetText(string);
	text.string = string; //Store preserved copy of string.
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
	text SetValue(number);
}
	/**<************************************************************
		- Empty label is used to distinguish "number" elements
		  from other labels.
	 ***************************************************************/

TTextLabel_Set(text, string)
{
	TText_Evaluate();
	text.label = string;
	level.tstrings[string] = true;
}
	/**<************************************************************
		@param string Must prefix "&".
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
	if (alpha > 0.0 && text.alpha == 0.0 && text.label != 0)
		TText_Set(text, text.string);

	text.alpha = alpha;
}
	/**<************************************************************
		- Invisible text elements (.alpha = 0) are excluded from
		  string application and thus are reapplied here when
		  set visible again.
	 ***************************************************************/

//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//██ Config-strings
//██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

CSStump_Clear()
{
	DebugPrint("[tweak-text]: Stump clear (" + game["roundsplayed"] + "/" + level.roundlimit + ")");
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
		- "MP_HALFTIME" is always the first config-string (MP).
		- "stump" refers to the first string in config-strings that
		  remains after clearing.
	 ***************************************************************/

CSStump_Push()
{
	DebugPrint("[tweak-text]: Stump push");
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

	DebugPrint("[tweak-text]: Head clear");
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
	DebugPrint("[tweak-text]: Anchor clear (" + idx + ")");
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
	DebugPrint("[tweak-text]: Anchor push (" + level.tstrings.size + "/" + level.tstrings_cap + ", " + level.tanchors.size + ", " + string + ")");
	level.tanchors[level.tanchors.size] = string;
	SetDvar("ttext_head", string);
}

CSAnchor_Pop()
{
	DebugPrint("[tweak-text]: Anchor pop (" + level.tanchors.size + ", " + level.tanchors[(level.tanchors.size - 1)] + ")");
	idx = (level.tanchors.size - 1);
	CSAnchor_Clear(idx);
	level.tanchors[idx] = undefined; //Sequential decrement is essential.
	wait 0.05; //Prevents reliable command cycle-out.
}

CSAnchor_Pops()
{
	DebugPrint("[tweak-text]: Anchor pops (" + level.tstrings.size + "/" + level.tstrings_cap + "/" + level.tstrings_clear_cap + ", " + level.tanchors.size + ")");

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

//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//██ Imports
//██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

AssertX(condition, message)
{
	if (IsDefined(condition) && condition)
		return;

	AssertMsg(message); //Prints to console when developer dvar enabled.
	println(message); //Prints to console.
	SetDvar("ui_errorTitle", "Error"); //Sets UI error.
	SetDvar("ui_errorMessage", message);
	ExitLevel();
}

DebugPrint(message)
{
	if (GetDvarInt("developer"))
		println(message);
}

_Round_WasFinal()
{
	return (level.forcedend || maps\mp\gametypes\_globallogic::HitRoundLimit() || maps\mp\gametypes\_globallogic::HitScoreLimit());
}

_Array_Contains(array, value)
{
	for (i = 0; i < array.size; i ++)
	{
		if (array[i] == value)
			return true;
	}

	return false;
}

//▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//██▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
//██ Analysis
//██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
//▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

CSOverflow_Test()
{
	level endon("game_ended");

	DebugPrint("[tweak-text]: Config-strings overflow test");

	if (level.roundlimit != 1)
	{
		SetDvar("scr_game_prematchperiod", 0);
		SetDvar("scr_" + GetDvar("g_gametype") + "_timelimit", 1);
	}
	else
		SetDvar("scr_" + GetDvar("g_gametype") + "_timelimit", 0);

	TText_Setup();
	if (level.players.size == 0) level waittill("connected"); //Prevents reliable command cycle-out.
	text = NewHUDElem();
	text.fontscale = 1.4; //Essential for text to display (IW3, IW4, IW5, T4).
	TText_Create(text);

	for (i = 0; i < 2147483647; i ++)
	{
		TText_Set(text, "SOT " + i); //text SetText("SOT " + i);
		wait 0.05;
	}
}
	/**<************************************************************
		- Call in init().
	 ***************************************************************/

UILimit_Test()
{
	level endon("game_ended");

	DebugPrint("[tweak-text]: UI limit test");
	texts = [];

	for (i = 0; i < 64; i ++) //Must be < string limit.
	{
		texts[i] = NewHUDElem();
		texts[i].elemtype = "font";
		texts[i].font = "default";
		texts[i].fontscale = 1.4;
		texts[i].horzalign = "left";
		texts[i].vertalign = "top";
		texts[i].alignx = "left";
		texts[i].aligny = "top";
		texts[i].x = (40 * (i / 40));
		texts[i].y = (10 * (i % 40));
		if (i > 30) texts[i].color = (1.0, 1.0, 0.0); else texts[i].color = (1.0, 1.0, 1.0);
		texts[i].alpha = 1.0;
		texts[i].archived = (i > 30);
		texts[i].sort = 5.0;
		texts[i] SetText("Text: " + i);
	}
}
	/**<************************************************************
		- Call in init().
	 ***************************************************************/