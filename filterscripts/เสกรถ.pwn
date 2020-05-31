/*
Simple Vehicle Spawn and Destroy by WarriorEd22
*/

#include <a_samp>
#include <zcmd>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print("Simple Vehicle Spawn and Destroy by WarriorEd22");
	print("--------------------------------------\n");
	return 1;
}

//Commands / Spawn Vehicles
COMMAND:v(playerid, params[])
{
	#if USE_ADMIN == true
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, C_RED, "This command will be added to this server soon. For now, try /cmds . ");
	#endif
	new Vehicle[50];
	if(!sscanf(params, "s[50]", Vehicle))
	{
		new string[128], Float:Pos[4];
		GetPlayerPos(playerid, Pos[0],Pos[1],Pos[2]); GetPlayerFacingAngle(playerid, Pos[3]);
		new veh = GetVehicleModelID(Vehicle);
		if(veh < 400 || veh > 611) return SendClientMessage(playerid, C_RED, "This is not a valid vehicle name! Please try again ");
		if(IsPlayerInAnyVehicle(playerid)) { DestroyVehicle(GetPlayerVehicleID(playerid)); }
		GetXYInFrontOfPlayer(playerid, Pos[0], Pos[1], 5);
		new PVeh = CreateVehicle(veh, Pos[0], Pos[1], Pos[2], Pos[3]+90, -1, -1, -1);
		LinkVehicleToInterior(PVeh, GetPlayerInterior(playerid)); SetVehicleVirtualWorld(PVeh, GetPlayerVirtualWorld(playerid));
		format(string, sizeof string, "You spawned a %s. ID: %i. ", aVehicleNames[veh - 400], veh);
  		SendClientMessage(playerid, C_GREEN, string);
	} else return SendClientMessage(playerid, C_GREEN, "Usage: /v [vehiclename] ");
	return 1;
}

//Stocks - Do NOT Edit ... Ignore
stock GetVehicleModelID(vehiclename[])
{
	for(new i = 0; i < 211; i++)
	{
		if(strfind(aVehicleNames[i], vehiclename, true) != -1)
		return i + 400;
	}
	return -1;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x2, &Float:y2, Float:distance)
{
	new Float:a;

	GetPlayerPos(playerid, x2, y2, a);
	GetPlayerFacingAngle(playerid, a);

	if(GetPlayerVehicleID(playerid))
	{
		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}

	x2 += (distance * floatsin(-a, degrees));
	y2 += (distance * floatcos(-a, degrees));
}

//Vehicle Destroy
COMMAND:vdestroy(playerid, params[])
{
     new testcar= GetPlayerVehicleID(playerid);
     SendClientMessage(playerid, 0xFFFFFFFF, "You have deleted a car!!");
     DestroyVehicle(testcar);
     return 1;
}
#endif
