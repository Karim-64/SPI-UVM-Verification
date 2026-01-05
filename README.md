# SPI Slave with Single Port RAM - UVM Verification

![Status](https://img.shields.io/badge/Status-Completed-success)
![Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen)
![Language](https://img.shields.io/badge/Language-SystemVerilog-blue)
![Framework](https://img.shields.io/badge/Framework-UVM-red)

## 📜 Project Overview
This project involves the **RTL design and verification** of a Serial Peripheral Interface (SPI) Slave module interfaced with a Single Port RAM. The verification environment is built using the **Universal Verification Methodology (UVM)** to ensure functional correctness and robust coverage.

The project is divided into three main phases:
1.  **SPI Slave Design & Verification**
2.  **Single Port RAM Design & Verification**
3.  **Top-Level Wrapper Verification** (Integrating Slave + RAM)

## 👥 Team Members
* **Rawan Mohamed Waziry**
* **Marina Bebawy Nasr**
* **Karim Maaty**

## 🛠️ Tools & Technologies
* **RTL Design:** Verilog HDL
* **Verification:** SystemVerilog, UVM, SVA (SystemVerilog Assertions)
* **Simulation:** Siemens EDA QuestaSim
* **Synthesis/Linting:** Xilinx Vivado, Questa Lint

## 🏗️ Architecture

### 1. SPI Slave Interface
The SPI Slave handles serial communication with a Master. It operates using a Finite State Machine (FSM) with the following states: `IDLE`, `CHK_CMD`, `WRITE`, `READ_ADD`, and `READ_DATA`.
* **Inputs:** `MOSI`, `SS_n`, `clk`, `rst_n`, `tx_valid`, `tx_data`
* **Outputs:** `MISO`, `rx_data`, `rx_valid`

### 2. Single Port RAM
A synchronous memory module with a depth of **256** and data width of **8 bits**. It supports write and read operations based on the address and data received from the SPI Slave.

### 3. SPI Wrapper (Top Level)
The wrapper instantiates both the SPI Slave and the RAM, connecting the Slave's parallel output ports (`rx_data`) to the RAM's input (`din`), and the RAM's output (`dout`) back to the Slave for transmission via MISO.

## 🧪 UVM Testbench Architecture
The testbench follows a modular UVM architecture featuring **one active agent** (Wrapper) and **two passive agents** (SPI and RAM) for monitoring internal signals.

### Components
* **Top Module:** Instantiates the DUT (Device Under Test), Interfaces, and Golden Models.
* **Scoreboard:** Compares DUT outputs against a **Golden Reference Model** to ensure data integrity.
* **Coverage Collector:** Tracks Code Coverage (Statement, Branch, Toggle, FSM) and Functional Coverage using Covergroups.
* **Sequences:**
    * `reset_seq`: Verifies reset behavior.
    * `write_only_seq`: Randomizes write operations.
    * `read_only_seq`: Randomizes read operations.
    * `read_write_seq`: Interleaved read/write operations with constrained randomization.

### Verification Plan
The verification plan targeted specific scenarios including:
* Valid transitions of `MOSI` (000, 001, 110, 111).
* Correct state transitions (e.g., `READ_ADD` must follow `READ_DATA` in specific constraints).
* Corner cases such as reset assertion during active transactions.
* **SVA (Assertions):** Concurrent assertions were used to verify protocol timing (e.g., `rx_valid` asserting exactly after 10 cycles).

## 📊 Results & Coverage

### Coverage Metrics
We achieved **100% coverage** across all metrics for the final integrated wrapper:
| Metric | Status |
| :--- | :---: |
| **Functional Coverage** | 100% |
| **Code Coverage (Statement)** | 100% |
| **Code Coverage (Branch)** | 100% |
| **Code Coverage (Toggle)** | 100% |
| **FSM Coverage** | 100% |

### Bug Fixes
Several bugs were identified and resolved during the verification process, including:
1.  **Counter Logic:** Fixed an issue where the counter did not return to 0 immediately upon reset assertion.
2.  **State Transitions:** Corrected logic where `READ_ADD` was mistakenly replaced by `READ_DATA` due to incorrect flag handling.
3.  **rx_valid Timing:** Fixed a bug where `rx_valid` was raised for two clock cycles instead of one.

## 🚀 How to Run
The project uses `do` files for automation in QuestaSim.

1.  **Compile the design and testbench:**
    ```bash
    vlib work
    vlog -f src_files.list +define+SIM +cover -covercells
    ```

2.  **Run Simulation:**
    ```bash
    vsim -voptargs=+acc work.SPI_wrapper_top -classdebug -uvmcontrol=all -cover
    ```

3.  **Generate Waveforms & Coverage:**
    ```tcl
    do wave.do
    run -all
    coverage save SPI_wrapper.ucdb
    ```

---
