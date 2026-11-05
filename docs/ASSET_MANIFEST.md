# Asset Manifest — RACE & RAID
ตรวจ 2026-11-03; รายการค้นหาเต็มพร้อมคำอธิบายผู้เผยแพร่ใน ASSET_MANIFEST.json
Found ไม่เท่ากับอนุญาตใช้/นำเข้า/ขับผ่านทดสอบ

| Asset | ผู้สร้าง / แหล่งจริง | สถานะ / สิทธิ์ / ข้อจำกัด |
|---|---|---|
| A-Chassis 1.7.2M | lisphm/A-Chassis contributors · https://github.com/lisphm/A-Chassis/releases/tag/v1.7.2-stable | Downloaded, Imported ใน Chassis Lab, ทดสอบขึ้นรถและคันเร่งจริงแล้ว; MPL-2.0 ใน release README และ LICENSE; ไม่ใช่ Street Cub final mesh |
| SuperOpen 16285498787 | ggg_2374 · https://create.roblox.com/store/asset/16285498787 | Rejected: ผู้สร้างระบุห้ามเชิงพาณิชย์ ไม่ดาวน์โหลด |
| Motorcycle Mesh Pack 12415033785 | TrainMaker6 · https://create.roblox.com/store/asset/12415033785 | Blocked: คำอธิบายบอก original mesh/decal unknown ไม่ใช้ |
| Motorcycle Exhaust Pack 16220021940 | NeverContent_1 · https://create.roblox.com/store/asset/16220021940 | Blocked: ผู้ลงบอกพบจากรถคันอื่น ไม่ยืนยันเจ้าของ |
| Mk 2 Motorcycle Exhaust 264942380 | AlrightAphrodite · https://create.roblox.com/store/asset/264942380 | Found เท่านั้น ต้องตรวจสิทธิ์/ไฟล์/mesh/จำนวนชิ้นก่อน |
| Spoked Wheel 5454106742 | Poriferan · https://create.roblox.com/store/asset/5454106742 | Found; คำอธิบายเชิญใช้สร้าง bike แต่ยังไม่ตรวจไฟล์หรือยืนยัน production license |
| Sideways Performance Drift Tuning Garage 213599179 | FataIJaka · https://create.roblox.com/store/asset/213599179 | Found; มี dependency ของ DisortedPixel ต้องตรวจสิทธิ์ทั้งชุด ไม่อนุมัติจากคำว่าฟรี |
| Car Repair Garage and MOT Workshop | 3DAssets.dev · https://3dassets.dev/packs/car-repair-garage-and-mot-workshop | Found; หน้าต้นทางระบุ original CC0; ยังไม่ได้ download/import/ประเมินภาพ ไม่รับรอง premium final art |
| Asphalt 03 | Poly Haven · https://polyhaven.com/a/asphalt_03 | License Verified: CC0 ตาม https://polyhaven.com/license ; ยังไม่ Downloaded/Imported ใช้เริ่ม 1K หลังตรวจ texture memory |
| Corrugated Iron | Poly Haven · https://polyhaven.com/a/corrugated_iron | License Verified: CC0; ยังไม่ Downloaded/Imported เหมาะเมทัลชีตอู่ แต่ภาพลายไม่ทดแทน geometry |
| Motorcycle 239e4ccb2bd440c995359db7adcbd184 | Tahseen · https://sketchfab.com/3d-models/motorcycle-239e4ccb2bd440c995359db7adcbd184 | Rejected สำหรับ Street Cub: เป็นรถแบรนด์จริงและ sport bike; หน้า CC BY ไม่ใช่การรับรอง trademark; 58.1k triangles ตามหน้าผู้เผยแพร่ |

## ตรวจไฟล์ที่ใช้จริง
A-Chassis release SHA256: 898BD0671D3FDE0126D7564BC1EF6720837A8F3AE92309DEACFDCE4D906ADFEE
สำเนาเดิม assets/quarantine/A-Chassis.1.7.2M.rbxm; สำเนาแก้ assets/vendor/AChassisMotorcycle.rbxmx
24 Lua containers: 8 ModuleScript, 5 Script, 11 LocalScript; 14 MeshPart, 69 Part, 2 SpecialMesh ใน XML ต้นฉบับ
สแกนไม่พบ external numeric require/HTTP/loadstring ในรายการตรวจ แต่พบ remote handlers ต้องเสริม occupant/function/buffer guards — ดู VENDOR_PATCHES.md
การสแกนไม่ใช่ full security certification; physics client ownership ยังต้องมี server validation ก่อน multiplayer economy
ไม่ถือจำนวน MeshPart ว่าเป็น body art มอเตอร์ไซค์: ภาพจริงเป็นโครงล้อและช่วงล่าง เหมาะ engineering เท่านั้น
เสียง/texture dependency ต้องตรวจสิทธิ์ runtime: พบข้อความ asset 1737635 not approved ใน console ยังไม่ยืนยันเจ้าของ dependency

## ยังขาด
Underbone body ที่มีเจ้าของ/สิทธิ์ชัด, อู่ไทยคุณภาพเป้าหมาย, texture upload ที่ได้รับอนุญาต, mobile/performance และ visual QA
ไม่ซื้อ ไม่ Publish ไม่แอบใช้โมเดลแบรนด์จริง ไม่แทนโมเดลสุดท้ายด้วยกล่อง
เพิ่มเติม: Motorbebek โดย alfinabil03 — https://sketchfab.com/3d-models/motorbebek-a59358c2126348729e41d400492b0fb4 : Found/Blocked; ผลค้นหาต้นทางระบุ CC BY และ 237.2k triangles แต่เปิดตรงได้403 ยังไม่ดาวน์โหลด/นำเข้า ต้องตรวจ license archive และลด mesh อย่างเหมาะสมก่อนมือถือ ไม่ใช่ตัวเลือกที่ผ่านแล้ว
