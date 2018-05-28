Minetest vacuum
======

Vacuum implementation and blocks for pumping and detection of vacuum and air
NOTE: Work in progress!

* Github: [https://github.com/thomasrudin-mt/vacuum](https://github.com/thomasrudin-mt/vacuum)
* Forum topic: TODO

# Operation

The space/vacuum starts at 1000 blocks in the y axis (hardcoded in init.lua)

The mod defines an airlike **vacuum:vacuum** block which suffocates the player (with drowning=1).
An [airtank](https://github.com/minetest-mods/airtanks) or similar would help to survive in space.

Air can be pumped in to any closed structure with an airpump (vacuum:airpump).
The airpump works in impulse mode, so if you have your airthight structure you can flush it with air (or mesecon signal)

## Vacuum propagation

The vacuum sucks air out of every structure if there are leaky nodes (doors, wool, wood, etc; defined in abm.lua)

A vacuum node in a pressurized area can suck out the whole structure.

## Other nodes in space

Vacuum exposure on nodes:
* Dirt converts to gravel
* All plants convert to dry shrubs
* Leaves disappear
* Water evaporates

# Compatibility

Optional dependencies:
* Mesecon interaction (execute pump on signal)
* Technic rechargeable (HV)

# Crafting

TODO

# Screenshots

Air pump:

![](screenshots/screenshot_20180524_204035.png?raw=true)

Hole in the structure (leaking air):

![](screenshots/screenshot_20180524_204042.png?raw=true)

Hole from outside:

![](screenshots/screenshot_20180524_204132.png?raw=true)

Mesecon/Technic compat:

![](screenshots/screenshot_20180524_204707.png?raw=true)


# History

TODO


