Scriptname UNSC:BR55:BurstFire extends ObjectReference
{Attaches to: BR55 "BR55" [WEAP:000017A3]}
import UNSC:Papyrus

;/
Don't try to check for throwing happening, detect shooting happening instead.
Cache the value of the player's current supply of ammo, and check to see if it decreased by 1 before doing the rest of the burst.
/;

Actor Player
Weapon this

; Ammunition
int Count = 0
int Amount = 0
int Capacity = 0

; Firing
int Burst = 0
int BurstSize = 3 const
float BurstDelay = 0.1 const
string FiringState = "Firing" const

; Biped Slots
int BipedWeapon = 41 const

; Animation Events
string WeaponFire = "weaponFire" const
string ReloadComplete = "reloadComplete" const


; Events
;---------------------------------------------

Event OnInit()
	this = self.GetBaseObject() as Weapon
	If (this)
		WriteLine(self, "OnInit")
	Else
		WriteUnexpectedValue(self, "OnInit", "this", "The script must be attached to a Weapon type.")
	EndIf
EndEvent


Event OnEquipped(Actor akActor)
	Player = akActor
	Capacity = GetAmmoCapacity()
	Amount = GetAmmoAmount()
	Count = GetAmmoCount()
	;---------------------------------------------
	RegisterForAnimationEvent(Player, WeaponFire)
	RegisterForAnimationEvent(Player, ReloadComplete)
	WriteLine(self, "OnEquipped", Player+" equipped: "+ToString())
EndEvent


Event OnUnequipped(Actor akActor)
	ClearState(self)
	;---------------------------------------------
	UnregisterForAnimationEvent(Player, WeaponFire)
	UnregisterForAnimationEvent(Player, ReloadComplete)
	WriteLine(self, "OnUnequipped", Player+" unequipped: "+ToString())
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	If (asEventName == WeaponFire)
		If (GetAmmoCount() < Count)
			OnFired()
			Count = GetAmmoCount()
		Else
			WriteLine(self, "OnAnimationEvent", "Ignoring the '"+asEventName+"' animation event.")
		EndIf
	ElseIf (asEventName == ReloadComplete)
		OnReloaded()
	Else
		WriteLine(self, "OnAnimationEvent", "The animation event '"+asEventName+"' was unhandled.")
	EndIf
EndEvent


; Methods
;---------------------------------------------

Function OnFired()
	ChangeState(self, FiringState)
EndFunction


Function OnReloaded()
	Burst = 0
	Amount = GetAmmoAmount()
	WriteLine(self, "OnReloaded", ToString())
EndFunction


; Functions
;---------------------------------------------

int Function GetAmmoAmount()
	int iCount = GetAmmoCount()
	If (iCount < Capacity)
		return iCount
	Else
		return Capacity
	EndIf
EndFunction


int Function GetAmmoCount()
	InstanceData:Owner instance = this.GetInstanceOwner()
	Ammo ammoType = InstanceData.GetAmmo(instance)
	return Player.GetItemCount(ammoType)
EndFunction


int Function GetAmmoCapacity()
	ObjectMod[] array = Player.GetWornItemMods(BipedWeapon)
	If (array)
		int index = 0
		While (index < array.Length)
			ObjectMod omod = array[index]
			ObjectMod:PropertyModifier[] properties = omod.GetPropertyModifiers()
			int found = properties.FindStruct("target", omod.Weapon_Target_iAmmoCapacity)
			If (found > -1)
				return properties[found].value1 as int
			EndIf
			index += 1
		EndWhile
	EndIf
	InstanceData:Owner instance = this.GetInstanceOwner()
	return InstanceData.GetAmmoCapacity(instance)
EndFunction


string Function ToString()
	return "("+Amount+"/"+Capacity+"), Count:"+Count+", Burst:"+Burst
EndFunction


; States
;---------------------------------------------

State Firing
	Event OnBeginState(string asOldState)
		WriteLine(self, "Firing.OnBeginState", ToString())
		OnFired()
	EndEvent

	Function OnFired()
		Amount -= 1
		Burst += 1
		If (Burst <= BurstSize)
			WriteLine(self, "Firing.OnFired", ToString())
			Utility.Wait(BurstDelay)
			Player.PlayIdle(WeaponFireIdle)
			Utility.Wait(BurstDelay)
		Else
			ClearState(self)
		EndIf
	EndFunction

	Event OnEndState(string asNewState)
		Burst = 0
		WriteLine(self, "Firing.OnEndState", ToString())
	EndEvent
EndState


; Properties
;---------------------------------------------

Group Properties
	Idle Property WeaponFireIdle Auto Const Mandatory
EndGroup
