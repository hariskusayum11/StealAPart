from pathlib import Path
import json,re
p=Path('src/first/Entry.client.luau');s=p.read_text(encoding='utf-8');s=s.replace('if failed then info.Text','failed=ContentProvider:GetAssetFetchStatus(LOADING)~=Enum.AssetFetchStatus.Success or ContentProvider:GetAssetFetchStatus(WELCOME)~=Enum.AssetFetchStatus.Success\nif failed then info.Text');p.write_text(s,encoding='utf-8')
p=Path('src/client/LabHUD.client.luau');s=p.read_text(encoding='utf-8');block='''local function entryChanged()
 gui.Enabled=player:GetAttribute("EntryOpen")~=true
end
player:GetAttributeChangedSignal("EntryOpen"):Connect(entryChanged)
entryChanged()
''';s=s.replace(block,'');s=s.replace('local elapsed=0',block+'local elapsed=0');p.write_text(s,encoding='utf-8')
manifest={'source':'User-supplied PNGs on 2026-11-04; use authorized by owner. Original files preserved unchanged.','uploadedVia':'Official Studio MCP upload_image','assets':{'loading':{'file':'assets/ui/source/loading.png','id':'rbxassetid://77547713334002'},'welcome':{'file':'assets/ui/source/welcome.png','id':'rbxassetid://135139130322921'},'garageArtwork':{'file':'assets/ui/source/garage-art.png','id':'rbxassetid://107954772658752'}},'verification':'Loading and welcome AssetFetchStatus.Success observed in Studio. Welcome ImageLabel.IsLoaded true. Not published; cross-owner permissions/mobile not verified.'}
Path('assets/ui/manifest.json').write_text(json.dumps(manifest,indent=2),encoding='utf-8')
source=Path('src/first/Entry.client.luau').read_text(encoding='utf-8');code='game:GetService("ScriptEditorService"):UpdateSourceAsync(game.ReplicatedFirst:FindFirstChild("Entry",true),function() return [====['+source+']====] end) return "image entry saved"'
r=[dict(label='image-final-stop',name='start_stop_play',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',is_start=False)),dict(label='image-final-sync',name='execute_luau',arguments=dict(studio_id='62c81645-c228-4b4d-a6ba-7cf2cbf8da1c',datamodel_type='Edit',code=code))];Path('docs/mcp-check/image-final-sync.json').write_text(json.dumps(r))