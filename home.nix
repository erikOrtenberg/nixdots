{
  config,
  pkgs,
  spicetify-nix,
  nixvim,
  ...
}:
let
  username = "kryddan";
  homeDir = "/home/${username}";
in
{

  imports = [
    ./software/neovim/neovim.nix
    nixvim.homeManagerModules.nixvim
    spicetify-nix.homeManagerModules.default
  ];

  home = {
    username = username;
    homeDirectory = homeDir;

    # No touchie
    stateVersion = "25.05";

    packages = with pkgs; [
      signal-desktop
      gimp
      pulsemixer
      audacity
      nerd-fonts.terminess-ttf
      nerd-fonts.zed-mono
      swaybg
      lshw
      feh
      unzip
      gammastep
      gcc
      rustup
      cmake
      gnumake
      libtool
      sqlite
      nixpkgs-fmt
      killall
      htop
      btop
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    spicetify =
      let
        spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;
      };
    git = {
      enable = true;
      userEmail = "erik.ortenberg@gmail.com";
      userName = "Erik Örtenberg";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
        };
      };
    };

    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      shellAliases = {
        #navigation shortcuts
        "..." = "cd ../..";
        #git aliases
        "gst" = "git status";
        "gad" = "git add .";
        "grs" = "git reset";
        "gcm" = "git commit -m";
        "gsh" = "git stash";
        "gsp" = "git stash pop";
        "gch" = "git checkout";
        "gbr" = "git branch";
        "gme" = "git merge";
        "gph" = "git push";
        "gpl" = "git pull --rebase --autostash";
      };
    };
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${homeDir}";
    documents = "${homeDir}/Documents";
    download = "${homeDir}/Downloads";
    music = "${homeDir}/Music";
    pictures = "${homeDir}/Pictures";
    videos = "${homeDir}/Videos";
  };

  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];
    config = rec {
      modifier = "Mod4";
      # Use kitty as default terminal
      terminal = "alacritty";
      input = {
        "type:keyboard" = {
          xkb_layout = "se";
        };
      };
      output = {
        "GIGA-BYTE TECHNOLOGY CO., LTD. G27Q 20452B002455" = {
          mode = "2560x1440@143.972Hz";
          background = "${homeDir}/nixdots/bgRight.png stretch #000000";
          scale_filter = "nearest";
          pos = "1080 0";
        };
        "GIGA-BYTE TECHNOLOGY CO., LTD. GIGABYTE M27F 20310B004487" = {
          mode = "1920x1080@143.999Hz";
          background = "${homeDir}/nixdots/bgLeft.png stretch #000000";
          pos = "0 -240";
          transform = "270";
        };
      };
      gaps = {
        inner = 30;
      };
      workspaceOutputAssign =
        let
          main = "GIGA-BYTE TECHNOLOGY CO., LTD. G27Q 20452B002455";
          second = "GIGA-BYTE TECHNOLOGY CO., LTD. GIGABYTE M27F 20310B004487";
        in
        [
          {
            output = main;
            workspace = "1";
          }
          {
            output = second;
            workspace = "2";
          }
          {
            output = second;
            workspace = "3";
          }
          {
            output = main;
            workspace = "4";
          }
          {
            output = main;
            workspace = "5";
          }
          {
            output = main;
            workspace = "6";
          }
          {
            output = second;
            workspace = "7";
          }
          {
            output = second;
            workspace = "8";
          }
          {
            output = second;
            workspace = "9";
          }
        ];
      window = {
        border = 3;
        titlebar = true;
        commands = [
          {
            command = "opacity 0.87, border pixel 3, inhibit_idle fullscreen";
            criteria = {
              class = ".*";
            };
          }
          {
            command = "opacity 0.87, border pixel 3, inhibit_idle fullscreen";
            criteria = {
              app_id = ".*";
            };
          }
          {
            command = "opacity 1, border pixel 3, inhibit_idle fullscreen";
            criteria = {
              app_id = "firefox";
            };
          }
          {
            command = "floating enable, resize set 800 500";
            criteria = {
              app_id = "org.keepassxc.KeePassXC";
            };
          }
          {
            command = "resize set 650 450";
            criteria = {
              app_id = "snippetexpandergui";
            };
          }
          {
            command = "floating enable, sticky enable";
            criteria = {
              title = "Picture-in-Picture";
            };
          }
          {
            command = "floating enable, sticky enable";
            criteria = {
              title = ".*Sharing Indicator.*";
            };
          }
          {
            command = "floating enable, sticky enable, resize set 650 450";
            criteria = {
              title = ".*Syncthing Tray.*";
            };
          }
        ];
      };
      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];
      startup = [
        # Launch Firefox on start
      ];
    };
  };

  services.gammastep = {
    enable = true;
    latitude = 57.69185789967825;
    longitude = 11.98613160127014;
    temperature = {
      day = 5500;
      night = 3700;
    };
    tray = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
