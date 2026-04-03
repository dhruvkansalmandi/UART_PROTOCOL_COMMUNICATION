Universal Asynchronous Receiver and Transmitter (UART) with Parity

Author Information

Name: Dhruv Kansal

Institution: Indian Institute of Technology (IIT), Mandi

Specialization: B.Tech in Microelectronics and VLSI

Project Overview

This project implements a complete UART (Universal Asynchronous Receiver and Transmitter) protocol in Verilog HDL. UART is a widely used serial communication protocol that allows for asynchronous data exchange between devices. This specific implementation includes a Transmitter (TX), a Receiver (RX), and a Baud Rate Generator (BRG), with integrated parity checking for error detection.

Technical Specifications

Protocol: Asynchronous Serial Communication

Data Width: 8-bit

Frame Format: 1 Start Bit, 8 Data Bits, 1 Parity Bit (Even), 1 Stop Bit

Baud Rate: Configurable via the Baud Rate Generator (BRG)

Error Detection: Parity checking and Stop bit validation

HDL: Verilog

Tools: Xilinx Vivado 2024.1

System Architecture

1. Transmitter (TX_UART)

The transmitter converts parallel 8-bit data into a serial stream. It consists of:

TX_FSM: A Finite State Machine that controls the transition between IDLE, START, DATA, PARITY, and STOP states.

TX_PISO: A Parallel-In Serial-Out shift register.

TX_PARITY: Generates an even parity bit for the data frame.

TX_MUX: Selects the appropriate bit (Start, Data, Parity, or Stop) to send to the TX_data_out line.

2. Receiver (RECEIVER)

The receiver reconstructs the parallel data from the incoming serial bitstream. It consists of:

RX_FSM: Synchronizes with the incoming start bit and manages the sampling of data, parity, and stop bits.

SIPO: A Serial-In Parallel-Out shift register that collects the incoming bits.

Parity Checker: Compares the received parity bit with the calculated parity of the data to detect single-bit errors.

Stop Bit Checker: Validates that the frame ends with a logic '1' to ensure synchronization.

Detect Start: A simple module to identify the high-to-low transition of the start bit.

3. Baud Rate Generator (BRG)

The BRG generates the necessary clock signals for both the transmitter and the receiver. The receiver clock typically runs at 16x the baud rate to allow for oversampling and finding the middle of the bit period for accurate data capture.

State Machine Logic

Transmitter States:

IDLE: Transmitter is waiting for the TX_start signal.

START: Sends the low-logic start bit.

DATA: Shifts out 8 bits of data sequentially.

PARITY: Sends the calculated parity bit.

STOP: Sends the high-logic stop bit and returns to IDLE.

Receiver States:

IDLE: Waiting for a high-to-low transition on the rx_in line.

DATA: Samples the incoming data bits at the center of each bit period.

PARITY: Samples and validates the parity bit.

STOP: Validates the stop bit and asserts rx_done.

Simulation Results

The design was verified using a comprehensive testbench (TEST_UART_RX.v).

Verification Highlights:

Successful Transmission: Parallel data 8'hAB (10101011) was successfully serialized and reconstructed.

Accurate Timing: The Baud Rate Generator correctly synchronized the TX and RX modules.

Zero Errors: No parity or stop bit errors were detected during standard operation.

Waveform Verification: Behavioral simulation waveforms confirm the shifting pattern in the SIPO register as data is reconstructed.

How to Use

Source Files: All .v files should be added to a Vivado project.

Top Module: Set UART.v as the top-level module for synthesis.

Simulation: Run the behavioral simulation using TEST_UART_RX.v.

Implementation: To put this on an FPGA, create a .xdc constraint file mapping clk, rst, TX_data_out, and rx_data_in to the physical pins of your board.

Developed as part of the Microelectronics and VLSI curriculum at IIT Mandi.