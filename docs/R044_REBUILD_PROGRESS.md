# R04.4 Combined World Rebuild — engineering checkpoint

Authority: DEVELOPMENT_ORDER_R044_SOURCE.md (owner brief dated 4 November 2026). Not final acceptance. No production asset imports or publishing.

## Scope and backup
- Existing coordinate limits retained: X=-1250..3800, Z=-1100..1100 (5050×2200studs). No speculative world expansion. Main alignment remains GarageCity → Zone01..12, opposite-direction return; no perimeter race loop.
- Source/generator/project and built Place backed up in backups/pre-r044-20261104-162212/ before edits.
- Main HUD, session Cargo/server ownership checks, existing chassis and six plot positions retained. No Coins/Shop/Upgrade backend or MainMenu added.

## Implemented source
- RoadSurface.luau: curved/graded roads use shared triangle boundaries; city flat surfaces are partitioned into disjoint rectangles instead of stacking junctions/roads/lots. No texture-stack road material.
- CargoCourse.luau: 32stud carriageway (16perlane) +6per shoulder=44; dark built-in Asphalt, yellow centre and white edge markings separated from collision surface. Bridge rails moved outside44; supported piers remain.
- All six garage floors/lots/accesses use Y=0; existing walls/roofs remain temporary blockout. Service route and side accesses remain outside building plots. No new final garage model claimed.
- Zone access portals now share road edge vertices and taper to flat pads. Version9 audit identified two flat access overlaps at X640/1860 producing~0.39stud height error; version10 removes those slabs and replaces them with ramps.
- HighwayTerrain.luau: detailed voxel occupancy near the highway/city, continuous berm enclosure instead of repeated distant sphere mountains. Measured engine occupancy needed2stud compensation; otherwise grass covered the road by~1.9stud. Foundation version9 is separate from road geometry version10 to avoid clearing/rebuilding terrain during a road-only revision.
- BoundarySystem.luau:16invisible collision segments, sky open. The initial4long-plane implementation was found to clamp at Roblox's2048stud Part limit, leaving gaps; it was replaced before delivery. Actual maximum horizontal segment1011studs,16/16structural blockcasts hit. [Boundary evidence](R044_BOUNDARY_AUDIT.json). Live player/car boundary driving still not passed. Walls extend above berm height; intended road margins remain hundreds of studs. Physical boundary/skyline quality acceptance remains separate from structural checks.
- Limited boundary studies only: timber fence at city/Zone01, native canal near outer Zone02, field bunds near outer Zone03. These are landscape/blockout studies, NOT completed Thai buildings/trees/market assets or finished12zones.
- VehicleAppearance streaming experiment reverted to the exact pre-R04.4 source. Atomic did not receive compatibility acceptance; the original chassis/appearance behavior is retained. Partial body/texture/audio observations remain unresolved, not silently certified.
- Entry.client.luau: game/world/character/vehicle+Cargo readiness, automatic loading dismissal, actual retry polling on timeout, Welcome popup with Close, no Play gate. Artwork shown only during loading; HUD unchanged. StreetHatch unavailable, no fake rewards. Tutorial reads real ride/Cargo/deposit states. Responsive popup sizing added; Mobile not tested.

## Geometry measurements (version10)
[Raw audit](mcp-check/r044-geometry-audit.json)
-165road sections:43.99996185..44.00005341studs from actual edge vertices.
-820road collision rays:0misses; maximum sampled surface deviation0.00651stud after portal fix.
-Grass edge samples: maximum absolute difference0.27963stud; no sampled grass higher than road by>0.4stud. Bridge omitted from grass-edge test.
-6garage floor profiles:0missing; Yerror<0.000001stud at sampled centres/approaches. These are support rays, not proof of all vehicle corner collisions.
-0identical collidable boxes found;2795generated BaseParts in the road audit before boundary segmentation; boundary updated separately from4clamped planes to16valid spans. This is not full coplanar polygon overlap/visual flicker certification.

## Automated driving evidence
-Geometry version9 full physical chassis roundtrip passed:341.70s,409/408waypoints,all12zones. No route teleport/pivot/velocity overrides. Evidence: mcp-check/r044-pre-garage-cases.json. Version10 portal changes require their own full combined replay; do not reuse version9 as final version10 acceptance.
-Independent fresh-spawn exit cases at6garages: [first cases](R044_GARAGE_CASES.json), [retries](R044_GARAGE_RETRIES.json). G1/G5/G6 complete first attempt; G2/G4 complete on retry. G3 still unconfirmed: controller missed a waypoint already behind the moving bike at driver start. Samples show continued~7stud/s movement, so this failure is not evidence of a collision lock. No teleport during driving; each case uses an explicit initial garage spawn and production source/spawn restored afterwards.
-First continuous in-garage Uturn stalled against rear wall. Attempted reverse was rejected: the original motorcycle has neutral/forward ratios and clamps manual downshift to0; it does not provide reverse. No chassis/economy feature added to force QA success. This manoeuvre is NOT passed.
-Physical grass excursion version9 succeeded Terrain → shoulder → city highway, then navigation missed a waypoint and looped; [raw attempt](R044_GRASS_FIRST_ATTEMPT.json). This proves the observed exit/re-entry, not successful Cargo delivery or full test completion.
-Version10 combined replay did NOT pass: first waypoint stalled while the motorcycle remained stationary. [Raw first attempt](R044_COMBINED_FIRST_ATTEMPT.json). Later control checks did not establish a complete pickup/deposit trip. Do not call this a road collision lock or a final roundtrip pass without further evidence. No Cargo was granted by script; current-version Cargo regression is unpassed.

## UI evidence and limits
-Real Entry script re-run under a controlled withheld readiness flag (geometry was retained) to verify progress does not finish early; readiness restored afterwards. [Loading](mcp-check/r044-loading.png).
-Welcome appeared after loading; actual mouse click on Close yielded popupVisible=false,HUDenabled=true,tutorialVisible=true. [Result](mcp-check/r044-ui-final-result.json).
-The first immediate readiness query ran before the0.2s polling tick and correctly still reported artwork visible; later popup/Close succeeded. Do not call that early query a failure of automatic loading completion.
-[Welcome capture](mcp-check/r044-welcome.png) has white 3D background; it verifies GUI appearance only, not visual compliance over a rendered map. Some world captures likewise white; those are rejected as visual evidence. No invented before/after or concept art used as implementation proof.
-Retry timeout branch, respawn and physical Mobile/Tablet not yet tested. Do not call entire UI acceptance passed.

## Performance actually measured
-120RenderStepped frames over8.0000s:mean~15FPS,worst68.34ms,Stats memory~1221.70MB,viewport1588×665,Studio PC client. Not Mobile, not isolated vehicle memory, not a sustained performance benchmark. Background Studio throttling may affect measurement but was not verified; performance acceptance is not passed.
-Streaming true in existing project; Atomic experiment reverted. Long-route automated movement is not comprehensive streamed-device testing.

## Current hold
Owner approval of road/GarageCity required before zone detailing or main-map assets. All Kenney/Pickup main-map installation remains unapproved. Existing catalogs preserved. Kenney ZIPs still unavailable in workspace; no new download attempts or substitutions in this work.

Remaining: final version10 combined replay, G3 reliable exit case, service-road complete drive, physical boundary player/car test, usable world screenshots/visual flicker QA, respawn/Retry/Mobile, final art direction review. Human QA has not occurred in this run. This checkpoint is incomplete until these are reported and owner accepts.


## Delivery state / exact remaining blocks
-Source and Studio Edit preview now geometry10 / terrain9 / boundary1; default Lab source and original player spawn(-752,3,100) restored. No temporary garage spawn override remains. Build passed after final boundary fix.
-Current road audit is strong geometric evidence (44width,0road ray misses,0.00651max sampled height error), not a substitute for all driving/visual acceptance.
-G1/G2/G4/G5/G6 exit cases completed; G3 has not passed a reliable automated exit test. Earlier controller failures missed a target while still moving; do not diagnose those as geometry collisions without a collision trace.
-Cargo, service-road complete test, final version10 full roundtrip, live boundary driving, in-garage turnaround and Human/Mobile QA remain unpassed. Version9 full roundtrip is retained as historical evidence only.
-Loading readiness/auto transition/actual Close tested; timed Retry and respawn remain untested. Welcome is a real native popup with artwork hidden after readiness, but the white-world capture prevents visual sign-off over the map.
-The13requested world/UI screenshots are NOT all delivered. Only Loading is a usable image for its purpose; other captured GUI/road views have mixed/incomplete rendering. No claim of final EnclosedWorld art or flicker acceptance.
-Current safe next step: owner visually inspect the main Studio preview / run the production Build, especially G3, grass transition, both problematic former zone access junctions, and Cargo F interaction. Record HumanQA separately. No further zone detailing/assets are authorized before owner accepts.
