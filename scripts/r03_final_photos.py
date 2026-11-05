from pathlib import Path
import json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
def add(l,n,**a):r.append(dict(label=l,name=n,arguments=dict(studio_id=sid,**a)))
add('r03-final-hide-entry','execute_luau',datamodel_type='Client',code='local p=game.Players.LocalPlayer local e=p.PlayerGui:FindFirstChild("StealEntry") if e then e:Destroy() end p:SetAttribute("EntryOpen",false) return "review HUD only"')
add('r03-main-walking','screen_capture',capture_id='r03-main-walking')
add('r03-final-garage-click','user_mouse_input',datamodel_type='Client',actions=[dict(action='moveTo',instance_path='LocalPlayer.PlayerGui.RaceAndRaidLabHUD.HUDRoot.Navigation.Nav1'),dict(action='mouseButtonClick',mouse_button='left'),dict(action='wait',wait_time_ms=500)])
add('r03-final-garage-shot','screen_capture',capture_id='r03-final-garage-shot')
add('r03-final-close-click','user_mouse_input',datamodel_type='Client',actions=[dict(action='moveTo',instance_path='LocalPlayer.PlayerGui.RaceAndRaidLabHUD.Menu.Close'),dict(action='mouseButtonClick',mouse_button='left'),dict(action='wait',wait_time_ms=400)])
add('r03-final-mount','execute_luau',datamodel_type='Server',code='workspace.ChassisTestBike.DriveSeat:Sit(game.Players:GetPlayers()[1].Character.Humanoid) return "mounted"')
add('r03-final-driving-input','user_keyboard_input',datamodel_type='Client',actions=[dict(action='wait',wait_time_ms=700),dict(action='keyPress',key_code='E'),dict(action='wait',wait_time_ms=400)])
add('r03-main-driving','screen_capture',capture_id='r03-main-driving')
add('r03-final-hud-integrity','execute_luau',datamodel_type='Client',code='local p=game.Players.LocalPlayer local g=p.PlayerGui.RaceAndRaidLabHUD local a={} for _,v in game:GetService("LogService"):GetLogHistory() do if v.messageType==Enum.MessageType.MessageError and (v.message:find("LabHUD") or v.message:find("RaceAndRaid.UI.Components") or v.message:find("UITheme")) then table.insert(a,v.message) end end return {logoLoaded=g.HUDRoot.Brand.Logo.IsLoaded,gear=g.HUDRoot.DrivingDock.Gear.Text,speedVisible=g.HUDRoot.DrivingDock.Speed.Visible,menuClosed=not g.Menu.Visible,errors=a,streaming=workspace.StreamingEnabled}')
Path('docs/mcp-check/r03-final-photo-request.json').write_text(json.dumps(r))