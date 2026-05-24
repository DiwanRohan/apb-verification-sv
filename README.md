# AMBA APB Verification Environment

SystemVerilog-based verification environment for the AMBA APB protocol featuring assertions, functional coverage, scoreboard checking, and randomized testcases.

## Features
- APB read/write verification
- Assertions (SVA)
- Functional coverage
- Scoreboard checking
- Randomized testing
- Wait-state verification

## Project Structure
- RTL  : DUT files
- ENV  : Verification environment
- TEST : Testcases
- SIM  : Simulation scripts
- DOCS : Testbench architecture and diagrams

## Documentation
Detailed testbench architecture and block diagrams are available in the DOCS folder.

## Run Simulation

```bash
vsim -do run.do
```
