# STEAL A PART! — Development Order R03 + Complete UI System
## Roblox Studio | Thailand Parts Highway

ฉันต้องการให้คุณพัฒนาเกม STEAL A PART! ต่อจากโปรเจกต์เดิม โดยทำงาน 2 ส่วนหลัก ได้แก่

**PART A — แก้ไข Blockout Revision 03 ให้ขับรถได้จริง**

**PART B — สร้างระบบ UI ของเกมทั้งหมดตามภาพอ้างอิง UI 01–07**

ห้ามสร้างโปรเจกต์ใหม่ ห้ามลบระบบเดิม และห้ามใช้ภาพ UI ทั้งภาพเป็นหน้าจอสำเร็จรูป

---

# PART A — MAP BLOCKOUT REVISION 03

## A1. แก้ไขการขับรถไปกลับ 12 โซน

ปัจจุบันถนนหลักเชื่อมจาก Garage City ไป Zone 12 แล้ว แต่ยังไม่ผ่านการทดสอบขับกลับอู่แบบต่อเนื่อง

ให้ดำเนินการดังนี้:

1. ตรวจสอบลานกลับรถ Zone 12
2. ตรวจสอบรอยต่อถนน ความชัน และการชน
3. ทดสอบ Street Cub และ Street Hatch
4. ขับจาก Garage City → Zone 12 → Garage City ด้วยรถจริง
5. ห้ามใช้ Teleport หรือ CFrame เพื่ออ้างว่าขับผ่าน
6. ทดสอบการรับและฝาก Cargo หลังขับกลับอู่
7. ตรวจสอบ StreamingEnabled หลังเปิดไฟล์ Build ใหม่
8. ตรวจสอบถนน สะพาน และจุดเสี่ยงรถตก

หากยังทดสอบไม่ผ่าน ให้รายงานปัญหาตามจริง ห้ามอ้างว่าผ่านแล้ว

## A2. รักษาระบบเดิม

ต้องรักษา:
- รถและระบบขับขี่
- Rider Pose
- ระบบขึ้นลงรถ
- Cargo Pickup / Deposit
- HUD เดิมจนกว่า UI ใหม่จะทดแทนได้
- Welcome Artwork เดิม
- RemoteEvents ที่มีอยู่
- โครง Garage City 6 หลัง
- ถนน 12 โซน
- ระบบที่มีอยู่ในโปรเจกต์

ให้สำรองก่อนแก้ และตรวจสอบผลกระทบทุกครั้ง

---

# PART B — COMPLETE GAME UI SYSTEM

## B1. เป้าหมาย

สร้าง UI ของ STEAL A PART! ให้เป็นเกม Roblox ที่มีคุณภาพ ดูทันสมัย สดใส และใช้งานง่าย

สไตล์:
- Roblox 3D Cartoon
- Neon Blue / Purple / Orange / Yellow
- พื้นหลังสีน้ำเงินเข้ม
- ขอบเรืองแสง
- มุมโค้ง
- ไอคอนใหญ่ อ่านง่าย
- รองรับภาษาไทยและภาษาอังกฤษ
- รองรับ PC และ Mobile

ใช้ภาพ UI ที่ฉันแนบเป็น **Visual Reference** เท่านั้น

**ห้ามใช้ภาพ UI ทั้งภาพเป็น Background หรือ ImageLabel เดียว**

ให้สร้าง UI ด้วย Roblox GUI Objects เช่น:
- ScreenGui
- Frame
- TextLabel
- TextButton
- ImageLabel
- ImageButton
- UICorner
- UIStroke
- UIGradient
- UIListLayout
- UIPadding
- UIScale
- UIAspectRatioConstraint ตามความเหมาะสม

สามารถใช้รูปภาพแยกเฉพาะ Logo, Icons, Illustrations และ Decorative Assets

ข้อมูลทั้งหมดต้องเปลี่ยนได้ตามสถานะเกมจริง

---

# UI 01 — GAME LOGO

ใช้โลโก้ STEAL A PART! ที่ออกแบบไว้แล้ว

ตำแหน่งใช้งาน:
- Loading Screen
- Welcome UI
- Main HUD
- เมนูหลักบางส่วน

ให้ใช้ ImageLabel และรักษาสัดส่วนของโลโก้

หากยังไม่มี Asset ID ที่ใช้งานได้ ให้ทำ Placeholder และรายงานว่าต้องนำเข้า Asset ใด

---

# UI 02 — GAME ICON

ใช้เป็นภาพไอคอนเกม Roblox

หากยังไม่ได้อัปโหลดเป็น Game Icon ให้รายงานขั้นตอนที่ต้องทำ

ไม่ต้องสร้าง Game Icon ใหม่โดยไม่ได้รับอนุมัติ

---

# UI 03 — LOADING SCREEN

แสดงระหว่างรอโหลดเกม

องค์ประกอบ:
- ภาพพื้นหลัง Loading ที่ออกแบบไว้
- Logo
- Progress Bar
- ข้อความ Loading
- Tips การเล่น

ตัวอย่าง Tips:
- ขับรถไปหาอะไหล่
- ใครเก็บก่อนคนนั้นได้
- ระวัง NPC ไล่จับ
- กลับอู่เพื่อฝากอะไหล่

Loading ต้องอ้างอิงสถานะการเตรียมเกมที่ตรวจสอบได้ ไม่ใช้แถบเปอร์เซ็นต์ปลอม

เมื่อข้อมูลจำเป็นพร้อมและตัวละคร Spawn สำเร็จ ให้ปิด Loading Screen

---

# UI 04 — WELCOME REWARDS & OFFERS

แสดงหลังโหลดแมพและผู้เล่นเกิดที่อู่ของตัวเองแล้ว

องค์ประกอบ:
- Welcome to STEAL A PART!
- คำแนะนำเกม 3 ขั้นตอน
- Welcome Reward
- Starter Pack
- ปุ่ม Claim
- ปุ่ม Close

ขั้นตอนการเล่น:
1. ขับรถไปหาอะไหล่
2. เก็บอะไหล่แล้วหนี NPC
3. กลับอู่เพื่อฝากและรับรายได้

ตัวเลขรางวัล เช่น 500 Coins + 100 Power เป็นค่าเสนอเดิม ต้องทำเป็น Config และให้ฉันอนุมัติก่อนเปิดแจกจริง

Starter Pack ต้องไม่ทำรายการซื้อเงินจริงจนกว่าจะกำหนดสินค้า ราคา และ Developer Product/Game Pass ID ที่ถูกต้อง

รางวัล Welcome ต้องรับได้เพียงครั้งเดียวตามนโยบายข้อมูลผู้เล่นที่กำหนด

หากยังไม่มีระบบบันทึกถาวร ห้ามอ้างว่าป้องกันการรับซ้ำข้ามเซสชันได้แล้ว

---

# UI 05 — STARTER VEHICLE SELECTION

สำหรับผู้เล่นใหม่ที่ยังไม่ได้เลือกรถเริ่มต้น

มีรถ 2 รุ่น:
- Street Cub — มอเตอร์ไซค์
- Street Hatch — รถยนต์แฮตช์แบ็ก

แสดง:
- ภาพหรือโมเดล Preview รถ
- ชื่อรถ
- Speed
- Acceleration
- Handling
- ปุ่ม Select
- ปุ่ม Confirm

เมื่อยืนยัน ให้กำหนดรถเริ่มต้นของผู้เล่นและ Spawn รถจริง

ห้ามให้ผู้เล่นรับรถเริ่มต้นซ้ำโดยไม่ตั้งใจ

หากยังไม่มีระบบ DataStore ให้ทำระบบ Session Test และรายงานข้อจำกัดอย่างชัดเจน

---

# UI 06 — FIRST-TIME TUTORIAL

สร้าง Tutorial แบบทีละขั้น

ขั้นตอน:
1. ไปที่รถ
2. ขึ้นรถ
3. ขับไป Zone 01
4. หาอะไหล่
5. เก็บอะไหล่
6. หนี NPC
7. กลับ Garage City
8. ฝากอะไหล่

UI ต้องมี:
- Tutorial Card
- Progress Indicator
- ปุ่ม Next / Skip ตามเงื่อนไข
- ลูกศรหรือ Marker นำทาง
- Highlight จุดสำคัญ

Tutorial ต้องตรวจสอบการกระทำจริงของผู้เล่น ไม่ใช่กด Next แล้วถือว่าทำภารกิจสำเร็จ

หาก Shared Loot หรือ NPC ยังไม่ได้สร้าง ให้แสดงสถานะ Demo/Unavailable อย่างชัดเจน ไม่ทำ Tutorial ปลอมว่าเล่นครบแล้ว

---

# UI 07 — MAIN HUD

นี่คือหน้าจอหลักที่ผู้เล่นเห็นระหว่างเล่นเกม

ให้สร้างตามภาพอ้างอิง UI 07 ที่ฉันแนบ แต่ต้องปรับให้ใช้งานได้จริงและไม่บังพื้นที่เล่น

## Top Bar

แสดง:
- Coins
- Gems (ถ้ามีระบบจริง)
- Power
- ปุ่มเพิ่มทรัพยากรเฉพาะที่มีฟังก์ชันรองรับ
- Daily Rewards
- Events
- Notifications

ข้อมูลต้องมาจากสถานะผู้เล่นจริง

ห้ามสร้างตัวเลขเงินหรือ Gems ปลอมเพื่อให้ UI ดูสวย

## Left Navigation

ปุ่ม:
- Garage
- Shop
- Upgrade
- Parts Market
- Race Hub
- Event Plaza

แต่ละปุ่มต้องเปิด Panel ที่ถูกต้อง

ถ้าระบบ Backend ยังไม่มี ให้เปิดหน้าข้อมูลสถานะ Coming Soon หรือ Prototype อย่างชัดเจน

ห้ามแสดงข้อความว่าซื้อ ขาย หรืออัปเกรดสำเร็จโดยไม่มีการทำงานจริง

## Right Side

- Mini Map
- Current Zone
- Daily Quests
- Notification Panel

Mini Map ควรแสดงตำแหน่งผู้เล่นและทิศทางตามข้อมูลโลกจริง หากยังไม่มีระบบแผนที่ ให้ใช้ปุ่มเปิด World Map แทนก่อน

## Bottom HUD

แสดง:
- Speedometer
- Vehicle Status
- Cargo Capacity
- Carried Parts
- Return to Garage Indicator
- NPC Chase Warning
- NOS Button เฉพาะเมื่อรถมีระบบ NOS จริง

ตัวอย่าง:
Cargo 2/5
Zone 01 — ซอยช่างบ้านเรา
NPC CHASING!
Garage Distance 3,420 studs

ค่าทั้งหมดต้องเป็นข้อมูลจริง ไม่ใช้ค่าคงที่จากภาพตัวอย่าง

## Context Sensitive HUD

เมื่อเดิน:
- แสดงปุ่ม Interact
- แสดงคำแนะนำเก็บอะไหล่
- ซ่อนปุ่มขับรถที่ไม่เกี่ยวข้อง

เมื่อขับรถ:
- แสดง Speedometer
- แสดงปุ่มควบคุมรถ
- แสดง Cargo และ NPC Chase
- ซ่อน UI ที่ไม่จำเป็น

เมื่อเปิดเมนู:
- ลดความรกของ HUD
- ให้ผู้เล่นปิดเมนูได้ง่าย

---

# UI 08 — GARAGE PANEL

สร้างหน้า Garage Management

องค์ประกอบ:
- ชื่อเจ้าของอู่
- รถที่ครอบครอง
- อะไหล่ที่ฝากแล้ว
- รายได้ Coins/min
- พื้นที่จัดแสดงอะไหล่
- ปุ่มจัดการรถ
- ปุ่มขยายอู่

ระบบที่ยังไม่มีให้เป็น Prototype UI และแยกจากระบบจริง

---

# UI 09 — PARTS INVENTORY

สร้างหน้ารายการอะไหล่

แสดง:
- Part Name
- Rarity
- Value
- Coins/min
- จำนวนที่ครอบครอง
- สถานะ Carried / Deposited

ระดับความหายาก:
Common, Uncommon, Rare, Epic, Mythic, Legendary

รองรับการกรองและเรียงลำดับ

---

# UI 10 — SHOP

สร้างหน้าร้านค้า

แยกหมวด:
- Vehicles
- Parts
- Upgrades
- Cosmetics
- Special Offers

ห้ามเปิดการซื้อจริงหากไม่มี Backend ที่ตรวจสอบราคา ยอดเงิน และการมอบสินค้า

---

# UI 11 — UPGRADE CENTER

แสดง:
- Vehicle Preview
- Current Stats
- Upgrade Levels
- Upgrade Cost
- Speed
- Acceleration
- Handling
- Cargo Capacity

การอัปเกรดจริงต้องให้ Server ตรวจสอบเงินและสิทธิ์ของผู้เล่น

---

# UI 12 — RACE HUB

สร้างหน้าแข่งขัน

แสดง:
- Race Selection
- Race Registration
- Countdown
- Position
- Lap / Progress
- Results
- Leaderboard
- Rewards

หากระบบแข่งยังไม่พร้อม ให้สร้างเฉพาะเมนู Prototype และไม่แสดงผลการแข่งขันปลอม

---

# UI 13 — EVENT PLAZA

สร้างหน้า Events

แสดง:
- Active Events
- Upcoming Events
- Event Timer
- Missions
- Rewards
- Claim Status

Event Timer ต้องใช้เวลาและสถานะจากระบบจริง

---

# UI 14 — PARTS MARKET

สร้างหน้าตลาดอะไหล่

แสดง:
- My Parts
- Sell
- Buy
- Trade
- Item Details

ระบบซื้อขายระหว่างผู้เล่นต้องมีการตรวจสอบจาก Server และป้องกันการทำรายการซ้ำ

ยังไม่ต้องเปิด Trading จริงจนกว่าจะมีระบบ Inventory และการบันทึกข้อมูลถาวรที่ปลอดภัย

---

# UI 15 — WORLD MAP

สร้างแผนที่สำหรับ Thailand Parts Highway

ต้องมี:
- Garage City
- Race Hub
- Shop
- Parts Market
- Upgrade Center
- Event Plaza
- Zone 01–12
- ตำแหน่งผู้เล่น
- Current Zone
- ระดับความยากของโซน

ต้องแสดงถนนสายหลักที่เดินทางตามลำดับ Zone 01 → Zone 12

แผนที่ต้องอิงตำแหน่งจริงจาก HubLayout หรือระบบพิกัดที่ใช้อยู่ ไม่ใช่ภาพแมพคอนเซ็ปต์ที่มีตำแหน่งไม่ตรงกับโลกจริง

---

# UI 16 — SETTINGS & NOTIFICATIONS

สร้าง:
- Settings
- Audio Settings
- Graphics Settings
- UI Scale
- Notification Center
- Confirmation Dialog
- Error Messages
- Success Messages

การตั้งค่าต้องมีผลจริงตามขอบเขตที่ Roblox รองรับ

---

# UI ARCHITECTURE

จัดระบบ UI ให้แก้ไขและขยายได้ง่าย

เสนอให้แยกเป็น:

StarterGui
- LoadingGui
- WelcomeGui
- VehicleSelectionGui
- TutorialGui
- MainHUDGui
- MenuGui
- NotificationGui

ReplicatedStorage
- UIComponents
- UIConfig
- ThemeConfig
- Localization
- SharedState

StarterPlayerScripts
- UIController
- HUDController
- MenuController
- TutorialController

สามารถปรับโครงสร้างตามสถาปัตยกรรมโปรเจกต์เดิมได้ แต่ต้องหลีกเลี่ยงการสร้าง Controller ซ้ำซ้อน

ให้ใช้:
- Responsive Layout
- UIScale
- Safe Area
- UI Constraints
- Reusable Components
- Data Binding
- Tween Animations
- Keyboard / Mouse / Touch Support

ห้ามใช้การกำหนดตำแหน่งแบบตายตัวทั้งหมดจน UI พังบนมือถือ

---

# UI INTERACTION RULES

1. ทุกปุ่มต้องกดได้
2. ทุกเมนูต้องเปิดและปิดได้
3. ข้อมูลต้องอัปเดตจากสถานะเกม
4. ไม่มีปุ่มตกแต่งที่ดูเหมือนใช้งานได้แต่กดแล้วไม่เกิดอะไร
5. ฟังก์ชันที่ยังไม่สร้างต้องระบุสถานะอย่างชัดเจน
6. UI ไม่บังปุ่มควบคุมรถบนมือถือ
7. UI ไม่บังจุด Interact หรือ ProximityPrompt
8. ไม่แสดง HUD ขับรถเมื่อผู้เล่นไม่ได้ขับ
9. ไม่ให้เมนูหลายหน้าทับกันจนใช้งานไม่ได้
10. ต้องทดสอบทุกหน้าบน PC และ Mobile

---

# DEVELOPMENT ORDER

ให้แบ่งงานเป็นขั้นตอนดังนี้:

**Phase 1 — Project Audit**
ตรวจระบบเดิมและ UI ที่มีอยู่ก่อนแก้ไข

**Phase 2 — UI Foundation**
สร้าง Theme, Components, UIController และระบบเปิดปิดเมนู

**Phase 3 — Main HUD**
สร้าง UI 07 ก่อน เพราะต้องใช้ระหว่างทดสอบเกม

**Phase 4 — Core Player Flow**
สร้าง Loading, Welcome, Vehicle Selection และ Tutorial

**Phase 5 — Functional Menus**
สร้าง Garage, Inventory, Shop, Upgrade, Race, Events, Market และ World Map

**Phase 6 — Integration**
เชื่อม UI กับระบบเกมจริงเท่าที่มีอยู่ และแสดง Prototype สำหรับส่วนที่ยังไม่มี Backend

**Phase 7 — Testing**
ทดสอบการเล่นจริงและ UI บน PC/Mobile

ทำงานเป็นขั้นตอน ห้ามสร้าง UI ทั้งหมดแบบผิวเผินเพียงเพื่อรายงานว่าเสร็จ

---

# ACCEPTANCE CRITERIA

ก่อนส่งงานต้องมี:

1. ภาพ Main HUD ขณะเดิน
2. ภาพ Main HUD ขณะขับรถ
3. ภาพเมนู Garage
4. ภาพเมนู Inventory
5. ภาพเมนู Shop
6. ภาพ World Map
7. ภาพ UI บนมือถือ
8. รายการปุ่มที่ทำงานจริง
9. รายการระบบที่ยังเป็น Prototype
10. ผลทดสอบ Blockout R03 และการขับไปกลับครบ 12 โซน

ให้รายงานแยกชัดเจนว่า:
- Implemented
- Connected to Backend
- UI Prototype Only
- Not Implemented
- Tested / Not Tested

**ห้ามอ้างว่า UI หรือระบบเกมเสร็จสมบูรณ์หากยังไม่ได้ทดสอบจริง**

ให้เริ่มจาก Project Audit และ Main HUD ก่อน จากนั้นส่งภาพให้ฉันตรวจอนุมัติ แล้วจึงทำ UI ถัดไป
