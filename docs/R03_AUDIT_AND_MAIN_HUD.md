# R03 — Audit + UI Foundation + Main HUD review

วันที่ 2026-11-04 · ดำเนินการเฉพาะด่าน Audit/Foundation/Main HUD ตามคำสั่ง R03 ให้เจ้าของตรวจภาพก่อน UI ถัดไป

## ภาพจริงจาก Studio
- [HUD ขณะเดิน](mcp-check/r03-main-walking.png)
- [HUD ขณะขับ](mcp-check/r03-main-driving.png)
- [Garage status panel — Prototype](mcp-check/r03-final-garage-shot.png)

ภาพสอง HUD ใช้ crop โลโก้/ไอคอนจากชุดภาพผู้ใช้ ส่วนกรอบ ปุ่ม ข้อความ และตัวเลขเป็น GUI Objects. ไม่มีการแปะภาพ UI ทั้งหน้าเป็น Main HUD.

## Project Audit
- รถที่มีจริง: Street Cub mesh + chassis ทดสอบ; ไม่มี Street Hatch ที่พร้อมขับ จึงยังทดสอบรถยนต์ตาม Part A ไม่ได้.
- Server: Lab.server.luau ดูแล Cargo แบบ session และตรวจผู้ขับ/ระยะ/ความเร็ว. ไม่พบ DataStore ใน src; ไม่มีระบบเงิน, Power, Gems, รายได้อู่, Shared Loot หรือ NPC chase ที่สมบูรณ์.
- Vendor remote และ rider/camera เดิมคงไว้; ไม่สร้างช่องทางซื้อ/รับรางวัลจาก client. สำรองก่อนแก้ backups/pre-r03-ui-*.
- Main HUD เดิมปรับใน LabHUD controller เดิม ไม่เพิ่ม controller แข่งขันกัน. Theme ใน src/shared/UITheme.luau, Components ใน src/client/UI/Components.luau.
- Welcome เดิมใช้ภาพ UI ทั้งหน้า ขัด R03: เปลี่ยน source เป็นภาพอู่ที่ไม่มี UI สำเร็จรูป + cropped logo + native labels/buttons/readiness. เก็บ source artwork เดิมครบ. การแก้ Welcome รอบนี้ Build checked และ Editor synced เท่านั้น ยังไม่ใช่ Core Player Flow/Rewards ที่เสร็จ.

## สถานะตามที่ขอ
| ส่วน | สถานะ | ข้อมูล/ผลทดสอบ |
|---|---|---|
| Theme, panels/buttons, border/hover/press/selected/disabled helper | Implemented | native GUI; แก้ UIStroke ให้เป็นขอบแทน stroke ตัวหนังสือ |
| Speed / Gear / engine state | Implemented + Connected to Backend | อ่าน chassis จริง; เดินซ่อนตัวเลขความเร็ว ขับแสดงเกียร์1; PC tested |
| Cargo / deposited count / feedback | Implemented + Connected to Backend | ใช้ TestCargo/TestSecured/CargoMessage ของ server เดิม ไม่มี item rarity/value ปลอม |
| Zone / straight-line garage distance | Implemented | อิง HubLayout และตำแหน่ง character จริง; ไม่อ้างเป็นระยะถนน |
| Coins/Power/Gems | Not Implemented backend | แสดง Coins/Power เฉพาะมี numeric attribute จริง; Gems ไม่แสดง |
| Navigation 6 ปุ่ม + one-menu-at-a-time | Implemented UI | เปิด title/status panel ถูกหน้าและปิดได้จริง; ทุกปุ่มทดสอบเมาส์ PC |
| Garage management / Shop / Upgrade / Market / Race / Event | UI Prototype Only | เป็น status panels ไม่มีซื้อ ขาย รายได้ upgrade การแข่ง หรือแจกของ |
| Notifications / UI scale | Implemented limited UI | notification history จาก Cargo; scale 100->90% tested. ไม่ใช่ Settings เต็ม |
| World Map | UI Prototype Only entry point | ปุ่มเปิดคำอธิบายว่ายังรอ Phase เมนู; ยังไม่สร้างแผนที่จริง |
| Inventory / selection / tutorial / rewards / full settings | Not Implemented | รอ approval HUD ก่อนสร้างขั้นถัดไป |
| Logo | Implemented | UI kit upload 92686584842368; ImageRect crop เฉพาะโลโก้และไอคอน; Logo.IsLoaded=true ใน Studio |
| Game Icon | Not Implemented deployment | ไม่อัปโหลด Game Icon หรือ Publish เกม |
| Mobile / tablet | Not Tested | มี compact layout + scroll navigation + touch hints; ทดสอบได้แค่หน้าต่าง PC ขนาดเล็ก ไม่เรียกเป็น Mobile QA |
| Localization | Partial | labels ไทย/อังกฤษบางส่วน; ยังไม่ใช่ระบบสลับภาษาครบ |
| R03 roundtrip / Street Hatch | Not Tested / Not Implemented | ผล R02 ยังไม่ผ่านกลับอู่ ไม่อ้างว่าผ่าน R03 |

## ผลทดสอบและปัญหาที่แก้
- ทดสอบ PC viewport 1588×665: เปิด/ปิด Garage, Shop, Upgrade, Parts Market, Race Hub, Event Plaza ด้วย mouse input จริง. UI scale เปลี่ยนเป็น 0.9.
- ทดสอบเกียร์ N->1 และ speed visibility เมื่อขึ้นรถ; screenshot เดิน/ขับตรวจด้วยตา. ไม่พบ error ของ LabHUD/Components/UITheme ในชุดตรวจ.
- พบเมนูไม่คืนเมื่อขยายจาก compact เป็น PC: แก้ nav visibility. พบ stroke ทับตัวหนังสือ: เปลี่ยน Border mode.
- พบภาพ atlas crop คลาด: ปรับพิกัด crop แล้วดูภาพใหม่ ยืนยันเฉพาะ crop ที่เห็น ไม่ได้ดึงข้อมูลบัญชีหรือ bypass authentication.
- StreamingEnabled=true ใน Play ล่าสุดของ Studio เดิมหลังตั้ง Edit; ยังไม่ใช่ผลทดสอบเปิด Build ใหม่และขับครบ routeพร้อม streaming.
- Source/Build ล่าสุดรวม crop และ native-entry compliance fix. Crop ได้ตรวจภาพด้วย runtime property patch ที่ตรงกับ source; native Entry ใหม่ยังต้อง fresh-Play ตรวจใน Phase Core Player Flow.
- Build passed: build/RaceAndRaid-ChassisLab.rbxlx. No new project, no original-game edits, no Publish/purchases, no system software installation.

## จุดหยุดรออนุมัติ
ตามประโยคท้ายคำสั่ง R03: ให้เจ้าของตรวจ Main HUD ก่อน UI ถัดไป. ยังไม่เรียก UI 01–16 หรือเกมทั้งระบบว่าเสร็จ. หลังอนุมัติ ให้เก็บข้อบกพร่อง R03 driving/Street Hatch และดำเนิน Core Player Flow/functional menus ตามลำดับ โดยยังไม่แต่งครบ12โซน.