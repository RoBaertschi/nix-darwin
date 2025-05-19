{
  description = "Example nix-darwin system flake";

  inputs = {
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    shelly.url = "github:RoBaertschi/shelly-scripts";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    shelly,
    lix-module,
  }: let
    configuration = {
      pkgs,
      darwin,
      home-manager,
      ...
    }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        alejandra
        neovim
        oh-my-zsh
        zsh-completions
        rustup
        go
        qemu
        nh
        fh
      ];
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;

      homebrew = {
        enable = true;
        taps = [];
        brews = [];
        casks = ["iterm2" "proton-pass" "mac-mouse-fix" "zen-browser" "obsidian"];
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      security.pam.services.sudo_local.touchIdAuth = true;
      security.pam.services.sudo_local.reattach = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.robin = ./home.nix;
      home-manager.extraSpecialArgs = {inherit inputs;};
      home-manager.backupFileExtension = "before-home-manager";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#UM00016
    darwinConfigurations."UM00016" = nix-darwin.lib.darwinSystem {
      modules = [
        lix-module.nixosModules.default
        configuration
        home-manager.darwinModules.home-manager
        {
          system.primaryUser = "taabaroy";
          users.users = {
            robin = {
              name = "taabaroy";
              home = /Users/taabaroy;
            };
          };
        }
      ];
    };
    darwinConfigurations."macbook-air" = nix-darwin.lib.darwinSystem {
      modules = [
        lix-module.nixosModules.default
        configuration
        home-manager.darwinModules.home-manager
        {
          system.primaryUser = "robin";
          users.users = {
            robin = {
              name = "robin";
              home = /Users/robin;
            };
          };
        }
      ];
    };
  };
}
