import xml.etree.ElementTree as E,json,pathlib,re
r=E.parse('build/ChassisAudit.rbxlx').getroot()
scripts=[]; counts={}
for i in r.iter('Item'):
 c=i.get('class');counts[c]=counts.get(c,0)+1
 if c in ('Script','LocalScript','ModuleScript'):
  p=i.find('Properties');name=p.find("string[@name='Name']").text;s=p.find("*[@name='Source']").text or ''
  idx=len(scripts);pathlib.Path(f'assets/quarantine/source-{idx}.luau').write_text(s,encoding='utf-8')
  flags=[line.strip() for line in s.splitlines() if re.search(r'require\(|HttpService|GetAsync|PostAsync|loadstring|InsertService|DataStore|TeleportService|MarketplaceService',line)]
  scripts.append(dict(index=idx,name=name,lines=len(s.splitlines()),flags=flags))
report=dict(counts=counts,scripts=scripts)
pathlib.Path('docs/CHASSIS_STATIC_AUDIT.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(report,indent=2))