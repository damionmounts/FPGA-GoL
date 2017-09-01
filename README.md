# FPGA Game of Life
---
#### Game of Life Rules:
* Any live cell with fewer than two live neighbours dies, as if caused by under-population.
* Any live cell with two or three live neighbours lives on to the next generation.
* Any live cell with more than three live neighbours dies, as if by over-population.
* Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

#### Programming/Descriptor Languages Utilized:
* Java
* VHDL

#### Software Utilized:
* Vivado 2016.1
* Netbeans 8.1
* Notepad++ v6.9.1

#### Hardware Utilized
* Zybo Zynq-7010 SoC Board
* 1024x768 VGA Monitor

#### Project Design
The components of the project included:
* (2) 96KB Block RAMs: BRAM0 and BRAM1
* A Read/Write Router
* A VGA Timing Generator
* A Finite State Machine with Color LUT and GoL LUT

The project functions as such... BRAM0 is preloaded with a coeficients file with the pattern b'000000000000000000000000000111111110111110001110000001111111011111'. 1 being alive and 0 being dead. This GoL structure was chosen as it was easy to type within one line and it creates visual interest. Along with this structure, another preload had been a glider gun that was used when implementing cycling colors. BRAM0 starts at the read port and BRAM1 at the write port, as dictated by the finite state machine controlling the router. The VGA timing generator iterates through the contents of BRAM0 and displays them onto the screen with the color set by the finite state machine from the color look-up table. At the same time, the finite state machine is iterating through all cells within BRAM0, using the GoL look-up table to calculate the next state of each cell, and is writing it to BRAM1. Cells on the edge of the screen have the opposite edge of the screen treated as their neighbors, as if the GoL simulation were happening on a torus. After all new states have been written to BRAM1 and the timing generator indicates that the frame is done being displayed and a blanking time has been reached, the finite state machine increments a counter leading into the color look-up table, thus setting a new color for the next frame, and it inverts the select bit to the router. The router now reads from BRAM1 for calculation and display, while writing new states to BRAM0 - causing the whole process to repeat. This repository was created after the project and an older version of the VHDL file is present, so the color changing look-up table is not present. The live-cell coloring iterated through a 3-bit (1-bit/channel) RGB colorspace while avoiding black as all dead cells were colored as such. Last thing to mention, the GoL look-up table was created by a Java program. Each cell's new state is dependant on its current and the state of its 8 neighbors meaning there are 2^9 = 512 entries to be placed into the look-up table. I knew that according to GoL's rules, there were more states where the outcome is a dead cell as opposed to a living cell. So, I had the Java program define all conditions where a live cell should occur, and then output the VHDL convention of (when others => life_new := '0';). This statement meaning that when the pattern of bits within 'others' doesn't fit any definition of a living outcome, 'life_new' will be set to '0', or dead.

#### Project Purpose and Recap
The purpose of this project was to shadow some of the functions and workflow that I may go through in my career down the road. This project gave me a great deal of experience working with VHDL and allowed me to understand many design differences between using a programming language and a hardware descriptor language. The most valuable piece of information I gathered while creating this project was how to utilize the Vivado ILA (Integrated Logic Analyzer) and how to properly do timings for block RAM read and write. The biggest problem that I faced during this project was that while the initial coefficient values were being properly read from the BRAM on the read port, and the proper according either life or death state was calculated from them, the process of wiriting the new state wasn't occuring properly. Through headache, coffee, and documentation - it was realized that my GoL finite state machine hadn't set the write enable early enough.

#### Project Results
A picture of the development board as well as 2 pictures and 2 videos of the game of life simulation occuring can be found under 'General_Project_Documentation'.