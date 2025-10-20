{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      spicetify-nix,
      catppuccin,
      nixvim,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
      lib = nixpkgs;
      secrets = builtins.fromTOML (builtins.readFile ./secrets.toml);
    in
    {
      nixosConfigurations = {
        SpiceCube = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./configuration.nix
            catppuccin.nixosModules.catppuccin
          ];
        };
      };
      homeConfigurations = {
        SpiceCube = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit spicetify-nix;
            inherit nixvim;
            inherit secrets;
          };
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
