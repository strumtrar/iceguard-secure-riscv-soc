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

bitstream: nix-litex-fix
	#!/usr/bin/env bash
	source venv/bin/activate
	
	python hw/build.py --build --integrated-rom-size=0x8000
