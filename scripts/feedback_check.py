import pathlib,json
r=json.loads(pathlib.Path('docs/mcp-check/course-loop-check.json').read_text())
for v in r:
 v['label']='feedback-'+v['label']
 if v['name']=='execute_luau' and v['arguments']['datamodel_type']=='Client':
  v['arguments']['code']='local p=game.Players.LocalPlayer local g=p.PlayerGui.RaceAndRaidLabHUD return {cargo=p:GetAttribute("TestCargo"),secured=p:GetAttribute("TestSecured"),message=p:GetAttribute("CargoMessage"),waypoint=g.CargoWaypoint.Adornee.Name,noticeVisible=g.CargoFeedback.Visible}'
r.append(dict(label='feedback-errors',name='execute_luau',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',datamodel_type='Client',code='local a={} for _,v in game:GetService("LogService"):GetLogHistory() do if v.messageType==Enum.MessageType.MessageError and (v.message:find("LabHUD") or v.message:find("CargoWaypoint")) then table.insert(a,v.message) end end return a')))
pathlib.Path('docs/mcp-check/feedback-check.json').write_text(json.dumps(r))