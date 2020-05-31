/************************************Zone Function**********************************/


/************************************Function Register & Login***********************************************/
function:CheckBanList(playerid)
{
	if(!cache_num_rows())
	{
		new existCheck[699];

		mysql_format(ourConnection, existCheck, sizeof(existCheck), "SELECT UCP_ID FROM ucp WHERE UCP_Name = '%e'", ReturnName(playerid));
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

		SendClientMessageEx(playerid, COLOR_YELLOW, "�س����� ucp %s  ���㹡��������", ReturnName(playerid));
		SendClientMessage(playerid, -1, "��س�������������Ѥ� UCP");

		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "�Թ�յ�͹�Ѻ��ҹ������ SAMP Base [TH]", "�к�: �س������ 60�Թҷ�㹡����Ѥ������� Server\n��ͤ�����ѧ: �ô�����������ҡ��͡�äҴ��\n�ҡ��ҹ���ѭ�������ô���ҷҧ Forum �ͧ Server �Ф�Ѻ\n\n           ������ʼ�ҹ�ͧ�س:", "�Թ�ѹ", "¡��ԡ");
		return 1;
	}


	SendClientMessageEx(playerid, COLOR_YELLOW, "�Թ�յ�͹�Ѻ��ҹ������ SAMP:BETA %s {FFFFFF}[0.1]", ReturnName(playerid));
	return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�Թ�յ�͹�Ѻ��ҹ������ SAMP:Beta", "�к�: �س������ 60 �Թҷ�㹡�� Login ������ Server\n\n           ������ʼ�ҹ�ͧ�س:", "�׹�ѹ", "¡��ԡ");
}

function:OnPlayerRegister(playerid)
{
	p_AccountData[playerid][UCP_ID] = cache_insert_id();
	format(p_AccountData[playerid][UCP_Name], 266, "%s", ReturnName(playerid));

	//registerTime[playerid] = 0;
	//loginTime[playerid] = 1;

	SendClientMessageEx(playerid, COLOR_YELLOW, "�س����Ѥ���ҪԤ��������Ǥس %s. ������ҨйӤس�˹�ҵ�ҧ�������к�:", ReturnName(playerid));
	return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "�׹�յ͹�Ѻ ��� SAMP:Beta", "�к�: �س������ 60 㹡���������к�\nTIP: �ҡ�ͻѭ������ö�駼������к�\n�����ʹء�Ѻ������.\n\n           ������ʼ�ҹ�ͧ�س:", "�׹�ѹ", "¡��ԡ");
}

function:LoggingIn(playerid)
{
	new fetchChars[699];

	if(!cache_num_rows())
	{
		SendClientMessage(playerid, COLOR_RED, "[�Կ�����]: ���ʼ�ҹ�Դ��سҵԴ��� �������к�");
		return KickEx(playerid);
	}

	mysql_format(ourConnection, fetchChars, sizeof(fetchChars), "SELECT * FROM banlist WHERE BAN_UCP_ID = %i", p_AccountData[playerid][UCP_ID]);
	mysql_tquery(ourConnection, fetchChars, "Query_CheckBannedAccount", "i", playerid);
	return 1;
}



/***********************************************************************************/


function:KickTimer(playerid) { return Kick(playerid); }

//*****************************STOCK �������������/*********************************/
stock ReturnName(playerid, /*underScore = 1*/)
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




/*************************************static Zone***************************************/



/*************************************static Zone***************************************/


/**********************************************************************/
