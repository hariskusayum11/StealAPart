from pathlib import Path
import shutil,datetime
root=Path('.')
b=root/'backups'/('pre-steal-a-part-direction-'+datetime.datetime.now().strftime('%Y%m%d-%H%M%S'));b.mkdir(parents=True)
for file in ['AGENTS.md','docs/GAME_DESIGN.md','docs/ROADMAP.md']:shutil.copy2(file,b/Path(file).name)
source=Path(r'C:\Users\SC1220-000\.codex\attachments\3545f05c-52a0-430b-a875-22b5771d2530\Pasted text.txt')
shutil.copy2(source,'docs/MASTER_HANDOFF_30_1_SOURCE.md')
memory='''# STEAL A PART! — Project decisions

Confirmed by owner: 2026-11-04 (Asia/Bangkok).

- Official game name: **STEAL A PART!**. RACE & RAID is the former project name.
- Keep working directory D:\\RobloxProjects\\RaceAndRaid for now; naming approval does not require moving folders or breaking launchers.
- Latest design authority: docs/MASTER_HANDOFF_30_1_SOURCE.md (original supplied handoff, preserved verbatim), interpreted with this owner-confirmed naming override and the eight supplied UI reference images.
- Core loop: drive -> gain Power -> raid parts -> escape NPC owner -> return to own garage -> display deposited parts -> automatic Coins income -> upgrade/buy vehicles -> race -> repeat.
- Direction: Thai Street Racing x Colorful Simulator x Modern Garage Tycoon. Navy panels, cyan/magenta accents, gold objectives/rewards; readable Thai, Mobile/PC layouts, at most three permanent primary menu buttons while driving.
- Power improves vehicle performance within class caps; Coins buy vehicles/cosmetics/garage upgrades. Deposited parts improve garage value/income. No approved offline income or paid random core-loop rewards.
- Being caught loses only undeposited raid parts; never owned vehicles, deposited parts or existing Coins. No forced PvP or pay-to-win.
- Supplied images are design references, not evidence of implemented systems, balances, currency amounts, paid products or approved purchase offers.
- Current authorization: design/audit/documentation under handoff 30.1. The owner confirmed name and latest gameplay direction; this does not approve implementing all new systems. Obtain implementation approval before changing game scripts/Studio to the expanded design.
- Existing bike/chassis/Cargo prototype is retained engineering evidence; Power, Tycoon income, NPC chase, races and persistence are not complete.
- Credit-saving workflow persists: focused batches, reuse inspected assets/code, concise evidence, no repeated broad research or unnecessary test runs.
- Never modify WorldRepairSimulator; never publish, buy assets or install system software without authorization.
'''
Path('PROJECT_MEMORY.md').write_text(memory,encoding='utf-8')
p=Path('AGENTS.md');s=p.read_text(encoding='utf-8');s=s.replace('# RACE & RAID','# STEAL A PART!',1);s=s.replace('Read docs/GAME_DESIGN.md and docs/ROADMAP.md; record evidence in TASKS.md.','Read PROJECT_MEMORY.md first. Latest authority is docs/MASTER_HANDOFF_30_1_SOURCE.md with the owner-confirmed STEAL A PART! name override. Older GAME_DESIGN/ROADMAP are historical where conflicting. Current expanded-design phase is design/documentation only until implementation is authorized; record evidence in TASKS.md.');p.write_text(s,encoding='utf-8')
for filename in ['docs/GAME_DESIGN.md','docs/ROADMAP.md']:
 p=Path(filename);s=p.read_text(encoding='utf-8');p.write_text('> Superseded where conflicting: owner confirmed STEAL A PART! and handoff 30.1 on 2026-11-04. Read ../PROJECT_MEMORY.md and MASTER_HANDOFF_30_1_SOURCE.md. The content below preserves the earlier plan and does not describe the latest approved vision.\n\n'+s,encoding='utf-8')
p=Path('TASKS.md');s=p.read_text(encoding='utf-8');p.write_text(s+'''\n## 2026-11-04 — Owner-confirmed STEAL A PART! direction\n- Official title is STEAL A PART!; latest gameplay/design follows handoff 30.1 and supplied eight UI references.\n- Stored original handoff verbatim in docs/MASTER_HANDOFF_30_1_SOURCE.md; persistent decisions in PROJECT_MEMORY.md; updated AGENTS and precedence notices on legacy design/roadmap.\n- Directory remains RaceAndRaid. No runtime code, Studio, economy/save data, publish or old-game changes. No Build needed for documentation-only update.\n- Current design-only scope remains until implementation approval.\n''',encoding='utf-8')
print('Updated PROJECT_MEMORY.md, AGENTS.md, legacy plan notices, TASKS.md; preserved handoff source. No gameplay files modified.')