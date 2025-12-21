BUILDDIR := env_var_or_default('BUILD', "build")
BITSTREAM := "colorlight_i5.bit"
GATEWARE := BUILDDIR + "colorlight_i5/gateware/"

python-env:
	#!/usr/bin/env bash
	python3.10 -m venv venv
	source venv/bin/activate
	python -m pip install --upgrade pip
	pip install --cache-dir ~/.cache/pip .

nix-litex-fix: python-env
	#!/usr/bin/env bash

	sed -i "s/ar    = '\$(TRIPLE)-gcc-ar'/ar    = '\$(TRIPLE)-ar'/g" venv/lib/python3.10/site-packages/litex/soc/software/libc/Makefile
	sed -i "s/AR_normal      := \$(TARGET_PREFIX)gcc-ar/AR_normal      := \$(TARGET_PREFIX)ar/g" venv/lib/python3.10/site-packages/litex/soc/software/common.mak

gateware: nix-litex-fix
	#!/usr/bin/env bash
	source venv/bin/activate
	
	./hw/build.py --build \
		--gateware-dir={{GATEWARE}} \
		--integrated-rom-size=0x8000 \
		--csr-json {{BUILDDIR}}/csr.json
		--no-compile-gateware \
		--no-compile-software

	cd {{GATEWARE}}

	yosys -l colorlight.log colorlight_i5.ys 

	nextpnr-ecp5 \
		--json colorlight_i5.json \
		--lpf colorlight_i5.lpf \
		--textcfg colorlight_i5.config \
		--25k \
		--package CABGA381 \
		--speed 6 \
		--timing-allow-fail \
		--seed 1

software: gateware
	#!/usr/bin/env bash

	#!/usr/bin/env bash
	source venv/bin/activate
	
	./hw/build.py --build \
		--gateware-dir={{GATEWARE}} \
		--integrated-rom-size=0x8000 \
		--csr-json {{BUILDDIR}}/csr.json \
		--no-compile-gateware

inject-software: gateware software
	#!/usr/bin/env bash

	cd {{GATEWARE}}

	ecppack  --bootaddr 0 colorlight_i5.config \
	--svf colorlight_i5.svf --bit colorlight_i5.bit 

bitstream: nix-litex-fix
	#!/usr/bin/env bash
	source venv/bin/activate
	
	./hw/build.py --build --integrated-rom-size=0x8000

flash: software
	#!/usr/bin/env bash

	openFPGALoader -b colorlight-i5 {{GATEWARE}}/{{BITSTREAM}}
