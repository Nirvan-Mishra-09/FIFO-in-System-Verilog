# FIFO-in-System-Verilog
This repository contains a Verilog implementation of a FIFO (First-In-First-Out) buffer. The FIFO module supports parameterizable data width and depth, and provides signals for full and empty flags.

## Overview

The FIFO module is designed to store and retrieve data in a first-in, first-out manner. It includes parameters for data width and depth, and handles the logic for pushing and popping data, as well as managing full and empty states.

## Features

- Parameterizable data width and depth
- Push and pop operations
- Full and empty flag signals
- Synchronous reset

## Module Parameters

- `DW` (default: 8): Data width
- `DP` (default: 4): Depth of the FIFO (number of entries)

## Ports

### Inputs

- `clk`: Clock signal
- `rst`: Synchronous reset signal
- `push`: Push enable signal
- `push_data`: Data to be pushed into the FIFO
- `pop`: Pop enable signal

### Outputs

- `pop_data_o`: Data popped from the FIFO
- `full_flag`: Indicates if the FIFO is full
- `empty_flag`: Indicates if the FIFO is empty
