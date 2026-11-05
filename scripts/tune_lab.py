import xml.etree.ElementTree as E,pathlib,json
p=pathlib.Path('assets/vendor/AChassisMotorcycle.rbxmx');tree=E.parse(p)
tune=tree.getroot().find("Item/Item[@class='ModuleScript']/Properties/*[@name='Source']")
start='-- RACE RAID LAB TUNE START'
s=tune.text.split(start)[0] if start in tune.text else tune.text.replace('return Tune','')
s+='''-- RACE RAID LAB TUNE START
-- Experimental fictional starter tune; not production balance.
Tune.Weight = 155
Tune.PeakTorque = 7
Tune.PeakTorqueRPM = 6000
Tune.IdleTorque = 3
Tune.Redline = 9000
Tune.RedlineTorque = 5.5
Tune.ShiftRPM = 8000
Tune.PeakRPM = 8000
Tune.HPLimit = 10
Tune.SpeedLimit = 65
Tune.MaxLean = 35
Tune.CollisionVisible = false
Tune.SusVisible = false
return Tune
'''
tune.text=s;tree.write(p,encoding='utf-8',xml_declaration=True)
c=json.loads(pathlib.Path('default.project.json').read_text());c['tree']['Workspace']['TestSurface']['$properties']['Size']=[400,1,1200];pathlib.Path('default.project.json').write_text(json.dumps(c,indent=2),encoding='utf-8')
code='assert(workspace:FindFirstChild("ChassisTestBike")); workspace.TestSurface.Size=Vector3.new(400,1,1200); game:GetService("ScriptEditorService"):UpdateSourceAsync(workspace.ChassisTestBike["A-Chassis Tune"], function() return [====['+s+']====] end); return "Tune updated"'
requests=[dict(label='tune-studio',name='execute_luau',arguments=dict(studio_id='bc26bc01-2367-43e5-becd-edd0fac7ba3e',datamodel_type='Edit',code=code)),dict(label='tuned-play',name='start_stop_play',arguments=dict(studio_id='bc26bc01-2367-43e5-becd-edd0fac7ba3e',is_start=True))]
pathlib.Path('docs/mcp-check/tune.json').write_text(json.dumps(requests),encoding='utf-8')