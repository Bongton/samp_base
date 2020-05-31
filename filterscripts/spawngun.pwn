//Weapon  Menu-David Sean
#include <a_samp>

new Menu:weaponmenu;
new Menu:weaponmenu2;

#define LIGHT_BLUE 0x33CCFFAA

public OnFilterScriptInit()
{

	weaponmenu = CreateMenu("Weapon Menu", 1, 220.0, 100.0, 150.0, 150.0);
	AddMenuItem(weaponmenu, 0, "9mm Weapon");
	AddMenuItem(weaponmenu, 0, "Silenced 9mm Weapon");
	AddMenuItem(weaponmenu, 0, "Desert Eagle Weapon");
	AddMenuItem(weaponmenu, 0, "Shotgun Weapon");
	AddMenuItem(weaponmenu, 0, "Sawnoff Shotgun Weapon");
	AddMenuItem(weaponmenu, 0, "Combat Shotgun Weapon");
	AddMenuItem(weaponmenu, 0, "Micro SMG (Uzi)Weapon");
	AddMenuItem(weaponmenu, 0, "SMG (MP5) Weapon");
	AddMenuItem(weaponmenu, 0, "AK47 (Kalashnikov)Weapon");
	AddMenuItem(weaponmenu, 0, "M4 Weapon");
	AddMenuItem(weaponmenu, 0, "Tec9 Weapon");
	AddMenuItem(weaponmenu, 0, "Next Page Weapon");

	weaponmenu2 = CreateMenu("Weapon Menu", 1, 220.0, 100.0, 150.0, 150.0);
	AddMenuItem(weaponmenu2, 0, "Country Rifle Weapon");
	AddMenuItem(weaponmenu2, 0, "Sniper Rifle Weapon");
	AddMenuItem(weaponmenu2, 0, "Minigun Weapon");
	AddMenuItem(weaponmenu2, 0, "Rocket Launcher Weapon");
	AddMenuItem(weaponmenu2, 0, "HS Rocket Launcher Weapon");
	AddMenuItem(weaponmenu2, 0, "Flamethrower Weapon");
	AddMenuItem(weaponmenu2, 0, "Tear Gas Weapon");
	AddMenuItem(weaponmenu2, 0, "Gernade Weapon");
	AddMenuItem(weaponmenu2, 0, "Molotov Cocktail Weapon");
	AddMenuItem(weaponmenu2, 0, "Chainsaw Weapon");
	AddMenuItem(weaponmenu2, 0, "Previous Page");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	SendClientMessage(playerid, LIGHT_BLUE, "พิม /gunshop เพื่อเสกปืน.");
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp(cmdtext, "/gunshop", true) == 0)
	{
    	ShowMenuForPlayer(weaponmenu, playerid);
    	return 1;
	}
	return 0;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:CurrentMenu = GetPlayerMenu(playerid);
	if(CurrentMenu == weaponmenu)
	{
    	switch(row)
    	{
	        case 0: //9mm
	        {
	            GivePlayerWeapon(playerid, 22 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your 9mm!");
	        }
	        case 1: //Silenced 9mm
	        {
	            GivePlayerWeapon(playerid, 23 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Silenced 9mm!");
	        }
	        case 2: //Desert Eagle
	        {
	            GivePlayerWeapon(playerid, 24 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Desert Eagle!");
	        }
	        case 3: //Shotgun
	        {
	            GivePlayerWeapon(playerid, 25 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Shotgun!!");
	        }
	        case 4: //Sawnoff Shotgun
	        {
	            GivePlayerWeapon(playerid, 26 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Sawnoff Shotgun!");
	        }
	        case 5: //Combat Shotgun
	        {
	            GivePlayerWeapon(playerid, 27 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Combat Shotgun!");
			}
	        case 6: //Micro SMG (Uzi)
	        {
	            GivePlayerWeapon(playerid, 28 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Micro SMG (Uzi)!");
			}
	        case 7: //SMG (MP5)
	        {
	            GivePlayerWeapon(playerid, 29 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your SMG (MP5)!");
			}
			case 8: //AK47 (Kalashnikov)
	        {
	            GivePlayerWeapon(playerid, 30 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your AK47 !");
			}
	        case 9: //M4
	        {
	            GivePlayerWeapon(playerid, 31 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your M4!");
	        }
	        case 10: //Tec9
	        {
	            GivePlayerWeapon(playerid, 32 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Tec9!");
	        }
	        case 11: //Next Page
	        {
				HideMenuForPlayer(weaponmenu,playerid);
				ShowMenuForPlayer(weaponmenu2,playerid);
	        }
        }
	}
	else if(CurrentMenu == weaponmenu2)
	{
    	switch(row)
    	{
    		case 0: //Sniper Rifle
	        {
	            GivePlayerWeapon(playerid, 34 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Sniper Rifle!");
	        }
	        case 1: //Minigun
	        {
	            GivePlayerWeapon(playerid, 38 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Minigun!");
				return 1;
			}
   			case 2: //Country Rifle
	        {
	            GivePlayerWeapon(playerid, 33 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Country Rifle!");
	        }
   			case 3: //Rocket Launcher
	        {
	            GivePlayerWeapon(playerid, 35 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Rocket Launcher!");
	        }
   			case 4: //HS Rocket Launcher
	        {
	            GivePlayerWeapon(playerid, 36 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your HS Rocket Launcher!");
	        }
   			case 5: //Flame Thrower
	        {
	            GivePlayerWeapon(playerid, 37 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Flamethrower!");
	        }
   			case 6: //Tear Gas
	        {
	            GivePlayerWeapon(playerid, 17 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Tear Gas!");
	        }
   			case 7: //Gernade
	        {
	            GivePlayerWeapon(playerid, 16 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Gernades!");
	        }
   			case 8: //Molotov Cocktail
	        {
	            GivePlayerWeapon(playerid, 18 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Molotov Cocktails!");
	        }
   			case 9: //Chainsaw
	        {
	            GivePlayerWeapon(playerid, 9 , 500);
	            SendClientMessage(playerid, LIGHT_BLUE, "Enjoy your Chainsaw!");
	        }
   			case 10: //Previous Page
	        {
				HideMenuForPlayer(weaponmenu2,playerid);
				ShowMenuForPlayer(weaponmenu,playerid);
	        }
        }
	}
	return 1;
}
