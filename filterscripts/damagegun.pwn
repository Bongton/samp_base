// realistischer Waffenschaden 
// Da ich keins Fand habe ich mir selbst eins Gescriptet
// und habe dabei das include OnPlayerShootPlayer genutzt.
#define FILTERSCRIPT
#define COLT45_DAMAGE 15.0
#define PISTOL_DAMAGE 35.0
#define DESERT_EAGLE_DAMAGE 100.0
#define SHOTGUN_DAMAGE 60.0
#define SNIPER_DAMAGE 100.0
#define MICRO_SMG_DAMAGE 25.0
#define AK47_DAMAGE 30.0
forward tot();
#include <a_samp>
#include <OPSP> //man braucht das addon OnPlayerShootPlayer
#if defined FILTERSCRIPT


public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	
}

#endif

public OnPlayerShootPlayer(shooter,target,Float:damage)
{
	if(GetPlayerWeapon(shooter)  == 24){ //deagle
		new Float:armour;
		GetPlayerArmour(target,armour);
		new Float:health;
		GetPlayerHealth(target,health);
		if(armour == 0)
		{
			SetPlayerHealth(target,health+damage-DESERT_EAGLE_DAMAGE); //schaden den Deagle  abzieht
		}
		else
		{
			SetPlayerArmour(target,health+damage-DESERT_EAGLE_DAMAGE); //schaden den Deagle  abzieht
		}
}


if(GetPlayerWeapon(shooter) == 29 || 31 || 30){ //ak,m4.smg
new Float:armour;
GetPlayerArmour(target,armour);
new Float:health;
GetPlayerHealth(target,health);
if(armour == 0){
SetPlayerHealth(target,health+damage-AK47_DAMAGE); //schaden den M4/Ak-47  abzieht
}
else{
SetPlayerArmour(target,armour+damage-AK47_DAMAGE); //schaden den M4/Ak-47  abzieht
}
}

if(GetPlayerWeapon(shooter) == 28 || 32 ){ //micro_smg,tec9
new Float:armour;
GetPlayerArmour(target,armour);
new Float:health;
GetPlayerHealth(target,health);
if(armour == 0){
SetPlayerHealth(target,health+damage-MICRO_SMG_DAMAGE); //schaden den tec9,micro smg  abzieht
}
else{
SetPlayerArmour(target,armour+damage-MICRO_SMG_DAMAGE); //schaden den tec9,micro smg  abzieht
}
}

if(GetPlayerWeapon(shooter) == 33 || 34 ){ //sniper , rifle
new Float:armour;
GetPlayerArmour(target,armour);
new Float:health;
GetPlayerHealth(target,health);
if(armour == 0){
SetPlayerHealth(target,health+damage-SNIPER_DAMAGE); //schaden den sniper, rifle  abzieht
}
else{
SetPlayerArmour(target,armour+damage-SNIPER_DAMAGE); //schaden den sniper, rifle  abzieht
}
}

if(GetPlayerWeapon(shooter) == 25 || 27 || 26){ //shotgun
new Float:armour;
GetPlayerArmour(target,armour);
new Float:health;
GetPlayerHealth(target,health);
if(armour == 0){
SetPlayerHealth(target,health+damage-SHOTGUN_DAMAGE); //schaden den shotguns  abziehen
}
else{
SetPlayerArmour(target,armour+damage-SHOTGUN_DAMAGE); //schaden den shotguns  abziehen
}
}

if(GetPlayerWeapon(shooter) == 22  ){ //pistol [9mm]
new Float:armour;
GetPlayerArmour(target,armour);
new Float:health;
GetPlayerHealth(target,health);
if(armour == 0){
SetPlayerHealth(target,health+damage-COLT45_DAMAGE); //schaden den 9mm  abzieht
}
else{
SetPlayerArmour(target,armour+damage-COLT45_DAMAGE); //schaden den 9mm  abzieht
}
}

if(GetPlayerWeapon(shooter) == 23  ){ //silenced
new Float:armour;
GetPlayerArmour(target,armour);
new Float:health;
GetPlayerHealth(target,health);
if(armour == 0){
SetPlayerHealth(target,health+damage-PISTOL_DAMAGE); //schaden den silenced  abzieht
}
else{
SetPlayerArmour(target,armour+damage-PISTOL_DAMAGE); //schaden den silenced  abzieht
}
}

else{

}
}

public OnPlayerUpdate(playerid)
{
	return 1;
}
public tot(){
for(new playerid=0; playerid<MAX_PLAYERS; playerid++) {
if(IsPlayerConnected(playerid)) {
new Float:health;
GetPlayerHealth(playerid,health);
if(health <20)
{
if (GetPlayerState(playerid)== 1)
{
ApplyAnimation(playerid,"CRACK", "crckdeth2", 1.800001, 1, 0, 0, 1, 600);
}
}
}
}
}
