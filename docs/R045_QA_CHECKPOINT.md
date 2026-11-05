# R04.5 — Phase A checkpoint, 5 November 2026

Historical Phase A checkpoint. Superseded by the Cargo follow-up below and owner conditional G1 approval (2026-11-05). Current work: docs/G1_CONDITIONAL_REVIEW.md. Overall acceptance remains INCOMPLETE.

Backup: backups/pre-r045-20261105-090711. Latest authority: docs/DEVELOPMENT_ORDER_R045_SOURCE.md. Geometry10 / Terrain9 / Boundary1 retained.

- Automated v10 roundtrip: PASS, 339.283806 seconds, 408/408 waypoint targets, all12 zones visited, Zone12 physical turnaround, maximumX3142.28125. No in-drive teleport/Pivot/velocity overrides. Centreline run only, not both-lane/full junction acceptance. Evidence: mcp-check/r045-v10-roundtrip.json.
- G3 exit: PASS, 19.931027 seconds,12/12 targets. Initial test spawn configured before Play; production Lab and player spawn restored. Other5garage passes remain historical evidence, not new R04.5 runs. Evidence: mcp-check/r045-g3-exit.json.
- Cargo: actual F held800ms; server TestCargo0→1, TestSecured0, successful pickup message. Return driver missed waypoint49/93, watchdog stopped at160.7068s. Samples show continued movement around the missed turn; do not diagnose collision from waypoint failure. Subsequent local8stud front Blockcast had no hit. Deposit NOT reached, full loop NOT passed. No cargo injected by QA. Evidence: mcp-check/r045-cargo-attempt.json.
- HUD fix: hide Main HUD Hint while visible StealEntry Tutorial supplies instruction. Fresh Play verified Tutorial=true, Hint=false, EntryOpen=false. Build passed. Existing UnderboneBody Name warning remains.
- Performance: Studio Play Client,1588x665, graphicsAutomatic, streaming=true;10.06677s during highway drive:14.99985FPS, worst68.9168ms,787.96MB,2976client BaseParts. Foreground state unknown. LibMP available;31frame snapshot, regular1..31 / absolute2636495..2636525. Largest inclusive CPU scope Sleep; parallel inclusive totals do not prove throttling or bottleneck. Cause and acceptance unresolved. Evidence: mcp-check/r045-microprofiler.json.
- MCP world screenshot again white: Capture Failed. Owner screenshots are current blockout baseline, not completed art approval.

Unpassed: full Cargo deposit loop; new grass/shoulder driving at city AND Zones01–03; live player/vehicle boundary impacts; all service branches; Retry timeout/respawn/Mobile/Tablet/Human QA; performance cause; visual flicker and requested final screenshots. G1 art/lighting/markers not started due PhaseA gate. No new asset imports, economy, Publish or original-game changes.

Next: correct QA return-turn tracking using continuous segment progress and a wider drivable arc, retaining full trace, actual arrival/range and realF deposit. Do not alter chassis or skip route to manufacture pass. Report proposed fix before risky changes, per owner gate. Studio left in Edit with production spawn/Lab restored.
## Follow-up — Cargo regression passed (2026-11-05)
Corrected only QA route: widened pickup return arc from25 to45stud radius and lowered target speed8→6stud/s; intermediate waypoint tolerance8, actual pickup/deposit target tolerance6. Production chassis, Cargo handlers and world geometry unchanged.
New normal-spawn run completed91/91 targets in367.416057s including waits for external keyboardF. Actual F held800ms at pickup and deposit; server verified Cargo0→1→0 and TestSecured0→1, success messages. No Cargo injection or in-drive teleport/Pivot/velocity override. Evidence: mcp-check/r045-cargo-wide-turn-client.json and r045-cargo-wide-turn-server.json. Original failed attempt retained.
The three specific core blockers (G3, v10 roundtrip, Cargo) now have automated passes. This does not close all PhaseA: Zones01–03 grass transitions, physical boundaries, Retry/respawn/Mobile/Human and performance cause remain pending. No PhaseB visuals started. Studio stopped in Edit.
