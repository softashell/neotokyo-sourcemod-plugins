#include <neotokyo>

#pragma semicolon 1
#pragma newdecls required

enum HeldKeys {
	KEY_VISION,
	KEY_LEAN_LEFT,
	KEY_LEAN_RIGHT
}

bool g_bKeyHeld[MAXPLAYERS+1][HeldKeys];

public Plugin myinfo = 
{
	name = "NEOTOKYO° Vision modes for spectators",
	author = "glub, soft as HELL",
	description = "Thermal vision and night vision for spectators",
	version = "0.14",
	url = "https://github.com/glubsy"
}

public void OnPluginStart()
{
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("player_death", OnPlayerDeath);
	
	HookEvent("game_round_start", OnRoundStart);
}

public Action OnPlayerSpawn(Handle event, const char[] name, bool dontbroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if(!IsClientConnected(client) || !IsClientInGame(client) || IsFakeClient(client))
		return;
		
	SetPlayerVision(client, VISION_NONE);
}

public Action OnPlayerDeath(Handle event, const char[] name, bool dontbroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(!IsClientConnected(client) || !IsClientInGame(client))
		return;
	
	SetPlayerVision(client, VISION_NONE);
}

public void OnRoundStart(Handle event, const char[] name, bool Broadcast)
{
	for(int client = 1; client <= MaxClients; client++)
	{
		if(!IsClientConnected(client) || !IsClientInGame(client) || IsFakeClient(client))
			continue;
		
		if(GetClientTeam(client) <= 1)
			continue;
		
		SetPlayerVision(client, VISION_NONE);
	}
}

public Action OnPlayerRunCmd(int client, int &buttons)
{	
	if(IsPlayerAlive(client))
		return;

	if((buttons & IN_VISION) == IN_VISION)
	{
		if(g_bKeyHeld[client][KEY_VISION])
		{
			buttons &= ~IN_VISION; 
		}
		else
		{
			if(GetPlayerVision(client) == VISION_THERMAL)
				SetPlayerVision(client, VISION_NONE);
			else
				SetPlayerVision(client, VISION_THERMAL);

			g_bKeyHeld[client][KEY_VISION] = true;
		}
	}
	else 
	{
		g_bKeyHeld[client][KEY_VISION] = false;
	}
	
	if((buttons & IN_LEANR) == IN_LEANR)
	{
		if(g_bKeyHeld[client][KEY_LEAN_RIGHT])
		{
			buttons &= ~IN_LEANR;
		}
		else
		{
			if(GetPlayerVision(client) == VISION_MOTION)
				SetPlayerVision(client, VISION_NONE);
			else
				SetPlayerVision(client, VISION_MOTION);

			g_bKeyHeld[client][KEY_LEAN_RIGHT] = true;
		}
	}
	else
	{
		g_bKeyHeld[client][KEY_LEAN_RIGHT] = false;
	}
	
	if((buttons & IN_LEANL) == IN_LEANL)
	{
		if(g_bKeyHeld[client][KEY_LEAN_LEFT])
		{
			buttons &= ~IN_LEANL;
		}
		else
		{
			if(GetPlayerVision(client) == VISION_NIGHT)
				SetPlayerVision(client, VISION_NONE);
			else
				SetPlayerVision(client, VISION_NIGHT);

			g_bKeyHeld[client][KEY_LEAN_LEFT] = true;
		}
	}
	else
	{
		g_bKeyHeld[client][KEY_LEAN_LEFT] = false;
	}
}
