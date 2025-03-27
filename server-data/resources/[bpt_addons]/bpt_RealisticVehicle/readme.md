# Vehicle Realism System

## Overview

The Vehicle Realism System is a comprehensive modification for FiveM servers that enhances vehicle dynamics and behaviors to closely mimic real-world physics. This system aims to provide players with a more immersive and authentic driving experience within the game.

## Features

- **Engine and Body Damage Simulation**: Implements realistic damage multipliers and thresholds for engine, body, and petrol tank components, affecting vehicle performance based on the severity of damage.
- **Torque Multiplier**: Dynamically adjusts engine torque in response to engine health, simulating power loss due to damage.
- **Limp Mode**: Introduces a 'limp mode' where severely damaged vehicles operate at reduced performance, allowing players to reach a mechanic without complete vehicle failure.
- **Prevent Vehicle Flip**: Disables the ability to flip overturned vehicles, adding to the realism of vehicle accidents.
- **Sunday Driver Mode**: Modifies accelerator and brake responsiveness to facilitate smoother, more controlled driving, especially beneficial for players using analog input devices.
- **Random Tire Burst**: Implements a statistical chance of tire punctures when driving at high speeds for extended periods, enhancing unpredictability and challenge.
- **Repair Costs**: Configurable system to charge players for vehicle repairs, adding an economic aspect to vehicle maintenance.

## Configuration

The system offers extensive configuration options through the `config.lua` file, allowing server administrators to tailor the realism aspects to their preferences. Key configurable parameters include:

- Damage multipliers and exponents for various vehicle components.
- Thresholds for degrading and cascading failures.
- Torque multipliers and limp mode settings.
- Options to enable or disable specific features like vehicle flip prevention and Sunday driver mode.
- Economic settings for repair costs.

## Installation

1. **Download**: Obtain the latest version of the Vehicle Realism System from the official repository.
2. **Extract**: Unzip the downloaded files into your FiveM server's `resources` directory.
3. **Configure**: Edit the `config.lua` file to adjust settings according to your server's requirements.
4. **Start Resource**: Add `start bpt_RealisticVehicle` to your server's `server.cfg` to ensure the resource starts with the server.

## Usage

Once installed and configured, the Vehicle Realism System will automatically apply the defined realism settings to all applicable vehicles within the server. Players will experience enhanced vehicle dynamics, requiring more attentive and skillful driving.

## Contributing

Contributions to the Vehicle Realism System are welcome. To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes with descriptive messages.
4. Push your branch and submit a pull request for review.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Acknowledgments

Special thanks to the FiveM community and all contributors who have provided valuable feedback and support in the
