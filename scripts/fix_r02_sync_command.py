from pathlib import Path
import json
p=Path('docs/mcp-check/r02-delivery-sync-request.json');r=json.loads(p.read_text());r=r[1:];r[0]['label']='r02-final-edit-sync';r[0]['arguments']['code']=r[0]['arguments']['code'].replace('return "hub synced"','');p.write_text(json.dumps(r))