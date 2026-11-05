from pathlib import Path
import xml.etree.ElementTree as E
r=E.parse('build/RaceAndRaid-ChassisLab.rbxlx')
for item in r.iter('Item'):
 p=item.find('Properties')
 if p is None:continue
 n=p.find("*[@name='Name']")
 if n is not None and n.text=='TestSurface':
  c=p.find("*[@name='CFrame']");assert c is not None and float(c.findtext('Y'))==-1
  print('Built artifact TestSurface CFrame.Y = -1 verified')