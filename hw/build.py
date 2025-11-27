#!/usr/bin/env python3
#
# IceGuard – LiteX SoC build script for Colorlight-i5
#

from migen import *
from litex.soc.integration.soc_core import SoCCore
from litex.soc.integration.builder import Builder

from litex_boards.platforms import colorlight_i5
from litex_boards.targets  import colorlight_i5 as colorlight_target

class IceGuardSoC(SoCCore):
    def __init__(self, **kwargs):
        platform = colorlight_i5.Platform()

        # CPU / SoC Core setup
        SoCCore.__init__(
            self,
            platform     = platform,
            clk_freq     = int(50e6),
            cpu_type     = "vexriscv",
            integrated_rom_size  = 0x8000,
            integrated_sram_size = 0x4000,
            **kwargs
        )

        # TODO: UART, Timer, LEDs etc. hinzufügen

def main():
    soc     = IceGuardSoC()
    builder = Builder(soc, output_dir="build", csr_csv="csr.csv")

    builder.build(run=False)

if __name__ == "__main__":
    main()
