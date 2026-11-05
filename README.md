# RACE & RAID — ซิ่งล่าอะไหล่
โปรเจกต์ใหม่: D:\RobloxProjects\RaceAndRaid แยกจาก World Repair Simulator

เปิด VS Code ด้วย RaceAndRaid.code-workspace
เปิดสนามที่ใช้อยู่ด้วย Open-ChassisLab.cmd (Build ก่อนเปิดทุกครั้ง)
ไฟล์หลักของรอบนี้: build/RaceAndRaid-ChassisLab.rbxlx
RaceAndRaidBenchmark.rbxlx เป็นพื้นทดสอบรุ่นแรกที่ยังไม่มี chassis — ไม่ใช่ไฟล์เล่นล่าสุด

```powershell
Set-Location D:\RobloxProjects\RaceAndRaid
.\.tools\rojo\rojo.exe build default.project.json --output build/RaceAndRaid-ChassisLab.rbxlx
.\.tools\rojo\rojo.exe serve default.project.json --port 34880
```
มี server 34880 เปิดทดสอบแล้ว ห้ามเปิดซ้ำถ้าพอร์ตยังใช้งานอยู่ อย่าเชื่อมกับ Place ของ World Repair Simulator

วิธีลอง: Play → เข้าใกล้ chassis กด E ขึ้น → E เพิ่มเกียร์จาก N → W เร่ง/S เบรก/A-D เลี้ยว/Space ลง
จุดสีทองด้านหน้า Z=-140: หยุดรถใกล้แล้ว F เก็บ; จุดสีฟ้าใกล้เริ่มต้น: F ฝาก ต้องนั่งขับและเคลื่อนช้าพอ
Cargo ทดสอบ session เท่านั้น ไม่บันทึกหลังออก

สถานะ: engineering chassis ที่ทดสอบการเคลื่อนที่แล้ว ไม่ใช่ Street Cub 110 final mesh ไม่ใช่ premium visual benchmark
ดู docs/GAME_DESIGN.md, docs/ROADMAP.md, docs/ASSET_MANIFEST.md, docs/TEST_REPORT.md และ TASKS.md
ยังไม่อนุมัติ Mobile / Performance / Visual QA / anti-cheat production