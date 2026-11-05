# Chassis Lab — measured evidence
2026-11-03. Only D:\RobloxProjects\RaceAndRaid. Engineering scene, not approved final environment.

## Tools verified
Official installed StudioMCP.exe: list Studio, execute Luau, keyboard, character navigation, Creator Store search, Play/Stop and screen capture worked in the new place.
Screenshot docs/mcp-check/lab-shot.png was viewed: visible chassis wheels/suspension and Thai lab HUD. It is NOT a finished motorcycle model or visual-quality pass.

## Runtime evidence
- Seat entry with E: Occupant present, driving interface and project HUD present.
- Initial vendor tune: after ~2.5s W, speed 70.848 studs/s (~71.4 km/h using 0.28m/stud), upright dot 0.99999. After 1s S still 50.02 studs/s. Rejected as starter tuning.
- Revised tune: after ~3.5s W, 40.883 studs/s (~41.2 km/h); after ~2.5s S, 2.506 studs/s (~2.5 km/h). Upright dot 0.99982. Does not establish top speed or exact stopping distance.
- Low-speed steer input changed heading and position; high-speed turning not accepted/tested fully. One run began in neutral, so no claim of a completed cornering test.
- Exit returned CameraSubject to character Humanoid. A cleanup guard initially left chassis UI alive; guard corrected to retain own-player cleanup. Final-exit-check JSON is the authoritative retest result.
- Cargo integration: keyboard F pickup twice → Cargo1/Secured0; deposit twice → Cargo0/Secured1. Script repositioned bike for this test; NOT a complete driven delivery route. Session-only; no DataStore.
- Vehicle disappeared after leaving finite test surface during unattended run. Added lab recovery and forced out-of-bounds test: count1, seat near (-13.5,2.855,-1.053). Recovery is a lab aid, NOT anti-cheat.

## Performance sample — NOT a pass
Client RenderStepped sample: 45 frames / 2.99854s = 15.007 FPS; worst frame 68.421ms; Stats client total memory 1686.754 MB.
Studio PC only, short sample with multiple Studio windows. Foreground/background throttling, plugins and rendering cost not isolated. No mobile results, no device FPS guarantee.
Console contains many existing local user_rojo-master plugin load errors and an asset 1737635 access denial. No global plugin removal/change performed; not proven those caused the measured frame rate.

## Required next checks
- Confirm exit cleanup retest and repeated enter/exit; no leaked interfaces/input connections.
- Tune cornering, idle creep, parking, reverse and collision before approving driving feel.
- Test mobile in emulator and real device; touch buttons and camera view must not overlap.
- Licensed body/garage still missing. Found != Imported != Studio Tested.
- Capture final visual benchmark views only after real art is imported.
- Security: speed/teleport validation, parts ownership, malicious remote/packet testing, multiplayer before any persistent rewards.
## Final verification
Exit retest: Seated=false, Interface=false, CameraSubject=Workspace.Gooris99.Humanoid. Cleanup fix verified in Studio.
Final Rojo build and full API read passed (553 instances); hash in ROJO_VERIFICATION.json. Studio left in Edit mode. Server34880 remains available. No publish.
