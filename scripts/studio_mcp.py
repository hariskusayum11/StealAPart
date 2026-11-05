import subprocess,json,threading,queue,time,pathlib
p=subprocess.Popen([r'C:\Users\SC1220-000\AppData\Local\Roblox\Versions\version-7062aec9dbe74b14\StudioMCP.exe'],stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,encoding='utf-8',creationflags=0x08000000)
q=queue.Queue()
def read():
 for line in p.stdout:
  try:q.put(json.loads(line))
  except:pass
threading.Thread(target=read,daemon=True).start()
def send(x):p.stdin.write(json.dumps(x)+'\n');p.stdin.flush()
def call(i,m,params):
 send({'jsonrpc':'2.0','id':i,'method':m,'params':params})
 end=time.time()+20
 while time.time()<end:
  x=q.get(timeout=max(.1,end-time.time()))
  if x.get('id')==i:return x
try:
 init=call(1,'initialize',{'protocolVersion':'2024-11-05','capabilities':{},'clientInfo':{'name':'WorkspaceReadOnlyAudit','version':'1.0'}})
 send({'jsonrpc':'2.0','method':'notifications/initialized'})
 call(900,'tools/list',{})
 for attempt in range(8):
  ready=call(901+attempt,'tools/call',{'name':'list_roblox_studios','arguments':{}})
  if attempt >= 6: break
  time.sleep(1)
 import sys,base64
 requests=json.loads(pathlib.Path(sys.argv[1]).read_text(encoding='utf-8-sig'))
 for i,request in enumerate(requests,2):
  result=call(i,'tools/call',{'name':request['name'],'arguments':request['arguments']})
  for c in result.get('result',{}).get('content',[]):
   if c.get('type')=='image':
    path=pathlib.Path('docs/mcp-check/'+request['label']+'.png');path.write_bytes(base64.b64decode(c['data']));c['data']='Saved to '+str(path)
  pathlib.Path('docs/mcp-check/'+request['label']+'.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
  print(request['label'],json.dumps(result)[:11000],flush=True)
except Exception as e:print(type(e).__name__,str(e))
finally:p.terminate()
