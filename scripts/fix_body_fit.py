import pathlib,json
p=pathlib.Path('scripts/export_body.py');s=p.read_text();s=s.replace('props.update(Anchored=True','props["InitialSize"]=v["MeshSize"]\n props.update(Anchored=True');p.write_text(s,encoding='utf-8')
p=pathlib.Path('src/server/VehicleAppearance.luau');s=p.read_text();s=s.replace(' local body = bike:WaitForChild("Body")',''' for _,wheel in {front,rear} do
  for _,name in {"Parts","Fixed","WheelFixed"} do
   if not wheel:FindFirstChild(name) then
    local group=Instance.new("Model");group.Name=name;group.Parent=wheel
   end
  end
 end
 local seat=bike:FindFirstChild("DriveSeat")
 if seat and seat:IsA("BasePart") then seat.Transparency=1 end
 local body = bike:WaitForChild("Body")''');p.write_text(s,encoding='utf-8')
req=[dict(label='body-fit-diagnosis',name='execute_luau',arguments=dict(studio_id='4444ef2a-1901-4b17-a9a1-f39e08afd804',datamodel_type='Server',code='local out={} for _,v in game:GetService("LogService"):GetLogHistory() do if string.find(v.message,"VehicleAppearance") or string.find(v.message,"Fixed") then table.insert(out,v.message) end end return out'))]
pathlib.Path('docs/mcp-check/body-diagnose-request.json').write_text(json.dumps(req))