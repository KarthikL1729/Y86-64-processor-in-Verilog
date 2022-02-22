---
title: IPA Project Report

subtitle: Mid-eval progress

authors:

- Ananya Sane (2020102007)
- L Lakshmanan (2020112024)
---

## Overview

Up to this point, we have written code for all 5 stages of a sequential processor SEQ. Each stage is implemented in its own module, with one final module `processor.v` to instantiate each block and another module for a centralised register array with read and write operations called `regarr.v`, connect the outputs of one stage to the input of the next, and create the final processor. In our implementation, all 5 stages happen in one clock cycle as is required for the sequential implementation, with the PC being updated to the newPC value at every positive edge of the clock. 

The processor has 2kB of instruction memory, 14 registers and 2kB of data memory.

## Implemented Instructions

- `halt`    
- `nop`
- `cmovXX`
- `irmovq`
- `rmmovq`
- `mrmovq`
- `OPq`
- `jXX`
- `call`
- `ret`
- `pushq`
- `popq`

## Stage 1: Fetch

The fetch stage works on the instruction memory `insmem`, reading 10 bytes at a time. `icode` and `ifun` are split and aligned from the first byte, and valP is decided based on the value of icode. From the second byte of the  fetched instruction, the register operand specifiers are also obtained and stored. In the case where the instruction is 10 bytes long, the eight byte constant is stored in valC.

Thus, the inputs and outputs to this stage are as follows:

### Inputs:

- `clk`
- `PC`

### Outputs:

- `icode`
- `ifun`
- `rA`
- `rB`
- `valC`
- `valP`
- Status conditions:
    - `inst_valid` : set when inst is valid
    - `imem_er` : set when address is invalid
    - `hlt_er` : set when halt is required

### Other Paramaters

- `insmem` : register array that functions as the instruction memory


## Stage 2: Decode

In this stage, the instruction is decoded from the `icode` value and the required values (usually `valA` and `valB`) are obtained from the registers `rA` and `rB` which are read from the central register bank according to operand specifiers that were obtained from the fetch stage.

### Inputs

- `icode`
- `rA`
- `rB`

## Outputs

- `valA`
- `valB`

---

## Stage 3: Execute

The ALU is instantiated in this stage, and the results of computations on valA and valB are stored in valE (where applicable). In most cases, this is an add instruction from the ALU. Also, the three flags used by this architecture: zf, of and sf are computed in this stage.

### Inputs

- `icode`
- `ifun`
- `valA`
- `valB`
- `valC`

### Outputs

- `valE`
- Condition Codes:
    - `cnd`
    - `of`
    - `zf`
    - `sf`
    

---

## Stage 4: Memory

The portion of instructions that require the altering of or reading from data memory is done in this stage. It is here that we interact with the actual memory of the device.

### Inputs

- `icode`
- `valA`
- `valB`
- `valE`
- `valP`

### Outputs

- `valM`

### Other Parameters

- `datamem` register array

---

## Stage 5: Write Back

Writes either valE or valM to the required registers in the instructions that call for it. Therefore, this stage handles register updates.

### Inputs

- cnd (condition code for cmovXX)
- icode
- rA
- rB
- valA
- valB
- valM
- valE

### Outputs

- regmem(0-14)

### Other Parameters

- regArr

---

## Stage 6: PC Update

Sets newPC value to valP in non conditional instructions, and to valP, valC or valM in instructions that invoke control transfer depending on whether the condition is met.

### Inputs

- cnd
- icode
- valP
- valM
- valC
- PC

### Outputs

- newPC

---