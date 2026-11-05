# A-Chassis 1.7.2M local changes

Source: https://github.com/lisphm/A-Chassis/releases/tag/v1.7.2-stable
License: MPL-2.0, preserved in assets/vendor/A-Chassis-LICENSE.txt. Modified source is embedded in the readable XML and must remain available under MPL when distributed.

- Initialize: exit cleanup remains restricted to caller PlayerGui; removed a current-occupant guard because it broke cleanup after exiting.
- FEAnims: function and character allowlist
- Server: occupant, packet length, rate guards
- Server: occupant, packet length, rate guards

These are preliminary remote guards, NOT a complete security review or anti-speed-cheat implementation. Source original retained in quarantine. Model is a chassis reference, NOT approved Street Cub final art. No purchase or publish.

Starter lab tune changes: weight155, torque7 lb-ft, RPM9000, 10 hp limit, speed cap65 km/h, lean35deg. Experimental inputs, not approved balance.

## Real rider pose (2026-11-03)
Anims client (TuckInSpeed) and FEAnims server avatar-replacement scripts are disabled, retained intact under MPL. They replaced/hid the actual avatar with a fixed-size cloned rig. RiderPose now uses real R15 limbs and native IK, with cleanup on dismount/death. Original vendor model is preserved in backups/pre-rider-ik-*. Chassis physics and initialization are retained. prepare_chassis.py reapplies these flags.
