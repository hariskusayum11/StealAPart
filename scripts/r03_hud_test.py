from pathlib import Path
import json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
def add(label,name,**args):r.append(dict(label=label,name=name,arguments=dict(studio_id=sid,**args)))
def lua(label,code):add(label,'execute_luau',datamodel_type='Client',code=code)
def enter(label):add(label,'user_keyboard_input',datamodel_type='Client',actions=[dict(action='keyPress',key_code='Return'),dict(action='wait',wait_time_ms=200)])
lua('r03-walk-state','local g=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD return {speedVisible=g.HUDRoot.DrivingDock.Speed.Visible,cargo=g.HUDRoot.DrivingDock.Cargo.Text,resources=g.HUDRoot.Resources.Values.Text,zone=g.HUDRoot.Zone.Name.Text}')
# Name property is a string; child lookup must be explicit.
r[-1]['arguments']['code']=r[-1]['arguments']['code'].replace('g.HUDRoot.Zone.Name.Text','g.HUDRoot.Zone:FindFirstChild("Name").Text')
add('r03-hud-walking','screen_capture',capture_id='r03-hud-walking')
for idx in [1,2]:
 lua('r03-select-nav'+str(idx),'game:GetService("GuiService").SelectedObject=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD.HUDRoot.Navigation.Nav'+str(idx)+' return "selected"')
 enter('r03-activate-nav'+str(idx))
 lua('r03-nav'+str(idx)+'-state','local g=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD return {open=g.Menu.Visible,title=g.Menu.Title.Text,body=g.Menu.Body.Text,hudVisible=g.HUDRoot.Visible}')
 if idx==1:add('r03-garage-status','screen_capture',capture_id='r03-garage-status')
 lua('r03-select-close'+str(idx),'game:GetService("GuiService").SelectedObject=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD.Menu.Close return "selected close"')
 enter('r03-close-nav'+str(idx))
lua('r03-select-scale','game:GetService("GuiService").SelectedObject=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD.HUDRoot.Scale return "selected UI scale"')
enter('r03-scale-input')
lua('r03-scale-state','local g=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD return {scale=g.HUDRoot.PreferenceScale.Scale,label=g.HUDRoot.Scale.Text}')
add('r03-mount','execute_luau',datamodel_type='Server',code='local p=game.Players:GetPlayers()[1] workspace.ChassisTestBike.DriveSeat:Sit(p.Character.Humanoid) return "mounted"')
add('r03-driving-input','user_keyboard_input',datamodel_type='Client',actions=[dict(action='wait',wait_time_ms=800),dict(action='keyPress',key_code='E'),dict(action='keyDown',key_code='W'),dict(action='wait',wait_time_ms=1000),dict(action='keyUp',key_code='W')])
lua('r03-driving-state','local g=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD local d=g.HUDRoot.DrivingDock return {speedVisible=d.Speed.Visible,speed=d.Speed.Text,gear=d.Gear.Text,cargo=d.Cargo.Text,menuOpen=g.Menu.Visible}')
add('r03-hud-driving','screen_capture',capture_id='r03-hud-driving')
add('r03-brake','user_keyboard_input',datamodel_type='Client',actions=[dict(action='keyDown',key_code='S'),dict(action='wait',wait_time_ms=2000),dict(action='keyUp',key_code='S')])
lua('r03-runtime-errors','local a={} for _,v in game:GetService("LogService"):GetLogHistory() do if v.messageType==Enum.MessageType.MessageError and (v.message:find("LabHUD") or v.message:find("RaceAndRaid.UI.Components") or v.message:find("UITheme")) then table.insert(a,v.message) end end return a')
Path('docs/mcp-check/r03-hud-functional-request.json').write_text(json.dumps(r))