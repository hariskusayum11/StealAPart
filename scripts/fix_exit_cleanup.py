import pathlib,xml.etree.ElementTree as E,json
p=pathlib.Path('assets/vendor/AChassisMotorcycle.rbxmx');t=E.parse(p)
old='shutdownEvent.OnServerEvent:Connect(function(player)\n\tlocal occupant = bike.DriveSeat.Occupant\n\tif not occupant or occupant.Parent ~= player.Character then return end'
new='shutdownEvent.OnServerEvent:Connect(function(player)\n\t-- Exit cleanup is scoped to this player GUI and must work after leaving the seat.'
source=None
for i in t.getroot().iter('Item'):
 s=i.find("Properties/*[@name='Source']")
 if s is not None and old in (s.text or ''):s.text=s.text.replace(old,new);source=s.text
assert source is not None
t.write(p,encoding='utf-8',xml_declaration=True)
prep=pathlib.Path('scripts/prepare_chassis.py');s=prep.read_text();begin=s.index(" if 'shutdownEvent.OnServerEvent:Connect(function(player)' in s:");end=s.index(' if s!=src.text:',begin);s=s[:begin]+s[end:];prep.write_text(s,encoding='utf-8')
req=[dict(label='fix-exit-cleanup',name='execute_luau',arguments=dict(studio_id='bc26bc01-2367-43e5-becd-edd0fac7ba3e',datamodel_type='Edit',code='game:GetService("ScriptEditorService"):UpdateSourceAsync(workspace.ChassisTestBike["A-Chassis Tune"].Initialize,function() return [====['+source+']====] end);return "exit cleanup fixed"')),dict(label='exit-fix-play',name='start_stop_play',arguments=dict(studio_id='bc26bc01-2367-43e5-becd-edd0fac7ba3e',is_start=True))]
pathlib.Path('docs/mcp-check/fix-exit.json').write_text(json.dumps(req),encoding='utf-8')