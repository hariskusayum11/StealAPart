# C1 rev2 — Wheel Wobble / Body Collapse / Rider Alignment

Status: fixed in Studio QA. **Waiting for owner visual approval.** C1 is not Final PASS until then.
Builds: `build/StealAPart-C1.rbxlx` (before, commit 8dbb1c3) and `build/StealAPart-C1r2.rbxlx` (after).
Evidence (local, gitignored): `docs/mcp-check/c1-*`, `c1r2-*`, `c1old-*`.

## Confirmed root cause (one cause, three symptoms)

After A-Chassis Initialize unanchors the bike, the parked, rider-less chassis leans (~16°, once 58°) and the
front end swings (~12°). `VehicleAppearance.apply` (C1 rev1) computed every mesh pose from a **world-level**
frame and then welded it, so the lean/steer at that instant was frozen into the welds. Because the parked
lean differs every server start, the error changed per session ("บางรอบ").

| Measured (bike parked, server) | Session 1 | Session 2 | Session 3 |
|---|---|---|---|
| Shell up vs DriveSeat up | 20.3° | 17.1° | 13.5° |
| Rear wheel mesh axle vs real axle | 20.1° | 16.9° | 13.5° |
| Front wheel mesh / forks / handlebar vs front axle | 24.8° | 22.6° | 15.7° |

- Wheel wobble: physics wheels spin on the hinge axis (0° error); the display meshes were tilted 12–25°
  around a centred axle → rim swings ±0.24–0.36 stud = figure 8.
- "Collapse / lean": physics never collapsed (ROUNDTRIP monitor 6,793 samples: seat height 2.0–2.6, roll ≤16°,
  springs never at limit). Only the welded shell was tilted 13–20° relative to the chassis.
- Rider alignment: RiderPose IK targets the handlebar mesh `black`; the crooked handlebar pulled the arms.
  HumanoidRootPart offset to seat was constant (1.27 stud) — rider physics was fine.
- Source model checked: all meshes share one rotation and the axles are ⟂ wheelbase (0.3°), so the asset is fine.
- Not caused by collisions/mass: meshes are CanCollide=false, Massless; AssemblyMass 2.98170 before and after.

## Fix (VehicleAppearance only; vendor untouched; BodyFitVersion 3)

- Fit frame = chassis frame: right = DriveSeat.RightVector (= rear axle, 0.00° measured), forward = wheelbase
  projected ⟂ right, so parked lean no longer matters.
- Steering: the vendor "Rotate" hinge angle is undone for the front group (forks, handlebar, mudguards, disc),
  so they are fitted straight-ahead and then welded to F.Arm as before.
- Wheel meshes copy the physics wheel rotation exactly (both have the axle on local X).

## Results after fix (C1r2)

| Check | Result |
|---|---|
| Wheel mesh axle vs real axle (parked, 3 sessions incl. 58° fallen start) | 0.00–0.02° |
| While driving 10/25/max stud/s and turning | ≤0.05° |
| Forks / handlebar vs front axle | 0.33° |
| Shell vs seat | 2.3–3.3° (constant built-in pitch) |
| Drift from weld targets / max mesh-to-seat | ~1e-4 stud / 3.5 stud |
| Physics (seat height, pitch, roll, springs, rider offset) | same as C1 within run variance |
| B3 regression: WALK, G1, CARGO (pickup 0→1, deposit 0→1), SPEEDLANE, ROUNDTRIP (12 zones, 420 s) | PASS, same as B3 |
| TURN radius 28/35 stud/s | 30.6 / 30.7 / 32.3 / 31.1 (B3 30.6 / 30.6 / 32.4 / 35.8; 35R varies 31–36 between runs) |
| Ride monitor over ROUNDTRIP (6,791 samples) | 0 anomalies |

## Video for owner review (animated GIF, 15 fps, BEFORE | AFTER)

- `docs/mcp-check/c1-compare-straight-slow-side-side.gif` — side, ~7 stud/s
- `docs/mcp-check/c1-compare-straight-slow-side-front.gif` — front
- `docs/mcp-check/c1-compare-straight-slow-side-oblique.gif` — oblique
- `docs/mcp-check/c1-compare-straight-fast-chase.gif` — chase, ~30 stud/s
- After-only: `c1r2-video-straight-fast-side.gif`

Turning clips could not be kept: the capture privacy guard rejected them (another window covered Studio).
Please check turning in your own test. Capture rule now: frames are kept only while Studio is the
foreground window; any clip with non-Studio content is deleted.

## Owner visual checklist

1. Ride straight slow/fast: both wheels spin flat, no figure 8 (side and front view).
2. Turn left/right in a circle: front wheel and forks steer together, body stays on the frame.
3. Stop and park: body not sunk or tilted relative to the wheels.
4. Rider hands on the handlebar, seated on the seat, through Zone 12 and back.
5. Repeat after a Stop/Play restart (the old bug changed per session).

## Rollback

`git revert <C1r2 commit>` returns to C1 rev1 (8dbb1c3); `git revert 8dbb1c3` returns to the B3 state.
