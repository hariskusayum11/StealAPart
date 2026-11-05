# R04 — Asset Catalog เพื่อพิจารณา

ตรวจ 4 พฤศจิกายน 2026 · STEAL A PART! · Research only

## ขอบเขตล่าสุดและจุดหยุด

ขั้น 1 ส่ง Catalog ก่อนนำเข้า ตามคำสั่ง R04 และคำสั่งเพิ่มเติมล่าสุด ขั้น 2 ต้องแก้ Collision, Z-fighting, พื้นต่างระดับและรอยต่อใน R03 แล้วทดสอบขับจริงไป–กลับ Zone01–12 ผ่านก่อนติดตั้ง Asset ที่อนุมัติ ไม่ลบถนน12โซน อู่6หลัง รถ Cargo หรือ Main HUD ไม่สร้าง Main Menu แยก ใช้ภาพ UI07 เป็นเป้าหมายงาน HUD ต่อจากของเดิม

รอบนี้ไม่มีการนำเข้า Asset ใหม่ ไม่มีแก้แผนที่/Gameplay ไม่มี Play ใหม่ และไม่มีผล FPS/Memory ใหม่ ไม่ใช้ Build เป็นหลักฐานคุณภาพภาพ

## สถานะที่ต้องอ่านแยก

Found = พบแหล่งจริง; License verified (page) = ตรวจข้อความหน้าแหล่ง ไม่ใช่ตรวจ archive/dependencies; Downloaded = มีไฟล์จริง; Imported = นำเข้า Studio จริง; Studio tested = มีการทดสอบที่ระบุขอบเขต ผลค้นหาหรือคำว่า working/no scripts ของผู้เผยแพร่ไม่เท่ากับทดสอบเอง

## แพ็กต้นทาง Kenney

ทุกแถว: ผู้สร้าง Kenney, ฟรีแบบดาวน์โหลดรายแพ็ก/บริจาคตามสมัครใจ, หน้า official ระบุ CC0; ยังไม่ดาวน์โหลด/นำเข้า/ทดสอบในรอบ R04 รูปแบบ archive และ mesh/texture รายชิ้นยังไม่ตรวจ จำนวน files เป็นข้อมูลหน้าเว็บ ไม่ใช่ triangle count ผลิตภัณฑ์ All-in-one แบบจ่ายเงินไม่จำเป็นสำหรับรายแพ็กฟรี

| ชื่อ/ลิงก์ | Files ตามหน้า | ใช้ที่ใด | ความเหมาะสม/ความเสี่ยง |
|---|---:|---|---|
| [Car Kit](https://kenney.nl/assets/car-kit) | 45 | รถเริ่มต้น/รถประกอบฉาก; ไม่ใช่ chassis | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |
| [City Kit Commercial](https://kenney.nl/assets/city-kit-commercial) | 50 | ร้านค้า/อาคารระบบ; ต้องปรับเอกลักษณ์ไทย | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |
| [City Kit Suburban](https://kenney.nl/assets/city-kit-suburban) | 40 | อาคารประกอบ/หลังคา; ไม่ยืนยันมีอู่เปิดหน้า | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |
| [City Kit Industrial](https://kenney.nl/assets/city-kit-industrial) | 40 | อาคารอู่/โกดัง/โรงงานที่ต้องคัด geometry | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |
| [Factory Kit](https://kenney.nl/assets/factory-kit) | 140 | เครื่องจักร/สายพาน/props อู่ | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |
| [Nature Kit](https://kenney.nl/assets/nature-kit) | 330 | ภูมิทัศน์รอง; ไม่อ้างเป็นต้นยางไทย | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |
| [City Kit Roads](https://kenney.nl/assets/city-kit-roads) | 90 | ป้าย/องค์ประกอบถนน; ไม่แทนแนวถนน12โซน | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |
| [Racing Kit](https://kenney.nl/assets/racing-kit) | 110 | props สนาม; ไม่รวมระบบแข่งขัน | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |
| [UI Pack](https://kenney.nl/assets/ui-pack) | 430 | ไอคอน/ชิ้น UI รอง; ไม่แทน HUD controller | Found; License verified (page) CC0; รูปทรง stylized ต้องเทียบภาพ ไม่รับรอง final art; Scripts/UV/pivot/scale/collision/materials/triangles ยังไม่ตรวจไฟล์ |

## Creator Store — ผลค้นจริงผ่าน Studio MCP

ค้นครบ 13 คำ วันที่ตรวจ Studio MCP เชื่อมต่อ Place RaceAndRaid-ChassisLab.rbxlx สำเร็จ Web keyword pages เข้าไม่ได้ด้วย web tool แต่ MCP search_asset ใช้ได้ หลักฐานดิบ `docs/mcp-check/r04-search-*.json`; metadata รวมใน R04_CREATOR_STORE_RESULTS.json

ทุกแถวต่อไป: Found เท่านั้น, ราคาฟรีตามผล MCP, ประเภท Roblox Model, **Downloaded: No / Imported: No / Studio tested: No** License ยังไม่ verified เป็นราย dependency ต้องตรวจผู้สร้างต้นฉบับ/เงื่อนไขแพลตฟอร์มก่อนใช้ ไม่อ้างว่า CC0 และยังไม่ได้ตรวจ scripts, textures, mesh counts, bounds, collision หรือ performance

| คำค้น/Assetจริง | ผู้เผยแพร่ | การคัดกรอง/ข้อจำกัด |
|---|---|---|
| car workshop · [Car Workshop/Garage](https://create.roblox.com/store/asset/11659710171) | DRrobloxp | Hold provenance: อ้าง/ส่อแหล่งต้นฉบับอื่น ต้องยืนยัน license chain ก่อน ไม่แนะนำเข้าแมพ |
| car workshop · [Mechanic Shop Garage Car Lift Workshop Auto Repair](https://create.roblox.com/store/asset/122720800921908) | Pinezogo51 | Hold: ผู้เผยแพร่ระบุมี scripts; ยังไม่ตรวจไฟล์/remote/dependencies; จำนวนชิ้นในคำอธิบายไม่ใช่ผลวัดเรา |
| car workshop · [Benny Garage Car Mechanic Workshop Tools Roleplay](https://create.roblox.com/store/asset/114706074059244) | Content Deleted - 158552482 | Hold: ผู้เผยแพร่ระบุมี scripts; ยังไม่ตรวจไฟล์/remote/dependencies; จำนวนชิ้นในคำอธิบายไม่ใช่ผลวัดเรา |
| cyberpunk city · [Cyberpunk city](https://create.roblox.com/store/asset/11332829712) | creepercatchanel | Hold provenance: อ้าง/ส่อแหล่งต้นฉบับอื่น ต้องยืนยัน license chain ก่อน ไม่แนะนำเข้าแมพ |
| cyberpunk city · [Cyberpunk City Map Building Neon Urban Sky Pack](https://create.roblox.com/store/asset/119153990140716) | Nagubofi330 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| cyberpunk city · [Synty CyberPunk City](https://create.roblox.com/store/asset/8358474720) | Mehdiw8 | Hold provenance: อ้าง/ส่อแหล่งต้นฉบับอื่น ต้องยืนยัน license chain ก่อน ไม่แนะนำเข้าแมพ |
| fishing dock · [fishing dock](https://create.roblox.com/store/asset/13224072200) | watermealreal | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| fishing dock · [fishing dock (better)](https://create.roblox.com/store/asset/131122336679213) | brawlerbeastrush | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| fishing dock · [Fishing Dock](https://create.roblox.com/store/asset/4823470953) | Scriptai | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| floating market · [Flooding Floating Market [Crazy+]](https://create.roblox.com/store/asset/12538354647) | BlueBoywith_BlueBird | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| floating market · [fruit stand](https://create.roblox.com/store/asset/172091501) | ppaxxy | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| floating market · [🛡 Village Pack Low Poly Map Build Stylized Gras](https://create.roblox.com/store/asset/98640056863981) | lowkeypolyest | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| garage workshop · [Car Workshop/Garage](https://create.roblox.com/store/asset/11659710171) | DRrobloxp | Hold provenance: อ้าง/ส่อแหล่งต้นฉบับอื่น ต้องยืนยัน license chain ก่อน ไม่แนะนำเข้าแมพ |
| garage workshop · [Rev's Garage Concrete Workshop Mechanic Garages](https://create.roblox.com/store/asset/126322102618496) | Witkx3902 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| garage workshop · [Mechanic Shop Garage Car Lift Workshop Auto Repair](https://create.roblox.com/store/asset/122720800921908) | Pinezogo51 | Hold: ผู้เผยแพร่ระบุมี scripts; ยังไม่ตรวจไฟล์/remote/dependencies; จำนวนชิ้นในคำอธิบายไม่ใช่ผลวัดเรา |
| golden vault · [Golden Vault Room](https://create.roblox.com/store/asset/16000249751) | Teteu_lindo06 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| golden vault · [golden vault bye chewboy1196](https://create.roblox.com/store/asset/2970840) | chewboy1196 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| golden vault · [💛 Golden Vault Fence Security Barrier Fortificati](https://create.roblox.com/store/asset/73131518778688) | Maya773Fusi0n5421 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| industrial factory · [Abandoned Warehouse Building Industrial Factory](https://create.roblox.com/store/asset/83031996844896) | Content Deleted - 158552482 | Hold: ผู้เผยแพร่ระบุมี scripts; ยังไม่ตรวจไฟล์/remote/dependencies; จำนวนชิ้นในคำอธิบายไม่ใช่ผลวัดเรา |
| industrial factory · [Industrial Factory Night Skybox](https://create.roblox.com/store/asset/18327888557) | KenzoAmano99 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| industrial factory · [Industrial factory night skybox night RP](https://create.roblox.com/store/asset/115241542121833) | zen422023 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| industrial tunnel · [Industrial Style Tunnel](https://create.roblox.com/store/asset/1882901199) | visionpsyche7 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| industrial tunnel · [🗿 Grunge Tunnel Concrete Urban Industrial Decay R](https://create.roblox.com/store/asset/97828357926734) | OrbitIqFlashB1258 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| industrial tunnel · [👽 Area 51 Lab Base Car Elevator Sci-fi](https://create.roblox.com/store/asset/101305249204569) | altuw999 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| market stall · [market stall](https://create.roblox.com/store/asset/15147571772) | Quantaily | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| market stall · [Market stall](https://create.roblox.com/store/asset/86311252190175) | IAmASwedishMale | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| market stall · [Market stall](https://create.roblox.com/store/asset/118134436668232) | IAmASwedishMale | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| motorcycle · [Motorcycle](https://create.roblox.com/store/asset/5602872985) | Lucekeen | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| motorcycle · [motorcycle](https://create.roblox.com/store/asset/12819226631) | Seru_SeruYTID2 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| motorcycle · [Dirt-Bike (Motorcycle)](https://create.roblox.com/store/asset/12875869842) | JuanCool_2004 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| pickup truck · [Ford Raptor Pickup Truck 2013](https://create.roblox.com/store/asset/9562232802) | angelitroxxx | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| pickup truck · [Pickup Truck](https://create.roblox.com/store/asset/6418225759) | Roblox | Shortlist: publisher Roblox; ตรวจ chassis/scripts/dependencies แยก ห้ามแทน Cub เดิมโดยตรง |
| pickup truck · [Simple working car/pickup truck](https://create.roblox.com/store/asset/8431871375) | Lego_DuckJustice | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| rubber tree · [Rubber Tree *for penguin8115*](https://create.roblox.com/store/asset/47466153) | shadowe22 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| rubber tree · [Small tree](https://create.roblox.com/store/asset/98246202053227) | FUN789GUY | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| rubber tree · [palm tree](https://create.roblox.com/store/asset/90872489) | SONlClTHElHEDGEHOGXX | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| tractor · [Tractor](https://create.roblox.com/store/asset/6218544412) | slendermaannn | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| tractor · [tractor](https://create.roblox.com/store/asset/18231475818) | Kricanss | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |
| tractor · [Old tractor](https://create.roblox.com/store/asset/4825999251) | SeaHarrierFRS1 | Hold: ต้องตรวจเจ้าของสิทธิ์และไฟล์ก่อน; ไม่เลือกจากลำดับผลค้น |

## แหล่งไทย Sketchfab

[Thai](https://sketchfab.com/tags/thai), [Thailand](https://sketchfab.com/tags/thailand), [Bangkok](https://sketchfab.com/tags/bangkok): เปิดด้วย web tool ตอบ403 ในรอบตรวจ จึงไม่ยืนยัน license/download/รายชื่อโมเดลจาก tag pages ไม่ bypass บัญชี ต้องหาโมเดลต้นทางที่มี commercial license ชัดเจนก่อนใช้ โดยเฉพาะตลาดน้ำ เรือ ตึกแถวไทย และต้นยาง ยังไม่มีชุดไทยที่ผ่านคัดกรองพร้อมนำเข้าจากสามหน้านี้

## UI ที่ระบุใน R04

| ชื่อ/แหล่ง | ผู้สร้าง/ราคา/รูปแบบ | License/ความปลอดภัย | สถานะ/ข้อเสนอ |
|---|---|---|---|
| [Studded UI Design Only](https://rblx-essentials.itch.io/studded-ui) | RBLX Essentials; ฟรี; หน้าเว็บระบุ ZIP52kB, .rbxm1ไฟล์,14เมนู | หน้าอนุญาตใช้/แก้ใน Roblox เชิงพาณิชย์ ห้ามขาย/แจก kit แยก; ต้องอ่าน README ใน archive อีกครั้ง คำว่าไม่มี scripts เป็นคำผู้เผยแพร่ | Found + License verified (page); Downloaded/Imported/Tested: No; รูปแบบ Studded ไม่ตรง Neon จึงเป็นตัวสำรอง ไม่ติดตั้ง controller ใหม่ |
| [RoCode UI kits](https://www.rocode.app/tools/roblox-ui-kits) | RoCode; gallery ฟรี/บริการมี credits; ต้องบัญชี+plugin ไม่ใช่ .rbxm download โดยตรง | ไม่พบ license standalone ที่ยืนยันแล้ว; มี currency/save/shop/reward server scripts เสี่ยงระบบซ้ำ | Found; license Hold; Downloaded/Imported/Tested: No; ไม่แนะนำเชื่อมบริการหรือติดตั้งรอบนี้ |
| [Kenney UI Pack](https://kenney.nl/assets/ui-pack) | Kenney; ฟรี; archive format ยังไม่ตรวจ | CC0 หน้า official; ไม่ได้ตรวจไฟล์ | Found + License verified (page); Downloaded/Imported/Tested: No; คัดไอคอนรองเท่านั้น |

เก็บ Main HUD เดิมและ UI07 เป็นเป้าหมาย ไม่ใช้ภาพ UI สำเร็จรูปเต็มจอแทนปุ่มจริง ไม่สร้าง Main Menu/Play-to-enter-map การแก้ Welcome flow เป็นงานหลัง gate แยกต่างหาก

## Asset เดิม ไม่ใช่ความคืบหน้าใหม่ R04

- A-Chassis1.7.2M: Downloaded/Imported แล้ว, ทดสอบขับ PC บางส่วนตาม R03; MPL2.0 เก็บใน assets/vendor/A-Chassis-LICENSE.txt; remote guard patches ใน VENDOR_PATCHES.md ไม่เท่ากับผ่าน multiplayer security หรือขับครบไปกลับ
- Underbone เดิม: Imported และทดสอบสวม body/ขึ้นรถบางส่วนตามหลักฐานเดิม ไม่ใช่ asset ใหม่ที่อนุมัติใน R04; Creator Store source13113759800 Kenzie_XD ยังต้องปิดข้อจำกัด dependency/สิทธิ์ production ไม่ประกาศ CC0
- ภาพ UI เจ้าของส่ง: มีไฟล์และ uploaded IDs เดิมใน assets/ui/manifest.json; การนำเข้าภาพไม่เท่ากับทุกหน้าทำงานแล้ว ไม่แจกภาพต้นฉบับเป็น kit

## ชุดเสนอเพื่ออนุมัติการตรวจเชิงลึก (ยังไม่อนุมัติติดตั้ง)

1. Kenney City Kit Industrial + Factory Kit: เลือกอาคาร/props มาประกอบ Garage01 เท่านั้น ต้องดู silhouette จริงก่อนยืนยันเป็น final art
2. Kenney Commercial/Suburban: ตัวเสริมร้านและหลังคา หากเข้ากับอู่ไทย; ไม่อนุมัติเหมาอาคารทุกชิ้น
3. Roblox Pickup Truck6418225759: ตรวจขับและ scripts ในฉากแยกเป็นตัวเปรียบเทียบ; รักษามอเตอร์ไซค์เดิม ไม่ใช้ body แทนผลทดสอบขับ
4. Kenney Roads/Racing: props/ป้ายสนาม ไม่แทนถนนหลักหรือแก้12โซน
5. คง Main HUD และ artwork UI07; ยังไม่แนะนำ RoCode เพราะซ้ำ backend; Studded เป็นตัวสำรองที่ยังไม่ตรงภาพเป้าหมาย

ชุดเหล่านี้เป็นรายการคัดกรองเพื่อขออนุมัติ ไม่ใช่คำรับรองว่าสวยหรือพร้อมผลิต ยังไม่มี Asset ใหม่ที่ผ่าน file security audit ในรอบนี้

## Gate ก่อนติดตั้ง และแผนตรวจถนน R03

- สำรอง generator/layout ก่อนแก้ ตรวจ source ของถนน/ฐาน/terrain ทุกชั้นและ collision groups ระบุ geometry ซ้อน ผิวเกือบร่วมระนาบ และรอยต่อจริง ไม่แก้ด้วยปิด collision ทั้งถนน
- สแกนระดับผิวสอง lane/ไหล่ทาง/ทางแยก/สะพาน/ทางเข้าอู่6หลัง/จุดCargo แยก finding กับ fix ไม่สรุปจาก center ray อย่างเดียว
- ทดสอบรถเริ่มต้นจริงจาก GarageCity ผ่าน01–12และกลับ พร้อม F pickup/deposit จุดใหม่ ตรวจรถชนขอบ/ติดรอยต่อ; teleport หรือรายงานระยะไม่แทน driven test
- ส่งภาพถนน/รอยต่อกับผลขับจริงก่อนติดตั้งชุดที่อนุมัติ หากยังไม่ผ่านให้รายงานจุดที่ล้มเหลว
- หลังผ่านและได้รับอนุมัติ Asset: quarantine ตรวจ hash/license/scripts/external require/remotes/deps/UV/texture/material/scale/pivot/triangles แล้ว import Garage01 แยกทดสอบก่อนคัดลอก ไม่แต่งครบ12โซน

## ผลตรวจรอบนี้

ค้นแหล่งจริงและบันทึกข้อจำกัดแล้ว; ไม่ดาวน์โหลดใหม่ ไม่ import ใหม่ ไม่แก้ถนนหรือ HUD ไม่ Publish ไม่ซื้อ ไม่ติดตั้งโปรแกรม ไม่รัน Build เพราะเป็นการแก้เอกสาร/metadata เท่านั้น Collision/Z-fighting/roundtrip ยังไม่ผ่านใหม่ และไม่มีภาพ Studio หรือผล Mobile/FPS ใหม่ที่ใช้รับรองงานรอบนี้
