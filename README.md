# Tweak-Text

## Overview

- This product is intended to solve string overflow problems which occur for Call of Duty 
  **GSC-1.x MP/ZM** *user scripts* that variably set text across run-time and encounter the 
  error: ``G_Findconfig-stringIndex: overflow (488)``.

  SP is currently unsupported.

## Coverage

Game                                    | Date | Codename  | GSC Version | Supported
----------------------------------------|------|-----------|-------------|-----------
Call of Duty                            | 2003 | IW1*/COD1 | 1.0         | ⛔
Call of Duty 2                          | 2005 | IW2*/COD2 | 1.0         | ⛔
Call of Duty 3                          | 2006 | T3*/COD3  | 1.0         | ⛔
Call of Duty 4: Modern Warfare          | 2007 | IW3/COD4  | 1.0         | ✅*
Call of Duty: World at War              | 2008 | T4/COD5   | 1.0         | ✅
Call of Duty: Modern Warfare 2          | 2009 | IW4/COD6  | 1.1         | ✅
Call of Duty: Black Ops                 | 2010 | T5/COD7   | 1.0         | ✅
Call of Duty: Modern Warfare 3          | 2011 | IW5/COD8  | 1.2         | ✅
Call of Duty: Black Ops II              | 2012 | T6/COD9   | 1.2         | ✅
Call of Duty Online                     | 2012 | H0/CODO   | 1.x         | ⛔
Call of Duty: Ghosts                    | 2013 | IW6       | 1.3         | ⛔
Call of Duty: Advanced Warfare          | 2014 | S1        | 1.3         | ❌
Call of Duty: Black Ops III             | 2015 | T7        | 2.0         | ⛔
Call of Duty: Infinite Warfare          | 2016 | IW7       | 1.3         | ❌
Call of Duty: Modern Warfare Remastered | 2016 | H1        | 1.3         | ⛔
Call of Duty: WWII                      | 2017 | S2        | ?           | ❌
Call of Duty: Black Ops 4               | 2018 | T8        | 2.x         | ❌
Call of Duty: Modern Warfare            | 2019 | IW8       | 1.3         | ❌
Call of Duty: Warzone                   | 2020 | WZ        | 1.3         | ❌
Call of Duty: Modern Warfare 2 CR       | 2020 | H2        | 1.3         | ❌
Call of Duty: Black Ops Cold War        | 2020 | T9        | 2.x         | ❌
Call of Duty: Vanguard                  | 2021 | S4        | ?           | ❌
Call of Duty: Modern Warfare II         | 2022 | IW9       | ?           | ❌
Call of Duty: Warzone 2.0               | 2022 | WZM       | ?           | ❌
Call of Duty: Modern Warfare III        | 2023 | JUP       | 2.x         | ❌
Call of Duty: Black Ops 6               | 2024 | T10       | 2.x         | ❌
Call of Duty: Black Ops 7               | 2025 | SAT       | 2.x         | ❌

**CoD4x** is unsupported as it provides its own engine side implementation which inhibits this
script from working.

**IW1/IW2/T3** is unsupported as essential function ``clearalltextafterhudelem()`` is absent.

**IW6** is unsupported as essential function ``clearalltextafterhudelem()`` is defective.
PC function is empty.

**T7** is unsupported as essential function ``clearalltextafterhudelem()`` is absent.  
Note ``makelocalizedstring()`` can be used to grant an additional ``~1200`` strings.

**H1** is unsupported as essential function ``clearalltextafterhudelem()`` is defective.
PC function is empty. PS4 function doesn't work for ``settext()`` strings due to being 
"netconststrings" which are permanently enabled in ship build. Conversely ``setdevtext()`` 
strings can be cleared but never appear in configstrings to begin with due to deprecated code
requiring dev string slots be initialized ``(127)`` which is inaccessible in ship build.
Note ``.label`` is also unable to be cleared.

## Setup

- Implementation of this requires applying the following modifications to desired
  scripts/projects/mods:

  1. **Copy** or **aggregate** **``cjl_ttext.gsc``** script into target scripts directory:

     Platform              | Directory                                                  | Method
     ----------------------|------------------------------------------------------------|-----------
     Plutonium - T6MP      | ``%LOCALAPPDATA%\Plutonium\storage\t6\scripts\mp\cjl``     | Copy
     Plutonium - T6ZM      | ``%LOCALAPPDATA%\Plutonium\storage\t6\scripts\zm\cjl``     | Copy
     Plutonium - T5MP      | ``%LOCALAPPDATA%\Plutonium\storage\t5\scripts\mp\cjl``     | Copy
     Plutonium - T5ZM      | ``%LOCALAPPDATA%\Plutonium\storage\t5\scripts\sp\cjl``     | Copy
     Plutonium - T4MP      | ``%LOCALAPPDATA%\Plutonium\storage\t4\raw\scripts\mp\cjl`` | Copy
     Plutonium - T4ZM      | ``%LOCALAPPDATA%\Plutonium\storage\t4\raw\scripts\sp\cjl`` | Copy
     Plutonium - IW5MP     | ``%LOCALAPPDATA%\Plutonium\storage\iw5\scripts\cjl``       | Copy
     GSC Studio - T6MP/ZM  | ``maps\mp\_development_dvars.gsc``                         | Aggregate
     GSX Studio - T6MP/ZM  | ``maps\mp\_development_dvars.gsc``                         | Aggregate
     IW6x - IW6MP          | ``<GAMEROOT>\data\scripts\mp\cjl``                         | Copy
     IW4x - IW4MP          | ``<GAMEROOT>\userraw\scripts\cjl``                         | Copy
     CoD4x - IW3MP         | ``<GAMEROOT>\main\cjl``                                    | Copy

  2. **Include** **``cjl_ttext.gsc``** inside every user script that uses text elements 
     by inserting the following code at the top of each one:
     
     ```c
     #include <path>\cjl\cjl_ttext;
     ```
     Replace ``<path>`` with target scripts subdirectory, 
     e.g. ``scripts\mp``, ``scripts\zm``, ``scripts\sp``, ``scripts\``.

  3. **Call** **``TText_Setup()``** at the top of ``init()`` for every user script 
     that uses text elements. E.g.

     ```c
     init()
     {
         TText_Setup(); //<--- HERE
         //Existing code...
     }
     ```
     Call must be non-threaded and occur after game script config-strings have populated 
     (``precachestring()``).

  4. **Call** **``TText_Create()``** immediately after every listed instance present in 
     user scripts:

     Instance                 |
     -------------------------|
     createfontstring()       |
     createserverfontstring() |
     newhudelem()             |
     newclienthudelem()       |

     E.g.

     ```c
     text = newhudelem();
     TText_Setup(text); //<--- HERE
     text.fontscale = 1.0;
     text.x = 0.0;
     text.y = 0.0;
     //...
     ```

  5. **Replace** listed instances present in user scripts with the counterparts:

     Instance               | Replacement
     -----------------------|---------------------------
     text settext("string") | TText_Set(text, "string")
     text destroy()         | TText_Delete(text)
     text.alpha = n         | TTextAlpha_Set(text, n)
     text.label = n         | TTextLabel_Set(text, n)
     text setvalue(n)       | TTextLabelNumber_Set(text, n)

     Replace ``text`` with existing name.\
     Replace ``n`` with existing value.

     E.g.

     ```c
     text = newhudelem();
     text.fontscale = 1.0;
     text.x = 0.0;
     text.y = 0.0;
     text.alignx = "left";
     text.aligny = "center";
     text.color = (1.0, 1.0, 1.0);
     text.alpha = 1.0;
     TText_Set(text, "string"); //<--- HERE
     //text settext("string");
     //...
     ```

     Note the aforementioned modifications must be applied to any loaded user scripts inside 
     fastfile mods too.

  6. <sup>***(optional)***</sup> **Set** optimal mode for user scripts which require many 
     text element strings by inserting the following code at the top of ``main()`` for 
     target scripts:

     ```c
     main()
     {
         level.ttext_mode = index; //<--- HERE
     }
     ```
     Replace ``index`` with with any of the following mode indexes:

     Name     | Index                    | String Limit | Preservation | Round Switch | Fast Restart | Anchors          
     ---------|--------------------------|--------------|--------------|--------------|--------------|------------------
     Minimum  | 0 <sub>*(default)*</sub> | < 100        | ✅           | ✅          | ✅           | Single           
     Moderate | 1                        | < 511        | ✅           | ✅          | ❌           | Multiple         
     Maximum  | 2                        | 511          | ❌           | ❌          | ❌           | Stump + Multiple 

     **Maximum** mode provides substantial config-strings space useful for user scripts that
     use many text element strings, however adversely removes default gametype text element 
     **label** strings (e.g. +100 kill) and doesn't support round-based gametypes, hardpoint, 
     and ``fast_restart``, making it only appropriate for specific cases like non-round-based 
     **custom gamemodes**.

  7. <sup>***(optional)***</sup> **Set** adjusted stump string if established by user maps/mods 
     by inserting the following code at the top of ``main()`` for pertaining parent scripts: 

     ```c
     main()
     {
         level.ttext_mode = 2;
         level.ttext_stump = "stump";
     }
     ```
     Replace ``"stump"`` with adjusted stump string.

## Notice

- Text elements must never be created before ``TText_Setup()`` has executed.

- ``level.ttext_mode`` must never be modified outside of ``main()``.

- Config-strings character count can be reduced by using **minimum**/**moderate** mode.

- Flicker from string clearing routine can be eliminated by using **minimum** mode.

- String patch scripts like ``maps\mp\gametypes\_rank.gsc`` which increase config-strings
  space can be effectively replaced using **maximum** mode.

- Players with hitching or network lag are susceptible to **reliable command overflow**
  (both local and server) due to being unable to "acknowledge" queued reliable commands in 
  time. This occurs particularly with window switching and high CPU load.

- T4 text element strings set within first ~6x frames on first match can incur 
  *reliable command cycle-out*.

- T4MP user maps/mods which shift first perk in ``statstable.csv`` break **maximum** mode
  unless ``level.ttext_stump`` is otherwise provided.

- T4ZM/T5ZM user maps/mods which shift first weapon in ``statstable.csv`` breaks **maximum** mode
  unless ``level.ttext_stump`` is otherwise provided.

## Details

- The **cause** behind the infamous *"string overflow"* error that pervades older Call of Duty
  mods is ***user scripts*** that obliviously execute code which **unsystematically** push 
  strings to an internal **"config-strings"** array (separate from string literals/variables) 
  that is vulnerable to overflow without planned management.

  The **CS_LOCALIZED_STRINGS** segment of said array is particularly vulnerable being that it is
  affected by common essential functions: ``settext()``, ``.label =``, which this product 
  focuses on managing.

- The solution provided in this product:

  1. Text element methods are replaced with **guard functions** that superficially evaluate 
     when CS_LOCALIZED_STRINGS nears capacity and invoke **``clearalltextafterhudelem()``**
     to clear strings from said segment before overflow can occur.

  2. Text element strings are each stored in a **child variable** ``.string`` of their parent text
     to be **reapplied** when CS_LOCALIZED_STRINGS is cleared, and in a **global array** for 
     counting "unique" strings to track overflow.

     The total strings reapplied at a time is **assumed** to be always less than the available 
     space in CS_LOCALIZED_STRINGS, assured by: visible-only string reapplication, player mutual
     strings, render limit constraints (62), and the nature of typical UI paging designs.
     Cases in which said supposition can fail are when many players each render many text elements 
     with unique strings.  
     E.g. ``18x players x 62 strings/elements = 1116``

  3. **Anchor** strings are pushed to CS_LOCALIZED_STRINGS every ``100`` entries to enable 
     sequentially clearing (backwards) past the ``129`` limit that 
     **``clearalltextafterhudelem()``** imposes where it's set to clear ``(510 - string_index)`` 
     but is ultimately limited by each cleared string invoking a  **reliable server command** 
     which when exceeding ``129`` in a single server frame results in the error: 
     ``CL_CGameNeedsServerCommand: A reliable command was cycled out``.

  4. Config-strings are cleared before each round switch to prevent subsequent overflow when 
     string counters reset.

---

- **Round Switch** is only supported for **minimum** and **moderate** mode as game script 
  config-strings repopulate on match start (despite any prior clearing) which **cannot** be 
  cleared in time before overflow when using **maximum** mode due to its stump clearing incurring 
  *reliable command cycle-out* from exceeding ``129`` in a single frame.

- **Fast Restart** is only supported for **minimum** mode as config-strings persist across 
  matches which cannot be preemptively cleared for ``fast_restart`` and  thus require clearing 
  on subsequent match start in first few frames to prevent overflow, of which 
  **moderate**/**maximum** mode's usage of multiple anchors otherwise inhibits due to incurring 
  *reliable command cycle-out* from exceeding ``129`` in a single frame (unlike ``map_restart``).

- **Auto-archiving** of text elements is applied to enable rendering 62 maximum UI elements 
  simultaneously.

---

> [!IMPORTANT]
> - Documented metrics pertain to **T6Win** and vary per game and platform.  
>   E.g. CS_LOCALIZED_STRINGS limit is ``1023`` in T4/T5 instead of ``511``.
>
> - **X360**, **PS3**, **Wii U**, **Wii**, limits aren't thoroughly tested.

- CS_LOCALIZED_STRINGS limit is ``511``.

- Config-strings character limit is ``65535`` with available space being ``~41595``.   
  Exceeding this limit incurs the error: ``MAX_GAMESTAT_CHARS exceeded``.

- Text element character limit is ``255``.

- String literal character limit is ``4096``.

- String variable character limit is ``8191``.

- UI element render limit is ``62`` (``31`` unarchived, ``31`` archived).

  T6MP has 6x slots preoccupied which can be removed using:\
  ``scripts\mp\cl\cjl_core::SessionOUI_Delete()``.

  Waypoints don't contribute.

- Reliable command limit per server frame is ``128``.

- Reliable commands queued past ``64`` per server frame are subject to eviction and 
  forward-substitution based on command type priority. Variance of this behavior forces
  usage of an approximated clear threshold (``level.tstrings_clear_cap``).

  T6 config-string commands are particularly substituted more aggressively than previous games 
  (evident in engine code), enabling a stable clear threshold of ``~100`` as opposed to ``~60`` 
  used for T5/T4. Note T6 config-string command ID is ``2`` whilst T5 is ``C``/``d``.

- Config-strings are stored both server and client-side.

---

- Various platforms, gametypes, and maps push varying load-time (**``configstrings.csv``**) and 
  run-time (``mas\mp\gametypes\*.gsc``) strings to config-strings array which requires 
  accounting for.  
  e.g. T6MP TDM has: ``448/511 (63)`` whilst One Flag CTF has: ``477/511 (34)``.

- ``"MP_HALFTIME"`` is always the first config-string (T6MP/ZM).

- ``timescale`` increases can incur **reliable command overflow**. This can be accounted for by
  **dividing** ``level.ttext_clear_cap`` by ``timescale``. Note this can't be automated as 
  existing anchors can't be adjusted.

- ``setvalue()`` doesn't push to config-strings.

- ``configstrings`` command can be used to view contents of config-strings array.

- Localized strings (``&``) used with ``settext()`` are pushed to config-strings regardless of 
  whether they are precached (``precachestring()``) or previously cleared.

- Map switch clears config-strings.

- Round switch preserves config-strings.

### Config-strings Segments

<details>
<summary>Click to expand</summary>

- Various config-strings segments are subject to overflow beyond just CS_LOCALIZED_STRINGS, 
  however less common. See table bellow.

Segment                   | Index | Size    | Influencers                      | Note
--------------------------|-------|---------|----------------------------------|-----------------
CS_SYSTEM_INFO            | 0     | 1       | ---                              | ---
CS_SERVER_INFO            | 1     | 1       | ---                              | ---
CS_GAME_VERSION           | 2     | 1       | ---                              | ---
CS_SERVERID               | 3     | 1       | ---                              | ---
CS_MESSAGE                | 4     | 1       | ---                              | ---
CS_SCORES1                | 5     | 1       | ---                              | ---
CS_SCORES2                | 6     | 1       | ---                              | ---
CS_CULLDIST               | 7     | 1       | ---                              | ---
CS_SUNLIGHT               | 8     | 1       | ---                              | ---
CS_SUNDIR                 | 9     | 1       | ---                              | ---
CS_FOGVARS                | 10    | 1       | ---                              | ---
CS_MOTD                   | 11    | 1       | ---                              | ---
CS_GAMEENDTIME            | 12    | 1       | ---                              | ---
CS_MAPCENTER              | 13    | 1       | setmapcenter()                   | ---
CS_TIMESCALE              | 14    | 1       | ---                              | ---
CS_VOTE_TIME              | 15    | 1       | ---                              | ---
CS_VOTE_STRING            | 16    | 1       | ---                              | ---
CS_VOTE_YES               | 17    | 1       | ---                              | ---
CS_VOTE_NO                | 18    | 1       | ---                              | ---
CS_VOTE_MAPNAME           | 19    | 1       | ---                              | ---
CS_VOTE_GAMETYPE          | 20    | 1       | ---                              | ---
CS_MULTI_MAPWINNER        | 21    | 1       | ---                              | ---
CS_ENEMY_CROSSHAIR        | 22    | 1       | ---                              | ---
CS_CODINFO                | 23    | 149     | ---                              | Stores ``configstrings.csv`` dvars only. ``setdvar()`` has no effect.
CS_CODINFO_VALUE          | 173   | 149     | setdvar()                        | CS_CODINFO dvar values are affected only. e.g. ``"ui_motd"``.
CS_PLAYERINFOS            | 323   | 17      | ---                              | ---
CS_SESSIONNONCE           | 341   | 1       | ---                              | ---
CS_PLAYEREMBLEMS          | 342   | 17      | ---                              | ---
CS_TARGETS                | 360   | 31      | ---                              | ``.target``/``.targetname`` has no effect.
CS_USE_TRIG_STRINGS       | 392   | 95      | sethintstring()                  | ---
**CS_LOCALIZED_STRINGS**  | 488   | 511     | precachestring(), settext()      | ---
CS_CLIENTSYSTEM_NAMES     | 1000  | 8       | registerclientsys()              | ---
CS_CASE_INSENSITIVE_BEGIN | 1009  | 1       | ---                              | ---
CS_RUMBLES                | 1010  | 47      | precacherumble()                 | ---
CS_NORTHYAW               | 1058  | 1       | ---                              | ---
CS_MINIMAP                | 1059  | 1       | setminimap()                     | ---
CS_VISIONSET_NAKED        | 1060  | 1       | visionsetnaked()                 | ---
CS_VISIONSET_NIGHT        | 1061  | 1       | visionsetnight()                 | ---
CS_NIGHTVISION            | 1062  | 1       | ---                              | ---
CS_LOC_SEL_MTLS           | 1063  | 14      | precachelocationselector()       | ---
CS_MODELS                 | 1078  | 511     | precachemodel()                  | ---
CS_EFFECT_NAMES           | 1590  | 195     | loadfx()                         | ---
CS_EFFECT_TAGS            | 1786  | 255     | playfxontag()                    | ``playfxontag()`` pushes only valid tags and has duplicates per invocation.
CS_SHELLSHOCKS            | 2042  | 15      | precacheshellshock()             | ---
CS_SCRIPT_MENUS           | 2058  | 31      | precachemenu()                   | ---
CS_SERVER_MATERIALS       | 2090  | 255     | precacheshader()                 | ---
CS_WEAPONFILES            | 2346  | 255     | precacheitem(), precacheturret() | ---
CS_STATUS_ICONS           | 2602  | 7       | precachestatusicon()             | ---
CS_HEAD_ICONS             | 2610  | 14      | precacheheadicon()               | ---
CS_TAGS                   | 2625  | 63      | attach(), linkto()               | ``attach()`` pushes any tag. ``detach()`` clears tags. ``linkto()`` pushes only valid tags (e.g. ``"tag_fx"``). ``gettagorigin()`` has no effect.
CS_ITEMS                  | 2689  | 1       | ---                              | ---
CS_VEHICLE_TYPES          | 2690  | 31      | precachevehicle()                | ---
CS_DESTRUCTIBLES          | 2722  | 63      | destructibledef                  | entity key.
CS_ANIMTREES              | 2786  | 15      | ---                              | ``#using_animtree`` has no effect.
CS_VISIONSET_LASTSTAND    | 2802  | 1       | visionsetlaststand()             | ---
CS_LEADERBOARDS           | 2803  | 1       | precacheleaderboards()           | ---
CS_SESSIONINFO            | 2804  | 1       | ---                              | ---
CS_MATCHID                | 2805  | 1       | ---                              | ---

Empty influencer fields are affected by ``configstrings.csv`` only.

</details>

## Design Notes

- Invisible text elements (``.alpha = 0``) are excluded from string reapplication to preserve 
  config-string space.

- Anchors are recycled from existing config-strings instead of pushing dedicated strings as to 
  relieve slight additional config-strings space.

- Stump ``"MP_HALFTIME"`` is used as first anchor when **maximum** mode is enabled to relieve 
  slight additional config-strings space.

- ``level.ttext_mode`` is intended for setting via ``main()`` as to take precedence when 
  multiple user scripts execute ``TText_Setup()`` in nondeterministic order and prevent 
  modification after ``TText_Setup()`` which otherwise causes the game to crash.

- CS_LOCALIZED_STRINGS is never cleared immediately before map switch as the latter action invokes 
  ``~5`` reliable server commands itself which together can incur *reliable command cycle-out*.

- ``G_LocalizedStringIndex()`` is the internal function responsible for emitting string overflow 
  errors from ``settext()``/``.label``.

- ``SV_AddServerCommand()``, ``CL_CGameNeedsServerCommand()``, ``SV_ProcessClientCommands()``, 
  are the internal functions responsible for emitting reliable command errors.

- ``clearlocalizedstrings()`` is SP only.

- ``makelocalizedstring()`` is CSC only.

- ``precachestring()`` pushes config-strings only if called within first few server frames.

- ``LUA::settext()`` doesn't affect config-strings.

- ``settext()`` second parameter used for appendages is ignored as string concatenation can
  be used instead.

- UI element archiving (``.archived``) is primarily intended for toggling spectated player
  HUD-elem visibility during killcam/spectator/codcaster but can be used to render an additional 
  ``31`` elements concurrently as they occupy a separate memory store.

- Mismatching text element strings is caused by unorderly reapplication of strings in which
  they continue to point to the same config-strings index after being replaced by a different 
  string.

- T5ZM ``level.chalk_hud2`` text element is deleted as it otherwise brokenly appears when 
  clearing config-strings due to being pushed shortly after first anchor is established.

- MP and ZM script variants are provided due to varying string limits, game script functions,
  and for maximum compactness.

- Note previous "string overflow fix" scripts used gratuitous polling threads for counting
  strings which has been replaced here with an improved *"inline evaluation"* paradigm.

- Idea of otherwise having maximum/moderate mode support fast restart by clearing anchors across 
  frames on match start is infeasible as it takes too long to complete before text elements are 
  created. E.g. ``(1023 / 60) = 18 frames``.

- Idea of otherwise using ``autoexec`` calling convention to alleviate user scripts from calling 
  ``TText_Setup()`` is infeasible as such breaks backwards compatibility with clients/games 
  which don't support said feature.

- Script is library independent.

## Credits

Name                         | Contribution                                              | Date       | Reference
-----------------------------|-----------------------------------------------------------|------------|-----------
cooljay                      | Refinement                                                | 2026:06:09 | ---
xeirh                        | Testing                                                   | 2026       | ---
treminaor                    | Additional influencers discovery                          | 2024:02:04 | https://wiki.ugx-mods.com/Modding/World-at-War-Modtools/Script/G_FindConfigstringIndex-overflow.html \ https://github.com/UGX-Mods/community-wiki/blob/main/Modding/World-at-War-Modtools/Script/G_FindConfigstringIndex-overflow.html
EternalHabit/xTurntUpLobbies | Rendition                                                 | 2016:07:13 | https://nextgenupdate.com/forums/black-ops-2-gsc-mods-scripts/916615-gsc-resources.html
Serious                      | Unique string counter, string anchors, round switch clear | 2016:07:07 | https://nextgenupdate.com/forums/black-ops-2-gsc-mods-scripts/915525-overflow-fix-cooljay-black-ops-iiutility-1.html#post7034281 \ https://nextgenupdate.com/forums/black-ops-2-gsc-mods-scripts/1019588-overflow-fix-tutorial-explanation-gsx.html
SyGnUs                       | String patching _rank.gsc                                 | 2015:03:08 | https://nextgenupdate.com/forums/black-ops-2-gsc-mods-scripts/805370-releasehow-gain-170-unique-strings-settext-use.html
Im_YouViolateMe              | Rendition                                                 | 2015:03:08 | https://nextgenupdate.com/forums/black-ops-2-gsc-mods-scripts/805379-noob-friendly-tut-how-add-overflow-prevention-your-mod-menu.html
jwm614                       | Rendition                                                 | 2015:01:04 | https://nextgenupdate.com/forums/black-ops-2-gsc-mods-scripts/791634-release-jwm614-skybasefireballspet-chopperoverflow-fixbunkerstunt-plane.html
TheFallen                    | String reapplication                                      | 2014:11:02 | https://nextgenupdate.com/forums/black-ops-2-gsc-mods-scripts/775971-overflow-fix.html
Jake625                      | String patching configstrings_x.csv                       | 2013:08:09 | https://nextgenupdate.com/forums/modern-warfare-2-mods-patches-tutorials/676708-mw2-never-overflow-gsc.html
Correy                       | String counter                                            | 2012:02:07 | https://nextgenupdate.com/forums/call-duty-4-modern-warfare/520110-release-string-check-prevents-future-overflows-2.html
teh1337                      | clearalltextafterhudelem() discovery                      | 2011:12:23 | https://nextgenupdate.com/forums/call-duty-4-modern-warfare/500399-release-how-not-string-overflow-3.html
Amanda                       | String patching _rank.gsc, unique string discovery        | 2011:10:04 | https://nextgenupdate.com/forums/call-duty-4-modern-warfare/467330-iresets-private-patch-v1-preview-2.html#post3830598 \ https://nextgenupdate.com/forums/call-duty-4-modern-warfare/522695-sacrifice-gsc-save-up-263-unique-strings-6.html#post4238127
Karoolus                     | String patching _rank.gsc                                 | 2011:07:24 | https://nextgenupdate.com/forums/call-duty-4-modern-warfare/434156-preview-karoolus-monster-cod4-patch-includes-beta-download-need-recorder-28.html