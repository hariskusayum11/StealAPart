> Superseded where conflicting: owner confirmed STEAL A PART! and handoff 30.1 on 2026-11-04. Read ../PROJECT_MEMORY.md and MASTER_HANDOFF_30_1_SOURCE.md. The content below preserves the earlier plan and does not describe the latest approved vision.

# RACE & RAID — ซิ่งล่าอะไหล่
วันที่ 2026-11-03 · ข้อกำหนดล่าสุดจากผู้ใช้แทน World Repair Simulator

## Vision
Thai Street Racing Culture × Premium Roblox Arcade; Modern Stylized Realism.
เมืองไทยสมมติ Bangkok Rush District ใช้แบรนด์สมมติทั้งหมด ไม่ย้ายระบบหรือแก้ไฟล์เกมเดิม
วงจรหลัก: ออกจากอู่ → แข่ง/ล่าอะไหล่ → ตัดสินใจเสี่ยง Cargo → กลับฝาก → แต่งรถ → เส้นทางใหม่
การแข่งขันอยู่ในโลกสมมติ มี Safe Zone และสนามปิดสำหรับการทดสอบ

## Vehicle classes
| รุ่นสมมติ | บทบาท | ขอบเขต |
|---|---|---|
| Street Cub 110 | รถครอบครัวแต่งซิ่ง ล้อซี่ลวด ท่อแต่ง ชุดสี; คล่องตัว Cargo 1 ช่องในการทดลอง | รถเป้าหมายแรก |
| Drag Cub 150 | เบา ล้อเรียว เน้นทางตรง | หลังอนุมัติการขับ |
| Turbo Hauler | กระบะโหลดเตี้ย Cargo Rack บรรทุกมาก | ภายหลัง |
| Phantom GT | คูเป้ Widebody สปอยเลอร์ | กลางเกม |
| Sport bike | รถสปอร์ตชื่อสมมติที่กำหนดภายหลัง | ยังไม่สร้าง |
มอเตอร์ไซค์ใช้ทางลัดได้ รถยนต์ขน Cargo มากกว่า ทั้งคู่แข่งขันและล่าอะไหล่ได้ ต้องทดสอบเวลาต่อรอบ/รายได้ต่อความเสี่ยง ไม่ขายชัยชนะด้วยสถิติรถ

## Customization
ช่องอะไหล่: Exhaust, Engine/Piston, ECU, Sprocket/Gearbox, Wheels/Tyres, Suspension, Paint/Decals.
Catalog ฝั่งเซิร์ฟเวอร์กำหนด compatibility, modifiers, ownership และค่าใช้จ่าย ห้ามรับ stat table จาก client
Garage กล้อง orbit 360°, zoom ชิ้นส่วน, preview ก่อนยืนยัน, เทียบ speed/acceleration/handling/cargo ก่อน–หลัง
Preview เปลี่ยน mesh/material บนรถจริงตามจุดยึด; ยืนยันติดตั้งจึงเปลี่ยนของจริง เสียงท่อ/FX ต้องมีสิทธิ์และทดสอบโหลดได้
ยังไม่สร้างระบบแต่งครบก่อนรถหนึ่งคันขับผ่านเกณฑ์

## World & art
Palette: Asphalt Black #111923; Race Gold #F5B82E; Turbo Cyan #27C5E5; Risk Red #F45B68; Mythic Purple #A76BEA.
วัสดุสีรถ โลหะ ยาง กระจก ถนนแยกชัด แสงกลางคืนอ่านถนนได้ ไม่ใช้ Neon กลบรายละเอียด
ห้าม primitive final art ของรถ/บ้าน/อู่; พื้นทดสอบ geometry เป็น engineering fixture ไม่ใช่ Visual Benchmark ที่ผ่านแล้ว
ย่าน: Bike Alley, Garage Street/Safe Zone, Scrap Yard, Risk Highway, Race Arena.
Bike Alley: ร้านท่อ ร้านล้อซี่ลวด ร้านสติกเกอร์ ลานโชว์รถ และ NPC นักแข่งไทย/ต่างชาติ
Benchmark เฉพาะ Bike Alley → Scrap Yard → Player Garage; ตึกแถว หลังคาเมทัลชีต ป้ายไทย–อังกฤษ สะพานคลอง เมื่อ asset ผ่านตรวจ
Garage มีแท่นยก ชั้นอะไหล่ กล่องเครื่องมือ ผนังท่อ/ล้อ ที่จอด จุดฝาก Cargo และจุดเปิด customization
กล้องตรวจซ้ำ: Garage entrance, rider-height road approach, scrapyard return; บันทึก CFrame หลังจัดฉากจริง

## Race modes
Drag Bike 201m, Night Circuit, Parts Run. เริ่มสนามสั้นสำหรับเร่ง เบรก เลี้ยวและทรงตัว ไม่สร้างทุกโหมดทันที

## UI / input
Driving: speed, gear, boost (แสดงเมื่อระบบพร้อม), cargo slots, minimap, pursuit warning เฉพาะพื้นที่/ระบบที่เปิด
Garage: vehicle preview, part slots, before/after, install/remove, vehicle selection
Loot: item name, rarity, cargo risk, deposit confirmation
ไทยเป็นหลัก; keyboard และ touch; ปุ่มไม่ทับพื้นที่มองถนนและ safe insets; รองรับมือถือแนวนอนและ tablet
ไม่มีปุ่มแสร้งว่าทำงานแล้ว ระบบที่ยังไม่มีซ่อนหรือระบุยังไม่เปิด

## Cargo & security
Benchmark มีอะไหล่ทดสอบหนึ่งชนิด: Loose → Cargo → Secured; server สร้าง unique ID และตัดสินระยะ ความจุ ผู้ครอบครอง และการฝาก
ข้อมูล benchmark เป็น session เท่านั้น ต้องแสดงชัด ไม่ใช้รางวัล persistent จนมี migration/transaction tests
Server ตรวจ seat occupant, finite inputs, speed/displacement envelope และ cooldown; การขับ client-owned ไม่ถือว่าป้องกันโกงได้แล้ว
ตรวจความเร็วผิดปกติต้องแยกชน/กระโดด/lag; ไม่แบนจากตัวอย่างเดียว
การไล่ล่า: เตือน risk zone, cooldown, คุ้มครองมือใหม่, safe escape, เสี่ยงเฉพาะ unsecured cargo, ป้องกันคู่สมรู้ farming — งานภายหลัง

## Architecture
src/server: trusted vehicle session, cargo transactions, validation.
src/client: input, camera, presentation; src/shared: catalog/types/constants ไม่มี secrets.
Third-party chassis อยู่แยก assets/vendor พร้อมต้นฉบับ license/hash/patch log; strict Luau สำหรับ source ใหม่ ไม่แกล้งเพิ่ม strict ให้ vendor เก่าแล้วอ้าง typecheck
Rojo port 34880 แยกจากเกมเดิม; build/ เป็น output เขียนทับได้ Place ที่มี imports ต้องเก็บแยก

## Acceptance gates
Build != Runtime != Visual QA. ต้องทดสอบการขับจริง, เข้าลงรถ, กล้อง, เบรก, สมดุล, mobile touch, collision, texture permissions, FPS/memory.
ยังไม่อนุมัติทั้งเมือง/full customization/Pursuit/Persistence. หยุดรอผู้ใช้หลังส่ง benchmark ก่อนขยาย