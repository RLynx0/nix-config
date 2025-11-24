```tree
nix-config
│
│ # Custom library functions
├─╴lib
│
│ # These directories are reserved for additional flake outputs
├─╴modules
├─╴overlays
├─╴packages
│
├─╴home
│  │
│  │ # Extracted User and Home-manager modules under users/common
│  ├─╴common
│  │
│  │ # Raw config files for home-manager
│  ├─╴files
│  │
│  │ # User / Home-manager configurations live here
│  │ # Users define profiles, that are built from the modules in common
│  │ # Hosts can import these profiles and/or choose from options
│  ╰─╴users
│     │
│     ╰─╴lynx
│        ├─╴default.nix # Minimal selection
│        ╰─╴full.nix # All options enabled
│
├─╴system
│  │
│  │ # Extracted system modules live under system/common
│  │ # Individual hosts can import modules from here
│  ├─╴common
│  │  │
│  │  │ # Disko configurations
│  │  ╰─╴disks
│  │     ╰─╴default.nix
│  │
│  ╰─╴hosts
│     ├─╴lynx-nixos-vm
│     │  ├─╴default.nix
│     │  ├─╴hardware-configuration.nix
│     │  ╰─╴users.nix # Declare users and profiles
│     │
│     ╰─╴lynx-laptop
│        ├─╴default.nix
│        ├─╴hardware-configuration.nix
│        ╰─╴users.nix # Declare users and profiles
│
│ # Flake pulls in dependencies
│ # - stable channel
│ # - unstable channel
│ # - home-manager
│ # - disko
│ # And exposes outputs
│ # - nixosConfigurations per host
│ # - packages
│ # - overlays
│ # - modules
├─╴flake.nix
╰─╴flake.lock
```
