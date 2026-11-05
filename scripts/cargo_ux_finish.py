import pathlib,json
p=pathlib.Path('src/server/Lab.server.luau');s=p.read_text(encoding='utf-8');s=s.replace('p.KeyboardKeyCode = Enum.KeyCode.F','p.KeyboardKeyCode = Enum.KeyCode.F\n p.HoldDuration = 0.35')
s=s.replace('local lastPickup = 0','''local function initialize(player: Player)
 if player:GetAttribute("TestCargo")==nil then player:SetAttribute("TestCargo",0) end
 if player:GetAttribute("TestSecured")==nil then player:SetAttribute("TestSecured",0) end
end
Players.PlayerAdded:Connect(initialize)
for _,player in Players:GetPlayers() do initialize(player) end
local lastPickup = 0''');p.write_text(s,encoding='utf-8')
p=pathlib.Path('default.project.json');c=json.loads(p.read_text());c['tree']['Workspace']['Spawn']['$properties']['Duration']=0;p.write_text(json.dumps(c,indent=2),encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';source=pathlib.Path('src/server/Lab.server.luau').read_text(encoding='utf-8')
code='local m=game.ServerScriptService:FindFirstChild("Lab",true) game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+source+']====] end) workspace.Spawn.Duration=0 return "cargo UX synced"'
r=[dict(label='cargo-ux-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='cargo-ux-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code))]
pathlib.Path('docs/mcp-check/cargo-ux-sync.json').write_text(json.dumps(r))