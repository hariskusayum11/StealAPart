import pathlib,json
rows=[]
for name in ['bike-search','motorcycle-mesh','garage-search','Thai-shophouse','motorcycle-exhaust','spoke-wheel']:
 p=pathlib.Path('docs/mcp-check')/(name+'.json')
 if not p.exists():continue
 for block in json.loads(p.read_text()).get('result',{}).get('content',[]):
  if block.get('type')!='text':continue
  try:d=json.loads(block['text'])
  except:continue
  for a in d.get('results',[]):
   a['category']=name;a['status']='Found';a['licenseVerified']=False;a['downloaded']=False;a['imported']=False;a['studioTested']=False
   if a['assetId'] in ['16285498787','12415033785','16220021940','83165839748672','116427695342215']:
    a['status']='Rejected / Blocked';a['reason']='Non-commercial restriction or unclear original author/provenance in description.'
   rows.append(a)
pathlib.Path('docs/ASSET_MANIFEST.json').write_text(json.dumps(rows,indent=2,ensure_ascii=False),encoding='utf-8')