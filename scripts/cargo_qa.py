import pathlib,json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[dict(label='cargo-qa-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
base=json.loads(pathlib.Path('docs/mcp-check/course-loop-check.json').read_text())
for start in [3,0,0,3,3]:
 for item in base[start:start+3]:
  item=json.loads(json.dumps(item));item['label']='cargo-qa-'+str(len(r))
  if item['name']=='execute_luau' and item['arguments']['datamodel_type']=='Client':
   item['arguments']['code']='local p=game.Players.LocalPlayer return {cargo=p:GetAttribute("TestCargo"),secured=p:GetAttribute("TestSecured"),message=p:GetAttribute("CargoMessage"),notice=p.PlayerGui.RaceAndRaidLabHUD.CargoFeedback.Visible}'
  r.append(item)
r.append(dict(label='cargo-qa-shot',name='screen_capture',arguments=dict(studio_id=sid,capture_id='cargo-qa-shot')))
pathlib.Path('docs/mcp-check/cargo-qa-request.json').write_text(json.dumps(r))