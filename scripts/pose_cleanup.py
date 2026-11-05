import pathlib,json,xml.etree.ElementTree as E
p=pathlib.Path('src/server/VehicleAppearance.luau');s=p.read_text();s=s.replace(' local clone = template:Clone()',''' -- Hide vendor wheel display geometry, retaining its physics and weld hierarchy.
 for _,wheel in {front,rear} do
  for _,item in wheel:GetDescendants() do
   if item:IsA("BasePart") and not item:GetAttribute("BodyFitMesh") then item.Transparency=1 end
  end
 end
 local clone = template:Clone()''');p.write_text(s,encoding='utf-8')
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c'
tree=E.parse('assets/vendor/AChassisMotorcycle.rbxmx');t=tree.getroot().find("Item/Item[@class='ModuleScript']/Properties/*[@name='Source']").text
code='game:GetService("ScriptEditorService"):UpdateSourceAsync(game.ServerScriptService.Server.VehicleAppearance,function() return [====['+s+']====] end)'
# Resolve the module via descendants rather than assuming Rojo folder name.
code='local m=game.ServerScriptService:FindFirstChild("VehicleAppearance",true) assert(m) game:GetService("ScriptEditorService"):UpdateSourceAsync(m,function() return [====['+s+']====] end) game:GetService("ScriptEditorService"):UpdateSourceAsync(workspace.ChassisTestBike["A-Chassis Tune"],function() return [====['+t+']====] end) return "current source and tune synced"'
r=[dict(label='pose-source-sync',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Edit',code=code)),dict(label='pose-clean-play',name='start_stop_play',arguments=dict(studio_id=sid,is_start=True))]
pathlib.Path('docs/mcp-check/pose-clean-request.json').write_text(json.dumps(r))