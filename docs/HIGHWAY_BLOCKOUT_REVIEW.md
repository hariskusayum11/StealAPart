> Superseded structural checkpoint: see BLOCKOUT_REVISION_02.md. Final blockout remains unapproved.

# Thailand Parts Highway — Blockout review, 2026-11-04

Latest authority: THAILAND_HIGHWAY_REBUILD_SOURCE.md. This is an incomplete blockout checkpoint, not final environment or gameplay acceptance.

## Built
- Replaced generated roundabout island with thick Terrain foundation and background hill masses; no Terrain:Clear used. Terrain changes are scoped to this generator's footprint. Backup: backups/pre-highway-*.
- Six temporary open-front garage shells in two rows of three, parking/access roads.
- Single outbound two-way highway from Garage City through 12 sequential zone markers. Return uses the opposite lane. Coordinates are provisional and stored in src/shared/HubLayout.luau.
- Facility reservations for Race Hub, Parts Market, Shop, Upgrade Center and Event Plaza. Straight speed-test lane with start/finish signs, not a functioning race.
- Existing bike, rider pose, HUD, welcome artwork and Cargo server logic retained. Pickup/deposit and recovery bounds moved with the layout. No DataStore in current src; session-only Cargo counters. Vendor remotes retained, not replaced by a new inventory system.
- StreamingEnabled and radii configured in project file; actual streamed-device behavior not verified. Six-player capacity still requires Roblox experience configuration; six plots do not enforce six users.

## Actual evidence
- Studio reports 6 plot pads, 12 zone markers; downward rays at all 12 zone centers hit Terrain.
- First visual test found buried roads; fixed soil elevation and thick road beds. Updated garage/player screenshots viewed with visible roads.
- [World overview](mcp-check/highway-world.png)
- [Six garage shells](mcp-check/highway-garages.png)
- [Highway sequence](mcp-check/highway-sequence.png)
- [Facility reservations](mcp-check/highway-facilities.png)
- [Player-height view](mcp-check/highway-player.png)

## Not passed / not implemented
- World edge remains visible from high aerial views. Hill silhouettes are crude; no claim of naturally hidden boundaries, completed rivers/coastline/forest or reference-image art quality.
- Garage shells are temporary primitive blockout explicitly allowed by this rebuild brief; not final assets. No garage ownership/player-name assignment yet.
- Shared Loot, NPC chase/capture/escape, race registration/ranking, trading, shop, upgrades and events remain unimplemented. Current Cargo pickup is the old single-item test, not Shared Loot.
- Full driven round trip, all road joins/grade transitions, new-location Cargo input, streaming, FPS/memory and Mobile not yet verified. Terrain center hits are not complete collision QA.
- Request blockout review before detailed Zone 01 work; do not expand detailed zone visuals until owner approves.