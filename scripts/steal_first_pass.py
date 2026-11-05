from pathlib import Path
import json,shutil,datetime
b=Path('backups')/('pre-steal-implementation-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'));b.mkdir(parents=True);shutil.copytree('src',b/'src');shutil.copy2('default.project.json',b/'default.project.json')
p=Path('PROJECT_MEMORY.md');s=p.read_text(encoding='utf-8');s=s.replace('- Current authorization: design/audit/documentation under handoff 30.1. The owner confirmed name and latest gameplay direction; this does not approve implementing all new systems. Obtain implementation approval before changing game scripts/Studio to the expanded design.','- Current authorization: owner explicitly approved implementation on 2026-11-04 (เริ่มแก้และสร้างได้เลย). Develop handoff 30.1 incrementally, retaining existing engineering work. No publish/purchase/system installation authorization.');p.write_text(s,encoding='utf-8')
p=Path('AGENTS.md');s=p.read_text(encoding='utf-8').replace('Current expanded-design phase is design/documentation only until implementation is authorized','Owner approved implementation of the expanded design on 2026-11-04');p.write_text(s,encoding='utf-8')
p=Path('default.project.json');c=json.loads(p.read_text());c['name']='StealAPartBenchmark'
for n in ['Spawn','TestSurface']:
 props=c['tree']['Workspace'][n]['$properties'];pos=props.pop('Position',None)
 if pos:props['CFrame']=pos+[1,0,0,0,1,0,0,0,1]
c['tree']['Workspace']['TestSurface']['$properties'].update(Color=[.19,.23,.25],Material='Concrete')
c['tree']['Lighting']={'$properties':{'ClockTime':15,'Brightness':2,'Ambient':[.35,.38,.46],'OutdoorAmbient':[.48,.51,.58],'ExposureCompensation':0,'GlobalShadows':True}}
p.write_text(json.dumps(c,indent=2),encoding='utf-8')
p=Path('src/server/CargoCourse.luau');s=p.read_text(encoding='utf-8');s=s.replace('local asphalt=Color3.fromRGB(43,48,54)','local asphalt=Color3.fromRGB(65,70,79)');s=s.replace('Vector3.new(-40,6,9)','Vector3.new(-23,6,16)');p.write_text(s,encoding='utf-8')
p=Path('src/client/LabHUD.client.luau');s=p.read_text(encoding='utf-8');s=s.replace('Color3.fromRGB(17,25,35);f.BackgroundTransparency=0.08','Color3.fromRGB(8,19,48);f.BackgroundTransparency=0.04');s=s.replace('stroke.Color=Color3.fromRGB(65,89,106);stroke.Parent=f','stroke.Color=Color3.fromRGB(39,197,229);stroke.Thickness=2;stroke.Parent=f\n local gradient=Instance.new("UIGradient");gradient.Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(92,99,170));gradient.Rotation=90;gradient.Parent=f')
s=s.replace('local status=panel','local brand=panel("Brand",UDim2.fromOffset(190,38),UDim2.new(0,16,0,54),Vector2.zero)\ntext(brand,"Title",UDim2.fromScale(1,1),UDim2.fromOffset(0,0),20,gold).Text="STEAL A PART!"\nlocal status=panel',1)
p.write_text(s,encoding='utf-8')
p=Path('src/server/Lab.server.luau');s=p.read_text(encoding='utf-8').replace('Chassis Lab — ยังไม่ใช่ Street Cub','Street Cub • รถทดสอบ').replace('RaceAndRaid-ChassisLab-01','StealAPart-Slice-01');p.write_text(s,encoding='utf-8')
# Sync only named project objects and source; preserve unrelated Studio content.
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';code=''
for name,path in [('CargoCourse','src/server/CargoCourse.luau'),('Lab','src/server/Lab.server.luau')]:
 source=Path(path).read_text(encoding='utf-8');code+='game:GetService("ScriptEditorService"):UpdateSourceAsync(game.ServerScriptService:FindFirstChild("'+name+'",true),function() return [====['+source+']====] end) '
source=Path('src/client/LabHUD.client.luau').read_text(encoding='utf-8');code+='game:GetService("ScriptEditorService"):UpdateSourceAsync(game.StarterPlayer.StarterPlayerScripts:FindFirstChild("LabHUD",true),function() return [====['+source+']====] end) '
code+='workspace.TestSurface.CFrame=CFrame.new(0,-1,0) workspace.TestSurface.Color=Color3.fromRGB(48,59,64) workspace.TestSurface.Material=Enum.Material.Concrete workspace.Spawn.CFrame=CFrame.new(0,2,0) local l=game.Lighting l.ClockTime=15 l.Brightness=2 l.Ambient=Color3.new(.35,.38,.46) l.OutdoorAmbient=Color3.new(.48,.51,.58) return "source and floor corrected"'
r=[dict(label='steal-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='steal-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='steal-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))];Path('docs/mcp-check/steal-sync.json').write_text(json.dumps(r))