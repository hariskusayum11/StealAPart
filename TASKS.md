# RACE & RAID — Progress
2026-11-03. New project only; World Repair Simulator files/place not edited.

## Phase 0 — project & design
- [x] Separate D:\RobloxProjects\RaceAndRaid, Git initialized (no commit).
- [x] GAME_DESIGN.md and ROADMAP.md include Thai Bike Culture, fictional vehicle classes, customization, garage, race modes, cargo balance and security gates.
- [x] Portable Rojo 7.6.1 copied; no install/system PATH change. Dedicated 34880.
- [x] Asset research from real Creator Store and primary websites, raw metadata and rejected provenance recorded.
- [x] Chassis original download preserved with SHA256 and MPL license; working copy separate.

## Phase 1A — driving engineering, IN PROGRESS
- [x] A-Chassis 1.7.2M reference chassis imported into new test place, not Street Cub final body art.
- [x] Keyboard E seat entry, real throttle and brake measured in Studio.
- [x] Starter experimental tune: 10 hp cap, 65 km/h configured cap, 155 kg, 35-degree lean. These are tuning inputs, NOT validated final stats.
- [x] Basic Thai HUD, test cargo pickup/deposit with server range/driver/capacity checks and no persistent rewards.
- [x] Integration test: repeated pickup stays Cargo=1; repeated deposit stays Secured=1. Bike was repositioned by test script; full route not driven.
- [x] Boundary recovery: forced out-of-bounds → recovery count 1, bike returned near origin.
- [x] Build and full Rojo /api/read passed with 553 instances before final cleanup patch; recheck final in TEST_REPORT.
- [ ] Handling approval, high-speed cornering, stable parking and repeated respawns.
- [ ] Mobile touch and physical-device test.
- [ ] Anti-speed-cheat and server-owned part inventory; preliminary remote validation is not sufficient.

## Phase 1B — visual benchmark, NOT COMPLETE
- [ ] Licensed underbone body, garage architecture and accessory meshes meeting target quality.
- [ ] Bike Alley → Scrap Yard → Garage completed environment, three camera views.
- [ ] Final driving HUD and garage preview/customization UI.
- [ ] Mesh/texture access, collision, performance and visual QA.

No permission to call this full benchmark complete. Do not expand to Phase 2/full city/customization until benchmark reviewed by user. Never publish automatically.
## 2026-11-03 — Body fit checkpoint
- Fixed missing InitialSize using exported native MeshSize; retained MeshParts.
- Created missing wheel attachment containers before chassis initialization; fitted 38 meshes (2 logo meshes excluded), 0 anchored fitted meshes at runtime.
- Body source: Creator Store 13113759800, Kenzie_XD; source pack matches mesh owner. Static review reported no scripts. Branded body atlas removed. Candidate only, not final rights/art approval.
- Studio actual screenshot: docs/mcp-check/body-v2-side.png. Real mesh body visible; rider pose still needs adjustment.
- Studio seat + E/W acceleration: occupied seat, 29.866 studs/s after 2.5-second throttle input. This is a smoke test, not handling/mobile approval.
- Disabled suspension debug visibility in tune after screenshot; final visibility change Build checked only.
- Pending: rider fit, steering/braking with body, mobile, performance, garage and route. No WorldRepairSimulator changes.

## 2026-11-03 — Body-equipped handling smoke test
- Studio ChassisLab: 38 fitted meshes; rider remained seated.
- Throttle: 30.295 studs/s. Left steering for 0.9s changed heading from (0.281,-0.016,-0.960) to (-0.214,-0.025,-0.976); up.Y=0.9695 (no fall in this test).
- Brake for 2.5s: 31.246 -> 2.732 studs/s, up.Y=0.99975. Not a full stop or handling acceptance test.
- Evidence: docs/mcp-check/handling-*.json and handling-seated-shot.png.
- Added initialization-completion debug-constraint visibility cleanup; Build verification only for this new callback.
- Outstanding: refine seated pose, duplicate vendor gauge UI, mobile, performance and full garage benchmark.

## 2026-11-03 — Ride camera and pose inspection
- Added src/client/RideCamera.client.luau: native camera zoom 10–24 studs while riding this bike, +0.65 vertical focus offset; restore on dismount/death/character removal. Leaves vendor mouse-steering camera ownership intact.
- Studio measured: baseline zoom 0.5–400 / offset zero; seated 10–24 / offset 0.65; after dismount restored 0.5–400 / zero. Evidence camera-baseline/riding/restored.json.
- Build passed. Actual R15 side screenshot pose-side.png inspected: hands are not aligned with handlebars; existing vendor animation fixtures also remain visible. Rider pose is NOT approved and was not blindly offset because the existing rig drives limbs separately.
- Next focused task: inspect and fit vendor R15 hand/foot targets, hide only animation fixture geometry, then recapture same angle. Mobile/death lifecycle not runtime-tested.

## 2026-11-03 — Current-source visual cleanup
- Synced current VehicleAppearance and vendor tune into ChassisLab Edit; previous Studio tune was stale.
- Hid existing wheel display descendants while preserving physics; actual side capture confirms yellow debug springs gone.
- Grey geometry and mismatched hands remain visible: rider pose NOT fixed/approved. Vendor uses cloned R15 body parts via FEAnims; must inspect that rig before changing limb targets.
- Build passed; camera enter/exit settings restored in Studio. Latest evidence: docs/mcp-check/pose-side.png.


## 2026-11-03 — Real-avatar rider pose delivery
- Replaced fixed-size cloned-avatar presentation with src/server/RiderPose.luau for real R15 avatars. Legacy Anims/FEAnims disabled, preserved in vendor XML and backup; prepare_chassis.py reapplies flags.
- Hand targets follow the front grip mesh. Foot targets and seated forward offset fitted to current test avatar. Native IK reference: https://create.roblox.com/docs/reference/engine/classes/IKControl
- Actual Studio side/front images reviewed: docs/mcp-check/rider-verified-side.png and rider-verified-front.png. Hands now near grips; no cloned rider. These are stationary pose inspections, not performance evidence. Foot alignment across different avatar proportions remains an acceptance gate; R6 uses default seating, not custom IK.
- Latest fresh Play from saved source: throttle 30.807 studs/s; left steering changes heading and stays upright (up.Y=0.9688); brake 31.063 -> 2.826 studs/s in 2.5s. No claim of complete stop or mobile approval.
- Dismount: 0 Ride IK controls, 0 Ride attachments, head visible, zoom restored 0.5–400. Runtime: 0 visible clone parts, seat not anchored, 38 body meshes, no RiderPose errors observed.
- Evidence: docs/mcp-check/pose-delivery-*.json and rider-final-cleanup.json. Temporary stationary capture anchoring is NOT in delivered source.
- Build passed: build/RaceAndRaid-ChassisLab.rbxlx. Open-ChassisLab.cmd rebuilds current source; close old unsaved test tabs without overwriting the new build.
- Remaining benchmark gates: duplicate HUD cleanup, avatar-size variants, R6 pose, mobile/device performance, garage/route. No WorldRepairSimulator edits or publishing.

## 2026-11-03 — Driving HUD consolidation
- Replaced large top debug banner with Cargo status, bottom speed/gear/engine card and contextual controls hint.
- Hides legacy Gauges, GForces and Tires art only; Drive, Mobile, ignition and control remapping retained.
- Studio verified gear N -> 1 after E, engine state and speed read from live chassis. Actual screenshot hud-final-shot.png inspected; shifted card upward another 22px afterward to clear vendor Controls button (final offset Build checked only).
- Build passed. PC runtime checked; mobile layout and touch controls not yet verified. Cargo remains session-only.


## 2026-11-03 — Cargo route checkpoint
- Added CargoCourse module: 140-stud driving corridor, two turnaround areas, lane markings and Thai destination signs. Test-course geometry only; detailed garage assets remain pending.
- Shared pickup/deposit coordinates used by fixtures and server range validation. Pickup/deposit pads now noncolliding and near floor level.
- HUD shows next destination and distance, switches to return/deposit when carrying.
- Studio: repeated build() returns same model (19 children); no observed course/HUD errors. F pickup sets Cargo=1; F deposit sets Cargo=0 / Secured=1; HUD follows both states.
- Input test repositioned bike between endpoints: NOT evidence of a complete manually driven round trip or route visual approval. Build passed. WorldRepairSimulator untouched.


## 2026-11-04 — Cargo guidance and feedback
- Added next-destination BillboardGui and nearby F interaction hint. Added server-authored pickup/deposit/rejection feedback displayed for 3.5 seconds, using sequence attribute for repeated messages.
- Studio input test: pickup Cargo=1, waypoint TestGarageDeposit and success notice visible; deposit Cargo=0/Secured=1, waypoint TestScrapPickup and deposit notice visible. No observed relevant client errors.
- Test moved bike between endpoints; full driven loop, new visual layout and rejection branches not verified. Build passed; mobile and detailed garage still pending. No WorldRepairSimulator changes.


## 2026-11-04 — Cargo rejection QA and UX
- Actual F input: full Cargo remains 1; duplicate deposit remains Secured=1 and shows empty-Cargo message. First initial test setup ran before Character spawned and failed; subsequent pickup/full/deposit/duplicate cases succeeded. Evidence cargo-qa-*.json.
- Viewed cargo-qa-shot.png: feedback readable, top/bottom panels do not overlap in this PC viewport; full route/scene still not visually approved.
- Added 0.35s hold to pickup/deposit prompts; initialize session counters to zero; Spawn Duration=0 removes temporary spawn shield. These final changes Build verified and Edit synced, not fresh-Play verified.
- Remaining: detailed garage/route art, full driven round trip, mobile. No original-game changes.


## 2026-11-04 — Stopping-bay markers and hold validation
- Added eight noncolliding flat bay-edge markings: gold pickup, cyan deposit, kept out of wheel collision.
- Fresh Play input: F held 650ms activates configured 0.35s pickup and deposit; Cargo 0->1->0 / Secured 0->1, waypoint switches correctly. No observed relevant errors.
- Server confirms Spawn shield absent, eight bay markers noncolliding, hold duration 0.35. Build passed.
- Evidence hold-*.json. Test uses endpoint repositioning, not complete driven route; bay visual quality not captured this round. Detailed garage/route art and mobile remain pending.


## 2026-11-04 — Owner-confirmed STEAL A PART! direction
- Official title is STEAL A PART!; latest gameplay/design follows handoff 30.1 and supplied eight UI references.
- Stored original handoff verbatim in docs/MASTER_HANDOFF_30_1_SOURCE.md; persistent decisions in PROJECT_MEMORY.md; updated AGENTS and precedence notices on legacy design/roadmap.
- Directory remains RaceAndRaid. No runtime code, Studio, economy/save data, publish or old-game changes. No Build needed for documentation-only update.
- Current design-only scope remains until implementation approval.

## 2026-11-04 — STEAL A PART implementation authorized / visibility fix
- Owner authorized implementation of latest handoff. PROJECT_MEMORY and AGENTS updated; prior source/state backed up.
- Root cause verified in Studio: TestSurface runtime Y=0/top=0.5 covered road at -0.49. Replaced mapping Position with serialized CFrame for TestSurface and Spawn. Built XML confirms floor center Y=-1.
- Studio after fix: floor top=-0.5, road top=-0.49; overview screenshot steal-overview.png viewed and lane/bay markings visible.
- Updated navy/cyan UI theme, STEAL A PART! brand, road/background contrast, afternoon lighting, and garage sign placement. Preserved engineering service names/launchers to avoid broken references.
- Build passed. This is visibility/theme foundation, NOT complete reference art. Detailed garage, full new gameplay, mobile and persistent save still outstanding; no publication or WorldRepairSimulator changes.


## 2026-11-04 — Loading and welcome UI
- Added src/first/Entry.client.luau mapped under ReplicatedFirst. Removes default loader only after own ScreenGui exists; reports actual game/character/vehicle/endpoint readiness without fake percentage.
- Ready welcome offers 3-step instructions, Start and Close. 25s timeout offers dismissal with incomplete-state message. Session-only welcome, no fake rewards/products. Loading does not assert all mesh/textures have preloaded.
- Main HUD hidden while entry is open; restored on dismissal. Studio verified ready button visible / HUD hidden, keyboard Return activates selected Start, entry removed / HUD enabled afterward.
- Viewed actual entry-welcome-shot.png: Thai instructions and primary button readable in PC viewport. Mobile compact layout implemented but not device-tested; timeout/Close not runtime-tested. Supplied raster reference artwork not uploaded or embedded; current native UI establishes functioning foundation.
- Build passed. No WorldRepairSimulator changes or publication.


## 2026-11-04 — User artwork loading/welcome
- Uploaded user PNGs via official Studio MCP upload_image: loading 77547713334002; welcome 135139130322921; garage art 107954772658752. Source copies and manifest in assets/ui.
- Entry now displays supplied loading and welcome artwork at original aspect ratio, native readiness overlay masks baked 72%, native Start/Close buttons. Unimplemented reward/product offers masked; current prototype instructions replace chase card.
- Studio observed both loading/welcome AssetFetchStatus.Success and welcome IsLoaded=true; actual image-entry-shot.png viewed. Initial transient image warning fixed by checking current fetch status; final fix Build verified, not fresh-Play verified.
- Temporary localhost image server stopped. Build passed. Original-image upload authorized by owner; no game publication. Mobile and loading-screen capture remain unverified.


## 2026-11-04 — Roundabout island hub layout v2
- Latest image direction implemented as geometry foundation: ring radius100/width28, six lot pads, north parts yard, south entrance, island base/water backdrop. Detailed architecture/foliage/wrench landmark NOT delivered.
- Added shared HubLayout. Pickup=(0,0,-250), deposit=(-180,0,125), bike near G1. Updated all existing server point references through Course constants and recovery bounds. Old generated geometry only replaced; old-game files untouched.
- Studio: six PlotId pads, 399 generated children, four representative down-rays hit ground; viewed hub-overview.png showing island/ring/lots. This is sample grounding only, not a full drive/collision/performance acceptance test.
- Build passed to StealAPart-Hub.rbxlx and launcher-compatible RaceAndRaid-ChassisLab.rbxlx. Current scene visibly blockout; no claim of reference-art completion or ownership system.


## 2026-11-04 — Thailand Highway rebuild checkpoint
- Backed up src/project mapping; preserved latest owner brief in docs/THAILAND_HIGHWAY_REBUILD_SOURCE.md. Supersedes ring hub.
- Terrain foundation, 6 temporary garage shells, 12 ordered zones, facility pads and test lane built. First road burial failure corrected after actual screenshots; roadbeds now thick and visible.
- Actual Studio 6 plots/12 zones/Terrain hits at all zone centers. See HIGHWAY_BLOCKOUT_REVIEW.md for screenshots and explicit remaining failures. World-edge concealment and final art not passed; gameplay systems not falsely marked complete.
- Streaming mapping enabled; actual streaming, new-location Cargo input, route driving and performance not tested. Build checked. Await blockout review before detailed Zone 01.


## 2026-11-04 — Blockout Revision02 (not approved / roundtrip not passed)
- Backup pre-blockout-r02-*; revised continuous curves/4.21% max sampled grade, terrain profile, supported bridge, garage turn aprons and separated facility access streets. No zone detailing.
- Studio center support samples every12 studs and 1,011 lane samples: no gaps/burial in sampled geometry. Six garage entry rays unblocked; 5 facility routes x11 support samples passed.
- Actual virtual-input chassis driving reached all12 zones, but multiple terminal-turn attempts stalled/off-road. Last 260x260 apron enlargement not fresh-drive verified. Do not mark roundtrip passed or final blockout approved.
- Separate F-hold Cargo input check passed 0->1->0/Secured1; used endpoint repositioning explicitly. Player stands on Concrete after exit; HUD retained. No DataStore changes/publish/old-game edits.
- Evidence/images and failure history documented in docs/BLOCKOUT_REVISION_02.md. Build passed. Continue structural driving fixes before owner review of final blockout.

## 2026-11-04 — R03 Audit/Foundation/Main HUD review gate
- Preserved source order and backed up pre-r03-ui-*. Retained LabHUD as sole HUD controller; reusable UITheme and Components added.
- Live chassis speed/gear, session Cargo/deposit count, real zone/location and next-target guidance. No fake economy/NOS/chase.
- All six navigation buttons open/close prototype status panels via real PC mouse input; UI scale100->90% tested. Last integrity check logoLoaded=true, gear1, menuClosed=true, no relevant runtime errors. Compact behavior fixed; Mobile not tested.
- Uploaded user UI kit 92686584842368 and cropped logo/icons only. Last atlas correction visually checked. Original artwork retained; native Entry compliance fix is Build checked, not fresh-Play verified.
- See docs/R03_AUDIT_AND_MAIN_HUD.md and r03-main-walking/driving.png. Build passed. R03 roundtrip and Street Hatch remain unpassed/unavailable; full UI menus/backends not complete.
- Waiting owner review of Main HUD before next UI phase per latest order. No publish, no WorldRepairSimulator changes.


## R04 — 2026-11-04 latest order
Authority: docs/DEVELOPMENT_ORDER_R04_SOURCE.md + docs/R04_ADDITIONAL_ORDER.md override conflicting R03 sequencing. Catalog: docs/R04_ASSET_CATALOG.md. Owner approval required before imports; R03 collision/Z-fighting/road joins and real driven roundtrip must pass before approved installation. Preserve highway12zones,6garages,chassis,Cargo,MainHUD. UI07 target; no separate MainMenu/Play entry gate. Research only this checkpoint:13CreatorStore searches with raw evidence, official external sources reviewed; zero new downloads/imports/Studio driving tests. Do not count existing assets as new R04 completion.


## R03.1 + R04 owner review — 2026-11-04
Owner approved catalog shortlist and isolated inspection of four Kenney packs + Roblox Pickup only; main-map installation still unapproved. R031_R04_PROGRESS.md records fixes and real 339.90s chassis roundtrip complete with all12zones/no teleport. Build passed. Geometry support1521samples/no gaps; flicker full visual QA/all6garage inputs not passed. Kenney signed download403 => no usable ZIP/import/Garage01. Pickup imported only in separate Studio quarantine,42Lua containers scanned, remote issues found; not production-safe/driving/performance tested. Three track thumbnails viewed: R04_RACE_TRACK_OPTIONS.md; no tracks imported. MainHUD/chassis/Cargo preserved. No12zone decoration or original-game changes.


## R04.4 latest authority / work in progress
Latest: docs/DEVELOPMENT_ORDER_R044_SOURCE.md supersedes R04.1–R04.3. docs/R044_REBUILD_PROGRESS.md records engineering evidence and unresolved gates. Backup pre-r044-20261104-162212 includes source/generator/build. Geometry10 / Terrain9:44stud road, partitioned city floors, portal ramps, 4boundary planes within existing5050x2200 bounds, limited native boundary studies. No asset installs/Publish/old-game edits. Automated v9 roundtrip passed; v10 combined QA pending. Five garage exits recorded complete; G3 controller case unresolved. Grass exit/re-entry observed; no Cargo pass yet. Loading auto/Welcome Close exercised; world screenshots unreliable white, Mobile/respawn/Retry and Human QA not passed. Stop for owner road/Garage acceptance before detailing or main-map asset imports.

R04.4 checkpoint update: final geometry10/terrain9/boundary1. Fixed actual2048Part clamp with16boundary spans(max1011),16structural Blockcast hits; no live boundary drive claim. FinalBuildpassed, StudioEditpreviewgenerated, defaultLab/spawnrestored; appearanceAtomicexperimentreverted. G1/G2/G4/G5/G6 exit QA complete, G3unpassed. V10combinedQA stalled; Cargo/currentfullroundtrip/Human/Mobile and requested13worldphotos not passed. Never promote historicalv9roundtrip to v10acceptance. docs/R044_REBUILD_PROGRESS.md is the detailed handoff. Stop before zone detailing/main-map imports; owner quality approval still required.

## R04.5 checkpoint — 2026-11-05
Authority docs/DEVELOPMENT_ORDER_R045_SOURCE.md. See docs/R045_QA_CHECKPOINT.md. Automated v10 roundtrip408/408 in339.284s and G3exit12/12 in19.931s passed. RealF pickup passed; return waypoint49/93 failed, deposit pending. PhaseA gate CLOSED; no G1 decoration/PhaseB yet. HUD hint/tutorial overlap fixed, Build and freshPlay state checked. Performance15FPS unresolved; MCP worldcapturewhite. Production Lab/spawn restored. No imports/Publish/original-game edits.


## Follow-up — Cargo regression passed (2026-11-05)
Corrected only QA route: widened pickup return arc from25 to45stud radius and lowered target speed8→6stud/s; intermediate waypoint tolerance8, actual pickup/deposit target tolerance6. Production chassis, Cargo handlers and world geometry unchanged.
New normal-spawn run completed91/91 targets in367.416057s including waits for external keyboardF. Actual F held800ms at pickup and deposit; server verified Cargo0→1→0 and TestSecured0→1, success messages. No Cargo injection or in-drive teleport/Pivot/velocity override. Evidence: mcp-check/r045-cargo-wide-turn-client.json and r045-cargo-wide-turn-server.json. Original failed attempt retained.
The three specific core blockers (G3, v10 roundtrip, Cargo) now have automated passes. This does not close all PhaseA: Zones01–03 grass transitions, physical boundaries, Retry/respawn/Mobile/Human and performance cause remain pending. No PhaseB visuals started. Studio stopped in Edit.

## R04.5 Conditional G1 approval — 2026-11-05 (latest authority)
Owner accepts actual automated v10 roundtrip, G3, Cargo and Build scopes; this is not Human QA/final acceptance. Limited PhaseB is now authorized: G1 only plus adjacent apron/background and client-local Bright Thai Garage Day. Preserve production chassis/Cargo/main road/boundary. No other garages/zones, backend, imports or Publish. Record repeatable before/after performance and remaining QA. Stop for Owner Review after prototype. See docs/G1_CONDITIONAL_REVIEW.md for this checkpoint.

## G1 conditional review checkpoint — 2026-11-05
G1Visual v4 implemented154noncollidable BaseParts/2lights; idempotent154→154. CargoCourse only visual hooks (normalized source comparison true), protected Lab/chassis/Terrain/Boundary hashes unchanged. Client-local GarageDay; debug deposit tile hidden nearG1, prompt unchanged. Eight real Studio Play images captured/viewed: docs/mcp-check/g1-*-v4.png. Beam transform bug fixed before v4. Main report docs/G1_CONDITIONAL_REVIEW.md.
Automated grass city+Zones01–03 complete127/127 in193.141s; service loop180/180 observed (full trace not retained); one live player boundary case stopped atZ1085.37 withcontacts/Health100. Vehicle boundary NOT passed (rolled away from berm). True60s LoadingRetry and Respawn tested on unchanged Entry. Mobile/tablet emulators exercised; finalphone close/touchdriving NOT accepted. Experimental Entry layout reverted exactly to pre-G1 backup. Performance15FPS unresolved; finalv4 15.0007/15.0026FPS at1588x625, baseline1588x665 not exactA/B. Background B stillsparse; no finalvisual/performance acceptance. Buildpassed withknownNamewarning. StudioEdit/defaultviewport/productionSpawnLabrestored. STOP for Owner Review, noG2–G6/zoneexpansion/import/Publish.

## Phase B: B0–B2 Layout v11 rev2 (2026-11-05)
Owner approved Y-fork rev2. B0: backup pre-b0-v11-20261105-124543 (SHA256SUMS), Git initial commit a5230f2 on main, local identity hariskusayum11, origin added (NOT pushed), Roblox MCP local scope registered + read-only test passed, v10 perf baseline 15.00FPS with Studio OS-foreground 44/44 (focus throttling not supported; render AMD RX6500/display Intel; cause unresolved). B1 ba417ab: PlotFrame refactor, snapshot 2961 parts 71/71 groups identical to v10. B2: Layout Version 11 (Terrain9 unchanged), G1-G3 left Z-225, G4-G6 right Z+225, ring R56, Y-fork R60/50deg, gateway -396..-364, throat -364..-250, hub placeholders, CityEntry, SpeedTestLane candidate (-1060,0,0). Audit: protected highway/boundary 13/13 hashes = v10; 7092 surface samples 0 gaps, max dev 7.6e-7, 0 real coplanar overlaps, 0 obstacles; smoke spawn/deposit/bike/prompts/plots/G1Visual v5/HUD/GarageDay pass. Real Studio images docs/mcp-check/b2-*.png. Report docs/LAYOUT_V11_B2_REVIEW.md. STOP for Owner Review; B3 driving QA not started.

## B3 Driving/Functional QA (2026-11-05)
Report docs/B3_DRIVING_QA_REPORT.md. No source changes. G1-G6/Y-fork/R56-R60/SpeedTestLane/grass/roundtrip12 PASS; Cargo functional PASS but Zone01 turn needs grass (F3). F1 manual shift N->1 required (Easy Arcade conflict). F2 terrain protrudes <=0.59 above MainHighway X3026-3046 (HighwayTerrain flatten from 3030). Turn radius 28sps 30.6, 35sps 32.4/35.8. Perf: 60FPS foreground v11 & empty; 15FPS = Studio background render throttle (log-correlated A/B/C). STOP for Owner Review; proposals: Zone01 fix, Vehicle Assist module, Perf/Mobile QA, Visual.


## Master Owner Directive (2026-11-06) — continuous M1–M7
Owner approved continuous IMPLEMENT→TEST→FIX→COMMIT through M1 controls, M2 garage ownership/personal bikes, M3 Layout B (250) + alternating sides, M4 Raid Gate + 2/5 min cycle, M5 shared parts/E pickup/gate deposit/inventory, M6 NPC chase, M7 end-to-end. Garage auto-deposit cancelled (deposit at Raid Gate). No push/publish; vendor A-Chassis untouched.

### M1 Vehicle Controls — PASS (real keys, build StealAPart-M1)
F mount (RidePrompt), E pickup prompt, W/S/A/D, Space dismount only when stopped, LeftShift sunk. Assist remaps vendor gear/clutch/mode/toggles off game keys at runtime, stops the rider-copy Ignition LocalScript (vendor F = engine off) and restarts a stalled engine via IsOn.Starting. Real keyboard (StudioMCP user_keyboard_input): F mount → gear 1 engine on; W to 6 stud/s 0.50/0.73 s; F tap/hold while riding: engine stays on; E/Q/M/P/R/T/Y/U/C: gear 1 Auto TCS unchanged; S hold after stop −0.03 stud (no reverse); Space at 27 stud/s no dismount, at 0 dismount; walk + jump on foot. Evidence docs/mcp-check/m1-realkeys.json.

### M2 Garage Ownership + personal Street Cubs — PASS (solo + mock owners), real multi-client NOT VERIFIED
GarageService (session plots G1..G6, first free, release on leave, PlotOwnership markers, Player.PlotId), VehicleService (StreetCub_<UserId> cloned from ServerStorage.StreetCubTemplate = unmodified vendor rbxmx; owner-only RidePrompt F; foreign touch-sit ejected by breaking SeatWeld; per-bike out-of-world recovery from HubLayout bounds). Workspace.ChassisTestBike mapping removed; clients detect bikes by StreetCub attribute. Studio-only ServerStorage.QAHook for mock owners. Test (StealAPart-M2b): player G1, spawn 0.91 from plot spawn; mocks G2–G6, 7th nil, idempotent assign, release G4 → newcomer G4; 6 bikes each 0.52–0.88 from own BikeStart; foreign Sit ejected + message; foreign F prompt refused; own bike real keys F→gear1, W 6 stud/s 0.46 s, brake hold −0.03, Space dismount at 0. Evidence docs/mcp-check/m2-*.json. Studio MCP cannot start multi-client tests: real 2–6 player run NOT VERIFIED.

### M3 Zone Layout B + alternating sides — PASS (build StealAPart-M3e)
HubLayout v12 / Terrain10: zones every 250 studs from X −250 (Zone 01 unchanged, pickup unchanged), odd = left (−Z), even = right (+Z) for +X travel; padNear widened where the road bends toward the pad; RouteEndX = Z12+60 (2560), BridgeX = Z05–Z06 midpoint (875), MaxX = RouteEndX+750 (3310, was 3800). CargoCourse/HighwayTerrain/LabHUD/QA read these values (no 3050/1050/3800 literals left). Zone connector widened to 80–100 studs, portals snapped to road vertices. Terrain follows the connector→pad profile below the surfaces and fades out (no protrusion/ditch); fine-voxel corridor ±152.
Audit (m3_zone_audit): highway 3515 samples 0 gaps, 0 terrain on road, max step 0.24/4 studs, 0 collidable obstacles; pads/connectors clear of road by ≥4 studs, bridge gap 25; residual ≤1 sample/zone at slanted connector corners outside the drivable surface, one 0.15-stud terrain bump (Zone 04). Course parts 3137 (v11 3226).
Driving: ZONES case entered/U-turned/exited all 12 zones (0 bumps); ROUNDTRIP gate→Z12 at 45 stud/s 68.6 s, full throttle (64 stud/s) 51.6 s (v11: 65 s); full gate→Z12→gate 179.8 s / 133.7 s, 0 bumps. Evidence docs/mcp-check/m3-*.json.

### M4 Raid Gate + shared 2/5-minute cycle — PASS (tested in combined build StealAPart-M4b)
RaidConfig (gate X −330 in the throat, assembly line X −378, Closed 120 s / Open 300 s, tiers, part types) and RaidService: server-authoritative phase on workspace attributes (RaidPhase/RaidPhaseEndsAt server time/RaidRound), gate model with ForceField barrier solid while Closed, live countdown on the gate sign and RaidHUD banner. Direction-aware crossing from 10 Hz samples of each player's tracked point (own bike seat or root): only a west crossing counts as exit; east crossing while Closed is put back. Round end: hooks clear Cargo/parts/guards first, then every player still in the Raid Area is moved to the assembly line with their bike; Garage City players untouched. QA durations shortened via Studio-only QAHook (logic identical). Test: barrier solid while Closed, real W into barrier stops at X −334.9; Open → 60 parts; round end in Raid Area with Cargo → seat at (−378,−14), Cargo 0, Inventory kept; auto-reopen round 2.

### M5 Shared parts, Cargo, gate deposit, Inventory — PASS (StealAPart-M4b)
PartsService: 5 shared parts per zone per round (60), placed on each pad; E ProximityPrompt (hold 0, 12 studs) works riding or on foot; server checks Open phase, part state (first valid press wins), range, Raid Area, one Cargo slot; commit has no yields. Cargo (unsafe) vs Inventory (per player entries + counts, InventoryTotal/InventoryJson attributes) are separate; west gate crossing deposits automatically (no button/dismount/stop), consume-before-credit prevents double deposit. Round end clears Cargo/dropped parts, secured parts stay in Inventory. Garage deposit tile and legacy test fixtures removed; HUD/Entry/G1 sign texts now point to the Raid Gate. Test (real keys): E steal → Cargo 1 'wheel'; standing inside gate with Cargo → no deposit; W west across gate → Cargo 0, Inventory {"wheel":1}; Cargo full message path; LastPickupResult diagnostics.

### M6 NPC chase — PASS for Zone 01 tier (StealAPart-M4b); medium/hard tiers NOT VERIFIED in play
NpcService: light anchored guard models (no Humanoid/physics), simulated at 15 Hz only while alert/chasing/returning. Tiers: Z01–04 1 guard 26 stud/s, Z05–08 2 × 36, Z09–12 2 × 46; 1.2 s alert before chasing; only the thief of that zone's part is chased; guards stop at the gate line. Catch inside zone → guard carries part home → slot restored (case A); outside → dropped at catch point, guard returns, re-pick restarts chase (case B); deposit stops chase (C); round end resets all (D). First run showed easy guard (32 stud/s, no alert) catching before a standing start could reach the gate → tuned. Test: A, B, re-pick, C, D all observed with real E/W keys; ChasedBy HUD warning attribute.

### M7 End-to-end gameplay loop — PASS solo (build StealAPart-M7c); multiplayer NOT VERIFIED
Loop driven in Studio Play: spawn at own garage G1 → real F mount → drive to Raid Gate (waits while Closed) → Zone 02 (easy, right side) steal via server pickup path → guard alert/chase → escape at 45 stud/s → west gate crossing auto-deposits (Inventory {"seat":1}, "ฝากอะไหล่สำเร็จ!") → re-enter → Zone 10 (hard, 2 guards) steal → caught inside zone, part returned (case A) → round end: barrier closes, Inventory kept → next round opens with 60 fresh parts. 0 falls, 0 script errors. Studio captures docs/mcp-check/m7-*.png (contact sheet m7-contact-sheet.png).
Fixes found by M7: (1) M5 welcome text had real line breaks inside a Luau string → ReplicatedFirst Entry failed to parse (welcome/tutorial broken in M5 commit) — fixed, plus a repo-wide multi-line-string check; (2) guard tiers retuned twice: a guard standing on the pad cuts inside a bike U-turn arc, so easy guards (6 stud/s, alert 3 s, reach 5) are slower than any moving bike; medium 16/2.2 s/7; hard 28/1.5 s/8. Route driver RAID case + QA open/close steps added.
