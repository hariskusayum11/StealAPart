from pathlib import Path
import json
sid='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c';r=[]
for label,x in [('r02-zones01-04',200),('r02-zones05-08',1400),('r02-zones09-12',2600)]:
 r.append(dict(label=label,name='screen_capture',arguments=dict(studio_id=sid,capture_id=label,camera_position=[x,260,480],look_at_position=[x,15,90])))
Path('docs/mcp-check/r02-zone-photos-request.json').write_text(json.dumps(r))