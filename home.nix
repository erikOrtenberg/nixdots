{ config, pkgs, spicetify-nix, ... }:
let
  username = "kryddan";
  homeDir = "/home/${username}";
in {
  #nix.settings.experimental-features = ["nix-command" "flakes"];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    signal-desktop
    gimp
    pulsemixer
    audacity
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  imports = [ spicetify-nix.homeManagerModules.default ];
  programs.spicetify = let
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
  in
  {
    enable = true;
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
  programs.git = {
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

  programs.fish = {
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

  
  wayland.windowManager.sway = {
    enable = true;
    extraOptions = ["--unsupported-gpu"];
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
	  pos = "1920 0";
	};
        "GIGA-BYTE TECHNOLOGY CO., LTD. GIGABYTE M27F 20310B004487"  = { 
	  mode = "1920x1080@143.999Hz";
	  background = "${homeDir}/nixdots/bgLeft.png stretch #000000";
	  pos = "0 180";
	};
      };
      gaps = {
        inner = 30;
      };
      workspaceOutputAssign = let
        main   = "GIGA-BYTE TECHNOLOGY CO., LTD. G27Q 20452B002455";
	second = "GIGA-BYTE TECHNOLOGY CO., LTD. GIGABYTE M27F 20310B004487";
      in [
        { output = main; workspace = "1"; }
        { output = second; workspace = "2"; }
        { output = second; workspace = "3"; }
        { output = main; workspace = "4"; }
        { output = main; workspace = "5"; }
        { output = main; workspace = "6"; }
        { output = second; workspace = "7"; }
        { output = second; workspace = "8"; }
        { output = second; workspace = "9"; }
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
      startup = [
        # Launch Firefox on start
      ];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
