from pathlib import Path
import shutil,datetime
b=Path('backups')/('pre-blockout-r02-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'));b.mkdir(parents=True);shutil.copytree('src',b/'src');shutil.copy2('default.project.json',b/'default.project.json')
p=Path('src/shared/HubLayout.luau');s=p.read_text(encoding='utf-8');s=s.replace('return {','local Layout = {',1).replace('Version=4','Version=5');s=s.rstrip()+'''
-- Continuous analytic alignment: X always increases; zones never wrap back.
function Layout.RoutePoint(x: number): Vector3
 local t=math.max(0,x+250)
 local z=90*(1-math.cos(t/360))
 local h=math.max(0,x-200)
 local y=16*(1-math.cos(h/380))
 return Vector3.new(x,y,z)
end
for _,zone in Layout.Zones do zone.position=Layout.RoutePoint(zone.position.X) end
Layout.Pickup=Layout.Zones[1].position+Vector3.new(0,0,-55)
return Layout
''';p.write_text(s,encoding='utf-8')