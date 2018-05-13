# ksp-f9-flight-gnc
Flight software for automating the flight of a Falcon 9 in KSP using kOS

## Requirements
Currently this is verified to work on KSP 1.3, with the corresponding mod versions.
Obviously you will need Kerbal Space Program, but you will also need the following:
- [SpaceX Launchers pack](https://forum.kerbalspaceprogram.com/index.php?/topic/71323-142-launchers-pack-spacex-pack-v52-released-april-3rd/)
- [kOS](https://ksp-kos.github.io/KOS/)
- [Trajectories](https://forum.kerbalspaceprogram.com/index.php?/topic/162324-131-trajectories-v200-2018-02-15-atmospheric-predictions/)
- [Realism Overhaul](https://forum.kerbalspaceprogram.com/index.php?/topic/155700-131-realism-overhaul-v1210-29-apr-2018/)
- [Real Solar System](https://forum.kerbalspaceprogram.com/index.php?/topic/173396-131-real-solar-system-v131-26-apr-2018/)

## Setup
A few changes have to be made before the script will work perfectly.
First, you need to get the correct RO/RSS configuration file for the SpaceX pack. The one included might work, but I had to use this (ADD A LINK LATER) one.
Second, you need to set the tag of the center engine to be "center_engine". This allows the script to throttle it independently of the others.
