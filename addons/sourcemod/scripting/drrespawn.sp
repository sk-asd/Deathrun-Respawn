#include <sourcemod>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

Handle revtimer = null;
int sayi = 0;

public Plugin myinfo = 
{
	name = "...", 
	author = "phiso", 
	description = "...", 
	version = "1.0", 
	url = "phiso#3331"
};

public void OnPluginStart()
{
	HookEvent("round_start", elbasladi);
	HookEvent("round_end", elbitti);
}
public void OnMapStart()
{
	char map[512];
	GetCurrentMap(map, sizeof(map));
	if (strncmp(map, "deathrun_", 3, false) != 0)
	{
		SetFailState("[DR RESPAWN] Bu eklenti sadece ve sadece deathrun modunda calisir.");
	}
}
public Action elbasladi(Event event, const char[] name, bool dontBroadcast)
{
	sayi = 0;
	revtimer = CreateTimer(1.0, revle, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}
public Action revle(Handle timer)
{
	sayi++;
	if (sayi == 30)
	{
		sayi = 0;
		if (revtimer != null)
		{
			delete revtimer;
			revtimer = null;
		}
		PrintToChatAll("[SM] \x02Respawn \x04süresi bitti.");
		return Plugin_Stop;
	}
	else if (sayi >= 1)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if (!IsPlayerAlive(i) && IsClientInGame(i) && !IsFakeClient(i))
			{
				CS_RespawnPlayer(i);
			}
		}
	}
	return Plugin_Continue;
}
public Action elbitti(Event event, const char[] name, bool dontBroadcast)
{
	if (revtimer != null)
	{
		delete revtimer;
		revtimer = null;
	}
} 