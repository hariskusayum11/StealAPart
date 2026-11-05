import pathlib,json
p=pathlib.Path('src/server/RiderPose.luau');s=p.read_text();s=s.replace('Vector3.new(sign*1.0,-0.95,-0.65)','Vector3.new(sign*1.0,-0.95,-1.35)');p.write_text(s,encoding='utf-8')
p=pathlib.Path('scripts/prepare_chassis.py');s=p.read_text();needle=" src.text=s\n";replacement=''' src.text=s
 if ('TuckInSpeed = 70' in s and 'handler' in s) or 'F.CreatePlayer = function' in s:
  disabled=p.find("*[@name='Disabled']")
  if disabled is None:disabled=E.SubElement(p,'bool',name='Disabled')
  disabled.text='true';patches.append(name+': disabled cloned-avatar animation; RiderPose handles real R15 avatar')
''';assert needle in s;s=s.replace(needle,replacement);p.write_text(s,encoding='utf-8')
p=pathlib.Path('docs/VENDOR_PATCHES.md');s=p.read_text(encoding='utf-8');s+='\n## Real rider pose (2026-11-03)\nAnims client (TuckInSpeed) and FEAnims server avatar-replacement scripts are disabled, retained intact under MPL. They replaced/hid the actual avatar with a fixed-size cloned rig. RiderPose now uses real R15 limbs and native IK, with cleanup on dismount/death. Original vendor model is preserved in backups/pre-rider-ik-*. Chassis physics and initialization are retained. prepare_chassis.py reapplies these flags.\n';p.write_text(s,encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c'
code='local parent=game.ServerScriptService:FindFirstChild("Lab",true).Parent '
for name,path in [('RiderPose','src/server/RiderPose.luau'),('Lab','src/server/Lab.server.luau')]:
 source=pathlib.Path(path).read_text(encoding='utf-8');code+='do local m=parent:FindFirstChild("'+name+'") assert(m) game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+source+']====] end) end '
code+='workspace.Spawn.Transparency=1 workspace.Spawn.CanCollide=false return "Final pose source synced"'
r=[dict(label='rider-delivery-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='rider-delivery-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='rider-delivery-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/rider-delivery-sync.json').write_text(json.dumps(r))