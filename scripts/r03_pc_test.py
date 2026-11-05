from pathlib import Path
import json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
def add(l,n,**a):r.append(dict(label=l,name=n,arguments=dict(studio_id=sid,**a)))
def lua(l,c):add(l,'execute_luau',datamodel_type='Client',code=c)
def click(l,path):add(l,'user_mouse_input',datamodel_type='Client',actions=[dict(action='moveTo',instance_path=path),dict(action='mouseButtonClick',mouse_button='left'),dict(action='wait',wait_time_ms=650)])
lua('r03-pc-prepare','local p=game.Players.LocalPlayer local e=p.PlayerGui:FindFirstChild("StealEntry") if e then e:Destroy() end p:SetAttribute("EntryOpen",false) local g=p.PlayerGui.RaceAndRaidLabHUD return {viewport=tostring(workspace.CurrentCamera.ViewportSize),nav=g.HUDRoot.Navigation.Visible,menu=g.Menu.Visible}')
add('r03-pc-walking','screen_capture',capture_id='r03-pc-walking')
for i in range(1,7):
 click('r03-click-nav'+str(i),'LocalPlayer.PlayerGui.RaceAndRaidLabHUD.HUDRoot.Navigation.Nav'+str(i))
 lua('r03-nav-check'+str(i),'local g=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD return {title=g.Menu.Title.Text,visible=g.Menu.Visible}')
 if i==1:add('r03-pc-garage-status','screen_capture',capture_id='r03-pc-garage-status')
 click('r03-click-close'+str(i),'LocalPlayer.PlayerGui.RaceAndRaidLabHUD.Menu.Close')
click('r03-click-scale','LocalPlayer.PlayerGui.RaceAndRaidLabHUD.HUDRoot.Scale')
lua('r03-pc-scale-result','return game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD.HUDRoot.PreferenceScale.Scale')
add('r03-pc-mount','execute_luau',datamodel_type='Server',code='workspace.ChassisTestBike.DriveSeat:Sit(game.Players:GetPlayers()[1].Character.Humanoid) return "mount"')
add('r03-pc-shift','user_keyboard_input',datamodel_type='Client',actions=[dict(action='wait',wait_time_ms=800),dict(action='keyPress',key_code='E'),dict(action='wait',wait_time_ms=400)])
lua('r03-pc-driving-state','local g=game.Players.LocalPlayer.PlayerGui.RaceAndRaidLabHUD return {speedVisible=g.HUDRoot.DrivingDock.Speed.Visible,gear=g.HUDRoot.DrivingDock.Gear.Text,menu=g.Menu.Visible,coins=game.Players.LocalPlayer:GetAttribute("Coins")}')
add('r03-pc-driving','screen_capture',capture_id='r03-pc-driving')
Path('docs/mcp-check/r03-pc-test-request.json').write_text(json.dumps(r))