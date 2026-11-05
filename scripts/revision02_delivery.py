from pathlib import Path
import json
p=Path('docs/mcp-check/hub-sync.json');r=json.loads(p.read_text());r=r[:2]
r[1]['arguments']['code']+=' local ok,err=pcall(function() workspace.StreamingEnabled=true workspace.StreamingMinRadius=256 workspace.StreamingTargetRadius=768 end) return {streamingConfigured=ok,error=not ok and tostring(err) or nil}'
Path('docs/mcp-check/r02-delivery-sync-request.json').write_text(json.dumps(r))
p=Path('docs/BLOCKOUT_REVISION_02.md');s=p.read_text(encoding='utf-8');s=s.replace('- [แนวถนน 12 โซน](mcp-check/r02-highway-order.png)','- [แนวถนนโซน 01–04](mcp-check/r02-zones01-04.png)\n- [แนวถนนโซน 05–08](mcp-check/r02-zones05-08.png)\n- [แนวถนนโซน 09–12](mcp-check/r02-zones09-12.png)');s+='''
## ผลขับและ Cargo — สถานะส่งตรวจ
**ยังไม่ผ่านการขับไปกลับครบ 12 โซนแบบต่อเนื่อง**

- ผู้ขับ QA ใช้ VirtualInput ของ chassis จริง เดินทางจากอู่เข้าใกล้ครบ Zone01–12. รอบหลังแก้รอยต่อเดินทางถึงลาน Zone12 (~171 วินาที) แต่กลับตัวหลุดขอบและหยุด ไม่สามารถกลับถึงอู่. ไม่มี automatic recovery ในผลตรวจ (0).
- ขยาย terminal apron ครั้งสุดท้ายเป็น 260×260 studs และเพิ่มทางลาดกลับเข้าถนน. การขยายครั้งสุดท้าย Build ผ่าน แต่ยังไม่ได้ทดสอบขับซ้ำจนจบรอบ. ไม่อ้างว่าผ่านการรับรองรัศมีเลี้ยวแล้ว.
- การตรวจ Cargo เป็นคนละชุดกับการขับ: ย้ายรถในฉากทดสอบไปที่จุดรับ/ฝากแล้วกด F ค้างจริง ผล Cargo 0→1→0, ฝากสำเร็จ 1. ไม่ใช้ผลนี้กล่าวอ้างว่าขับกลับสำเร็จ.
- หลังลงรถ: Humanoid.FloorMaterial=Concrete, ไม่ได้นั่งรถ, HUD.Enabled=true. [ภาพระดับผู้เล่น](mcp-check/r02-player-eye.png).
- ภาพมุมไกลมากบางภาพคืนเพียงท้องฟ้า จึงเปลี่ยนเป็นสามภาพแบ่งช่วงถนนและไม่ใช้ภาพท้องฟ้าเป็นหลักฐาน.
- Build ล่าสุด: build/RaceAndRaid-ChassisLab.rbxlx. ภาพยังเป็น Blockout และยังไม่ได้อนุมัติ. งานถัดไปต้องเก็บการกลับรถ/ทดสอบไปกลับให้ผ่านก่อนลงรายละเอียดโซน.
''';p.write_text(s,encoding='utf-8')
p=Path('docs/HIGHWAY_BLOCKOUT_REVIEW.md');s=p.read_text(encoding='utf-8');p.write_text('> Superseded structural checkpoint: see BLOCKOUT_REVISION_02.md. Final blockout remains unapproved.\n\n'+s,encoding='utf-8')
p=Path('TASKS.md');p.write_text(p.read_text(encoding='utf-8')+'''
## 2026-11-04 — Blockout Revision02 (not approved / roundtrip not passed)
- Backup pre-blockout-r02-*; revised continuous curves/4.21% max sampled grade, terrain profile, supported bridge, garage turn aprons and separated facility access streets. No zone detailing.
- Studio center support samples every12 studs and 1,011 lane samples: no gaps/burial in sampled geometry. Six garage entry rays unblocked; 5 facility routes x11 support samples passed.
- Actual virtual-input chassis driving reached all12 zones, but multiple terminal-turn attempts stalled/off-road. Last 260x260 apron enlargement not fresh-drive verified. Do not mark roundtrip passed or final blockout approved.
- Separate F-hold Cargo input check passed 0->1->0/Secured1; used endpoint repositioning explicitly. Player stands on Concrete after exit; HUD retained. No DataStore changes/publish/old-game edits.
- Evidence/images and failure history documented in docs/BLOCKOUT_REVISION_02.md. Build passed. Continue structural driving fixes before owner review of final blockout.
''',encoding='utf-8')