// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
//#include <nex-ac>
#include <a_mysql>
#include <zcmd>
#include <streamer>
#include <foreach>
#include <sscanf2>
#include <evi>
#include <easyDialog>
#define  CE_AUTO
#include <CEFix>
//#include "../gamemodes/script/Function.pwn"






/*******************Zone ������觹�������***************************/

#define SQL_HOSTNAME "localhost"
#define SQL_USERNAME "root"
#define SQL_DATABASE "boston"
#define SQL_PASSWORD ""

new ourConnection;


#define function:%0(%1) forward %0(%1); public %0(%1)

#undef MAX_PLAYERS
	#define MAX_PLAYERS  (50)

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
	
	
	
/***************COLOR*******************/
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0XA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_SEAGREEN 0x20B2AAAA
#define COLOR_LIMEGREEN 0x32CD32AA //<--- Dark lime
#define COLOR_MIDNIGHTBLUE 0X191970AA
#define COLOR_MAROON 0x800000AA
#define COLOR_OLIVE 0x808000AA
#define COLOR_ORANGERED 0xFF4500AA
#define COLOR_PINK 0xFFC0CBAA // - Light light pink
#define COLOR_SPRINGGREEN 0x00FF7FAA
#define COLOR_TOMATO 0xFF6347AA // - Tomato >:/ sounds wrong lol... well... :P
#define COLOR_YELLOWGREEN 0x9ACD32AA //- like military green
#define COLOR_MEDIUMAQUA 0x83BFBFAA
#define COLOR_MEDIUMMAGENTA 0x8B008BAA // dark magenta ^
/***************COLOR*******************/


/************** Message ��ͤ�����****************************/
#define SendUsageMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_RED, "�Ը���:{ffffff} "%1)

#define SendErrorMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_RED, "�Դ��Ҵ:{ffffff} "%1)

#define SendServerMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_RED, "�Կ�����:{ffffff} "%1)
/************** Message ��ͤ�����****************************/



//*******STATS PLAYER****************/
#define PLAYER_STATE_ALIVE (1)
#define PLAYER_STATE_WOUNDED (2)
#define PLAYER_STATE_DEAD (3)
//*******STATS PLAYER****************/

//*******NEW************************/
new globalWeather = 2;
//*******NEW************************/
	
/*******************Zone ������觹�������***************************/


/*******************Zone Diglog ����ö������������ҡ�����ҧ Diglog ��й�����ҡ����͡�ӺѤ��������*************************************/
#define DIALOG_DEFAULT (0)
#define DIALOG_CONFIRM_SYS (1)

#define DIALOG_REGISTER (2)
#define DIALOG_LOGIN (3)

/*******************Zone Diglog ����ö������������ҡ�����ҧ Diglog ��й�����ҡ����͡�ӺѤ��������*************************************/
	

enum P_CHAR_DATA
{
    ID,
	bool:pLogin,
	CHAR_IP,
	
	CHAR_Name[266],
	CHAR_Skin,
	Float:CHAR_POS[3],
	CHAR_POS_W,
	CHAR_POS_I,
}
new PlayerInfo[MAX_PLAYERS][P_CHAR_DATA];



main()
{
	print("\n----------------------------------");
	print(" Base Register & Login");
	print("----------------------------------\n");
}

public OnGameModeInit()
{
	ourConnection = mysql_connect(SQL_HOSTNAME, SQL_USERNAME, SQL_DATABASE, SQL_PASSWORD);

	if(mysql_errno() != 0)
		printf ("[DATABASE]: Connection failed to '%s'...", SQL_DATABASE);

	else printf ("[DATABASE]: Connection established to '%s'...", SQL_DATABASE);

	mysql_log(LOG_ERROR | LOG_WARNING);

	//Disabling single player entities:
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetNameTagDrawDistance(20.0);

	EnableStuntBonusForAll(0);

	ManualVehicleEngineAndLights();
	DisableInteriorEnterExits();

	//Configure world:
	SetWeather(globalWeather);

	new
		hour, seconds, minute;

	gettime(hour, seconds, minute);
	SetWorldTime(hour);
	
	return 1;
}


public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if (PlayerInfo[playerid][pLogin] == true)
	{
		TogglePlayerSpectating(playerid, true);
		return 0;
	}
	else if(PlayerInfo[playerid][pLogin] == false)
	{
		SetSpawnInfo(playerid, 0, PlayerInfo[playerid][CHAR_Skin], PlayerInfo[playerid][CHAR_POS][0], PlayerInfo[playerid][CHAR_POS][1], PlayerInfo[playerid][CHAR_POS][2], 0, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		return 0;
	}
	else return 0;
}



public OnPlayerConnect(playerid)
{

	SetPlayerColor(playerid, 0xAFAFAFFF);
	SetPlayerTeam(playerid, PLAYER_STATE_ALIVE);
	
	//Dualies;
	SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 899);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 0);
	SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 0);
	
	new
		existCheck[699]
	;

	mysql_format(ourConnection, existCheck, sizeof(existCheck), "SELECT * FROM BanList WHERE BAN_Name = '%e'", PlayerInfo[playerid][CHAR_Name]);
	mysql_tquery(ourConnection, existCheck, "CheckBanList", "i", playerid);

	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
    Streamer_Update(playerid);

	SetPlayerTeam(playerid, PLAYER_STATE_ALIVE);
	SetPlayerWeather(playerid, globalWeather);
	
	SetPlayersSpawn(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
     	case DIALOG_REGISTER:
		{
			if(!response)
			{
				SendClientMessage(playerid, COLOR_LIME, "�س�١���͡�ҡ�׿�������ͧ�ҡ�س���ӡ����Ѥ���ҪԤ");
				return KickEx(playerid);
			}

			new insert[256];
			
			PlayerInfo[playerid][pLogin] = true;

			if(strlen(inputtext) > 128 || strlen(inputtext) < 3)
				return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "SAMP:Beta", "�к�: �س�������ա60�Թҷ�㹡����Ѥ�������\n\n���ʼ�ҹ�ͧ�س�е�ͧ�ҡ���� 3 ��Ǣ���\n���ѧ: ��ʹ������͡���ʹ��Ѻ���索Ҵ\n\n           ������ʼ�ҹŧ�:", "�Թ�ѹ", "¡��ԡ");

			mysql_format(ourConnection, insert, sizeof(insert), "INSERT INTO `character` (`CHAR_Name`, `CHAR_Password`, `CHAR_Date`, `CHAR_IP`, `CHAR_Skin`) VALUES('%e', '%e', '%e', '%e', '299')", ReturnName(playerid), inputtext, ReturnDate(), ReturnIP(playerid));
			mysql_tquery(ourConnection, insert, "OnPlayerRegister", "i", playerid);
		}
		case DIALOG_LOGIN:
		{
			if (!response)
			{
				SendClientMessage(playerid, COLOR_RED, "[!] �س�١�����ͧ�ҡ�س����� �������к�");
				return KickEx(playerid);
			}

			new continueCheck[211];

			mysql_format(ourConnection, continueCheck, sizeof(continueCheck), "SELECT `ID`, `CHAR_ForumName`, `CHAR_IP` FROM `character` WHERE `CHAR_Name` = '%e' AND `CHAR_Password` = '%e' LIMIT 1",
				ReturnName(playerid), inputtext);

			mysql_tquery(ourConnection, continueCheck, "LoggingIn", "i", playerid);
			return 1;
		}
	}
	return 1;
}

/************************************Zone Function**********************************/


/************************************Function Register & Login***********************************************/
function:CheckBanList(playerid)
{
	if(!cache_num_rows())
	{
		new existCheck[699];

		mysql_format(ourConnection, existCheck, sizeof(existCheck), "SELECT * FROM `character` WHERE `CHAR_Name` = '%e'", ReturnName(playerid));
		mysql_tquery(ourConnection, existCheck, "LogPlayerIn", "i", playerid);
	}
	else
	{
		SendServerMessage(playerid, "IP \"%s\" �١ẹ�͡�ҡ�׿�����", ReturnIP(playerid));
		SendServerMessage(playerid, "�ô�Դ��ͼ������к� ��ҹ�ҧ ������");
		return KickEx(playerid);
	}
	return 1;
}

function:LogPlayerIn(playerid)
{
	if(!cache_num_rows())
	{
		for(new i = 0; i < 3; i ++) { SendClientMessage(playerid, -1, " "); }

		SendClientMessageEx(playerid, COLOR_YELLOW, "�س����� ����Ф� %s  ���㹡��������", ReturnName(playerid));
		SendClientMessage(playerid, -1, "��س�������������Ѥ� ����Ф�");
		
		PlayerInfo[playerid][pLogin] = true;

		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "�Թ�յ�͹�Ѻ��ҹ������ SAMP Base [TH]", "�к�: �س������ 60�Թҷ�㹡����Ѥ������� Server\n��ͤ�����ѧ: �ô�����������ҡ��͡�äҴ��\n�ҡ��ҹ���ѭ�������ô���ҷҧ Forum �ͧ Server �Ф�Ѻ\n\n           ������ʼ�ҹ�ͧ�س:", "�Թ�ѹ", "¡��ԡ");
		return 1;
	}


	SendClientMessageEx(playerid, COLOR_YELLOW, "�Թ�յ�͹�Ѻ��ҹ������   SAMP Roleplay �س , %s {FFFFFF}[0.1]", ReturnName(playerid));
	return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�Թ�յ�͹�Ѻ��ҹ������ SAMP:Beta", "�к�: �س������ 60 �Թҷ�㹡�� Login ������ Server\n\n           ������ʼ�ҹ�ͧ�س:", "�׹�ѹ", "¡��ԡ");
}

function:OnPlayerRegister(playerid)
{
	PlayerInfo[playerid][ID] = cache_insert_id();
	format(PlayerInfo[playerid][CHAR_Name], 266, "%s", ReturnName(playerid));

	//registerTime[playerid] = 0;
	//loginTime[playerid] = 1;

	SendClientMessageEx(playerid, COLOR_YELLOW, "�س����Ѥ���ҪԤ��������Ǥس %s. ������ҨйӤس�˹�ҵ�ҧ�������к�:", ReturnName(playerid));
	return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�׹�յ͹�Ѻ ��� SAMP:Roleplay", "�к�: �س������ 60 㹡���������к�\nTIP: �ҡ�ͻѭ������ö�駼������к�\n�����ʹء�Ѻ������.\n\n           ������ʼ�ҹ�ͧ�س:", "�׹�ѹ", "¡��ԡ");
}

function:LoggingIn(playerid)
{
	new thread[699];

	if(!cache_num_rows())
	{
		SendClientMessage(playerid, COLOR_RED, "[�Կ�����]: ���ʼ�ҹ�Դ��سҵԴ��� �������к�");
		return KickEx(playerid);
	}

	mysql_format(ourConnection, thread, sizeof(thread), "SELECT * FROM `character` WHERE `CHAR_Name` = '%e'", ReturnName(playerid));
	mysql_tquery(ourConnection, thread, "Query_LoadCharacter", "i", playerid);

	return 1;
}

function:Query_LoadCharacter(playerid)
{
    PlayerInfo[playerid][pLogin] = false;
    
	PlayerInfo[playerid][ID] = cache_get_field_content_int(0, "ID", ourConnection);

	PlayerInfo[playerid][CHAR_Skin] = cache_get_field_content_int(0, "CHAR_Skin", ourConnection);
	
	PlayerInfo[playerid][CHAR_POS][0] = cache_get_field_content_float(0, "CHAR_POSX", ourConnection);
	PlayerInfo[playerid][CHAR_POS][1] = cache_get_field_content_float(0, "CHAR_POSY", ourConnection);
	PlayerInfo[playerid][CHAR_POS][2] = cache_get_field_content_float(0, "CHAR_POSZ", ourConnection);
	PlayerInfo[playerid][CHAR_POS_W] = cache_get_field_content_int(0, "CHAR_POS_W", ourConnection);
	PlayerInfo[playerid][CHAR_POS_I] = cache_get_field_content_int(0, "CHAR_POS_I", ourConnection);
	
	return LoadCharacter(playerid);
}

function:LoadCharacter(playerid)
{
	new
		string[128]
	;

	//PlayerInfo[playerid][pLoggedin] = true;

	SetPlayerScore(playerid, /*PlayerInfo[playerid][pLevel]*/200);
	SetPlayerColor(playerid, 0xFFFFFFFF);

	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, /*PlayerInfo[playerid][pMoney]*/200);

	SetSpawnInfo(playerid, 0, PlayerInfo[playerid][CHAR_Skin], PlayerInfo[playerid][CHAR_POS][0], PlayerInfo[playerid][CHAR_POS][1], PlayerInfo[playerid][CHAR_POS][2], 0, 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);

	format(string, sizeof(string), "~w~Welcome~n~~y~ %s", ReturnName(playerid));
	GameTextForPlayer(playerid, string, 1000, 1);

	/*if (PlayerInfo[playerid][pAdmin])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "�к�: �س���������к��繼������к� Admin ����� %i", PlayerInfo[playerid][pAdmin]);

		if(!strcmp(e_pAccountData[playerid][mForumName], "Null"))
		{
			ShowPlayerDialog(playerid, 99, DIALOG_STYLE_MSGBOX, "����͹", "��ͤ����ͧ�Ҩ��駼������к�������㹡���������к��ҡ�ѧ������駪��Ϳ����\n���Ϳ�����ͧ�س��� NULL ��е�ͧ��á������¹�ŧ\n\n{F81414}�ô��Ǩ�ͺ����������ա������¹�ŧ���� /forumname.", "��������", "");
		}
	}

	if (PlayerInfo[playerid][pHelper])
	{
		SendClientMessageEx(playerid, COLOR_WHITE, "�к�: �س���������к��繼������к� Tester ����� %i", PlayerInfo[playerid][pHelper]);
	}*/

	/*if(PlayerInfo[playerid][pVehicleSpawned] == true)
	{
		if(!IsValidVehicle(PlayerInfo[playerid][pVehicleSpawnedID]))
			PlayerInfo[playerid][pVehicleSpawned] = false;

		else
			SendServerMessage(playerid, "�ҹ��˹Тͧ�س�ѧ�������� v list");
	}*/

	SetPlayerSkin(playerid, PlayerInfo[playerid][CHAR_Skin]);
	SetPlayerPos(playerid, PlayerInfo[playerid][CHAR_POS][0], PlayerInfo[playerid][CHAR_POS][1], PlayerInfo[playerid][CHAR_POS][2]);

	/*if(PlayerInfo[playerid][pOfflinejailed])
	{
		if(strlen(PlayerInfo[playerid][pOfflinejailedReason]) > 56)
		{
			SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s �������к��١�Ӥء�� ������ �к��ӹǹ %d �ҷ� ���˵�: %.56s", ReturnName(playerid), PlayerInfo[playerid][pAdminjailTime] / 60, PlayerInfo[playerid][pOfflinejailedReason]);
			SendClientMessageToAllEx(COLOR_RED, "AdmCmd: ...%s", PlayerInfo[playerid][pOfflinejailedReason][56]);
		}
		else SendClientMessageToAllEx(COLOR_RED, "AdmCmd: %s �������к��١�Ӥء�� ������ �к��ӹǹ %d �ҷ� ���˵�: %s", ReturnName(playerid), PlayerInfo[playerid][pAdminjailTime] / 60, PlayerInfo[playerid][pOfflinejailedReason]);

		ClearAnimations(playerid);

		SetPlayerPos(playerid, 2687.3630, 2705.2537, 22.9472);
		SetPlayerInterior(playerid, 0); SetPlayerVirtualWorld(playerid, 1338);

		PlayerInfo[playerid][pOfflinejailed] = false;
		PlayerInfo[playerid][pAdminjailed] = 1;
	}*/

	format(PlayerInfo[playerid][CHAR_IP], 60, "%s", ReturnIP(playerid));
	return 1;
}


/***********************************************************************************/


function:KickTimer(playerid) { return Kick(playerid); }


function:SetPlayersSpawn(playerid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	SetPlayerSkin(playerid, PlayerInfo[playerid][CHAR_Skin]);
	return 1;
}

//*****************************STOCK �������������/*********************************/
stock ReturnName(playerid, underScore = 1)
{
	new playersName[MAX_PLAYER_NAME + 2];
	GetPlayerName(playerid, playersName, sizeof(playersName));

	/*if(!underScore)
	{
		if(PlayerInfo[playerid][pMasked])
			format(playersName, sizeof(playersName), "[Mask %i_%i]", PlayerInfo[playerid][pMaskID][0], PlayerInfo[playerid][pMaskID][1]);

		else
		{
			for(new i = 0, j = strlen(playersName); i < j; i ++)
			{
				if(playersName[i] == '_')
				{
					playersName[i] = ' ';
				}
			}
		}
	}*/

	return playersName;
}


stock ReturnDate()
{
	new sendString[90], MonthStr[40], month, day, year;
	new hour, minute, second;

	gettime(hour, minute, second);
	getdate(year, month, day);
	switch(month)
	{
	    case 1:  MonthStr = "���Ҥ�";
	    case 2:  MonthStr = "����Ҿѹ��";
	    case 3:  MonthStr = "�չҤ�";
	    case 4:  MonthStr = "����¹";
	    case 5:  MonthStr = "����Ҥ�";
	    case 6:  MonthStr = "�Զع�¹";
	    case 7:  MonthStr = "�á�Ҥ�";
	    case 8:  MonthStr = "�ԧ�Ҥ�";
	    case 9:  MonthStr = "�ѹ��¹";
	    case 10: MonthStr = "���Ҥ�";
	    case 11: MonthStr = "��Ȩԡ�¹";
	    case 12: MonthStr = "�ѹ�Ҥ�";
	}

	format(sendString, 90, "%s %d, %d %02d:%02d:%02d", MonthStr, day, year, hour, minute, second);
	return sendString;
}

stock ReturnIP(playerid)
{
	new
		ipAddress[20];

	GetPlayerIp(playerid, ipAddress, sizeof(ipAddress));
	return ipAddress;
}

stock KickEx(playerid)
{
	return SetTimerEx("KickTimer", 100, false, "i", playerid);
}


stock SendClientMessageEx(playerid, color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[156]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 12)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 12); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 156
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		SendClientMessage(playerid, color, string);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	return SendClientMessage(playerid, color, str);
} // Credits to Emmet, South Central Roleplay

stock SendClientMessageToAllEx(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.pri args
		#emit ADD.C 4
		#emit PUSH.pri
		#emit SYSREQ.C format

        #emit LCTRL 5
		#emit SCTRL 4

		foreach (new i : Player) {
			SendClientMessage(i, color, string);
		}
		return 1;
	}
	return SendClientMessageToAll(color, str);
} // Credits to Emmet, South Central Roleplay


//*****************************STOCK �������������/*********************************/
stock ToggleVehicleEngine(vehicleid, bool:enginestate)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;

    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    SetVehicleParamsEx(vehicleid, enginestate, lights, alarm, doors, bonnet, boot, objective);
    return 1;
}



/*************************************static Zone***************************************/



/*************************************static Zone***************************************/


/**********************************************************************/
CMD:spawncar(playerid, params[])
{
    new float:x, float:y, float:z;
    new vehicleid = INVALID_VEHICLE_ID, modelid, color1, color2, siren, /*str[128]*/ Float:a;

    if(sscanf(params, "iiiI(0)", modelid, color1, color2, siren))
    {
        SendUsageMessage(playerid, "/spawncar [model id] [color1] [color2] [siren default 0]");
        SendServerMessage(playerid, "͸Ժ�����١������");
        return 1;
    }
    GetPlayerPos(playerid, Float:x, Float:y, Float:z);
    GetPlayerFacingAngle(playerid, a);

    if(modelid < 400 || modelid > 611)
        return SendErrorMessage(playerid, "You specified an invalid model.");

    if(color1 < 0 || color2 < 0 || color1 > 255 || color2 > 255)
        return SendErrorMessage(playerid, "A color you specified was invalid.");

    vehicleid = CreateVehicle(modelid, Float:x, Float:y, Float:z, a, color1, color2, -1, siren);
    ToggleVehicleEngine(vehicleid, true);
    PutPlayerInVehicle(playerid, vehicleid, 0);

    return 1;
}

