# Garage City Layout v11 rev2: Owner Review หลังจบ B2

วันที่ 5 พฤศจิกายน 2026 · STEAL A PART! · Phase B (B0 → B1 → B2)

**สถานะ:** สร้าง Blockout v11 แล้ว และหยุดรอ Owner Review ยังไม่เริ่ม B3 ไม่ได้ตกแต่ง G2–G6 หรือ Zone ไม่ได้ Publish ไม่ได้ Import และไม่ได้เพิ่ม Economy

## Git และ Backup

| รายการ | ค่า |
|---|---|
| Backup ก่อน commit | `backups/pre-b0-v11-20261105-124543/` (833 ไฟล์ มี `SHA256SUMS.txt`) |
| Initial commit | `a5230f2` (157 ไฟล์) บน `main` |
| B1 commit | `ba417ab` |
| Remote | `origin` = https://github.com/hariskusayum11/StealAPart.git (**ยังไม่ push**) |
| Identity ของ repo นี้ (`--local`) | hariskusayum11 <kusayum@gmail.com> |

## B0: MCP และ Performance Baseline

- ลงทะเบียน Roblox Studio MCP แบบ local scope เฉพาะ `D:/RobloxProjects/RaceAndRaid` แล้ว ทดสอบแบบอ่านอย่างเดียวผ่าน (`list_roblox_studios` และ `get_studio_state`)
- Baseline ของ v10 (`scripts/qa/b0_performance.luau`):
  - ตรวจทุก 1 วินาทีแล้วพบว่า Studio อยู่ foreground 44/44 ครั้ง และไม่มี event เสีย focus
  - วัดได้ **15.00 FPS** ทุกช่วง ทั้งมุมมาตรฐาน มองท้องฟ้า และซ่อน GUI frame median 66.7 ms
  - Graphics ตั้งเป็น Automatic, viewport 1588×625
- ข้อมูลเครื่อง: Studio render ด้วย **AMD Radeon RX 6500** แต่จอต่อกับ **Intel Graphics** (1920×1080 @60Hz) ระหว่างวัดมี Studio เปิดอยู่ 3 ตัว และ Roblox Player อยู่ใน tray
- **ข้อสรุป:** การที่ Studio อยู่ foreground ไม่ได้แก้ 15 FPS ผลนี้จึงไม่สนับสนุนสมมติฐานเรื่อง throttle ตอนไม่ได้ focus **ยังไม่ทราบสาเหตุ** สมมติฐานที่ยังไม่ได้ทดสอบคือการแสดงผลข้ามการ์ด (render ด้วย AMD แต่ส่งภาพออกทาง Intel), GPU ถูกแย่งใช้, และค่าของ driver หรือ power plan หลักฐานอยู่ใน `mcp-check/b0-evidence-summary.json`

## B1: PlotFrame Refactor

- HubLayout เพิ่ม `PlotFrame`, `FindPlot` และ `PlotLocal` ค่า Deposit, BikeStart และ SpawnCFrame คำนวณจาก G1
- CargoCourse, G1Visual (v5), GarageDay และ Lab ใช้พิกัดแบบ local ของ plot
- **Snapshot comparison:** ทั้ง 2,961 ชิ้นตรงกับ v10 ครบ 71/71 กลุ่ม ค่า Spawn, Deposit, BikeStart และจำนวนชิ้น G1Visual (162) ตรงกัน

## B2: ผัง v11 rev2

| ส่วน | พิกัด |
|---|---|
| G1 / G2 / G3 (ซ้าย หันไปทาง +Z) | (−865,−225) / (−745,−225) / (−625,−225) |
| G4 / G5 / G6 (ขวา หันไปทาง −Z) | (−625,225) / (−745,225) / (−865,225) |
| ถนนวง (สองทิศทาง กว้าง 32) | ด้านข้าง \|Z\| 150 ช่วง X −931…−557.7 · ด้านล่าง X −987 · มุม R56 |
| ทางแยก Y | R60 / θ 50° · เริ่มที่ X −557.7 · Gateway Plaza X −396…−364 · คอถนน X −364…−250 ไปต่อกับ MainHighway เดิม |
| Hub | พื้นลาน · Race Hub (−520,0) · Parts/Shop (−640,∓85) · Upgrade/Event (−870,∓85) · Landmark (−760,0) · Central Plaza (−940,0) ทั้งหมดเป็น Placeholder |
| City Entry และ SpeedTestLane (Candidate) | Entry X −1038…−1003 · Lane ศูนย์กลาง (−1060,0,0) ขนาด 44×600 · ที่กลับรถ X −1090…−990, \|Z\| 300…380 |
| ค่าที่คำนวณจาก PlotFrame | Spawn (−873,3,−235) · Deposit (−865,0,−225) · BikeStart (−865,2.85,−215) |

ส่วนที่ตัดออกจากผังเดิม: CityHighway ช่วงผ่ากลางเมือง, CityTurnaround, ถนนบริการ, CrossRoad, ทางเข้าอู่แบบเดิม, FacilityAccess และ SpeedTestLane กับ TrackAccess ที่ตำแหน่งเดิม

## Build, Smoke และ Geometry Audit (B2)

- **Build:** ผ่าน (`build/StealAPart-v11-B2.rbxlx`) มี warning เดิมเรื่อง `UnderboneBody` Name
- **Highway, Boundary และรั้ว:** hash ตรงกับ v10 ครบ 13/13 กลุ่ม ได้แก่ MainHighway 660, HighwayShoulder 1,320, EdgeLine, CenterDash, ZonePad, ZoneAccessRamp, ป้าย Zone, Bridge, EndTurnaround, WorldBoundary 16 และรั้ว
- **รอยต่อถนน:** ยิง raycast ทุก 2 studs ตามเส้นกลางและที่ระยะ ±8 และ ±14 รวม 7,092 จุด ครอบคลุมถนนวง มุมโค้ง ทางแยก Plaza คอถนน (รวมรอยต่อ X −250) ลานหน้าอู่ทั้ง 6 Entry และ SpeedTestLane
  - ช่องว่าง 0 จุด
  - ระดับผิวคลาดสูงสุด 7.6×10⁻⁷ stud
  - ผิวซ้อนกันจริง 0 จุด (จุดที่เป็นแค่ขอบชนกันพอดีถูกแยกออกด้วยการขยับจุดตรวจ ±0.3)
- **สิ่งกีดขวางที่ชนได้ในแนวขับ:** 0
- **Smoke test:**
  - Spawn ตรงกับ Layout และตัวละครห่าง Spawn 0.91
  - Deposit อยู่ตรงตำแหน่ง (ห่าง 0.00) มี Prompt ครบ
  - Street Cub ห่าง BikeStart 0.75 และหันหน้าเข้า Hub มี RidePrompt
  - มีจุด Pickup ที่ Zone01
  - มี PlotId ครบ G1–G6
  - G1Visual v5 ครบ 162 ชิ้น
  - HUD และ StealEntry โหลดได้ (Welcome เปิดอยู่) และ GarageDay ทำงานที่ G1
- **Console:** ไม่มี error จากสคริปต์ของโปรเจกต์ มีแค่ warning `Infinite yield possible` ใน GarageDay ตอนรอ `TestGarageDeposit` ระหว่างที่ Place ใหม่ยังสร้าง Terrain ไม่เสร็จ หลังจากนั้นทำงานได้ (GarageDay=true) ส่วน error จาก Rojo plugin (`user_rojo-master`) เป็นปัญหาของ plugin ที่ติดตั้งไว้ในเครื่อง ไม่เกี่ยวกับโปรเจกต์

## ภาพจาก Studio จริง (Play, ซ่อน GUI ชั่วคราวแล้วคืนค่า)

| มุม | ไฟล์ |
|---|---|
| มุมบน | [b2-topdown](mcp-check/b2-topdown.png) |
| ทางแยก Y และทางออกไป Zone01 | [b2-yfork-zone01-exit](mcp-check/b2-yfork-zone01-exit.png) · [b2-throat-to-zone01](mcp-check/b2-throat-to-zone01.png) |
| G1–G6 หันหน้าเข้าหากัน | [b2-garages-facing](mcp-check/b2-garages-facing.png) |
| Central Hub | [b2-central-hub](mcp-check/b2-central-hub.png) |
| G1 / G3 / G4 | [b2-g1-front](mcp-check/b2-g1-front.png) · [b2-g3-fork-start](mcp-check/b2-g3-fork-start.png) · [b2-g4-fork-start](mcp-check/b2-g4-fork-start.png) |
| City Entry และ SpeedTestLane | [b2-speedlane-entry](mcp-check/b2-speedlane-entry.png) |

## ยังไม่ผ่าน (รอทดสอบใน B3 หลัง Owner Review)

- ขับจริงด้วย Street Cub: ออกและเข้าอู่ทั้ง 6 หลังโดยไม่ถอย, U-turn บนลานหน้าอู่, วนรอบถนนวง, ทางแยกทั้งสองข้าง และ Plaza
- รัศมีเลี้ยวที่ความเร็ว 28 และ 35 stud/s
- Roundtrip ถึง Zone12 บนผัง v11
- Cargo loop เต็มรอบ (ระยะจาก Pickup ไปจุดฝากเปลี่ยนเพราะ G1 ย้าย)
- ทางหญ้าและรอยต่อ
- SpeedTestLane และที่กลับรถ
- Boundary ของรถ, Mobile, Human QA, ฉากหลังแบบ B และสาเหตุของ 15 FPS
