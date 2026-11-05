import xml.etree.ElementTree as E
r=E.parse('assets/vendor/AChassisMotorcycle.rbxmx').getroot()
def walk(x,path=''):
 p=x.find('Properties');n=p.find("*[@name='Name']") if p is not None else None
 name=n.text if n is not None else '';path+='/'+name
 if x.attrib.get('class')=='ScreenGui' or 'Interface' in path and path.count('/')<6:print(x.attrib.get('class'),path)
 for a in x.findall('Item'):walk(a,path)
walk(r)