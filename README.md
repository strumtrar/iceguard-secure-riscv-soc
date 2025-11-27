# IceGuard – Secure RISC-V SoC on FPGA

**IceGuard** is an experimental, open FPGA-based RISC-V SoC platform focused on:

- 🛡️ **Security** – signed firmware, basic secure boot flow, integrity checks  
- 🌐 **Updateability** – CI-driven firmware build & OTA-like update simulation  
- 🧠 **Transparency** – fully reproducible builds, open toolchain where possible  

The primary target for the first iteration is the **Colorlight-i5** FPGA board, using:

- **LiteX** as SoC infrastructure
- **VexRiscv** as the RISC-V CPU core
- A small bare-metal firmware written in C

---

## Goals

- Build a **RISC-V SoC** on FPGA using LiteX
- Implement a **minimal secure boot chain** (hash + signature check before jumping to firmware)
- Provide a **CI pipeline** (GitHub Actions) that:
  - builds the gateware (bitstream)
  - builds the firmware
  - runs basic checks / simulations
  - emulates an **OTA update flow** (new firmware image + rollback if checks fail)
- Document **threat model**, assumptions, and limitations – this is a learning & showcase project, not a certified product.

---

## Repository Layout

```text
hw/           # SoC + FPGA build files (LiteX, board integration)
sw/           # Firmware and support code
docs/         # Architecture and security documentation
.github/      # CI pipelines
