/*
	Vehicle Headlight's Filterscript
	Toggle you vehicles lights on/off :)
	
	Created by: Anwix (http://forum.sa-mp.com/index.php?action=profile;u=12730)

	Thanks to:
	 ~ JernejL (RedShirt) - Encode Lights Script
	                                    */

#include <a_samp>

new bool: VehicleLightsOn[MAX_VEHICLES];
new panels, doors, lights, tires;

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Vehicle Lights Filterscript Loaded");
	print("--------------------------------------\n");
	
	for (new x = 1; x < MAX_VEHICLES; x++)
	{
		VehicleLightsOn[x] = false;
	}
	return 1;
}

public OnFilterScriptExit()
{
    print("\n--------------------------------------");
	print(" Vehicle Lights Filterscript Unloaded");
	print("--------------------------------------\n");
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER)
	{
	    if (VehicleLightsOn[GetPlayerVehicleID(playerid)] == false)
	    {
			GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
	        UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, encode_lights(1, 1, 1, 1), tires);
   			VehicleLightsOn[GetPlayerVehicleID(playerid)] = false;
	    }
	    else
	    {
			GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
	        UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, encode_lights(0, 0, 0, 0), tires);
         	VehicleLightsOn[GetPlayerVehicleID(playerid)] = true;
		}
	}
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (PRESSED(KEY_ACTION))
	{
	    if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
	        if (VehicleLightsOn[GetPlayerVehicleID(playerid)] == false)
	        {
                GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
	        	UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, encode_lights(0, 0, 0, 0), tires);
                VehicleLightsOn[GetPlayerVehicleID(playerid)] = true;
	        }
	        else
	        {
	    		GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
	        	UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, encode_lights(1, 1, 1, 1), tires);
	    		VehicleLightsOn[GetPlayerVehicleID(playerid)] = false;
			}
		}
	}
	return 1;
}

/*	Thanks to JernejL (RedShirt) for encode_lights   */
stock encode_lights(light1, light2, light3, light4)
{
	return light1 | (light2 << 1) | (light3 << 2) | (light4 << 3);
}