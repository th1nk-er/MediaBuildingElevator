#include <a_samp>
#include <streamer>
#include <string>
new dtDialogID = 3011;
new dtOBJ[10];
new Float:dtHeight[30];
new Float:dtDoorHeight[30];
new LeftDoorOBJ[50];
new RightDoorOBJ[50];
new CurrentFloor = 1;
new dtMoving;
new DoorOpen[30];
new FloorText[30][64];
new Text3D:Tips3DText[60];
public OnFilterScriptInit()
{
	printf("[传媒电梯]正在创建....");
	format(FloorText[1],64,"1楼");
	format(FloorText[2],64,"2楼");
	format(FloorText[3],64,"3楼");
	format(FloorText[4],64,"4楼");
	format(FloorText[5],64,"5楼");
	format(FloorText[6],64,"6楼");
	format(FloorText[7],64,"7楼");
	format(FloorText[8],64,"8楼");
	format(FloorText[9],64,"9楼");
	format(FloorText[10],64,"10楼");
	format(FloorText[11],64,"11楼");
	format(FloorText[12],64,"12楼");
	format(FloorText[13],64,"13楼");
	format(FloorText[14],64,"14楼");
	format(FloorText[15],64,"15楼");
    format(FloorText[16],64,"16楼");
    format(FloorText[17],64,"17楼");
    format(FloorText[18],64,"18楼");
    format(FloorText[19],64,"19楼");
    format(FloorText[20],64,"20楼");
    format(FloorText[21],64,"21楼");
	dtHeight[1] = 14.6084;
	dtHeight[2] = 23.1484;
	dtDoorHeight[1] = 14.5746;
	dtDoorHeight[2] = dtDoorHeight[1] + 8.53;
	for(new i = 3; i <= 21 ; i++){
		dtHeight[i] = dtHeight[i-1] + 5.45;
		dtDoorHeight[i] = dtDoorHeight[i-1] + 5.45;
	}
	DoorOpen[1] = 1;
	dtOBJ[0] = CreateDynamicObject(18755,1786.6709,-1303.4305,dtHeight[1],0,0,270);//电梯
	dtOBJ[1] = CreateDynamicObject(18756,1786.684936-1.8,-1303.395996,dtDoorHeight[1],0,0,-90);//电梯右内门  --和电梯一起移动
	dtOBJ[2] = CreateDynamicObject(18757,1786.684936+1.8,-1303.395996,dtDoorHeight[1],0,0,-90);//电梯左内门  --和电梯一起移动
	LeftDoorOBJ[1] = CreateDynamicObject(18757,1786.684936+1.8,-1303.185996,dtDoorHeight[1],0,0,-90);//电梯左门
	RightDoorOBJ[1] = CreateDynamicObject(18756,1786.684936-1.8,-1303.185996,dtDoorHeight[1],0,0,-90);//电梯右门

	for(new i = 2; i <= 21 ; i++){
		RightDoorOBJ[i] = CreateDynamicObject(18756,1786.684936,-1303.185996,dtDoorHeight[i],0,0,-90);//电梯右门
		LeftDoorOBJ[i] = CreateDynamicObject(18757,1786.684936,-1303.185996,dtDoorHeight[i],0,0,-90);//电梯左门
        DoorOpen[i] = 0;
	}
	for(new i = 1; i <= 21 ; i++){
	    new tips[256];
	    format(tips,sizeof(tips),"{FFFF00}[%s]{00FF00}按[{FF0000}H{00FF00}]呼叫电梯",FloorText[i]);
		Tips3DText[i] = CreateDynamic3DTextLabel(tips, 0xFFFFFFFF,1786.7131,-1298.09,dtDoorHeight[i] - 1.5, 5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0);
        format(tips,sizeof(tips),"{FFFF00}[%s]{00FF00}{00FF00}按[{FF0000}Y{00FF00}]选择楼层",FloorText[i]);
		Tips3DText[21 + i] = CreateDynamic3DTextLabel("{00FF00}按[{FF0000}Y{00FF00}]选择楼层", 0xFFFFFFFF,1786.72,-1304.75,dtDoorHeight[i] - 1.5, 5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,0);
	}
	printf("[传媒电梯]创建完毕");
	CurrentFloor = 1;
	dtMoving = 0;
	return 1;
}

public OnFilterScriptExit()
{
    for(new i = 1; i <= 150 ; i++){
    	if(IsValidDynamicObject(dtOBJ[i])){
			DestroyDynamicObject(dtOBJ[i]);
		}
		if(IsValidDynamicObject(LeftDoorOBJ[i])){
			DestroyDynamicObject(LeftDoorOBJ[i]);
		}
		if(IsValidDynamicObject(RightDoorOBJ[i])){
			DestroyDynamicObject(RightDoorOBJ[i]);
		}
		if(IsValidDynamicObject(dtOBJ[i])){
			DestroyDynamicObject(dtOBJ[i]);
		}
		if(IsValidDynamic3DTextLabel(Tips3DText[i])){
			DestroyDynamic3DTextLabel(Tips3DText[i]);
		}
		if(IsValidDynamic3DTextLabel(Tips3DText[i + 21])){
			DestroyDynamic3DTextLabel(Tips3DText[i + 21]);
		}
	}
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == dtDialogID){
		if(response){
		    if(listitem != 0 && listitem != CurrentFloor && dtMoving == 0){
		    	new msg[256];
            	CloseDoor();
 				SetTimerEx("GotoFloor",2000,false,"i",listitem);
				printf("[传媒大楼]即将前往%d楼",listitem);
				format(msg,sizeof(msg),"{FFFF00}[传媒大楼]电梯即将前往[{00FF00}%s{FFFF00}]",FloorText[listitem]);
				SendClientMessage(playerid,-1,msg);
				dtMoving = 1;
			}
		}
	}
	return 0;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!IsPlayerInAnyVehicle(playerid) && newkeys == 262144){
		for(new i = 1;i<= 21; i++){
			if(IsPlayerInRangeOfPoint(playerid,3,1786.7131,-1298.09,dtDoorHeight[i])){
				if(i != CurrentFloor){
					new msg[256];
				    if(dtMoving != 1){
				    	CloseDoor();
				    	SetTimerEx("GotoFloor",2000,false,"i",i);
						printf("[传媒大楼]%d楼呼叫电梯",i);
						format(msg,sizeof(msg),"{FFFF00}[传媒大楼]您已呼叫[{00FF00}%s{FFFF00}]电梯，请耐心等待!",FloorText[i]);
						SendClientMessage(playerid,-1,msg);
						dtMoving = 1;
						new tips[256];
						format(tips,sizeof(tips),"{FF1493}[{00FF00}%s{FFFF00}{FF1493}]电梯正在赶来，请耐心等待!",FloorText[i]);
						UpdateDynamic3DTextLabelText(Tips3DText[i],0xFFFFFFFF,tips);
					}
					else{
                        format(msg,sizeof(msg),"{FFFF00}[传媒大楼]电梯正在前往[{00FF00}%s{FFFF00}]，请等待电梯到达后再呼叫电梯",FloorText[CurrentFloor]);
                        SendClientMessage(playerid,-1,msg);
					}
				}
				break;
			}
		}
	}
	if(!IsPlayerInAnyVehicle(playerid) && newkeys == 	65536){
		for(new i = 1;i<= 21; i++){
			if(IsPlayerInRangeOfPoint(playerid,2,1786.72,-1304.75,dtDoorHeight[i])){
   				if(dtMoving == 0){
                    new dialogMsg[512];
       				format(dialogMsg,sizeof(dialogMsg),"{00FF00}请选择楼层");
		    		for(new j = 1;j<= 21; j++){
		    	    	if(j != i){
	    					format(dialogMsg,sizeof(dialogMsg),"%s\n%s",dialogMsg,FloorText[j]);
						}
						else{
    						format(dialogMsg,sizeof(dialogMsg),"%s\n{FF0000}%s",dialogMsg,FloorText[j]);
						}
					}
					ShowPlayerDialog(playerid,dtDialogID,DIALOG_STYLE_LIST,"传媒电梯",dialogMsg,"前往","取消");
			    	break;
	   			}
	   			else{
					SendClientMessage(playerid,-1,"{FFFF00}[传媒大楼]电梯正在移动，请稍后!");
				}
			}
		}
	}
	return 1;
}
forward OpenDoor();
public OpenDoor()
{
	new Float:x,Float:y,Float:z;
	GetDynamicObjectPos(LeftDoorOBJ[CurrentFloor],x,y,z);
	MoveDynamicObject(LeftDoorOBJ[CurrentFloor],x+1.8,y,z,5);
	GetDynamicObjectPos(RightDoorOBJ[CurrentFloor],x,y,z);
	MoveDynamicObject(RightDoorOBJ[CurrentFloor],x-1.8,y,z,5);
	DoorOpen[CurrentFloor] = 1;
	GetDynamicObjectPos(dtOBJ[1],x,y,z);
	MoveDynamicObject(dtOBJ[1],x-1.8,y,z,5);
	GetDynamicObjectPos(dtOBJ[2],x,y,z);
	MoveDynamicObject(dtOBJ[2],x+1.8,y,z,5);
	dtMoving = 0;
	new tips[256];
	format(tips,sizeof(tips),"{FFFF00}[%s]{00FF00}按[{FF0000}H{00FF00}]呼叫电梯",FloorText[CurrentFloor]);
	UpdateDynamic3DTextLabelText(Tips3DText[CurrentFloor],0xFFFFFFFF,tips);
}
forward CloseDoor();
public CloseDoor()
{
	new Float:x,Float:y,Float:z;
	GetDynamicObjectPos(LeftDoorOBJ[CurrentFloor],x,y,z);
	MoveDynamicObject(LeftDoorOBJ[CurrentFloor],x-1.8,y,z,5);
	GetDynamicObjectPos(RightDoorOBJ[CurrentFloor],x,y,z);
	MoveDynamicObject(RightDoorOBJ[CurrentFloor],x+1.8,y,z,5);
	DoorOpen[CurrentFloor] = 0;
	GetDynamicObjectPos(dtOBJ[1],x,y,z);
	MoveDynamicObject(dtOBJ[1],x+1.8,y,z,5);
	GetDynamicObjectPos(dtOBJ[2],x,y,z);
	MoveDynamicObject(dtOBJ[2],x-1.8,y,z,5);
}
forward GotoFloor(fid);
public GotoFloor(fid)
{
	MoveDynamicObject(dtOBJ[0],1786.6709,-1303.4305,dtHeight[fid],5);
	MoveDynamicObject(dtOBJ[1],1786.684936,-1303.395996,dtDoorHeight[fid],5);
	MoveDynamicObject(dtOBJ[2],1786.684936,-1303.395996,dtDoorHeight[fid],5);
	new Float:diff = dtHeight[fid] - dtHeight[CurrentFloor];
	if(diff < 0) diff = - diff;
	new Float:time = diff / 5 * 1000;
	new tmp[20];
	format(tmp,sizeof(tmp),"%.0f",time+2000);
	SetTimer("OpenDoor", strval(tmp), false);
	CurrentFloor = fid;
}
