# Digital Alarm Clock with Buzzer

## Project Overview
This project implements a digital alarm clock on the BASYS3 FPGA board. The clock displays hours and minutes using a 7-segment display, supports setting the current time and an alarm time, and generates an alarming sound using a buzzer when the alarm time is reached. The clock operates in two modes: `Clock/Alarm` mode and `Adjust` mode.

## Features
- **Time Display**: Displays the current time in hours and minutes on a 4-digit 7-segment display.
- **Alarm Functionality**: Sets an alarm time that triggers an audible alarm using a buzzer.
- **Adjust Mode**: Allows setting the current time and the alarm time.
- **Blinking Indicators**: Uses LEDs to indicate modes and the selected parameter for adjustment.
- **Decimal Point Blinking**: The second decimal point blinks at a frequency of 1 Hz in `Clock/Alarm` mode.

## Hardware Requirements
- BASYS3 FPGA board
- Buzzer connected to a GPIO pin
- 7-segment display integrated on the BASYS3 board
- Push buttons integrated on the BASYS3 board

## Usage Instructions

### Default `Clock/Alarm` Mode
- **LD0**: OFF
- **Decimal Point**: Blinks at 1 Hz

### Entering `Adjust` Mode
1. Press **BTNC** to enter the `Adjust` mode.
2. **LD0**: ON
3. **Decimal Point**: OFF

### Adjusting Time and Alarm
1. **BTNR**: Selects the parameter to adjust in the sequence: `Time Hours`, `Time Minutes`, `Alarm Hours`, `Alarm Minutes`.
2. **BTNL**: Selects the parameter to adjust in reverse order.
3. **BTNU**: Increments the selected parameter.
4. **BTND**: Decrements the selected parameter.
5. **LED Indicators**:
   - **LD12**: `Time Hours`
   - **LD13**: `Time Minutes`
   - **LD14**: `Alarm Hours`
   - **LD15**: `Alarm Minutes`

### Exiting `Adjust` Mode
- Press **BTNC** to exit the `Adjust` mode and return to `Clock/Alarm` mode.

### Alarm Activation
- When the current time matches the set alarm time, **LD0** blinks, and the buzzer generates an alarm sound.
- Pressing any button stops the alarm.

## File Descriptions
- **Digital_Clock.v**: Top-level module implementing the digital clock and alarm functionality.
- **Clock_Divider.v**: Module for dividing the clock frequency to generate 1 Hz and 1 kHz clock signals.
- **Hours_Mins_Secs.v**: Module for managing time and alarm settings.
- **MUX_4X1.v**: Multiplexer for selecting the digit to display.
- **Mod_N_Counter.v**: Modular counter supporting up and down counting.
- **Pushbutton_detector.v**: Module for debouncing button inputs.
- **Rising_edge_detector.v**: Module for detecting rising edges of signals.
- **Seven_Seg.v**: Module for controlling the 7-segment display.
- **debouncer.v**: Module for debouncing signals.
- **dflipflop.v**: D flip-flop module.
- **modSix.v**: Module for counting modulo 6.
- **modTen.v**: Module for counting modulo 10.
- **modThree.v**: Module for counting modulo 3.
- **sync.v**: Synchronizer module for handling asynchronous signals.

## Simulation and Testing
- A testbench (`TEST.v`) is provided to simulate the functionality of the digital clock.
- Ensure that all modules are properly instantiated and connected in the top-level module.
- Verify the behavior of the clock in both `Clock/Alarm` mode and `Adjust` mode.
- Test the alarm functionality to ensure the buzzer and LEDs operate correctly when the alarm time is reached.

