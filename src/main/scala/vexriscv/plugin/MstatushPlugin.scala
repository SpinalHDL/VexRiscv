package vexriscv.plugin

import spinal.core._
import vexriscv.{VexRiscv, Riscv}

/**
 * MstatushPlugin
 *
 * Implements the mstatush CSR (0x310) as defined in RISC-V Privileged Specification.
 *
 * For RV32 systems, mstatush represents the upper 32 bits (bits 63:32) of the
 * conceptual 64-bit mstatus register. Since VexRiscv is a little-endian RV32
 * implementation without hypervisor extension or big-endian support, all bits
 * in mstatush are hardwired to zero.
 *
 * This plugin is provided as a separate, optional component for backwards
 * compatibility. Existing VexRiscv configurations without this plugin will
 * continue to work unchanged.
 *
 * Usage:
 * {{{
 * // In your VexRiscv configuration plugins list:
 * new MstatushPlugin(readOnly = true)  // Read-only (default)
 * new MstatushPlugin(readOnly = false) // Allow writes (no effect)
 * }}}
 *
 * @param readOnly If true (default), mstatush is read-only. If false, writes
 *                 are accepted but have no effect (all bits remain zero).
 */
class MstatushPlugin(val readOnly: Boolean = true) extends Plugin[VexRiscv] {

  override def build(pipeline: VexRiscv): Unit = {
    import pipeline._
    import Riscv.CSR

    pipeline plug new Area {
      val csrService = pipeline.service(classOf[CsrInterface])

      // Register mstatush as hardwired to zero
      // On RV32 little-endian systems, upper bits of mstatus are not used
      // The r() method registers a signal for read at bit offset 0
      csrService.r(CSR.MSTATUSH, U(0, 32 bits))

      // If not read-only, accept writes but discard them (no-op)
      // This prevents illegal instruction exceptions on write attempts
      if (!readOnly) {
        csrService.onWrite(CSR.MSTATUSH) {
          // Write is accepted but has no effect
          // All bits remain hardwired to zero
          // Empty block - write data is simply ignored
        }
      }
    }
  }
}
