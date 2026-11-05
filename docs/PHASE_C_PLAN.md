# Phase C Plan: 4 Workstreams หลัง B3 (รอ Owner Approval)

วันที่ 5 พฤศจิกายน 2026 · STEAL A PART! · ฐานโค้ด commit `f90b5fd` (Layout v11 rev2, Terrain 9)

**สถานะ:** เป็นแผนอย่างเดียว ยังไม่ได้แก้ Source, A-Chassis, Zone01, Terrain หรือ HUD หลักฐานใหม่ในรอบนี้มาจาก probe ใน Studio Play ที่ไม่ถาวร (`scripts/qa/c0_visibility_probe.luau` และ `docs/mcp-check/c0-visibility-probe.json`)

---

## 1. Root Cause และระดับความมั่นใจ

| # | ปัญหา | สาเหตุ | หลักฐาน | ความมั่นใจ |
|---|---|---|---|---|
| **V1** | **ภาพขณะขับไม่เห็นตัวรถ** | `VehicleAppearance.luau` ตั้งตัวถัง MeshPart **ทุกชิ้นเป็น `Anchored=true`** และตั้งชิ้นส่วน vendor ที่ใช้คำนวณฟิสิกส์เป็น `Transparency=1` เมื่อรถเคลื่อนที่ ตัวถังจึงค้างที่จุดจอด ส่วนรถจริงที่มองไม่เห็นวิ่งไปพร้อมผู้ขับ | Probe ใน Play: ตัวถัง 38/38 ชิ้นเป็น anchored ทั้งฝั่ง client และ server ตอนจอดห่างเบาะเฉลี่ย 2.4 studs หลังขับ 5 วินาทีเบาะเคลื่อนไป 122 studs แต่ตัวถังยังอยู่ที่ (−864,−215) เดิม ห่างเบาะ 122 studs ชิ้น vendor ที่มองเห็นได้มี 0 ชิ้น | **สูง** ไม่ใช่ปัญหา Streaming (โหมด Nonatomic แต่ตัวถังยังอยู่ครบ), LOD, กล้อง หรือ Screenshot |
| **F1** | ต้องกด Shift จาก N | ตัวขับของ A-Chassis เริ่มที่ `local _CGear = 0` (N) แม้โหมด `TransModes[1]="Auto"` การตั้งเกียร์ 1 ให้อัตโนมัติมีเฉพาะ `AutoShiftVers=="Old"` | โค้ด vendor และการทดสอบ B3 ทุกเคส: ตอนขึ้นรถเกียร์เป็น 0, ไม่กด Shift วิ่งได้แค่ 2–3 stud/s, หลัง ShiftUp เกียร์เป็น 1 และวิ่งปกติ | **สูง** |
| **F2** | Terrain สูงกว่าถนนที่ x 3026–3046 | `HighwayTerrain.luau` มีเงื่อนไข `if x>=3030 and x<=3350 … then top=RoutePoint(3050).Y-.12` ทำให้ช่วง 3030–3050 ถูกยกขึ้นเท่าระดับถนนที่ x 3050 ซึ่งสูงกว่าถนนจริงในช่วงนั้น | สแกน 8,250 จุดบน Highway พบ 51 จุด ทั้งหมดอยู่ในช่วงนี้ สูงสุด +0.59 | **สูง** |
| **F3** | Zone01 เก็บ Cargo และกลับรถบนพื้นยางไม่ได้ | Pad ขนาด 100×72 และทางลาดกว้าง 40 รองรับแค่ keyhole รัศมี 28 ซึ่งห่าง Pickup (−250,−55) 15–25 studs แต่ `Lab.server` รับระยะไม่เกิน 14 | เรขาคณิตและ B3: เคส Cargo ลงหญ้า 192 sample | **สูง** |
| **F4** | วงกลับรถใน Zone01 แคบ | รัศมี 28 ใกล้รัศมีเลี้ยวสุดของรถ (25–28) | ระยะเบี่ยงสูงสุด 9.7 ที่ (−280,−66) ทั้ง 6 เคส | สูงสำหรับค่าที่วัดได้ / **กลาง**สำหรับข้อสรุปว่ามือถือขับยาก (ยังไม่ได้ทดสอบบนมือถือ) |
| **I1** | ปุ่มชนกัน | ใน A-Chassis: `ShiftUp=E` ชนกับ RidePrompt (E), `Clutch=LeftShift` ชนกับ Shift-lock, `ToggleTransMode=M` เปลี่ยนเป็น Manual ได้โดยไม่ตั้งใจ และ T/Y/U/R/P สลับระบบช่วยขับได้ ส่วน Space (กระโดด) ทำให้ลงจากรถ | `Tune.Controls` ใน vendor rbxmx | สูงด้านค่าที่ตั้ง / กลางด้านผลต่อผู้เล่น (ต้องทดสอบด้วยมือ) |

## 2. Workstream 1: Zone01 และ Terrain Fix

### Z1 Zone01 Turn Pad (ทางเลือกหลัก)

เพิ่มพื้นยางแบบ flat rect 2 ชิ้นที่ y=0 ใน partition เดียวกับคอถนนและ ZonePad จึงไม่มีผิวซ้อน

| ชิ้น | พิกัด | หน้าที่ |
|---|---|---|
| `Zone01TurnPad` | X −364…−300, Z −110…−22 (64×88) | พื้นที่กลับรถฝั่งตะวันตกของ Pad เดิม |
| `Zone01TurnLink` | X −300…−270, Z −34…−22 (30×12) | ปิดช่องหญ้าระหว่างคอถนนกับ Pad ทางตะวันตกของทางลาด |

```text
 Z  -8 ══ outbound lane ═══════════════► (Throat −364…−250) ═► MainHighway (X≥−250 ไม่แตะ)
 Z +8 ◄═ inbound lane ═══════════════════
 Z −22 ───────┬──────────────[ramps −270…−230]──
     TurnPad  │ TurnLink │      Zone01 Pad (เดิม)
   −364…−300  │−300…−270 │   −300…−200, −106…−34
              │   ╭── วงกลับรถ r38 ──╮  ● Pickup (−250,−55)
              │  (   ศูนย์กลาง (−290,−64) )
 Z −110 ──────┘   ╰──────────────────╯
```

- **เส้นทาง:** จาก outbound lane เบี่ยงเข้าจุดบนสุดของวง (−290,−26) แล้ววิ่งตามวงรัศมี **38** ผ่านด้านตะวันออก (x ≈ −252) ซึ่งห่าง Pickup ประมาณ 3 studs (เซิร์ฟเวอร์รับ 14) จุดนี้หยุดเก็บได้ จากนั้นผ่านก้นวง z −102 ขึ้นด้านตะวันตก x −328 ไปทาง +Z แล้วเลี้ยวขวารัศมี 28 เข้า inbound lane z +8 ที่ x ≈ −356
- รัศมี 38 เท่ากับ 1.46 เท่าของรัศมีเลี้ยวสุดที่ 10 stud/s (26.1) ไม่ต้องใช้เกียร์ถอย และอยู่บนพื้นยางทั้งหมด
- **Terrain:** ราบตามเงื่อนไข x < −320 หรือ \|z\| < 120 รอบเส้นทาง (Terrain 9 ไม่ต้องเปลี่ยน) ต้อง raycast ยืนยันก่อนสร้าง
- **ไม่แตะ:** MainHighway ช่วง x ≥ −250, ZonePad, ZoneAccessRamp และ Pickup ชิ้นใหม่ทุกชิ้นอยู่ที่ x ≤ −270
- **ความเสี่ยง:** ตำแหน่งตัดแบ่งของ flat partition อาจเปลี่ยนการแบ่งชิ้นของ ZonePad Zone01 คาดว่าไม่เปลี่ยนเพราะชิ้นที่ต่อกันยังถูกรวมเป็นชิ้นเดียว แต่ต้องตรวจ hash
- **ผลกระทบต่อ QA:**
  - เคส Cargo และ G ใช้วงใหม่แทน keyhole r28
  - ชุดตรวจ hash ส่วนที่ต้องคงไว้ (x ≥ −300) ต้องไม่นับชิ้นใหม่สองชิ้นนี้โดยอ้างตามชื่อ
  - การคืนค่า: เพิ่ม `Layout.Version` เป็น 12 ถ้าต้องย้อนก็ revert กลับเป็น 11

ทางเลือกสำรอง: **Z2** ย้าย Pickup ไปที่ (−250,−95) บนวง keyhole เดิม (แก้ fixture ของ Zone01) และ **Z3** ขยาย ZonePad ซึ่งกระทบทั้ง 12 โซน

### F2 Terrain Fix (แก้บรรทัดเดียว)

```lua
-- HighwayTerrain.luau: เดิม
if x>=3030 and x<=3350 and z>p.Z-85 and z<p.Z+215 then top=Layout.RoutePoint(3050).Y-.12 end
-- เสนอ: ไม่ยกพื้นให้สูงกว่าถนนจริงในช่วง 3030–3050
if x>=3030 and x<=3350 and z>p.Z-85 and z<p.Z+215 then top=math.min(Layout.RoutePoint(3050).Y,p.Y)-.12 end
```

- ช่วง x > 3050 ได้ค่า `p = RoutePoint(3050)` เหมือนเดิม จึงไม่เปลี่ยน ส่วนนอกเงื่อนไขนี้ก็ไม่เปลี่ยน
- ต้องเปลี่ยน `TerrainVersion` จาก 9 เป็น 10 ซึ่งจะสร้าง Terrain ใหม่ทั้งหมดด้วยฟังก์ชันเดิม
- **ตรวจรับ:** สแกน 8,250 จุดบน Highway ต้องได้ terrainAboveRoad = 0 และความสูง Terrain นอกช่วง x 3030–3050 ต้องเท่าเดิม (เทียบ hash ของความสูงทุก 8 studs ระหว่าง v9 กับ v10)

## 3. Workstream 2: Easy Arcade Vehicle Assist (เริ่มที่ Street Cub, ไม่แก้ไฟล์ vendor)

**หลักการ:** Module ใหม่ `src/client/VehicleAssist.client.luau` (และ `src/server/VehicleAssistServer.luau` สำหรับ Recovery) ส่งคำสั่งเข้า A-Chassis ผ่าน **VirtualInput ของ Interface เดิม** ซึ่ง B3 ใช้มาแล้ว 10 เคส และตั้งค่าปุ่มใหม่ผ่าน `A-Chassis Interface.Controls` (Value objects) ตอน runtime โดยไม่แก้ไฟล์ vendor ต้องยืนยันใน prototype ว่าการเปลี่ยน Controls มีผลจริง ถ้าไม่ได้จะรายงานก่อนทำต่อ

| ขั้น | ความสามารถ | วิธีทำ |
|---|---|---|
| A1 | **Auto-Drive** ขึ้นรถแล้วกดเร่งไปได้ทันที | เมื่อขึ้นรถแล้วเกียร์เป็น 0 ให้ส่ง ShiftUp อัตโนมัติ ล็อกโหมดเป็น Auto และย้าย T/Y/U/M/R/LeftShift/P ของ vendor ไปปุ่มที่ไม่ได้ใช้ (ไม่มี Clutch) ถ้าหยุดนิ่งแล้วกดเบรกค้าง 0.6 วินาทีให้เข้า R อัตโนมัติ และกดเร่งเพื่อกลับเป็น D (เป็นตัวเลือก) |
| A2 | **Smooth/Assisted Steering + Assisted Lean** | รับปุ่ม W/A/S/D หรือ touch เอง ทำ ramp และ deadzone ลดมุมเลี้ยวตามความเร็ว แล้วส่ง analog ผ่าน VirtualInput การเอียงใช้ระบบ lean เดิมของ A-Chassis (ปัจจุบันจำกัดที่ 35°) |
| A3 | **Auto Balance** | ใช้ `AlignOrientation` ฝั่ง client (driver เป็น network owner) ช่วยตั้งรถให้ตรงแบบนุ่มที่ความเร็วต่ำ และจำกัดการพลิก |
| A4 | **Quick Recovery** | กด R ค้าง หรือปุ่มบนมือถือ จะส่ง RemoteEvent ไปเซิร์ฟเวอร์ เซิร์ฟเวอร์ตรวจว่าเป็นผู้ขับจริง มีคูลดาวน์ 5 วินาที และรถพลิก (UpY < 0.5) หรือค้าง (< 1 stud/s เกิน 3 วินาที) จากนั้นวางรถตั้งตรงบนเลนที่ใกล้ที่สุด (คำนวณจาก HubLayout) ความเร็วเป็นศูนย์ **Cargo ไม่หาย** เพราะเก็บต่อผู้เล่นใน `Lab.server` ไม่ได้ผูกกับรถ |
| A5 | **Easy Wheelie** | กดค้างแล้ว AlignOrientation ยกหน้ารถไม่เกิน 18° นานไม่เกิน 1.5 วินาที และลงล้อแบบนุ่ม ต้องมีความเร็วอย่างน้อย 8 stud/s ไม่ต้องควบคุมสมดุลเอง |
| A6 | **Easy Tuck** | กดสลับท่าหมอบ ใช้ animation ท่าหมอบ (ใช้ `TuckInSpeed` ของ vendor ที่ปิดไว้อยู่ หรือท่า IK ของ RiderPose) และเพิ่มแรงเล็กน้อยด้วย VectorForce (+5% ไม่เกินเพดาน 65 km/h เดิม) |

**ปุ่มที่เสนอ (แก้ปัญหาปุ่มชนกัน I1):**

| การกระทำ | PC | Gamepad | Mobile |
|---|---|---|---|
| ขึ้น/ลงรถ | E (Prompt) / ลงด้วยปุ่มลงรถ (เลิกใช้ Space) | X | ปุ่ม Prompt |
| เร่ง / เบรก+ถอย | W / S | R2 / L2 | ปุ่มขวา "เร่ง" และ "เบรก" ขนาดไม่ต่ำกว่า 72 px |
| เลี้ยว | A / D | Stick | ปุ่มซ้าย/ขวา หรือ thumbstick |
| เก็บ/ฝาก Cargo | F ค้าง (Prompt) | Y | ปุ่ม Prompt |
| Wheelie | Q | B | ปุ่มเล็ก "ยกล้อ" |
| Tuck | C | L1 | ปุ่มเล็ก "หมอบ" |
| Quick Recovery | R ค้าง 0.5 วินาที | Select | ปุ่ม "ตั้งรถ" (แสดงเมื่อรถพลิกหรือค้าง) |
| Boost (อนาคต) | ยังไม่เปิด | — | — |

ตอนขี่รถจะ sink ปุ่ม Space และ LeftShift ไม่ให้ลงจากรถหรือเปิด Shift-lock โดยไม่ตั้งใจ และแต่ละปุ่มทำหน้าที่เดียวในแต่ละสถานะ (เดินเท้า/ขี่รถ)

## 4. Workstream 3: Vehicle Visibility, Camera และ HUD

### V1 แก้ปัญหาตัวถังค้าง (เสนอเป็นงานแรก)

- ใน `VehicleAppearance.luau` (ไฟล์ของโปรเจกต์ ไม่ใช่ vendor): ตั้งตัวถัง `Anchored=false` คง `Massless=true` และ `CanCollide=false` แล้ว `WeldConstraint` เข้ากับชิ้นของ A-Chassis ที่ตรงกัน:
  - ตัวถัง ผูกกับ DriveSeat หรือ Body root
  - ล้อ ผูกกับชิ้นล้อ F/R
  - ส่วนที่เลี้ยว ผูกกับ `Fixed` ล้อหน้า
  - ส่วนที่ติดล้อหลัง ผูกกับ `WheelFixed`
- เพิ่ม `BodyFitVersion` เป็น 2
- **ตรวจรับ:**
  - Probe วัดระยะตัวถังถึงเบาะได้ไม่เกิน 4 studs ตลอดการขับ (ตอนนี้ 122)
  - มวลของ assembly เท่าเดิม
  - รัศมีเลี้ยวที่ 10 stud/s คลาดไม่เกิน ±5% จาก 26.1
  - รัน B3 ทั้ง 10 เคสผ่านเหมือนเดิม
  - ภาพมุมผู้เล่นทั้ง 7 ภาพเห็นตัวรถ
- **ตรวจด้วยภาพ:** ภาพจาก Studio Play มุมผู้เล่นและมุมข้าง ส่วนภาพจาก **Roblox Player จริงต้อง Publish ไปยัง private test place** ซึ่งต้องได้รับอนุมัติ หรือให้เจ้าของถ่ายจากเครื่องเอง

### กล้อง

- `RideCamera` เดิมซูม 10–24 และ offset 0.65 ซึ่งเหมาะแล้วถ้ามองเห็นตัวรถ
- หลังแก้ V1 จะตรวจ 3 อย่าง: กล้องไม่จมพื้นตอนเข้าโค้ง, มองเห็นถนนข้างหน้าอย่างน้อย 30 studs ที่ 28 stud/s, และไม่ถูก HUD บัง

### ลด HUD (จากภาพ B3)

| ตอนนี้ | เสนอ |
|---|---|
| ปุ่มซ้าย 6 ปุ่ม (Garage/Shop/Upgrade/Parts/Race/Event) แสดงตลอด | **ซ่อนตอนขี่รถ** ตอนเดินเท้าแสดงไอคอนเล็ก ปุ่มที่ยังไม่มีระบบให้มีป้าย "เร็ว ๆ นี้ / Placeholder" สีเทาและกดไม่ได้ |
| แถบบน 2 แถบ (ฝากสำเร็จ x ครั้ง และชื่อโซน) | รวมเป็นแถบเดียวเล็ก ๆ เช่น "Zone 01 · ฝาก 1" |
| แผง Speed/Gear/Cargo กลางล่าง กว้างประมาณ 28% ของจอ | ย้ายไปมุมขวาล่าง ขนาดประมาณ 40% ของเดิม แสดง Speed และ Cargo ส่วน Gear แสดงเฉพาะ R |
| แถบ Tutorial กว้างเต็มจอ | แถบบางเหนือแผง แสดงขั้นปัจจุบัน และซ่อนเมื่อทำครบ |
| ปุ่มขวา (Map/แจ้งเตือน/UI 100%) และปุ่ม "Controls" ของ A-Chassis | เก็บเป็นปุ่มเมนูเดียว และซ่อนปุ่ม Controls ของ vendor |

- **ตรวจรับ:** ตอนขี่รถ GUI ที่ทึบรวมกันกินพื้นที่ไม่เกิน 15% ของ viewport (วัดด้วยสคริปต์จาก AbsoluteSize) ที่ PC 1588×625 และ iPhone/iPad ใน Device Simulator
- คงลำดับ Loading → Spawn → Welcome → Tutorial → HUD โดยไม่มี Main Menu

## 5. Workstream 4: Performance และ Visual Roadmap

- **บันทึกแล้ว:** 60 FPS เฉพาะใน Studio foreground ที่ทดสอบ ส่วน 15 FPS สัมพันธ์กับ background throttle **ยังไม่ใช่ผลของอุปกรณ์จริง**
- **แผน QA:**
  1. Device Simulator วัด HUD scale และ touch ทุกปุ่ม
  2. ทดสอบใน Roblox Player จริง ต้องมี private test place ซึ่ง**ต้องได้รับอนุมัติก่อน Publish**
  3. มือถือจริงอย่างน้อย 1 เครื่อง ให้เจ้าของทดสอบหรือติดตั้งเครื่องมือ
  4. MicroProfiler และ Render Stats ทุกครั้งที่ทดสอบ
  5. Budget เริ่มต้น: ไม่เกิน 250k triangles และไม่เกิน 400 draw calls ใน Garage City
- **Visual:** ยังไม่เริ่ม G2–G6 และ 12 โซน แผนหลังข้อ C1–C6 ผ่าน:
  - ทำ Garage Template จาก G1 ผ่าน PlotFrame
  - ทำ Hub Facilities Prototype 1 ชิ้น
  - ทำฉากขอบโลกแบบ B
  - คงสไตล์ Colorful Stylized Roblox × Thai Automotive Culture

## 6. ลำดับงาน (ความเสี่ยงต่ำไปสูง แต่ละขั้นมี backup, git commit, build ชื่อใหม่ และ regression)

| ขั้น | งาน | ไฟล์ | Regression |
|---|---|---|---|
| **C1** | แก้ V1 ตัวถังค้าง | `VehicleAppearance.luau` | Visibility probe, B3 G1/Cargo/Turn, ภาพมุมผู้เล่น |
| **C2** | Assist A1 Auto-Drive + จัดปุ่มใหม่ + กันปุ่มชนกัน | `VehicleAssist.client.luau` (ใหม่) | B3 ครบชุด **โดยไม่ส่ง ShiftUp** (เกณฑ์ใหม่ `manualShiftNeeded=false`) |
| **C3** | Z1 Turn Pad + F2 Terrain | `HubLayout` v12, `CargoCourse`, `HighwayTerrain` (TerrainVersion 10) | B2 audit (hash ส่วนที่ต้องคงไว้ + รอยต่อ), B3 ครบชุด, Cargo ต้องได้ grass 0, Roundtrip ต้องได้ grass 0 |
| **C4** | Assist A2–A4 (Steering/Lean/Balance/Recovery) | VehicleAssist + server remote | B3 ครบชุด, ทดสอบทำรถพลิกแล้ว Recover โดย Cargo คงอยู่ |
| **C5** | Wheelie / Tuck | VehicleAssist | ยกล้อ/หมอบ 20 ครั้งไม่ล้ม และ B3 G1 |
| **C6** | ลด HUD | `LabHUD`, `Entry` (เฉพาะส่วน layout) | Loading/Welcome/Tutorial flow, วัดพื้นที่ HUD, Device Simulator |
| **C7** | Perf/Mobile QA | ไม่มี | ต้องได้รับอนุมัติ private test place |

**หยุดรอ Owner Review หลัง C1+C2 และหลัง C3** เพราะเป็นจุดที่เปลี่ยนการขับและ Layout

## 7. Acceptance Criteria และ Rollback

**Acceptance:**
- ทุกขั้นต้องรัน B3 suite ผ่านครบ ได้แก่ G1–G6, Cargo, SpeedTestLane, Grass, Roundtrip และ Turn
- ไม่ค้าง ไม่ล้ม ไม่ใช้เกียร์ถอย และไม่ teleport ระหว่างขับ (ยกเว้นการ Recover ที่ผู้เล่นกดเอง)
- หลัง C3: unexpectedGrass = 0 และ grass = 0 ใน Cargo และ Roundtrip, hash ส่วนที่ต้องคงไว้ตรงเดิม และ audit รอยต่อได้ช่องว่าง 0 และผิวซ้อน 0
- หลัง C2: ขึ้นรถแล้วกดเร่งถึง 6 stud/s ภายใน 2 วินาทีโดยไม่กด Shift
- หลัง C1: ระยะตัวถังถึงเบาะไม่เกิน 4 studs ตลอดการขับ
- Performance: Studio foreground ไม่ต่ำกว่า 55 FPS ที่ 1588×625 และ Render GPU ไม่เกิน 6 ms
- Cargo และ Economy: ไม่เพิ่มระบบ และ Cargo เดิมผ่าน 0→1→0 เหมือนเดิม

**Rollback:**
- ทุกขั้นเป็น commit แยก ย้อนได้ด้วย `git revert <hash>`
- Backup โฟลเดอร์มี SHA256 ก่อนแต่ละขั้น
- Layout v12 ย้อนเป็น v11 ได้ และ Terrain v10 ย้อนเป็น v9 ได้ (สร้างใหม่จากโค้ดได้แน่นอน)
- Assist เป็นไฟล์ใหม่ทั้งหมด ลบหรือปิดด้วย attribute `VehicleAssistEnabled=false` เพื่อกลับไปใช้ vendor เดิม
- Build เป็นไฟล์ชื่อใหม่ทุกครั้ง และไม่ปิด Studio ของเจ้าของ

## 8. สิ่งที่ต้องขอการตัดสินใจ

1. อนุมัติลำดับ C1 → C2 (แล้วหยุด) → C3 (แล้วหยุด) → C4–C6 หรือไม่
2. จะทำ Auto-Reverse (เบรกค้างตอนหยุดนิ่งแล้วเข้าเกียร์ R) หรือไม่
3. ปุ่ม Wheelie = Q, Tuck = C และ Recovery = R ค้าง ตกลงหรือไม่
4. อนุมัติ private test place สำหรับทดสอบใน Roblox Player หรือมือถือหรือไม่ ถ้าไม่ จะใช้แค่ Device Simulator และภาพจากเครื่องของเจ้าของ
