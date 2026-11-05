import pathlib,json,shutil
p=pathlib.Path('docs/mcp-check/body-export.json');d=json.loads(p.read_text());raw=d['result']['content'][0]['text'];a=json.loads(raw)
if isinstance(a,str):a=json.loads(a)
pathlib.Path('assets/body-review').mkdir(exist_ok=True)
pathlib.Path('assets/body-review/source-metadata.json').write_text(json.dumps(a,indent=2),encoding='utf-8')
children=[]
for v in a['Parts']:
 props={k:v[k] for k in ['MeshId','TextureID','CFrame','Size','Color','Material','Transparency','Reflectance']}
 props["InitialSize"]=v["MeshSize"]
 props.update(Anchored=True,CanCollide=False,CanTouch=False,CanQuery=False,Massless=True)
 children.append(dict(name=v['Name'],className='MeshPart',properties=props))
model=dict(name='UnderboneBody',className='Model',children=children)
pathlib.Path('assets/body-review/UnderboneBody.model.json').write_text(json.dumps(model,indent=2),encoding='utf-8')
c=json.loads(pathlib.Path('default.project.json').read_text());c['tree']['ServerStorage']={'$ignoreUnknownInstances':True,'UnderboneBody':{'$path':'assets/body-review/UnderboneBody.model.json'}}
pathlib.Path('default.project.json').write_text(json.dumps(c,indent=2),encoding='utf-8')
print('Exported',len(children),'MeshParts; template only')