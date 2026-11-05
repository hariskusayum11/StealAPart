# G1 Conditional Visual Prototype — Owner Review

วันที่ 5 พฤศจิกายน 2026 · STEAL A PART! · R04.5 Conditional Approval

**สถานะ: สร้าง G1 ตัวอย่างแล้ว รอ Owner Review; ยังไม่ผ่าน Final Acceptance**

ทำเฉพาะ G1 และฉากหลังตัวอย่างที่เกี่ยวข้อง ไม่ขยาย G2–G6 หรือ Zone01–12 ภาพด้านหลังยังโล่งและยังไม่ผ่านเป้าการซ่อนขอบโลก คุณภาพระดับ Production ต้องให้เจ้าของตรวจจากภาพและเล่นจริง

## รุ่นและการสำรอง

- Road Geometry10 / Terrain9 / Boundary1 คงเดิม; G1Visual version4
- สำรอง: `backups/pre-g1-conditional-20261105-095423/` (Source, Config, Build, TASKS และข้อกำหนด)
- Build: `build/RaceAndRaid-ChassisLab.rbxlx` ผ่าน Rojo7.6.1 รุ่นส่งตรวจแล้ว มี warning เดิมเรื่อง UnderboneBody top-level Name
- Studio จบใน Edit, viewport ปกติ, Spawn(-752,3,100), Lab กลับใช้ Course.BikeStart ไม่มี QA spawn override ค้าง
- ไม่มี Publish, Asset ภายนอกใหม่, ระบบเงินใหม่ หรือแก้ WorldRepairSimulator

## สิ่งที่สร้างและไฟล์

| ไฟล์ | ผลที่ได้ |
|---|---|
| `src/server/G1Visual.luau` | หลังคาจั่ว/รอยต่อแผ่นโลหะ โครงเหล็ก ค้ำยัน ผนังครีม–ฐานกรม–หลังสีเขียวอมฟ้า ป้ายไทย ช่องจอด พื้น Epoxy แบบภาพ โต๊ะช่าง ตู้ลิ้นชัก แผงเครื่องมือ ชั้นอะไหล่ กระถาง และฉากรั้วไม้หลัง G1 |
| `src/server/CargoCourse.luau` | เพิ่ม hook เรียก G1Visual ทั้งตอนสร้างใหม่และเมื่อ Geometry เดิมพร้อม; เนื้อหาการสร้างถนนนอก hook เหมือนสำรอง |
| `src/client/GarageDay.client.luau` | Bright Thai Garage Day เฉพาะ Client ใกล้ G1, คืนค่าเดิมเมื่อออกจากบริเวณ; ซ่อน Debug tile จุดฝากใน Player Mode, คง Prompt/Logic เดิม |
| `scripts/qa/g1_*` | สคริปต์วัดซ้ำและเส้นทาง QA; ไม่ mapped ไปเกม |
| `docs/mcp-check/g1-*` | ผลวัด ภาพ และข้อจำกัดตามการทดสอบจริง |

ตัวโมเดลเป็นงานสถาปัตยกรรมที่ประกอบขึ้นในโปรเจกต์ด้วย geometry และวัสดุ native ของ Roblox ไม่ได้อ้างว่าเป็น Mesh Pack หรือโมเดลสำเร็จรูปที่นำเข้า ไม่มี Asset ID ใหม่หรือ third-party license ใหม่ ภาพรถใช้ Street Cub/A-Chassis ที่มีอยู่เดิมและคงไฟล์สิทธิ์เดิมใน assets/vendor

154 BaseParts ใหม่, **0 ชิ้นชนได้**, 2 PointLights (Shadows=false, Range22) ไม่มี animation/per-frame decoration generator เรียก apply ซ้ำสองครั้งยัง154ชิ้น ไม่มีการสร้างซ้ำ พื้นสีและเส้นใหม่เป็นภาพ ไม่มีพื้นชนซ้อนถนน/ลานเดิม ตัว shell เดิมยังเป็น collision authority

ค่าแสงตัวอย่าง: ClockTime13.4, Brightness2.2, Exposure0.05, Ambient116/125/135, Outdoor139/151/164 และ ColorCorrection อ่อน ๆ ใช้ท้องฟ้า/เมฆที่มีอยู่เดิม ไม่เปลี่ยนแสง Server ให้ผู้เล่นต่างโซน ไม่มีระบบกลางวันกลางคืนใหม่

Player Mode ซ่อน TestGarageDeposit เฉพาะภาพขณะอยู่ใกล้ G1; `Workspace.ShowDevelopmentMarkers=true` แสดงแผ่นสำหรับ QA ได้ เส้นกรอบสีทองยังตรงจุดฝาก(-760,0,90) และ Attachment/Prompt ไม่ถูกลบ

## ภาพจริงจาก Studio — G1 version4

จับจาก Studio Play และเปิดดูภาพแล้วครบ8มุม เป็นฉากจริง ไม่ใช่ Concept Art ซ่อน PlayerGui ชั่วคราวเพื่อถ่ายภาพ แล้วคืน GUI/กล้องก่อนจบ Play

| มุม | ภาพ |
|---|---|
| ด้านหน้า | [G1 Front](mcp-check/g1-front-v4.png) |
| มุมเฉียง | [G1 Angle](mcp-check/g1-angle-v4.png) |
| ภายใน | [G1 Interior](mcp-check/g1-interior-v4.png) |
| พร้อม Street Cub | [G1 + Cub](mcp-check/g1-cub-v4.png) |
| ลานและถนน | [Apron](mcp-check/g1-apron-v4.png) |
| ฉากด้านหลัง | [Background](mcp-check/g1-background-v4.png) |
| แสงและท้องฟ้า | [Sky](mcp-check/g1-sky-v4.png) |
| Garage City มุมบน | [City](mcp-check/g1-city-v4.png) |

MCP แบบเรียกตรงเคยได้ภาพขาว (Capture Failed) แต่ช่องทาง StudioMCP runner บันทึกภาพจริงได้แล้ว ไม่ได้นับภาพขาวเป็นหลักฐาน รุ่นก่อน4พบ Transform คานบวกตำแหน่งซ้ำ แก้ Source แล้วตรวจ max centreY27.2 แทน54.4 ภาพก่อนแก้นั้นไม่ใช่รุ่นรับตรวจ

**สิ่งที่ภาพยังไม่ผ่าน:** ฉากขอบโลก B มีเพียง screen รั้วและภูมิประเทศเดิม ยังไม่เป็นต้นไม้/เนิน/ฉากหลังหลายชั้นที่กลมกลืน ภาพมุมสูงเห็นขอบ Terrain ที่ render/stream อยู่ จึงไม่อ้างว่าปิดขอบโลกสำเร็จ ไม่เพิ่มรายละเอียดจำนวนมากเพื่อปกปิดปัญหา Performance ที่ยังหาสาเหตุไม่ได้

## Performance ก่อน–หลัง

สคริปต์ `scripts/qa/g1_performance.luau` ใช้กล้อง(-820,28,40) มอง(-760,10,113), Scriptable camera, Studio Play Client, Streaming=true และ GraphicsAutomatic ทุก window8วินาที

| รอบ | Viewport | FPS สองช่วงหลัก | หมายเหตุ |
|---|---|---|---|
| Baseline รอบ1 |1588×665|15.004 /43.538|มีช่วงเปลี่ยนสภาพ runtime; Sky60.007 /ซ่อน PlayerGui59.998 ไม่ทราบ foreground จริง |
| Baseline รอบ2 |1588×665|14.999 /15.003|Sky15.001 /ซ่อน GUI15.002 ยังช้า |
| Pilot150ชิ้น รอบ1–2 |1588×665|ประมาณ14.996–15.001|เป็นรุ่นระหว่างพัฒนา ไม่ใช่ผล Final Visual |
| Final v4 /154ชิ้น |1588×625|15.0007 /15.0026|window8.066/8.065s; P95 67.95/68.00ms; memory1924/1928MB;942client BaseParts |

Final viewport สูงน้อยกว่า Baseline40px หลัง Device Simulator จึงไม่ใช่ A/B ที่ resolution เท่ากันสมบูรณ์ Memory และ Rendering ต่างตาม streaming/เวลา/GC ห้ามสรุปว่า optimize memory ได้จากตัวเลขนี้

SceneAnalysis Final sample:214,300 triangles/383 draw calls รวมทุก pass ที่ query คืนมา ณ มุมนี้ ไม่ใช่ทั้งโลก รายละเอียดอยู่ `g1-final-performance.json` ห้ามเปรียบเทียบ draw calls ข้ามมุม/streaming state เป็นผลปรับปรุง

**สาเหตุ15FPSยังไม่ยืนยัน:**
- ทำซ้ำทั้งมอง G1/ท้องฟ้า/ซ่อน PlayerGui แล้ว ไม่ได้ดีขึ้นสม่ำเสมอ จึงยังโยนสาเหตุให้ geometry หรือ UI ไม่ได้
- อ่าน Graphics ได้ แต่การเขียน SavedQualityLevel ถูกปฏิเสธ capability; ยังไม่มี Graphics low/high A/B
- ไม่สามารถอ่าน foreground state ผ่าน API ที่ลองได้ ไม่มีหลักฐานให้ฟันธง Studio throttling
- มี ScriptMemory query และ MicroProfiler snapshot เดิม แต่หน่วยความจำไม่ใช่ CPUเวลา และ snapshotเดียวไม่พิสูจน์สาเหตุ
- ผลไม่เห็น FPS ลดเพิ่มจากช่วง15ที่วัดได้ แต่ข้อจำกัดนี้อาจซ่อนต้นทุนงานภาพ **ยังไม่ผ่าน Performance Acceptance** จึงหยุดเพิ่มรายละเอียด
- ข้อมูล: `g1-perfBefore1.json`, `g1-perfBefore2.json`, `g1-perfAfter1.json`, `g1-perfAfter2.json`, `g1-final-performance.json`

## QA เพิ่มเติม — แยกขอบเขต

| งาน | ผลจริง |
|---|---|
| Version10 roundtrip /G3/Cargo | ผลก่อนหน้าเจ้าของยอมรับตามขอบเขต ไม่มีการอ้างเป็น Human QA ใหม่ |
| ลงหญ้า GarageCity, Zone01–03 | Automated complete127/127 ใน193.141s; พบ Terrain ray hits จริงทุกบริเวณและขับกลับสู่แนวถนน เส้นทาง QA รอบแรกแคบเกินไปและพลาด waypoint เก็บผลล้มเหลวไว้ ไม่ตีความเป็น Collision เสีย |
| ถนนบริการ | สังเกต Client state complete180/180 ผ่านแนวบริการเหนือ–ตะวันออก–ใต้–ตะวันตกและกลับG1; progressสุดท้าย265.354s ไม่ใช่เวลา finish ที่วัดครบ Full trace ไม่ได้เก็บลงไฟล์ทัน จึงมี observation summary แทน ไม่รับรองแขนงหลังอู่ทุกหลัง/ทุก facility |
| Boundary ตัวละคร | จุดหนึ่งที่X-752,Z1088: Spawn สำหรับ QA ก่อนPlay, เดิน MoveToZ1120 จริง5s; เคลื่อน4.37studและหยุดที่Z1085.37, มี contact events, Health100 ไม่มี teleportระหว่างเดิน ไม่เท่ากับครบ16ช่วง |
| Boundary รถ | **ยังไม่ผ่าน** รอบแรก Play กลับEditก่อนอ่านผล รอบลองซ้ำรถไหลจากเนินก่อนควบคุมไปคนละทิศ พบ0contacts/0recoveries ไม่ได้ชนกำแพง จึงห้ามนับผ่าน ไม่แก้ Boundary หรือ chassis ให้ผลผ่าน |
| Loading Timeout/Retry | Runtime clone ของ production Entry เดิม, ระงับ Ready เฉพาะ QA60s; Retryปรากฏ/LoadingComplete=false; คืนReady10 แล้วกด Retry/Close จริง ได้ HUD=true/EntryOpen=false ไม่ใช้ progressปลอม |
| Respawn | LoadCharacterAsync จริง, Health100, StealEntry1ชุด/HUD1ชุด, Popupไม่ค้าง |
| Mobile/Tablet | เปิด Studio Device Simulator จริง iPhone17Pro และ iPadProM5 landscape มีข้อมูล viewport/bounds และภาพ; **ไม่รับรอง touch driving หรือ final phone Close** mouse automationรอบสุดท้ายยังไม่ยืนยันปิดได้ |
| Human QA | ยังไม่ได้รับผลจากเจ้าของ |

การทดสอบ Emulator พบว่าพิกัด GUI กับภาพมี Safe Area offset ไม่ตรงกัน การทดลองปรับ Entry จากพิกัดอย่างเดียวจึงถูก **revert กลับไฟล์สำรองเดิมทั้งหมด** ก่อนส่งงาน (hashตรงกัน) ไม่ส่ง layoutทดลองที่ภาพมีความเสี่ยงถูกตัด ภาพ `g1-phone-final-layout.png` เป็นภาพระหว่างทดลองที่ยกเลิกแล้ว ไม่ใช่ UI รุ่นรับตรวจ

ผล Timeout/Retry และ Respawn มาจาก Entry ก่อนทดลองซึ่งตรงกับ Source ที่คืนแล้ว Studio reset สู่ viewportปกติหลังทดสอบ ไม่มี QA spawn/Script override ในไฟล์ผลิต

หลักฐานหลัก: `g1-grass-wide.json`, `g1-service-road-observation.json`, `g1-boundary-player.json`, `g1-boundary-vehicle.json`, `g1-retry.json`, `g1-respawn.json`, `g1-preservation-hashes.json`, `g1-course-hook-comparison.json`, `g1-idempotence.json`

## สิ่งที่ต้องให้เจ้าของตรวจ

ใน Place เดิม Stop→Play ใหม่ผ่าน Rojo เดิม แล้วตรวจ G1:
1. ปิด Welcome, เดินออกจากอู่ ขึ้นStreetCub ขับออกลานและเลี้ยวเข้าถนน
2. ขับลงหญ้าและกลับขึ้น แล้วไปZone01 Fค้างเก็บ กลับG1 Fค้างฝาก ตรวจCargo0→1→0/ฝาก+1
3. ดูป้าย โครงหลังคา โต๊ะและชั้นอะไหล่ กล้องภายใน/ลาน ขอบพื้นและภาพกระพริบ
4. วัด foreground FPS ที่มุมเดียวกับกล้องมาตรฐานและระบุ Graphics/Resolution; ทดสอบ touch Close/การขับบนมือถือจริงเมื่อพร้อม
5. ตรวจภาพ8มุมแล้วแจ้งสิ่งที่รับ/ต้องแก้ โดยเฉพาะฉากด้านหลังและสไตล์อาคาร

**หยุดรอ Owner Review ที่ G1 นี้** ไม่ขยายอู่อื่นหรือโซนอื่น ไม่อ้างว่าเกมพร้อมเปิดจริง