-- This addon was formerly known as InterruptBar or Juked by Robrman (https://mods.curse.com/members/robrman)

--CHANGELOG:
-- Starting from scratch v1.0


spell_table = {
--Interrupts and Silences
{spellID=6552, time=15, prio=true},--Pummel - 7.2 updated
{spellID=183752, time=15, prio=true},--Consume Magic DH - 7.2 updated
{spellID=23920, time=25, prio=false},--Spell Reflection - 7.2 updated
{spellID=1766, time=15, prio=true},--Kick  - 7.2 updated
{spellID=47528, time=15, prio=true},--Mind Freeze - 7.2 updated
{spellID=47476, time=60, prio=false},--Strangulate - 7.2 updated
{spellID=96231, time=15, prio=true},--Rebuke - 7.2 updated
{spellID=215652, time=30, prio=true},--Shield of Virtue - 7.2 updated
{spellID=57994, time=12, prio=true},--Wind Shear - 7.2 updated
{spellID=2139, time=24, prio=true},--Counterspell - 7.2 updated
{spellID=171138, time=24, prio=true},--Shadow Lock Pet Doomguard - 7.2 updated
{spellID=19647, time=24, prio=true},--Spell Lock - 7.2 updated
{spellID=119911, time=24, prio=true},--Optical Blast - 7.2 updated
{spellID=106839, time=15, prio=true},--Skull Bash - 7.2 updated
{spellID=78675, time=60, prio=true},--Solar Bream - 7.2 updated
{spellID=116705, time=15, prio=true},--Spear Hand Strike - 7.2 updated
{spellID=15487, time=45, prio=true},--Silence - 7.2 updated
{spellID=147362, time=24, prio=true},--Counter Shot - 7.2 updated

--Gap Closers
{spellID=49576, time=25, prio=false},--Death Grip - 7.2 updated
{spellID=36554, time=30, prio=false},--Shadowstep - 7.2 updated

--CC
{spellID=51514, time=30, prio=true},--Hex - 7.2 updated
{spellID=211004, time=30, prio=false},--spooder - 7.2 updated
{spellID=211010, time=30, prio=false},--snake - 7.2 updated
{spellID=210873, time=30, prio=false},--compy - 7.2 updated
{spellID=211015, time=30, prio=false},--cockroach - 7.2 updated
{spellID=113724, time=45, prio=false},--Ring of Frost - 7.2 Updated
{spellID=213691, time=30, prio=false},--Scatter Shot | Honor talent | - 7.2 Updated
{spellID=187650, time=30, prio=true},--Freezing trap - 7.2 Updated
{spellID=2094, time=120, prio=true},--Blind - 7.2 Updated
{spellID=5246, time=90, prio=false},--Intimidating Shout - 7.2 Updated

{spellID=46968, time=40, prio=false},--Shockwave - 7.2 Updated
{spellID=118000, time=25, prio=false},--Dragon Roar  - 7.2 Updated
{spellID=5484, time=40, prio=false},--Howl of Terror - 7.2 Updated
{spellID=6789, time=45, prio=false},--Mortal Coil - 7.2 Updated
{spellID=30283, time=30, prio=false},--Shadowfury - 7.2 Updated

{spellID=211522, time=45, prio=false},--Psyfiend | Honor talent | - 7.2 Updated
{spellID=8122, time=30, prio=false},--Psychic Scream - 7.2 Updated
{spellID=20066, time=15, prio=false},--Repentance - 7.2 Updated
{spellID=853, time=60, prio=false},--Hammer of Justice - 7.2 Updated
{spellID=115750, time=90, prio=false},--Blinding Light - 7.2 Updated
{spellID=108194, time=45, prio=false},--Asphyxiate - 7.2 Updated
{spellID=102359, time=30, prio=false},--Mass Entanglement - 7.2 Updated
{spellID=5211, time=50, prio=false},--Mighty Bash - 7.2 Updated
{spellID=99, time=30, prio=false},--Incapacitated roar - 7.2 Updated
{spellID=102793, time=60, prio=false},--Ursol's Vortex - 7.2 Updated
{spellID=115078, time=15, prio=false},--Paralysis - 7.2 Updated
{spellID=233759, time=60, prio=false},--Grapple Weapon - 7.2 Updated

--Defensive
{spellID=31224, time=90, prio=true},--Cloak of Shadows - 7.2 Updated
{spellID=74001, time=120, prio=false},--Combat Readiness - 7.2 Updated
{spellID=47585, time=120, prio=true},--Dispersion - 7.2 Updated
{spellID=108698, time=300, prio=false},--Void Shift | Honor talent | - 7.2 Updated
{spellID=33206, time=240, prio=false},--Pain Suppression - 7.2 Updated
{spellID=48707, time=60, prio=true},--Anti-Magic Shell - 7.2 Updated
{spellID=51052, time=120, prio=false},--Anti-Magic Zone | Honor talent | - 7.2 Updated
{spellID=48792, time=180, prio=true},--Icebound Fortitude - 7.2 Updated
{spellID=642, time=300, prio=true},--Divine Shield - 7.2 Updated
{spellID=19263, time=180, prio=false},--Deterrence - 7.2 Updated
{spellID=109304, time=120, prio=false},--Exhilaration - 7.2 Updated
{spellID=48020, time=30, prio=false},--Demonic Circle: Teleport - 7.2 Updated
{spellID=104773, time=180, prio=false},--Unending Resolve - 7.2 Updated
{spellID=108416, time=60, prio=false},--Dark pact - 7.2 Updated
{spellID=22812, time=60, prio=false},--Barkskin - 7.2 Updated
{spellID=102342, time=90, prio=false},--Ironbark - 7.2 Updated
{spellID=61336, time=180, prio=false},--Survival Instincts - 7.2 Updated
{spellID=108238, time=90, prio=false},--Renewal - 7.2 Updated
{spellID=45438, time=240, prio=false},--Ice Block - 7.2 Updated
{spellID=98008, time=180, prio=false},--Spirit Link Totem - 7.2 Updated
{spellID=108271, time=90, prio=false},--Astral Shift - 7.2 Updated
{spellID=108280, time=180, prio=false},--Healing Tide Totem - 7.2 Updated
{spellID=118038, time=180, prio=false},--Die By The Sword - 7.2 Updated
{spellID=871, time=240, prio=false},--Shield Wall - 7.2 Updated
{spellID=115203, time=420, prio=false},--Fortifying Brew TANK - 7.2 Updated
{spellID=243435, time=90, prio=false},--Fortifying Brew | Honor talent | - 7.2 Updated
{spellID=115176, time=300, prio=false},--Zen Meditation - 7.2 Updated


--Offensive
{spellID=46924, time=90, prio=false},--Bladestorm - 7.2 Updated
{spellID=12292, time=30, prio=false},--Bloodbath - 7.2 Updated
{spellID=107574, time=90, prio=false},--Avatar - 7.2 Updated
{spellID=185313, time=60, prio=false},--Shadow Dance - 7.2 Updated
{spellID=137619, time=60, prio=false},--Marked for Death - 7.2 Updated
{spellID=121471, time=180, prio=false},--Shadow Blades - 7.2 Updated
{spellID=51271, time=60, prio=false},--Pillar of Frost - 7.2 Updated
{spellID=31884, time=120, prio=false},--Avenging Wrath |Protection & Retri| - 7.2 Updated
{spellID=31842, time=120, prio=false},--Avenging Wrath |Holy| - 7.2 Updated
{spellID=105809, time=90, prio=false},--Holy Avenger - 7.2 Updated
{spellID=106951, time=180, prio=false},--Berserk - 7.2 Updated
{spellID=16166, time=120, prio=false},--Elemental Mastery - 7.2 Updated
{spellID=201430, time=180, prio=false},--Stampede - 7.2 Updated
{spellID=19574, time=90, prio=false},--Bestial Wrath - 7.2 Updated

--Other
{spellID=29166, time=180, prio=false},--Innervate - 7.2 Updated
{spellID=1856, time=120, prio=false},--Vanish  - 7.2 Updated
{spellID=102280, time=30, prio=false},--Displacer Beast - 7.2 Updated
{spellID=77606, time=25, prio=false},--Dark Simulacrum - 7.2 Updated
{spellID=18499, time=60, prio=false},--Berserker Rage - 7.2 Updated
{spellID=235219, time=300, prio=false},--Cold Snap - 7.2 Updated
{spellID=204336, time=30, prio=false},--Grounding Totem | Honor talent | - 7.2 Updated
{spellID=212182, time=180, prio=false},--Smoke Bomb | Honor talent | - 7.2 Updated
{spellID=114018, time=360, prio=false},--Shroud of Concealment - 7.2 Updated
}
