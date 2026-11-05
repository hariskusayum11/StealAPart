from pathlib import Path
import struct
p=Path('assets/ui/source/ui-kit-roblox.png');data=p.read_bytes();print('PNG header:',data[:8], 'dimensions:',struct.unpack('>II',data[16:24]))