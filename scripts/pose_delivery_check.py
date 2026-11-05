import json,pathlib
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c'
r=json.loads(pathlib.Path('docs/mcp-check/handling-run.json').read_text())[:-1]
for v in r:v['label']='pose-delivery-'+v['label']
r.extend(json.loads(pathlib.Path('docs/mcp-check/rider-final-test.json').read_text())[-3:])
r.append(dict(label='pose-delivery-integrity',name='execute_luau',arguments=dict(studio_id=sid,datamodel_type='Server',code='local b=workspace.ChassisTestBike local visible=0 local rig=b.Misc.Anims for _,v in rig:GetDescendants() do if v:IsA("BasePart") and v.Transparency<1 then visible+=1 end end local errors={} for _,v in game:GetService("LogService"):GetLogHistory() do if v.message:find("RiderPose") and v.messageType==Enum.MessageType.MessageError then table.insert(errors,v.message) end end return {visibleCloneParts=visible,seatAnchored=b.DriveSeat.Anchored,bodyMeshes=b:GetAttribute("BodyMeshCount"),poseErrors=errors}')))
pathlib.Path('docs/mcp-check/pose-delivery-check.json').write_text(json.dumps(r))