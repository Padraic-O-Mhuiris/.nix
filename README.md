# .nix -  🐧

# Architecture

This system describes constructs NixOS machines using three categories of NixOS "modules".  

### Modules

These are NixOS "modules" but with the constraint that they are atomic and independent meaning they do not import other modules and expose an options interface for the consumer to describe. 

### Profiles

These are more in context of the user which is being operated on, a profile for a webserver or a my own desktop/laptop configuration may drastically change

### Hosts

Defines hardware and other machine specific configuration

Hierarchy :: Hosts >> Profiles >> Modules
