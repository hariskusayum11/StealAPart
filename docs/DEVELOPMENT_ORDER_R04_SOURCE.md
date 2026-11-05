# STEAL A PART! — 3D ASSET SOURCING & UI IMPLEMENTATION
## Development Order R04 — พร้อมลิงก์แหล่งโมเดล

ฉันต้องการให้คุณค้นหา คัดเลือก ดาวน์โหลดหรือนำเข้าโมเดล 3D และ UI Assets เพื่อพัฒนาเกม Roblox ของเราให้มีคุณภาพใกล้เคียงเกม Simulator ระดับมืออาชีพ

**ชื่อเกม:** STEAL A PART!

**แผนที่:** Thailand Parts Highway

**จำนวนผู้เล่นเป้าหมาย:** 6 คนต่อเซิร์ฟเวอร์

**โครงสร้าง:** Garage City → ถนนสายหลักสองทิศทาง → Zone 01–12 ตามลำดับ → กลับอู่ทางช่องจราจรฝั่งกลับ

ห้ามสร้างเกมใหม่ ให้ทำงานต่อจากโปรเจกต์เดิม

---

# 1. กฎการใช้ Assets

1. ค้นหาโมเดลสำเร็จรูปจากแหล่งที่ระบุด้านล่างก่อน
2. เลือกโมเดลที่เข้ากับสไตล์ Roblox Cartoon / Stylized 3D
3. ตรวจสอบใบอนุญาตก่อนดาวน์โหลดและใช้งาน
4. เลือก Assets ที่ฟรีหรือใช้เชิงพาณิชย์ได้โดยไม่ต้องซื้อก่อน
5. ห้ามซื้อ Assets หรือใช้ของเสียเงินโดยไม่ได้รับอนุมัติ
6. ห้ามนำ Script แปลกปลอมจาก Free Models มาใช้งานโดยไม่ตรวจสอบ
7. ห้ามนำระบบรถจากโมเดลใหม่มาทับ Chassis เดิมโดยไม่ทดสอบ
8. ต้องปรับขนาด Collision และ Anchoring ให้เหมาะสม
9. ต้องคำนึงถึง FPS, Streaming และการเล่นบนมือถือ
10. ห้ามใช้ภาพอ้างอิงเป็นหลักฐานว่าได้ติดตั้งโมเดลจริงแล้ว

หากไม่สามารถดาวน์โหลดหรือนำเข้า Asset โดยตรงได้ ให้บันทึกลิงก์และสถานะไว้ ไม่ต้องสร้างโมเดลปลอมแล้วอ้างว่าเป็น Asset ที่ดาวน์โหลดมา

---

# 2. VEHICLE ASSETS — โมเดลรถ

## แหล่งที่ 1 — Kenney Car Kit
https://kenney.nl/assets/car-kit

ใช้ค้นหา:
- Hatchback
- Pickup Truck
- Sedan
- Sports Car
- รถ NPC
- อะไหล่และชิ้นส่วนรถ

## แหล่งที่ 2 — Roblox Motorcycle
https://create.roblox.com/store/models?keyword=motorcycle

ใช้ค้นหา:
- Street Cub
- รถมอเตอร์ไซค์ชาวบ้าน
- รถ NPC ไล่จับ

## แหล่งที่ 3 — Roblox Pickup Truck
https://create.roblox.com/store/models?keyword=pickup%20truck

ใช้ค้นหา:
- รถกระบะไทย
- รถ NPC ในโซนภูเขาและสวนยาง

## คำสั่ง

คัดเลือกรถที่เข้ากับเกมและทำให้เป็นโมเดลที่ใช้งานร่วมกับ Chassis เดิมได้

รถเริ่มต้นของผู้เล่น:
- Street Cub
- Street Hatch

อย่าเปลี่ยนฟิสิกส์รถโดยไม่จำเป็น

ถ้าโมเดลเป็นเพียง Mesh ให้ใช้เป็นตัวถังและเชื่อมเข้ากับระบบขับขี่ที่มีอยู่

---

# 3. GARAGE CITY — อู่ผู้เล่น 6 หลัง

## แหล่งโมเดล

Garage Workshop:
https://create.roblox.com/store/models?keyword=garage%20workshop

Kenney City Kit Commercial:
https://kenney.nl/assets/city-kit-commercial

Kenney City Kit Suburban:
https://kenney.nl/assets/city-kit-suburban

## สิ่งที่ต้องสร้าง

อู่ผู้เล่น 6 หลัง จัดแบบ 2 แถว × 3 หลัง

แต่ละอู่ต้องมี:
- ตัวอาคารโรงรถ
- ประตูอู่
- พื้นที่จอดรถ
- ป้าย Garage 01–06
- ป้ายชื่อเจ้าของอู่เมื่อมีระบบรองรับ
- ชั้นวางอะไหล่
- จุดฝาก Cargo
- ไฟส่องสว่าง
- โต๊ะช่าง
- กล่องเครื่องมือ
- ยางรถยนต์
- ของตกแต่งร้านซ่อมรถ

ต้องมีทางเข้าออกที่รถใช้งานได้จริง

ห้ามวางของตกแต่งกีดขวางเส้นทางรถ

ทำ Garage 01 ให้สมบูรณ์เป็นต้นแบบก่อน แล้วค่อยนำรูปแบบไปใช้กับอู่อีก 5 หลัง

---

# 4. FACILITY BUILDINGS — อาคารระบบหลัก

แหล่งโมเดล:
https://kenney.nl/assets/city-kit-commercial

https://kenney.nl/assets/city-kit-industrial

https://create.roblox.com/store/models?keyword=car%20workshop

ให้พัฒนาอาคาร 6 ประเภท:

1. Race Hub — อาคารสนามแข่ง
2. Parts Market — ตลาดซื้อขายอะไหล่
3. Shop — ร้านค้า
4. Upgrade Center — ศูนย์อัปเกรดรถ
5. Event Plaza — ลานกิจกรรม
6. Speed Track — สนามทดสอบความเร็ว

แต่ละอาคารต้องมี:
- ป้ายชื่อ
- จุดทางเข้า
- แสงไฟ
- จุดจอดรถ
- ตกแต่งตามประเภทอาคาร
- ProximityPrompt หรือจุด Interact เมื่อเหมาะสม
- เส้นทางเชื่อมจากถนนบริการ

ถ้าระบบภายในอาคารยังไม่เสร็จ ให้แสดงสถานะ Prototype หรือ Coming Soon อย่างชัดเจน

---

# 5. THAILAND PARTS HIGHWAY — 12 ZONES

ให้ใช้โมเดลสำเร็จรูปประกอบฉาก โดยแต่ละโซนต้องมีเอกลักษณ์ชัดเจน

## Zone 01 — ซอยช่างบ้านเรา
ธีม: หมู่บ้านไทย

Assets:
- บ้านไม้
- ร้านซ่อมมอเตอร์ไซค์
- ต้นกล้วย
- ร้านขายของริมถนน
- เสาไฟ
- ป้ายภาษาไทย

แหล่ง:
https://sketchfab.com/tags/thai

https://kenney.nl/assets/city-kit-suburban

## Zone 02 — ตลาดน้ำอะไหล่ซิ่ง
ธีม: ตลาดน้ำไทย

Assets:
- บ้านริมน้ำ
- เรือหางยาว
- ร้านค้าลอยน้ำ
- สะพานไม้
- คลอง

แหล่ง:
https://sketchfab.com/tags/thailand

https://create.roblox.com/store/models?keyword=floating%20market

## Zone 03 — ทุ่งนาซิ่งสายฝุ่น
ธีม: ทุ่งนา

Assets:
- ต้นข้าว
- รถไถ
- กระท่อม
- ต้นไม้
- ถนนดินแดง

แหล่ง:
https://kenney.nl/assets/nature-kit

https://create.roblox.com/store/models?keyword=tractor

## Zone 04 — ถนนตลาดแซ่บ
ธีม: ตลาดอีสาน

Assets:
- ร้านอาหารริมถนน
- รถตุ๊กตุ๊ก
- แผงขายของ
- ป้ายร้านภาษาไทย
- ไฟประดับ

แหล่ง:
https://create.roblox.com/store/models?keyword=market%20stall

https://sketchfab.com/tags/thai

## Zone 05 — ดอยโค้งร้อยศอก
ธีม: ภูเขาภาคเหนือ

Assets:
- บ้านล้านนา
- ต้นสน
- หิน
- ทางโค้ง
- จุดชมวิว

แหล่ง:
https://kenney.nl/assets/nature-kit

https://sketchfab.com/tags/thailand

## Zone 06 — สวนยางสายแรง
ธีม: สวนยางภาคใต้

Assets:
- ต้นยางพารา
- กระท่อมสวนยาง
- ถังน้ำยาง
- รถกระบะ
- ทางสวน

แหล่ง:
https://create.roblox.com/store/models?keyword=rubber%20tree

https://kenney.nl/assets/nature-kit

## Zone 07 — ท่าเรือซิ่งริมเล
ธีม: ท่าเรือประมง

Assets:
- เรือประมง
- ท่าเทียบเรือ
- ตู้คอนเทนเนอร์
- โกดัง
- เครน

แหล่ง:
https://create.roblox.com/store/models?keyword=fishing%20dock

https://kenney.nl/assets/city-kit-industrial

## Zone 08 — นิคมเหล็กเดือด
ธีม: โรงงานอุตสาหกรรม

Assets:
- โรงงาน
- ปล่องควัน
- เครื่องจักร
- ท่อเหล็ก
- รถบรรทุก

แหล่ง:
https://kenney.nl/assets/factory-kit

https://create.roblox.com/store/models?keyword=industrial%20factory

## Zone 09 — บางกอกไนท์เรซ
ธีม: กรุงเทพกลางคืน

Assets:
- ตึกเมือง
- ทางด่วน
- ป้ายไฟนีออน
- ร้านแต่งรถ
- รถสปอร์ต

แหล่ง:
https://sketchfab.com/tags/bangkok

https://kenney.nl/assets/city-kit-commercial

## Zone 10 — อุโมงค์ช่างเถื่อน
ธีม: อู่ใต้ดิน

Assets:
- อุโมงค์
- ประตูเหล็ก
- เครื่องมือช่าง
- ไฟสีแดง
- ท่ออุตสาหกรรม

แหล่ง:
https://create.roblox.com/store/models?keyword=industrial%20tunnel

## Zone 11 — นครนีออนไทยแลนด์
ธีม: เมืองอนาคต

Assets:
- อาคารไซไฟ
- ป้ายโฮโลแกรม
- ไฟนีออน
- ถนนเมืองอนาคต
- อาคารสูง

แหล่ง:
https://create.roblox.com/store/models?keyword=cyberpunk%20city

## Zone 12 — คลังอะไหล่ตำนาน
ธีม: ป้อมคลังอะไหล่ทองคำ

Assets:
- ป้อมขนาดใหญ่
- ประตูคลัง
- เฟืองทอง
- แสงสีทอง
- จุด Boss

แหล่ง:
https://create.roblox.com/store/models?keyword=golden%20vault

---

# 6. ROADS & ENVIRONMENT

แหล่ง:
https://kenney.nl/assets/city-kit-roads

https://kenney.nl/assets/racing-kit

https://kenney.nl/assets/nature-kit

ให้ใช้ตกแต่ง:
- ทางแยก
- ถนนบริการ
- ไฟถนน
- ป้ายทางหลวง
- ป้ายบอกโซน
- ราวกั้น
- ต้นไม้
- หิน
- ภูเขา
- สนามแข่ง

ห้ามรื้อถนนหลักที่สร้างแล้วโดยไม่จำเป็น

ถนนหลักต้องเป็นเส้นทางต่อเนื่องตามลำดับ Zone 01–12 ไม่เป็นวงกลม

---

# 7. UI ASSETS — STEAL A PART!

เกมของเราไม่มีหน้า Main Menu และไม่มีปุ่ม Play เพื่อเข้าแมพ

ผู้เล่นต้อง:
Loading → Spawn ที่อู่ → Welcome/Starter Selection ตามเงื่อนไข → เล่นบนแมพจริง

UI 07 เป็น In-Game HUD ที่แสดงทับภาพโลก 3D จริง

## แหล่ง UI

RoCode Roblox UI Kits:
https://www.rocode.app/tools/roblox-ui-kits

Kenney UI Pack:
https://kenney.nl/assets/ui-pack

Studded UI:
https://rblx-essentials.itch.io/studded-ui

## สิ่งที่ต้องสร้าง

### Main HUD
- Game Logo
- Coins
- Gems (เฉพาะเมื่อมีระบบรองรับ)
- Power
- Current Zone
- Mini Map
- Daily Quests
- Notifications

### Left Menu
- Garage
- Shop
- Upgrade
- Parts Market
- Race Hub
- Event Plaza

### Bottom HUD
- Cargo Slots
- Carried Parts
- Garage Distance
- NPC Chase Alert
- Speedometer เมื่อขับรถ
- Mobile Controls เมื่อใช้อุปกรณ์สัมผัส

### Popup Windows
- Garage Management
- Inventory
- Shop
- Upgrade
- Race
- Events
- Parts Market
- World Map
- Settings

ให้ใช้ภาพ UI 07 ที่ฉันแนบเป็น Visual Reference

ห้ามนำภาพ UI 07 ทั้งภาพมาแปะเป็น ImageLabel เดียว

ต้องสร้างด้วย Roblox GUI Objects แยกเป็นชิ้นและรองรับ PC/Mobile

ปุ่มต้องเปิดหน้าต่างได้จริง และแสดงสถานะ Coming Soon หาก Backend ยังไม่พร้อม

---

# 8. ASSET IMPORT & SECURITY

ก่อนนำโมเดลเข้าเกมต้องตรวจ:

- License
- Creator / Source
- Scripts
- ModuleScripts
- RemoteEvents
- External Dependencies
- Mesh / Texture IDs
- Collision
- Anchoring
- Polygon Complexity
- จำนวน Parts
- Performance

ห้ามใช้โมเดลที่มีโค้ดอันตรายหรือแหล่งที่มาไม่ชัดเจน

ห้ามดาวน์โหลดโมเดลจากเว็บที่ละเมิดลิขสิทธิ์

สำหรับโมเดลจาก Sketchfab ให้ตรวจสิทธิ์ดาวน์โหลดและการใช้เชิงพาณิชย์ของแต่ละชิ้น

---

# 9. DEVELOPMENT PRIORITY

อย่าพยายามตกแต่งทั้ง 12 โซนให้เสร็จในรอบเดียว

ให้ทำตามลำดับ:

Phase 1 — ตรวจสอบ Assets และจัดทำ Asset Catalog

Phase 2 — แก้ไข Blockout R03 ให้ขับไปกลับครบ 12 โซนได้จริง

Phase 3 — เปลี่ยน Garage 01 ให้เป็นอู่ต้นแบบที่สวยและใช้งานได้

Phase 4 — สร้าง UI 07 In-Game HUD ที่ใช้งานได้จริง

Phase 5 — สร้าง Garage City และอาคารระบบหลัก

Phase 6 — ตกแต่ง Zone 01 ให้เป็นต้นแบบ

Phase 7 — ทดสอบประสิทธิภาพ PC/Mobile

Phase 8 — รออนุมัติก่อนขยายไป Zone 02–12

---

# 10. REQUIRED DELIVERABLES

ก่อนลงมือ Import จำนวนมาก ให้ส่งรายงาน Asset Catalog โดยระบุ:

1. ชื่อ Asset
2. ลิงก์ต้นฉบับ
3. ผู้สร้าง
4. License
5. ฟรีหรือเสียเงิน
6. ประเภทไฟล์
7. ใช้ในส่วนใดของเกม
8. สถานะดาวน์โหลด
9. สถานะ Import
10. ความเสี่ยงหรือข้อจำกัด

จากนั้นให้ส่งภาพจาก Roblox Studio จริง:
- Garage 01 ก่อนและหลังปรับ
- Garage City
- อาคารระบบหลัก
- Zone 01
- Main HUD บนแมพจริง
- Main HUD บนมือถือ

ห้ามใช้ภาพคอนเซ็ปต์เป็นหลักฐานว่า Implement สำเร็จ

**เริ่มจากสำรวจ Assets ตามลิงก์ทั้งหมด และเสนอรายการที่เหมาะสมที่สุดให้ฉันอนุมัติก่อนนำเข้าโปรเจกต์จริง**

หากเข้าถึงเว็บไซต์ภายนอกไม่ได้ ให้ระบุว่าเข้าถึงไม่ได้และส่งรายการลิงก์ให้ตรวจเอง ห้ามอ้างว่าดาวน์โหลดหรือตรวจ License สำเร็จแล้ว
