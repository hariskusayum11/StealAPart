import pathlib,json
p=pathlib.Path('src/server/CargoCourse.luau');s=p.read_text(encoding='utf-8');needle=' model.Parent=workspace';insert=''' -- Flat painted stopping bays: no geometry in the wheel path.
 for _,bay in {{position=Course.Pickup,color=Color3.fromRGB(245,184,46),name="PickupBay"},{position=Course.Deposit,color=Color3.fromRGB(39,197,229),name="DepositBay"}} do
  for _,offset in {Vector3.new(-4,0,0),Vector3.new(4,0,0),Vector3.new(0,0,-5),Vector3.new(0,0,5)} do
   local edge=part(bay.name,if offset.X~=0 then Vector3.new(.2,.02,10) else Vector3.new(8,.02,.2),bay.position+offset+Vector3.new(0,-.465,0),bay.color,Enum.Material.SmoothPlastic)
   edge.CanCollide=false;edge.CanTouch=false
  end
 end
''';assert needle in s;s=s.replace(needle,insert+needle);p.write_text(s,encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';source=s
code='local m=game.ServerScriptService:FindFirstChild("CargoCourse",true) game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+source+']====] end) return "bay markers synced"'
r=[dict(label='bay-stop',name='start_stop_play',arguments=dict(studio_id=sid,is_start=False)),dict(label='bay-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='bay-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/bay-sync.json').write_text(json.dumps(r))