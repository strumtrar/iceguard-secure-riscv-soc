python-env:
	#!/usr/bin/env bash
	python3.10 -m venv venv
	source venv/bin/activate
	export LITEX_ENV_CC_TRIPLE=riscv64-fick-brötchen 
	python -m pip install --upgrade pip
	pip install --cache-dir ~/.cache/pip .

bitstream: python-env
	#!/usr/bin/env bash
	source venv/bin/activate
	
	python hw/build.py --build --integrated-rom-size=0x8000
