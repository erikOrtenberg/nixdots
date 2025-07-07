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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
	  # or
  #
  #  /etc/profiles/per-user/kryddan/etc/profile.d/hm-session-vars.sh
  #
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
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      # { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      # Manually packaging and enable a plugin
      # {
      #   name = "z";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "jethrokuan";
      #     repo = "z";
      #     rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
      #     sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      #   };
      # }
    ];
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
	  background = "${homeDir}/Pictures/backgrounds/bgRight.png stretch #000000";
	  scale_filter = "nearest";
	  pos = "1920 0";
	};
        "GIGA-BYTE TECHNOLOGY CO., LTD. GIGABYTE M27F 20310B004487"  = { 
	  mode = "1920x1080@143.999Hz";
	  background = "${homeDir}/Pictures/backgrounds/bgLeft.png stretch #000000";
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
        titlebar = false;
        commands = [
          {
            command = "opacity 0.87, border pixel 3, inhibit_idle fullscreen";
            criteria = {
              class = ".*";
            };
          }
         ## {
         ##   command = "opacity 0.9, border pixel 3, inhibit_idle fullscreen";
         ##   criteria = {
         ##     app_id = ".*";
         ##   };
         ## }
         ## {
         ##   command = "floating enable, resize set 800 500";
         ##   criteria = {
         ##     app_id = "org.keepassxc.KeePassXC";
         ##   };
         ## }
         ## {
         ##   command = "resize set 650 450";
         ##   criteria = {
         ##     app_id = "snippetexpandergui";
         ##   };
         ## }
         ## {
         ##   command = "floating enable, sticky enable";
         ##   criteria = {
         ##     title = "Picture-in-Picture";
         ##   };
         ## }
         ## {
         ##   command = "floating enable, sticky enable";
         ##   criteria = {
         ##     title = ".*Sharing Indicator.*";
         ##   };
         ## }
         ## {
         ##   command = "floating enable, sticky enable, resize set 650 450";
         ##   criteria = {
         ##     title = ".*Syncthing Tray.*";
         ##   };
         ## }
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
