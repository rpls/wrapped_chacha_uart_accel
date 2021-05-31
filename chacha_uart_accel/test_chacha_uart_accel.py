import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, ReadWrite
from cocotbext.uart import UartSource, UartSink

import random
import struct

W = 32
M = 2 ** 32 - 1

def rot(a, r):
    return ((a << r) & M) | ((a >> (W - r)) & M)


def qr(a, b, c, d):
    a = (a + b) & M
    d ^= a
    d = rot(d, 16)
    c = (c + d) & M
    b ^= c
    b = rot(b, 12)
    a = (a + b) & M
    d ^= a
    d = rot(d, 8)
    c = (c + d) & M
    b ^= c
    b = rot(b, 7)
    return (a, b, c, d)


def chacha20(s):
    s = s.copy()
    for r in range(10):
        for i in range(4):
            s[i::4] = qr(*s[i::4])
        s[0], s[5], s[10], s[15] = qr(s[0], s[5], s[10], s[15])
        s[1], s[6], s[11], s[12] = qr(s[1], s[6], s[11], s[12])
        s[2], s[7], s[8], s[13] = qr(s[2], s[7], s[8], s[13])
        s[3], s[4], s[9], s[14] = qr(s[3], s[4], s[9], s[14])
    return s


async def reset(dut):
    dut.uart_rxd <= 1
    dut.reset <= 1
    await ClockCycles(dut.clk, 5)
    dut.reset <= 0
    await ClockCycles(dut.clk, 20)


async def test_permutation(dut, baud=115200):
    chacha_in = [random.getrandbits(32) for i in range(16)]
    chacha_out_ref = chacha20(chacha_in)
    chacha_in_bytes = struct.pack("<" + "I"*16, *chacha_in)
    print(f"Output len: {len(chacha_in_bytes)}")
    uart_source = UartSource(dut.uart_rxd, baud=baud, bits=8)
    uart_sink = UartSink(dut.uart_txd, baud=baud, bits=8)
    recv = bytearray()
    uart_source.write_nowait(chacha_in_bytes)
    while len(recv) < 64:
        recv.extend(await uart_sink.read())
    recv = bytearray()
    uart_source.write_nowait(chacha_in_bytes)
    while len(recv) < 64:
        recv.extend(await uart_sink.read())
    chacha_out = struct.unpack("<" + "I"*16, recv)
    assert all(out == ref for out, ref in zip(chacha_out, chacha_out_ref))


@cocotb.test()
async def test_uart_accel(dut):
    if hasattr(dut, "VPWR"):
        dut.VPWR <= 1
        dut.VGND <= 0
    if hasattr(dut, "div_valid"):
        dut.div_valid <= 0
        dut.div_payload <= 0
    clock = Clock(dut.clk, 50, units="ns")
    clkEdge = RisingEdge(dut.clk)
    cocotb.fork(clock.start())
    await reset(dut)
    # TXD line should be high after reset
    await clkEdge
    while dut.uart_txd != 1:
        await clkEdge
    # Test with the default bitrate
    await test_permutation(dut)
    # Test switching the baudrate
    newbaud = 38600
    if hasattr(dut, "div_valid"):
        await clkEdge
        dut.div_valid <= 1
        div = int(20e6 / newbaud / 8)
        print(f"Setting new divider to {div}")
        dut.div_payload <= div
        await clkEdge
        dut.div_valid <= 0
        await clkEdge
        await test_permutation(dut, newbaud)

