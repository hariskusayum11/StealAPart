from pathlib import Path
import json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
r.append(dict(label='r02-overview-fog-off',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Server',code='local a=game.Lighting:FindFirstChild("HighwayAtmosphere") if a then a:SetAttribute("ReviewSavedDensity",a.Density) a.Density=0 a.Haze=0 end return "Atmosphere reduced for structural review screenshots only"')))
for label,pos,target in [('r02-highway-order',[1350,1650,1700],[1350,15,70]),('r02-world-profile',[1350,650,1100],[1350,10,80])]:r.append(dict(label=label,name='screen_capture',arguments=dict(studio_id=sid,capture_id=label,camera_position=pos,look_at_position=target)))
r.append(dict(label='r02-overview-fog-restore',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Server',code='local a=game.Lighting:FindFirstChild("HighwayAtmosphere") if a then a.Density=a:GetAttribute("ReviewSavedDensity") or .26 a.Haze=1.5 end return "Runtime atmosphere restored"')))
Path('docs/mcp-check/r02-overview-request.json').write_text(json.dumps(r))