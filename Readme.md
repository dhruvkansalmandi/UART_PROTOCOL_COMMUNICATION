# UART with Parity Implementation (Verilog)

An asynchronous serial communication protocol implementation featuring integrated parity checking for error detection, designed for high-reliability data exchange.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Tool: Vivado 2024.1](https://img.shields.io/badge/Tool-Xilinx_Vivado_2024.1-orange)](https://www.xilinx.com/products/design-tools/vivado.html)
[![Hardware: Verilog HDL](https://img.shields.io/badge/Language-Verilog_HDL-green)](#)

---

## 👤 Author Information
* **Name:** Dhruv Kansal
* **Institution:** Indian Institute of Technology (IIT), Mandi
* **Specialization:** B.Tech in Microelectronics and VLSI

---

## 📖 Project Overview
This project implements a complete **Universal Asynchronous Receiver and Transmitter (UART)** protocol in Verilog HDL. UART is a foundational serial communication protocol used for asynchronous data exchange. 

This specific implementation includes a **Transmitter (TX)**, a **Receiver (RX)**, and a **Baud Rate Generator (BRG)**, with hardware-level **Even Parity** generation and checking for robust error detection.

## ⚙️ Technical Specifications
| Feature | Specification |
| :--- | :--- |
| **Protocol** | Asynchronous Serial |
| **Data Width** | 8-bit |
| **Frame Format** | 1 Start, 8 Data, 1 Even Parity, 1 Stop |
| **Baud Rate** | Configurable via BRG (16x Oversampling) |
| **Error Detection** | Parity checking & Stop bit validation |
| **Development Tool** | Xilinx Vivado 2024.1 |

---

## 🏗 System Architecture

### 1. Transmitter (TX_UART)
The transmitter converts parallel 8-bit data into a serial stream using:
* **TX_FSM**: Controls transitions between IDLE, START, DATA, PARITY, and STOP.
* **TX_PISO**: Parallel-In Serial-Out shift register.
* **TX_PARITY**: Logic to generate Even Parity for the frame.
* **TX_MUX**: Multiplexer to select the output bit for the serial line.

### 2. Receiver (RECEIVER)
Reconstructs parallel data from the incoming bitstream using:
* **RX_FSM**: Manages sampling at the center of the bit period.
* **SIPO**: Serial-In Parallel-Out register to collect data bits.
* **Parity & Stop Checkers**: Validates data integrity and synchronization.
* **Start Detector**: Identifies the high-to-low transition to trigger reception.

### 3. Baud Rate Generator (BRG)
Generates the sample clock. The receiver clock runs at **16x the baud rate**, allowing the system to oversample the incoming signal and find the ideal sampling point (the middle of the bit period) for maximum accuracy.

---

## 🚦 State Machine Logic

### Transmitter States
1.  **IDLE**: Waiting for the `TX_start` signal.
2.  **START**: Pulls the line low for one bit duration.
3.  **DATA**: Shifts out 8 bits of data.
4.  **PARITY**: Appends the calculated even parity bit.
5.  **STOP**: Pulls the line high and returns to IDLE.

### Receiver States
1.  **IDLE**: Monitoring `rx_in` for a start bit.
2.  **DATA**: Sampling the 8-bit payload.
3.  **PARITY**: Sampling and validating parity bit.
4.  **STOP**: Validating the stop bit before asserting `rx_done`.

---

## 🧪 Simulation & Verification
The design was verified using the `TEST_UART_RX.v` testbench in Vivado.

* **Scenario Tested**: Transmission of `8'hAB` (`10101011`).
* **Result**: Successful serialization and reconstruction.
* **Timing**: BRG correctly synchronized the TX and RX modules.
* **Reliability**: Zero parity or stop bit errors detected during standard behavioral simulation.

> [!TIP]
> **Waveform Verification:** View the behavioral simulation waveforms in Vivado to confirm the shifting pattern in the SIPO register.

---

## 🚀 How to Use
1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/yourusername/UART-with-Parity.git](https://github.com/yourusername/UART-with-Parity.git)
    ```
2.  **Add to Vivado:**
    * Create a new project in Vivado 2024.1.
    * Add all `.v` source files from the `src` folder.
    * Set `UART.v` as the **Top Module**.
3.  **Run Simulation:**
    * Launch behavioral simulation using the provided testbench to verify functionality.

```verilog
// Example top-level instantiation
UART my_uart (
    .clk(sys_clk),
    .rst(reset),
    .tx_data(data_in),
    .rx_data(data_out)
    // ... other ports
);
