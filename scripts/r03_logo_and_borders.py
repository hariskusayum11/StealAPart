from pathlib import Path
import json
p=Path('src/shared/UITheme.luau');s=p.read_text(encoding='utf-8').replace('return {','return {\n IconAtlas="rbxassetid://92686584842368",\n LogoRect=Vector2.new(650,200),',1);p.write_text(s,encoding='utf-8')
p=Path('src/client/UI/Components.luau');s=p.read_text(encoding='utf-8').replace('s.Color=Theme.Cyan;s.Thickness=1.5','s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;s.Color=Theme.Cyan;s.Thickness=1.5');p.write_text(s,encoding='utf-8')
p=Path('src/client/LabHUD.client.luau');s=p.read_text(encoding='utf-8');s=s.replace('UI.label(brand,"Title","STEAL A PART!",UDim2.new(1,0,0,30),UDim2.fromOffset(0,2),21,Theme.Gold)','''brand.Size=UDim2.fromOffset(190,62)
local logo=Instance.new("ImageLabel");logo.Name="Logo";logo.Image=Theme.IconAtlas;logo.ImageRectOffset=Vector2.zero;logo.ImageRectSize=Theme.LogoRect;logo.ScaleType=Enum.ScaleType.Fit;logo.Size=UDim2.new(1,-8,0,46);logo.Position=UDim2.fromOffset(4,0);logo.BackgroundTransparency=1;logo.Parent=brand''').replace('UDim2.fromOffset(0,32),11,Theme.Muted','UDim2.fromOffset(0,45),10,Theme.Muted')
s=s.replace('local navNames={','local iconRects={{1220,715,250,210},{280,700,230,225},{975,700,260,225},{1480,715,180,210},{0,0,650,200},{10,700,260,225}}\nlocal navNames={')
s=s.replace('button.LayoutOrder=i;button.TextSize=14','''button.LayoutOrder=i;button.Text=""
 local rect=iconRects[i]
 local icon=Instance.new("ImageLabel");icon.Name="Icon";icon.Image=Theme.IconAtlas;icon.ImageRectOffset=Vector2.new(rect[1],rect[2]);icon.ImageRectSize=Vector2.new(rect[3],rect[4]);icon.ScaleType=Enum.ScaleType.Fit;icon.Size=UDim2.fromOffset(40,40);icon.Position=UDim2.fromOffset(3,3);icon.BackgroundTransparency=1;icon.Parent=button
 UI.label(button,"Label",name,UDim2.new(1,-50,1,-4),UDim2.fromOffset(46,2),15)''')
p.write_text(s,encoding='utf-8')
p=Path('assets/ui/manifest.json');d=json.loads(p.read_text());d['assets']['uiKit']={'file':'assets/ui/source/ui-kit.png','id':'rbxassetid://92686584842368','use':'ImageRect crops only for logo/icons, never full-screen UI'};p.write_text(json.dumps(d,indent=2),encoding='utf-8')