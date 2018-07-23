Scriptname UNSC_Test:Setup extends Quest

Actor Player
bool Silent = true const

; Events
;---------------------------------------------

Event OnInit()
	Player = Game.GetPlayer()
EndEvent


Event OnQuestInit()
	Try(Fallout4, Ammo308Caliber, 600)
	Try(Fallout4, Ammo556, 600)
	Try(UNSCArmoryWeapons, MA5D)
	Try(UNSCArmoryWeapons, MA5H)
	Try(UNSCArmoryWeapons, MA5K)
	Try(UNSCArmoryWeapons, BR55)
	Try(UNSCArmoryWeapons, BR85N)
	Try(UNSCArmoryWeapons, M20SMG)
	Try(UNSCArmoryWeapons, M247H)
	Try(UNSCArmoryWeapons, M319)
	Try(UNSCArmoryWeapons, M45D)
	Try(UNSCArmoryWeapons, M57Pilum)
	Try(UNSCArmoryWeapons, M6HMagnum)
	Try(UNSCArmoryWeapons, M739SAW)
	Try(UNSCArmoryWeapons, M9fragGrenade, 20)
	Try(UNSCArmoryWeapons, MA37)
	Try(UNSCArmoryWeapons, SRS99)
	Try(UNSCArmoryWeapons, SRS99Reach)
	Try(UNSCArmoryWeapons, M392DMR)
	Try(UNSCArmoryWeapons, Ammo5X23mm, 600)
	Try(UNSCArmoryWeapons, Ammo762NATO, 600)
	Try(UNSCArmoryWeapons, Ammo95, 600)
	Try(UNSCArmoryWeapons, Ammo145mm, 600)
	Try(UNSCArmoryWeapons, Ammo50CalM6H, 600)
	Try(UNSCArmoryWeapons, Ammo40MM, 600)
EndEvent


; Functions
;---------------------------------------------

Function Try(string plugin, int formID, int amount = 1)
	If (Game.IsPluginInstalled(plugin))
		Form item = Game.GetFormFromFile(formID, plugin)
		If (item)
			Player.AddItem(item, amount, Silent)
		EndIf
	EndIf
EndFunction


; Properties
;---------------------------------------------

Group Vanilla
	string Property Fallout4 = "Fallout4.esm" AutoReadOnly
	{The Fallout 4 master data file.}

	int Property Ammo308Caliber = 0x0001F66B AutoReadOnly
	{Ammo308Caliber ".308 Round" [AMMO:0001F66B]}

	int Property Ammo556 = 0x0001F278 AutoReadOnly
	{Ammo556 "5.56 Round" [AMMO:0001F278]}
EndGroup

Group UNSC
	string Property UNSCArmoryWeapons = "UNSCArmoryWeapons.esp" AutoReadOnly
	{The UNSC data file.}

	int Property MA5D = 0x000017A0 AutoReadOnly
	{MA5D "MA5D" [WEAP:000017A0]}

	int Property MA5H = 0x000017A1 AutoReadOnly
	{MA5H "MA5H" [WEAP:000017A1]}

	int Property MA5K = 0x000017A2 AutoReadOnly
	{MA5K "MA5K" [WEAP:000017A2]}

	int Property BR55 = 0x000017A3 AutoReadOnly
	{BR55 "BR55" [WEAP:000017A3]}

	int Property BR85N = 0x000017A4 AutoReadOnly
	{BR85N "BR85N" [WEAP:000017A4]}

	int Property M20SMG = 0x000017A5 AutoReadOnly
	{M20SMG "M20 SMG" [WEAP:000017A5]}

	int Property M247H = 0x000017A6 AutoReadOnly
	{M247H "M247H" [WEAP:000017A6]}

	int Property M319 = 0x000017A7 AutoReadOnly
	{M319 "M319 Genade Launcher" [WEAP:000017A7]}

	int Property M45D = 0x000017A8 AutoReadOnly
	{M45D "M45D" [WEAP:000017A8]}

	int Property M57Pilum = 0x000017A9 AutoReadOnly
	{M57Pilum "M57 Pilum" [WEAP:000017A9]}

	int Property M6HMagnum = 0x000017AA AutoReadOnly
	{M6HMagnum "M6H Magnum" [WEAP:000017AA]}

	int Property M739SAW = 0x000017AC AutoReadOnly
	{M739SAW "M739 SAW" [WEAP:000017AC]}

	int Property M9fragGrenade = 0x000017AD AutoReadOnly
	{M9fragGrenade "M9 Frag Grenade" [WEAP:000017AD]}

	int Property MA37 = 0x000017AE AutoReadOnly
	{MA37 "MA37" [WEAP:000017AE]}

	int Property SRS99 = 0x000017B2 AutoReadOnly
	{SRS99 "SRS99" [WEAP:000017B2]}

	int Property SRS99Reach = 0x000017B3 AutoReadOnly
	{SRS99Reach "SRS99  Reach" [WEAP:000017B3]}

	int Property M392DMR = 0x00002797 AutoReadOnly
	{M392DMR "M392 DMR" [WEAP:00002797]}

	int Property Ammo5X23mm = 0x00001FDC AutoReadOnly
	{Ammo5X23mm "5X23mm" [AMMO:00001FDC]}

	int Property Ammo762NATO = 0x00002029 AutoReadOnly
	{Ammo762NATO "7.62X51 NATO" [AMMO:00002029]}

	int Property Ammo95 = 0x0000202A AutoReadOnly
	{Ammo95 "9.5×40mm" [AMMO:0000202A]}

	int Property Ammo145mm = 0x0000202B AutoReadOnly
	{Ammo145mm "14.5×114mm" [AMMO:0000202B]}

	int Property Ammo50CalM6H = 0x0000202C AutoReadOnly
	{Ammo50CalM6H "12.7X40MM" [AMMO:0000202C]}

	int Property Ammo40MM = 0x000046AF AutoReadOnly
	{Ammo40MM "40MM" [AMMO:000046AF]}
EndGroup
