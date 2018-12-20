# ksp-f9-flight-gnc
Flight software for automating the flight of a Falcon 9 in KSP using kOS. The basic information for the f9-full-system folder is listed in this readme, but for more complete information and walkthroughs on each individual flight, visit http://tchayden.com/ksp-f9-flight-gnc/.

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
- You need to get the correct RO/RSS configuration file for the SpaceX pack. The one included might work, but I had to edit mine. The configs are found in the configs/ of the repository, and honestly I'm not quite sure how they work so I added all three I had. As far as I know RR_KKLaunchersSpaceX.cfg is the interesting one (and the one I edited), but you might need them all.
- You need to set the tag of the center engine to be "center_engine". This allows the script to throttle it independently of the others.
- You need to set two opposite side engines to be "side_engine". This allows the script to throttle them independently of the others.
- Name the CPUs f9s1 and f9s2 respectively.
