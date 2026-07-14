---

🚀 UART Controller Design and Verification using Verilog HDL

> A complete UART (Universal Asynchronous Receiver/Transmitter) Controller designed in Verilog HDL with functional verification using ModelSim Intel FPGA Starter Edition.




---

📖 Overview

> This project presents the RTL design and functional verification of a Universal Asynchronous Receiver/Transmitter (UART) Controller using Verilog HDL. The design consists of a Baud Rate Generator, UART Transmitter, UART Receiver, and a Top-Level Integration Module. Functional verification was performed using ModelSim Intel FPGA Starter Edition, demonstrating successful end-to-end serial communication through loopback testing.

> The implementation validates correct baud timing generation, finite state machine (FSM) operation, serial data transmission, serial data reception, and data integrity.


---

🎯 Project Objective

> The objective of this project is to design, implement, and verify a complete UART Controller using Verilog HDL. The project demonstrates asynchronous serial communication by integrating a Baud Rate Generator, UART Transmitter, UART Receiver, and a Top-Level module while validating the design through functional simulation.


---

✨ Features

    • Parameterized Baud Rate Generator
    • Configurable Data Width (7-bit / 8-bit)
    • Configurable Stop Bits (1 / 2)
    • Configurable Parity
      - Even Parity
      - Odd Parity
      - No Parity
    • UART Transmitter
    • UART Receiver
    • UART Top-Level Integration
    • FSM-Based Control Logic
    • Framing Error Detection
    • Modular RTL Design
    • Individual Testbenches for Each Module
    • Loopback Communication Verification
    • ModelSim Waveform Verification
    • RTL/Dataflow Verification


---

📁 Project Structure

    📂 UART-Controller-Verilog/  
     📂 rtl/ (Design Source Files)  
       📄 baud_gen.v  
       📄 uart_tx.v.   
       📄 uart_rx.v  
       📄 uart_top.v  
    📂 tb/ (Testbench Verification Files)  
       📄 baud_gen_tb.v  
       📄 uart_tx_tb.v   
       📄 uart_rx_tb.v  
       📄 uart_top_tb.v  
    📂 waveform/ (Simulation Waveform Logs)  
       🖼️ uart_top_waveform.png  
    📂 docs/ (Design Documentation and Diagrams)  
       🖼️ uart_tx_dataflow.png  
       🖼️ uart_rx_dataflow.png  
    📄 README.md

 ---

---

⚙️ Module Description

🕐 Baud Rate Generator

> Generates baud timing pulses required for UART communication.

> Provides synchronized baud ticks for both transmitter and receiver.


---

📤 UART Transmitter

Converts parallel data into serial data according to the UART protocol.

    Features:
    • Configurable 7-bit / 8-bit data
    • Configurable Even/Odd/No Parity
    • Configurable 1 or 2 Stop Bits

    FSM States

    • IDLE
    • START
    • DATA
    • PARITY
    • STOP

---

📥 UART Receiver

Receives serial data and reconstructs the original parallel data.

    Features:
    • Configurable 7-bit / 8-bit data
    • Configurable Even/Odd/No Parity
    • Configurable 1 or 2 Stop Bits
    • Parity Error Detection
    • Framing Error Detection

    FSM States

    • IDLE
    • START
    • DATA
    • PARITY
    • STOP

---

🎛️ UART Top Module

    Integrates:

    • Baud Rate Generator

    • UART Transmitter

    • UART Receiver

The transmitter output is internally connected to the receiver input to perform complete loopback verification.


---

🏗️ Design Methodology

The UART Controller follows a modular RTL design methodology.

1. Baud clock generation


2. UART frame transmission


3. UART frame reception


4. FSM-based protocol implementation


5. Top-level integration


6. Functional verification using ModelSim




---

💻 Simulation Environment

    • HDL Language

        Verilog HDL

    • Simulation Tool

        ModelSim Intel FPGA Starter Edition 10.5b

    • Code Editor

        Visual Studio Code

    • Version Control

        GitHub


---

✅ Verification Status

Module	Status

    Baud Rate Generator	      ✅ Verified
    UART Transmitter	      ✅ Verified
    UART Receiver	          ✅ Verified
    UART Top Module	          ✅ Verified
    Loopback Communication	  ✅ Passed


---

🧪 Functional Verification

The following functionality has been verified:

    • Baud Tick Generation
    • UART Transmission
    • UART Reception
    • 7-bit / 8-bit Data Transfer
    • Even Parity Verification
    • Odd Parity Verification
    • No Parity Mode
    • 1 Stop Bit Operation
    • 2 Stop Bit Operation
    • Parity Error Detection
    • Framing Error Detection
    • FSM State Transitions
    • Busy Signal Operation
    • RX Done Assertion
    • Data Integrity
    • End-to-End UART Communication
---

🧪 Test Case

    • Input Data

       10100101 (0xA5)

    • Expected Output

      10100101 (0xA5)


---

🎉 Simulation Results

    • Successful UART transmission

    • Successful UART reception

    • Correct recovery of transmitted data

    • Proper baud timing generation

    • Correct FSM transitions

    • RX Done asserted successfully

    • FSM returned to IDLE state

    • No functional errors observed


---

📊 Results

> The UART Controller successfully transmitted and received serial data using configurable baud rates, configurable data widths (7-bit/8-bit), configurable stop bits (1/2), and configurable parity (Even/Odd/None). Simulation results verified correct baud timing, accurate FSM transitions, reliable serial communication, parity checking, framing error detection, and successful end-to-end loopback communication using ModelSim.


---

📸 Simulation Results

UART Top Waveform

waveforms/uart_top_waveform.png

UART Transmitter Dataflow

docs/uart_tx_dataflow.png

UART Receiver Dataflow

docs/uart_rx_dataflow.png


---

🛠️ Skills Demonstrated

    • Verilog HDL
    • RTL Design
    • Parameterized RTL Design
    • Finite State Machine (FSM)
    • UART Communication Protocol
    • Functional Verification
    • Testbench Development
    • Waveform Analysis
    • Error Detection Techniques
    • Modular Hardware Design
    • GitHub

---

🚀 Future Enhancements

    • FIFO Buffer Integration
    • Interrupt Support
    • Hardware Validation on FPGA
    • UART Register Interface
    • APB/AHB Bus Interface

---

📚 Learning Outcomes

Through this project, the following concepts were implemented and verified:

    • RTL Design using Verilog HDL

    • Finite State Machine (FSM) Design

    • UART Communication Protocol

    • Modular Hardware Design

    • Functional Simulation

    • Testbench Development

    • Digital System Integration

    • Waveform Analysis

    • RTL/Dataflow Verification


---

👨‍💻 Author

Harshavardhan Akula

GitHub: https://github.com/Harshavardhan739


---

📄 License

This project is intended for educational, academic, and learning purposes.


---
