Scriptname UNSC:BR55:BurstFire extends ObjectReference
{Attaches to: BR55 "BR55" [WEAP:000017A3]}
import UNSC:Papyrus

Actor Player
Weapon this

; Ammunition
int Count = 0
int Capacity = 0

; Firing
int Burst = 0
int BurstSize = 3 const
string FiringState = "Firing" const
string ThrowingState = "Throwing" const
string MeleeControl = "Melee" const

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
	Count = GetAmmoAmount()
	RegisterForControl(MeleeControl)
	RegisterForAnimationEvent(Player, WeaponFire)
	RegisterForAnimationEvent(Player, ReloadComplete)
	WriteLine(self, "OnEquipped", Player+" equipped: "+ToString())
EndEvent


Event OnUnequipped(Actor akActor)
	ClearState(self)
	UnregisterForControl(MeleeControl)
	UnregisterForAnimationEvent(Player, WeaponFire)
	UnregisterForAnimationEvent(Player, ReloadComplete)
	WriteLine(self, "OnUnequipped", Player+" unequipped: "+ToString())
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	If (asEventName == WeaponFire)
		OnFired()
	ElseIf (asEventName == ReloadComplete)
		OnReloaded()
	Else
		WriteLine(self, "OnAnimationEvent", "The animation event '"+asEventName+"' was unhandled.")
	EndIf
EndEvent


Event OnControlDown(string asControlName)
	ChangeState(self, ThrowingState)
EndEvent


; Methods
;---------------------------------------------

Function OnFired()
	ChangeState(self, FiringState)
EndFunction


Function OnReloaded()
	Count = GetAmmoAmount()
	WriteLine(self, "Reloaded", ToString())
EndFunction


; Functions
;---------------------------------------------

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


int Function GetAmmoAmount()
	InstanceData:Owner instance = this.GetInstanceOwner()
	Ammo ammoType = InstanceData.GetAmmo(instance)
	int ammoAmount = Player.GetItemCount(ammoType)
	If (ammoAmount < Capacity)
		return ammoAmount
	Else
		return Capacity
	EndIf
EndFunction


string Function ToString()
	return "Ammo ("+Count+"/"+Capacity+"), Burst:"+Burst
EndFunction


; States
;---------------------------------------------

State Firing
	Event OnBeginState(string asOldState)
		WriteLine(self, "Firing.OnBeginState", ToString())
		OnFired()
	EndEvent

	Function OnFired()
		Count -= 1
		Burst += 1

		WriteLine(self, "Fired", ToString())

		If (Burst <= BurstSize)
			Utility.Wait(4.0)
			this.Fire(Player) ; invokes the animation event
		Else
			ClearState(self)
		EndIf
	EndFunction

	Event OnEndState(string asNewState)
		Burst = 0
		WriteLine(self, "Firing.OnEndState", ToString())
	EndEvent
EndState


State Throwing
	Event OnBeginState(string asOldState)
		WriteLine(self, "Throwing.OnEndState")
	EndEvent

	Function OnFired()
		ClearState(self)
	EndFunction

	Event OnEndState(string asNewState)
		WriteLine(self, "Throwing.OnEndState", ToString())
	EndEvent
EndState
