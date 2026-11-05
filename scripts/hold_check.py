import pathlib,json
r=json.loads(pathlib.Path('docs/mcp-check/feedback-check.json').read_text())
for v in r:
 v['label']='hold-'+v['label']
 if v['name']=='user_keyboard_input':
  v['arguments']['actions']=[dict(action='wait',wait_time_ms=600),dict(action='keyDown',key_code='F'),dict(action='wait',wait_time_ms=650),dict(action='keyUp',key_code='F'),dict(action='wait',wait_time_ms=300)]
r.append(dict(label='hold-integrity',name='execute_luau',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',datamodel_type='Server',code='local c=game.Players:GetPlayers()[1].Character local n=0 for _,v in workspace.CargoTestCourse:GetChildren() do if v.Name=="PickupBay" or v.Name=="DepositBay" then assert(not v.CanCollide) n+=1 end end return {markers=n,spawnShield=c:FindFirstChildOfClass("ForceField")~=nil,hold=workspace.TestScrapPickup.ProximityPrompt.HoldDuration}')))
pathlib.Path('docs/mcp-check/hold-check.json').write_text(json.dumps(r))