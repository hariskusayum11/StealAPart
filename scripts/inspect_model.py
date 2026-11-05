import xml.etree.ElementTree as E
r=E.parse('build/ChassisAudit.rbxlx').getroot()
m=r.find("Item/Item")
print('root',m.get('class'),m.find("Properties/*[@name='Name']").text)
for i in m.findall('Item'):
 print(i.get('class'),i.find("Properties/*[@name='Name']").text)
for i in m.iter('Item'):
 if i.get('class')=='VehicleSeat':print(E.tostring(i.find('Properties'),encoding='unicode')[:4000])