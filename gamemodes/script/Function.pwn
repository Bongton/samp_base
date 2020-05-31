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
		SendServerMessage(playerid, "IP \"%s\" ถูกแบนออกจากเซืฟเวอร์", ReturnIP(playerid));
		SendServerMessage(playerid, "โปรดติดต่อผู้ดูแลระบบ ผ่านทาง ฟอรั่ม");
		return KickEx(playerid);
	}
	return 1;
}

function:LogPlayerIn(playerid)
{
	if(!cache_num_rows())
	{
		for(new i = 0; i < 3; i ++) { SendClientMessage(playerid, -1, " "); }

		SendClientMessageEx(playerid, COLOR_YELLOW, "คุณใช้ชื่อ ucp %s  เข้าในการเข้าเล่น", ReturnName(playerid));
		SendClientMessage(playerid, -1, "กรุณาเข้าเว็บเพื่อสมัคร UCP");

		ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "ยินดีต้อนรับท่านเข้าสู่ SAMP Base [TH]", "ระบบ: คุณมีเวลา 60วินาทีในการสมัครเข้าเล่น Server\nข้อควรระวัง: โปรดตั้งรหัสให้ยากต่อการคาดเดา\nหากท่านพบปัญหาอะไรโปรดแจ้งมาทาง Forum ของ Server นะครับ\n\n           ใส่รหัสผ่านของคุณ:", "ยินยัน", "ยกเลิก");
		return 1;
	}


	SendClientMessageEx(playerid, COLOR_YELLOW, "ยินดีต้อนรับท่านเข้าสู่ SAMP:BETA %s {FFFFFF}[0.1]", ReturnName(playerid));
	return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "ยินดีต้อนรับท่านเข้าสู่ SAMP:Beta", "ระบบ: คุณมีเวลา 60 วินาทีในการ Login เข้าเล่น Server\n\n           ใส่รหัสผ่านของคุณ:", "ยืนยัน", "ยกเลิก");
}

function:OnPlayerRegister(playerid)
{
	p_AccountData[playerid][UCP_ID] = cache_insert_id();
	format(p_AccountData[playerid][UCP_Name], 266, "%s", ReturnName(playerid));

	//registerTime[playerid] = 0;
	//loginTime[playerid] = 1;

	SendClientMessageEx(playerid, COLOR_YELLOW, "คุณได้สมัครสมาชิคสำเร็จแล้วคุณ %s. ต่อไปเราจะนำคุณไปหน้าต่างเข้าสู่ระบบ:", ReturnName(playerid));
	return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "ยืนดีตอนรับ สู่ SAMP:Beta", "ระบบ: คุณมีเวลา 60 ในการเข้าสู่ระบบ\nTIP: หากเจอปัญหาสามารถแจ้งผู้ดูแลระบบ\nขอให้สนุกกับการเล่น.\n\n           ใส่รหัสผ่านของคุณ:", "ยืนยัน", "ยกเลิก");
}

function:LoggingIn(playerid)
{
	new fetchChars[699];

	if(!cache_num_rows())
	{
		SendClientMessage(playerid, COLOR_RED, "[เซิฟเวอร์]: รหัสผ่านผิดกรุณาติดต่อ ผู้ดูแลระบบ");
		return KickEx(playerid);
	}

	mysql_format(ourConnection, fetchChars, sizeof(fetchChars), "SELECT * FROM banlist WHERE BAN_UCP_ID = %i", p_AccountData[playerid][UCP_ID]);
	mysql_tquery(ourConnection, fetchChars, "Query_CheckBannedAccount", "i", playerid);
	return 1;
}



/***********************************************************************************/


function:KickTimer(playerid) { return Kick(playerid); }

//*****************************STOCK ไม่จำเป็นอย่ายุ่ง/*********************************/
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
	    case 1:  MonthStr = "มกราคม";
	    case 2:  MonthStr = "กุมภาพันธ์";
	    case 3:  MonthStr = "มีนาคม";
	    case 4:  MonthStr = "เมษายน";
	    case 5:  MonthStr = "พฤษภาคม";
	    case 6:  MonthStr = "มิถุนายน";
	    case 7:  MonthStr = "กรกฎาคม";
	    case 8:  MonthStr = "สิงหาคม";
	    case 9:  MonthStr = "กันยายน";
	    case 10: MonthStr = "ตุลาคม";
	    case 11: MonthStr = "พฤศจิกายน";
	    case 12: MonthStr = "ธันวาคม";
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


//*****************************STOCK ไม่จำเป็นอย่ายุ่ง/*********************************/




/*************************************static Zone***************************************/



/*************************************static Zone***************************************/


/**********************************************************************/
