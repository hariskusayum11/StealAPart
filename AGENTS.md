# STEAL A PART!
Use PowerShell, Rojo 7.6.1 portable and strict Luau for new code.
Never modify WorldRepairSimulator or its Studio instance.
Read PROJECT_MEMORY.md first. Latest implementation order is docs/DEVELOPMENT_ORDER_R03_SOURCE.md (Audit/Main HUD approval gate), alongside docs/MASTER_HANDOFF_30_1_SOURCE.md with the owner-confirmed STEAL A PART! name override. Older GAME_DESIGN/ROADMAP are historical where conflicting. Owner approved implementation of the expanded design on 2026-11-04; record evidence in TASKS.md.
Server owns inventory, cargo, rewards and part compatibility. No client secrets.
Do not publish, buy assets or install system software without approval.
No primitive final vehicle/building art. Preserve vendor licenses and source modifications.
Build does not validate Luau execution or visual quality. Report all untested gates.
Do not commit .tools, build, quarantine, credentials or generated place files.
Stop for user approval after Phase 1 benchmark before expanding scope.

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

## Phase B v11 checkpoint (2026-11-05)
Latest: docs/LAYOUT_V11_B2_REVIEW.md. HubLayout Version 11 is the single coordinate source (PlotFrame). Never push to GitHub without owner approval. Studio saves the open place back to its .rbxlx on close: build reviews to a fresh file name. STOP at B2 owner review; no B3/decoration/import/Publish/economy.

