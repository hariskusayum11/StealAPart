import xml.etree.ElementTree as E,pathlib,json,shutil
root=E.parse('build/ChassisAudit.rbxlx').getroot(); storage=root.find('Item'); bike=storage.find('Item')
bike.find("Properties/*[@name='Name']").text='ChassisTestBike'
patches=[]
for item in bike.iter('Item'):
 p=item.find('Properties'); src=p.find("*[@name='Source']") if p is not None else None
 if src is None:continue
 s=src.text or ''; name=p.find("*[@name='Name']").text
 if 'local function update(player, packet)' in s:
  length=17 if 'local RPM, Throttle' in s else 8
  guard=f'''local remoteLast = {{}}
local function update(player, packet)
	local occupant = bike.DriveSeat.Occupant
	if not occupant or occupant.Parent ~= player.Character then return end
	if typeof(packet) ~= "buffer" or buffer.len(packet) ~= {length} then return end
	local now = os.clock()
	if now - (remoteLast[player] or 0) < 1/60 then return end
	remoteLast[player] = now
'''
  if length==17:guard+='\tfor _, offset in {7, 11} do local n=buffer.readf32(packet,offset); if n~=n or math.abs(n)>100 then return end end\n'
  s=s.replace('local function update(player, packet)\n',guard,1);patches.append(name+': occupant, packet length, rate guards')
 if 'F[Fnc](...)' in s:
  s=s.replace('F[Fnc](...)','''local character = select(1, ...)
	if character ~= pl.Character or not character then return end
	if Fnc ~= "CreatePlayer" and Fnc ~= "RemovePlayer" then return end
	if Fnc == "CreatePlayer" and bike.DriveSeat.Occupant ~= character:FindFirstChildOfClass("Humanoid") then return end
	F[Fnc](...)''');patches.append(name+': function and character allowlist')
 if s!=src.text:s='-- RACE & RAID local safety patch, 2026-11-03. MPL-2.0; see docs/VENDOR_PATCHES.md\n'+s
 src.text=s
 if ('TuckInSpeed = 70' in s and 'handler' in s) or 'F.CreatePlayer = function' in s:
  disabled=p.find("*[@name='Disabled']")
  if disabled is None:disabled=E.SubElement(p,'bool',name='Disabled')
  disabled.text='true';patches.append(name+': disabled cloned-avatar animation; RiderPose handles real R15 avatar')
root.remove(storage);root.append(bike)
pathlib.Path('assets/vendor').mkdir(exist_ok=True)
E.ElementTree(root).write('assets/vendor/AChassisMotorcycle.rbxmx',encoding='utf-8',xml_declaration=True)
shutil.copyfile('assets/quarantine/A-Chassis-LICENSE.txt','assets/vendor/A-Chassis-LICENSE.txt')
pathlib.Path('docs/VENDOR_PATCHES.md').write_text('# A-Chassis 1.7.2M local changes\n\nSource: https://github.com/lisphm/A-Chassis/releases/tag/v1.7.2-stable\nLicense: MPL-2.0, preserved in assets/vendor/A-Chassis-LICENSE.txt. Modified source is embedded in the readable XML and must remain available under MPL when distributed.\n\n'+ '\n'.join('- '+p for p in patches)+'\n\nThese are preliminary remote guards, NOT a complete security review or anti-speed-cheat implementation. Source original retained in quarantine. Model is a chassis reference, NOT approved Street Cub final art. No purchase or publish.\n',encoding='utf-8')
config=json.loads(pathlib.Path('default.project.json').read_text())
config['tree']['Workspace']['ChassisTestBike']={'$path':'assets/vendor/AChassisMotorcycle.rbxmx'}
config['tree']['Workspace']['TestSurface']['$properties']['Position']=[0,-1,0]
pathlib.Path('default.project.json').write_text(json.dumps(config,indent=2),encoding='utf-8')
print(patches)