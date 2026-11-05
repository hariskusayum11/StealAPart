import pathlib,shutil,datetime,json
backup=pathlib.Path('backups')/('pre-cargo-feedback-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'));shutil.copytree('src',backup/'src')
p=pathlib.Path('src/server/Lab.server.luau');s=p.read_text(encoding='utf-8');s=s.replace('local lastPickup = 0','''local lastPickup = 0
local function feedback(player: Player, message: string)
 player:SetAttribute("CargoMessage",message)
 player:SetAttribute("CargoMessageId",(player:GetAttribute("CargoMessageId") or 0)+1)
end''')
s=s.replace('if cargo[player] or os.clock()-lastPickup < 2 or not inRange(player, Course.Pickup) then return end','''if not inRange(player, Course.Pickup) then feedback(player,"ขึ้นรถ เข้าใกล้จุด แล้วเบรกให้ช้าก่อนเก็บ");return end
 if cargo[player] then feedback(player,"Cargo เต็มแล้ว กลับไปฝากที่จุดจอด");return end
 if os.clock()-lastPickup < 2 then feedback(player,"กำลังเตรียมอะไหล่ กรุณารอสักครู่");return end''')
s=s.replace('player:SetAttribute("TestCargo", 1)','player:SetAttribute("TestCargo", 1)\n feedback(player,"เก็บอะไหล่แล้ว! กลับจุดจอดเพื่อฝาก Cargo")')
s=s.replace('if not cargo[player] or not inRange(player, Course.Deposit) then return end','''if not inRange(player, Course.Deposit) then feedback(player,"ขี่รถเข้าใกล้จุดฝากและเบรกให้ช้าก่อน");return end
 if not cargo[player] then feedback(player,"ยังไม่มี Cargo ไปเก็บอะไหล่ที่ลานก่อน");return end''')
s=s.replace('player:SetAttribute("TestSecured", secured[player])','player:SetAttribute("TestSecured", secured[player])\n feedback(player,"ฝากสำเร็จ! ออกไปเก็บอะไหล่รอบถัดไปได้")')
p.write_text(s,encoding='utf-8')
p=pathlib.Path('src/client/LabHUD.client.luau');s=p.read_text(encoding='utf-8');needle='-- Hide only legacy gauge art.';insert='''local notice=panel("CargoFeedback",UDim2.new(.85,0,0,48),UDim2.new(.5,0,0,64),Vector2.new(.5,0))
local noticeLimit=Instance.new("UISizeConstraint");noticeLimit.MaxSize=Vector2.new(500,48);noticeLimit.Parent=notice
local noticeText=text(notice,"Message",UDim2.new(1,-16,1,0),UDim2.fromOffset(8,0),15,gold)
notice.Visible=false
local messageUntil=0
player:GetAttributeChangedSignal("CargoMessageId"):Connect(function()
 noticeText.Text=tostring(player:GetAttribute("CargoMessage") or "")
 messageUntil=os.clock()+3.5
 notice.Visible=true
end)
local waypoint=Instance.new("BillboardGui")
waypoint.Name="CargoWaypoint";waypoint.Size=UDim2.fromOffset(180,42);waypoint.StudsOffsetWorldSpace=Vector3.new(0,5,0)
waypoint.AlwaysOnTop=true;waypoint.MaxDistance=220;waypoint.Parent=gui
local waypointText=text(waypoint,"Destination",UDim2.fromScale(1,1),UDim2.fromOffset(0,0),15,gold)
waypointText.BackgroundTransparency=.15;waypointText.BackgroundColor3=Color3.fromRGB(17,25,35)
''';s=s.replace(needle,insert+needle)
s=s.replace('driving.Visible=riding','driving.Visible=riding\n notice.Visible=os.clock()<messageUntil')
s=s.replace('local root=character and','waypoint.Adornee=if point and point:IsA("BasePart") then point else nil\n waypoint.Enabled=point~=nil\n waypointText.Text=if carrying then "▼ จุดฝาก Cargo" else "▼ ลานอะไหล่"\n local root=character and')
s=s.replace('hint.Text=if riding then','hint.Text=if riding and distance<14 then "เบรกให้ช้า แล้วกด F เพื่อ"..(if carrying then "ฝาก Cargo" else "เก็บอะไหล่") elseif riding then')
p.write_text(s,encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';code=''
for service,name,path in [('game.ServerScriptService','Lab','src/server/Lab.server.luau'),('game.StarterPlayer.StarterPlayerScripts','LabHUD','src/client/LabHUD.client.luau')]:
 source=pathlib.Path(path).read_text(encoding='utf-8');code+='do local m='+service+':FindFirstChild("'+name+'",true) assert(m) game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+source+']====] end) end '
code+='return "feedback synced"'
r=[dict(label='feedback-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='feedback-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='feedback-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/feedback-sync.json').write_text(json.dumps(r))