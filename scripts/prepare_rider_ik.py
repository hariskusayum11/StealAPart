import pathlib,xml.etree.ElementTree as E,json,shutil,datetime
root=pathlib.Path('.')
backup=root/'backups'/('pre-rider-ik-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'));backup.mkdir(parents=True)
shutil.copytree('src',backup/'src');shutil.copy2('assets/vendor/AChassisMotorcycle.rbxmx',backup/'AChassisMotorcycle.rbxmx')
t=E.parse('assets/vendor/AChassisMotorcycle.rbxmx'); disabled=[]
for item in t.iter('Item'):
 props=item.find('Properties')
 if props is None:continue
 src=props.find("*[@name='Source']")
 if src is None:continue
 s=src.text or ''
 if ('TuckInSpeed = 70' in s and 'handler' in s) or 'F.CreatePlayer = function' in s:
  node=props.find("*[@name='Disabled']")
  if node is None:node=E.SubElement(props,'bool',name='Disabled')
  node.text='true';disabled.append(props.find("*[@name='Name']").text)
t.write('assets/vendor/AChassisMotorcycle.rbxmx',encoding='utf-8',xml_declaration=True)
print('Disabled legacy avatar replacement scripts:',disabled)
code='''local b=workspace.ChassisTestBike local out={} for _,v in b:GetDescendants() do if v:IsA("LuaSourceContainer") then local s=v.Source if (s:find("TuckInSpeed = 70",1,true) and s:find("handler",1,true)) or s:find("F.CreatePlayer = function",1,true) then v.Disabled=true table.insert(out,v:GetFullName()) end end end return out'''
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c'
r=[dict(label='rider-disable-legacy',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='rider-inspect-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/rider-initial.json').write_text(json.dumps(r))