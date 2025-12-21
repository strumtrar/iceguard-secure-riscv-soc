#!/usr/bin/env python3
#
# IceGuard – LiteX SoC build script for Colorlight-i5
#

from migen import *

from litex.gen import *

from litex_boards.platforms import colorlight_i5

from litex.soc.cores.clock import *
from litex.soc.integration.soc_core import SoCCore
from litex.soc.integration.builder import Builder

from litex.soc.cores.led import LedChaser

from litex.soc.interconnect.csr import *

from litex_boards.targets  import colorlight_i5 as colorlight_target

class IceGuardSoC(SoCCore):
    def __init__(self, sys_clk_freq=60e6, **kwargs):
        platform = colorlight_i5.Platform(board="i5", toolchain="trellis")

        #FIXME
        self.crg = colorlight_target._CRG(platform, 50e6)

        # CPU / SoC Core setup
        SoCCore.__init__(
            self,
            platform     = platform,
            clk_freq     = int(sys_clk_freq),
            **kwargs
        )

        # TODO: UART, Timer, LEDs etc. hinzufügen
        ledn = platform.request_all("user_led_n")
        self.leds = LedChaser(pads=ledn, sys_clk_freq=sys_clk_freq)

def main():
    from litex.build.parser import LiteXArgumentParser
    parser = LiteXArgumentParser(platform=colorlight_i5.Platform, description="IceGuard SoC on Colorlight i5")
    parser.add_target_argument("--sys-clk-freq",     default=60e6, type=float, help="System clock frequency.")
    args = parser.parse_args()

    soc     = IceGuardSoC(
        sys_clk_freq           = args.sys_clk_freq,
        **parser.soc_argdict)

    builder = Builder(soc, **parser.builder_argdict)
    if args.build:
        builder.build(**parser.toolchain_argdict)

if __name__ == "__main__":
    main()
