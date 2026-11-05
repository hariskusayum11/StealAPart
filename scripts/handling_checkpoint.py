import pathlib,json
p=pathlib.Path('src/server/VehicleAppearance.luau');s=p.read_text();needle=' bike:SetAttribute("BodyFitVersion",1)';s=s.replace(needle,''' -- Initialization can re-enable debug suspension visuals after the body is fitted.
 if seat and seat:IsA("VehicleSeat") then
  local function hideDebug()
   for _,item in bike:GetDescendants() do
    if item:IsA("Constraint") then item.Visible=false end
   end
  end
  seat:GetPropertyChangedSignal("Disabled"):Connect(function()
   if not seat.Disabled then hideDebug() end
  end)
  hideDebug()
 end
'''+needle);p.write_text(s,encoding='utf-8')
p=pathlib.Path('TASKS.md');p.write_text(p.read_text(encoding='utf-8')+'''\n## 2026-11-03 — Body-equipped handling smoke test\n- Studio ChassisLab: 38 fitted meshes; rider remained seated.\n- Throttle: 30.295 studs/s. Left steering for 0.9s changed heading from (0.281,-0.016,-0.960) to (-0.214,-0.025,-0.976); up.Y=0.9695 (no fall in this test).\n- Brake for 2.5s: 31.246 -> 2.732 studs/s, up.Y=0.99975. Not a full stop or handling acceptance test.\n- Evidence: docs/mcp-check/handling-*.json and handling-seated-shot.png.\n- Added initialization-completion debug-constraint visibility cleanup; Build verification only for this new callback.\n- Outstanding: refine seated pose, duplicate vendor gauge UI, mobile, performance and full garage benchmark.\n''',encoding='utf-8')
r=[dict(label='handling-stop',name='start_stop_play',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',is_start=False))]
pathlib.Path('docs/mcp-check/handling-stop-request.json').write_text(json.dumps(r))