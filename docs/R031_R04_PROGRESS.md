# R03.1 + R04 — ผลดำเนินงาน 4 พฤศจิกายน 2026

## ขอบเขตอนุญาตล่าสุด
Catalog ผ่านการพิจารณาเบื้องต้น อนุญาตตรวจ Industrial/Factory/Commercial/Racing ของ Kenney และ Roblox Pickup6418225759 ในฉากแยกเท่านั้น **ยังไม่อนุมัติลงแมพหลัก** รักษา MainHUD/UI07 ไม่สร้าง MainMenu ไม่แต่ง12โซน

## R03.1 — สิ่งที่พบและแก้
- พบ GarageJunction สร้างซ้ำสองครั้งที่พิกัดเดียวกัน เนื่องจาก iterate อู่สองฝั่ง: เหลือ3 junctions สำหรับอู่6หลัง
- ลดช่วงซ้อน deck/bed/rail จาก0.7เป็น0.02stud เพื่อลดแนว coplanar แยกระดับผิวลานจากถนน0.04stud และยก parking/entrance markings ตามผิวลาน เพิ่ม apron ที่จุด service crossings
- ทดสอบครั้งแรกผ่าน12โซนแต่หยุดที่x3015ก่อนลานกลับรถ: ขอบซ้ายลานแบนยื่นทับถนนลาดทำให้รถชนขอบต่างระดับ จึงย้ายลานให้เริ่มx3050พ้นช่วงขึ้นเนิน และรักษา return ramp
- แก้เฉพาะ CargoCourse.luau กับ Layout.Version6 ใน HubLayout.luau; ไม่เปลี่ยนพิกัดจุดGameplay ไม่ลบถนน12โซน/อู่6หลัง ไม่เปลี่ยน chassis/Cargo/HUD
- Backup: backups/pre-r031-20261104-152358/

## ผลทดสอบขับจริง
**ผ่านหนึ่งรอบ GarageCity → Zone01–12 → กลับรถ → หน้าอู่** ด้วยรถเริ่มต้นจริงใน Studio Play ผ่าน virtual controller ของ chassis ไม่ใช้การย้ายรถ/teleport/ตั้งvelocityระหว่างเส้นทาง
ผล: reason=complete, waypoint409จาก408, elapsed339.90s, maxX3142.28, visitedครบ1–12
เริ่มจากรถที่ spawn และ mount ผ่าน Seat:Sit ไม่ได้ขับด้วยผู้เล่นมือจริง ไม่ใช่ Mobile/6ผู้เล่น QA และไม่พิสูจน์ทางเข้าอู่ทุกหลังหรือเลนริมถนนทั้งหมด
หลักฐานเต็ม: [completed-trip](mcp-check/r031-completed-trip.json)
ครั้งแรกล้มเหลวเก็บไว้ที่ [attempt1](mcp-check/r031-attempt1-failed.json)
สแกนผิว1521จุดบนแนวหลักที่offset-12/0/12: ไม่มี ray ขาดพื้น, max deviationจากrouteY+.3≈0.393stud, ตรวจพบ12zone/6garages/3junctions เป็นการตรวจsupport ไม่ใช่รับรองรอยต่อทุกมุม
[ผลสแกน](mcp-check/r031-road-structural-audit.json)
Buildล่าสุดผ่าน build/RaceAndRaid-ChassisLab.rbxlx; warningเดิม top-level Name ใน Underbone model ไม่ใช่ error

## ภาพจริงและข้อจำกัด Visual QA
ภาพหลังใน Edit ที่เปิดดู geometry ได้จริง: [ทางเข้าอู่](mcp-check/r031-road-edit-after.png). ภาพกลับรถและสะพานยังเป็นฉากขาว จึงใช้รับรองภาพสองพื้นที่นั้นไม่ได้
ภาพก่อนและหลังรอบแรกใน Play ได้ฉากขาว/แสดงเฉพาะHUD จึง **ใช้เป็นภาพเปรียบเทียบพื้นไม่ได้** ไม่อ้างว่ามี before/afterที่ใช้รับรองครบ คู่ภาพก่อนที่อ่านพื้นได้ยังขาด
การแก้ duplicate/coplanar บางจุดยืนยันจากโค้ดและ geometry แต่ยังไม่รับรองว่าพื้นกระพริบหมดทุกระยะกล้อง ช่วงoverlap0.02บนท่อนถนนยังต้องตรวจขณะเคลื่อนกล้อง ไม่ใช้ภาพนิ่งรับรองว่าปราศจากflickerทั้งหมด
สร้าง geometryใน Edit ด้วย generator เดิมเพื่อดูฉากหลังทดสอบ ในStudioหลักตอนจบอยู่ Edit ไม่ Publish/Saveทับ Placeด้วยเครื่องมือ

## Asset review แยกจริง
เปิด Studio R04-AssetReview.rbxlx แยกจากเกมหลัก (configuration prototypes/r04-asset-review/review.project.json ไม่มี gameplay mapping)

| Asset | Found | Downloadedไฟล์ตรวจได้ | Imported | ทดสอบ/ข้อจำกัด |
|---|---|---|---|---|
| Kenney Industrial | Yes/CC0หน้าofficial | No — download-link403 | No | ไม่มีไฟล์meshให้ตรวจ |
| Kenney Factory | Yes/CC0หน้าofficial | No — download-link403 | No | ไม่มีไฟล์meshให้ตรวจ |
| Kenney Commercial | Yes/CC0หน้าofficial | No — download-link403 | No | ไม่มีไฟล์meshให้ตรวจ |
| Kenney Racing | Yes/CC0หน้าofficial | No — download-link403 | No | ไม่ใช่สนามประกอบเสร็จ |
| Roblox Pickup6418225759 | Yes/publisherRoblox | ไม่มีexportบนดิสก์ | Yes เฉพาะServerStorage quarantineฉากแยก | static audit + ภาพMeshเท่านั้น; ไม่ทดสอบขับ/FPS |

Kenney: URLZIPจากweb cacheส่งHTMLแทนZIP จึงไม่ถือdownloaded ได้เก็บresponseเป็น.response.html; ทดลองdownload-linkทางการทั้งไม่มีsessionและsessionมาตรฐานตอบ403 ไม่ข้ามบัญชี/ซื้อbundle [archive audit](R04_ARCHIVE_AUDIT.json)

Pickup: แพ็กมี3สี รวม123MeshPart/78Part/3VehicleSeat/9RemoteEvent และ42Lua containers (3Script/9LocalScript/30ModuleScript) แต่ละคันboundsประมาณ10.59×9.64×26.58studs
สแกนpatternไม่พบ numeric require/loadstring/HTTPใน42containersที่ตรวจ **ไม่ใช่full security certification** พบEffects.SetThrottle dereference occupant.Parentโดยไม่guardnil และไม่validate throttle/gainModครบ; ForceExitSeat callbackไม่มีplayer argumentแยกทำให้ใช้argumentผิด จึงยังไม่ผ่านproductionsecurity
คัดลอกสีน้ำเงินเป็นstaticreview (Script.Enabled=false,anchored) ตรวจcollidable23parts รวม15MeshPart ต้องวัดcollisiongeometryจริงต่อ ไม่ใช่ใช้boundsแทน
[ผลstatic audit](R04_PICKUP_STATIC_AUDIT.json) · [ภาพจริง](mcp-check/r04-pickup-static-final.png)
ครั้งแรกMeshยังไม่โหลดครบ หลังรอภาพแสดงbody/ล้อ/กระจกแล้ว ไม่รายงานเป็นโมเดลหายถาวร
ตัวoriginalอยู่ServerStorage.AssetQuarantineในStudioทดสอบ ยังไม่export/saveลงไฟล์อัตโนมัติ: keyboard saveใช้ในEditไม่ได้ ไฟล์build/R04-AssetReview.rbxlxบนดิสก์ยังเป็นพื้นทดสอบเปล่า อย่าเปิดไฟล์แล้วคาดว่ามีรถบันทึกแล้ว ต้อง Save to File AsจากStudioทดสอบหากต้องการเก็บassetloadedscene

## สนามและUI
[ตัวเลือกสนาม3แบบพร้อมภาพจริง/ผู้สร้าง/ขนาดที่ทราบ/ข้อจำกัด](R04_RACE_TRACK_OPTIONS.md) ทั้งหมดFoundเท่านั้น ไม่มีสนามใหม่ลงแมพหลัก
HUDเดิมคงไว้ UI07เป็นเป้าหมาย ไม่เพิ่มUIkit/backendซ้ำ ยังไม่แก้MainHUDในรอบนี้

## ยังไม่ผ่าน / ต้องดำเนินการต่อ
1. ภาพก่อน–หลังที่แสดงพื้นครบและการทดสอบflickerขณะเคลื่อนกล้อง
2. ขับทุกทางเข้าอู่6หลัง/ขอบไหล่ทาง/ทุกทางแยก + F Cargo regressionรอบใหม่นี้; roundtripหลักผ่านแต่ไม่เหมารวมพื้นที่ทั้งหมด
3. Garage01จากKenneyยังประกอบไม่ได้เพราะไฟล์blocked ไม่แทนด้วยกล่องแล้วนับว่าเสร็จ
4. Pickupfull script review/hardening, collision drive, dependency/licenseครบ, FPS/MemoryเปรียบเทียบและMobileยังไม่ผ่าน
5. Client memoryอ่านได้1207.96MBครั้งเดียวในเกมหลักหลังขับ ไม่ใช่memoryเฉพาะPickup/ผลbenchmark ไม่มีFPSวัดใหม่
6. Studioทดสอบมีerrorจากplugin Rojo localเดิมและจากคำสั่งinspectที่แก้แล้ว ไม่อ้างconsoleclean ไม่ติดตั้ง/ลบpluginเอง

สิ่งที่เจ้าของช่วยได้: ดาวน์โหลด4KenneyZIPจากหน้าofficialด้วยbrowserแล้ววางในassets/quarantine/r04/ (ไม่ต้องแตกหรือนำเข้าแมพหลัก) เพื่อให้ตรวจlicense/hash/meshต่อได้; Save to File AsของStudioชื่อR04-AssetReviewไว้ในprototypes/r04-asset-review/หากต้องการรักษารถที่นำเข้า
ไม่มีการซื้อ ติดตั้งระบบ Publish หรือแก้WorldRepairSimulator
