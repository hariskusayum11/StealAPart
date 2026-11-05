from pathlib import Path
import shutil,datetime,json
b=Path('backups')/('pre-highway-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'));b.mkdir(parents=True);shutil.copytree('src',b/'src');shutil.copy2('default.project.json',b/'default.project.json')
shutil.copy2(r'C:\Users\SC1220-000\.codex\attachments\65df5b5a-0eb2-4d5d-9c20-1ae4856b9522\Pasted text.txt','docs/THAILAND_HIGHWAY_REBUILD_SOURCE.md')
names=['ซอยช่างบ้านเรา','ตลาดน้ำอะไหล่ซิ่ง','ทุ่งนาซิ่งสายฝุ่น','ถนนตลาดแซ่บ','ดอยโค้งร้อยศอก','สวนยางสายแรง','ท่าเรือซิ่งริมเล','นิคมเหล็กเดือด','บางกอกไนท์เรซ','อุโมงค์ช่างเถื่อน','นครนีออนไทยแลนด์','คลังอะไหล่ตำนาน']
s='--!strict\nreturn {\n Version=3,\n Pickup=Vector3.new(-250,0,-40),\n Deposit=Vector3.new(-760,0,90),\n BikeStart=CFrame.new(-760,2.85,80),\n MinX=-1250,MaxX=3800,MaxZ=1100,\n Plots={\n'
for i,(x,z) in enumerate([(x,z) for z in [90,-90] for x in [-760,-640,-520]],1):s+=f'  {{id="G{i}",position=Vector3.new({x},0,{z}),label="อู่ {i} / Blockout"}},\n'
s+=' },\n Zones={\n'
for i,n in enumerate(names):s+=f'  {{id={i+1},name="{n}",position=Vector3.new({-250+i*300},0,{int([0,-70,50,110,0,-100][i%6])})}},\n'
s+=' },\n Facilities={\n'
for name,x,z in [('Race Hub / สนามทดสอบ',-900,-300),('Parts Market',-900,300),('Shop',-420,300),('Upgrade Center',-600,300),('Event Plaza',-420,-300)]:s+=f'  {{name="{name}",position=Vector3.new({x},0,{z})}},\n'
s+=' },\n}\n';Path('src/shared/HubLayout.luau').write_text(s,encoding='utf-8')
p=Path('src/server/Lab.server.luau');s=p.read_text(encoding='utf-8');s=s.replace('math.abs(p.X)>350 or math.abs(p.Z)>350','p.X < -1250 or p.X > 3800 or math.abs(p.Z)>1100');p.write_text(s,encoding='utf-8')
p=Path('default.project.json');c=json.loads(p.read_text());c['tree']['Workspace']['$properties'].update(StreamingEnabled=True,StreamingMinRadius=256,StreamingTargetRadius=768);c['tree']['Workspace']['Spawn']['$properties']['CFrame']=[-752,3,100,1,0,0,0,1,0,0,0,1];p.write_text(json.dumps(c,indent=2),encoding='utf-8')
p=Path('PROJECT_MEMORY.md');p.write_text(p.read_text(encoding='utf-8')+'\n- Latest owner World Rebuild instruction (2026-11-04), docs/THAILAND_HIGHWAY_REBUILD_SOURCE.md, supersedes roundabout/island layout: continuous grounded highway Garage City -> Zones 01–12, six garages in 2x3, core facilities; Shared Loot replaces prior per-player-loot design. Blockout approval required before detailed zone visuals. Latest staged geometry is provisional; no full gameplay completion implied.\n',encoding='utf-8')