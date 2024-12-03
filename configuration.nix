{ config, pkgs, ... }:

let
  frLocale = "fr_FR.UTF-8";
  enLocale = "en_US.UTF-8";
  keymap = "fr";
  userName = "tom";
  userGroups = [ "networkmanager" "wheel" "lp" "scanner" ];

  gnomeExtensions = with pkgs.gnomeExtensions; [
    hide-top-bar
    tailscale-qs
    appindicator
    alphabetical-app-grid
    search-light
    battery-health-charging
  ];

  systemPackages = with pkgs; [
    teams-for-linux
    remmina
    obsidian
    blanket
    papers
    whatip
    upscayl
    vscode
    mullvad-browser
    librewolf
    ciscoPacketTracer8
    gnome-software
    pdfarranger
    resources
    dconf-editor
    vesktop
    trayscale
    youtube-music
    showtime
    parabolic
    libreoffice
  ];

  unneededGnomePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    evince
    totem
    gnome-connections
    gnome-music
  ];
in
{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 20;
    };
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "asus-nixos";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = enLocale;
    extraLocaleSettings = {
      LC_ADDRESS = frLocale;
      LC_IDENTIFICATION = frLocale;
      LC_MEASUREMENT = frLocale;
      LC_MONETARY = frLocale;
      LC_NAME = frLocale;
      LC_NUMERIC = frLocale;
      LC_PAPER = frLocale;
      LC_TELEPHONE = frLocale;
      LC_TIME = frLocale;
    };
  };

  console.keyMap = keymap;

  services = {
    xserver = {
      enable = true;

      xkb = {
        layout = "fr"; 
        variant = "";  
      };

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true; 
      };
      pulse.enable = true;
      # Pour utiliser les applications JACK, décommentez la ligne suivante
      # jack.enable = true;
    };

    flatpak.enable = true;

    fwupd.enable = true;

    tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "client";
    };
  };

  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;

  users.users.${userName} = {
    isNormalUser = true;
    description = "Tom";
    extraGroups = userGroups;
    packages = [];
  };

  environment = {
    systemPackages = systemPackages  ++ gnomeExtensions;
    gnome.excludePackages = unneededGnomePackages;
  };

  programs = {
    firefox.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      persistent = true;
      options = "--delete-older-than 14d";
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      dates = "daily";
      persistent = true;
    };
    stateVersion = "24.05";
  };

  home-manager.users.${userName} = { pkgs, ... }: {
    home.stateVersion = "24.05";
    
    programs.git = {
    enable = true;
    userName  = "waddenn";
    userEmail = "waddenn.github@gmail.com";
  };
  
    programs.zsh = {
      enable = true; 
      enableCompletion = true;
      oh-my-zsh = {
        enable = true; 
        theme = "agnoster"; 
        plugins = [
          "git"                
          #"zsh-autosuggestions" 
          #"zsh-syntax-highlighting" 
          #"zsh-completions"     
        ];
    };
    };

    home.packages = with pkgs; [

    ];
          dconf.settings = {
        "org/gnome/shell" = {
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Console.desktop"
            "vesktop.desktop"
            "org.remmina.Remmina.desktop"
            "youtube-music.desktop"
          ];
          disable-user-extensions = false;
          remember-mount-password = true;
          enabled-extensions = [
            "hidetopbar@mathieu.bidon.ca"
            "tailscale@joaophi.github.com"
            "AlphabeticalAppGrid@stuarthayhurst"
            "appindicatorsupport@rgcjonas.gmail.com"
            "system-monitor@gnome-shell-extensions.gcampax.github.com"
            "Battery-Health-Charging@maniacx.github.com"
            "system-monitor@gnome-shell-extensions.gcampax.github.com"
            "search-light@icedman.github.com"
          ];
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          clock-show-weekday = true;
          accent-color = "slate";
        };
        # "org/gnome/desktop/background" = {
        #   color-shading-type = "solid";
        #   picture-options = "zoom";
        #   picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
        #   picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
        #   primary-color = "#241f31";
        #   secondary-color = "#000000";
        # };
        # "org/gnome/desktop/screensaver" = {
        #   color-shading-type = "solid";
        #   picture-options = "zoom";
        #   picture-uri = "file:///run-current-system/sw/share/backgrounds/gnome/blobs-l.svg";
        #   primary-color = "#241f31";
        #   secondary-color = "#000000";
        # };
        # "org/gnome/desktop/wm/preferences" = {
        #   action-right-click-titlebar = "toggle-maximize";
        #   action-middle-click-titlebar = "minimize";
        #   resize-with-right-button = true;
        #   mouse-button-modifier = "<super>";
        #   button-layout = ":minimize,close";
        # };
        "org/gnome/desktop/wm/keybindings" = {
          minimize = ["<Super>h"];
          show-desktop = ["<Super>d"];
          toggle-fullscreen = [ "<super>f" ];
          close = [ "<super>q" "<alt>f4" ];
          switch-to-workspace-left = [ "<alt>left" ];
          switch-to-workspace-right = [ "<alt>right" ];
          switch-to-workspace-1 = [ "<alt>1" ];
          switch-to-workspace-2 = [ "<alt>2" ];
          switch-to-workspace-3 = [ "<alt>3" ];
          switch-to-workspace-4 = [ "<alt>4" ];
          switch-to-workspace-5 = [ "<alt>5" ];
          move-to-workspace-left = [ "<ctrl><alt>left" ];
          move-to-workspace-right = [ "<ctrl><alt>right" ];
          move-to-workspace-1 = [ "<ctrl><alt>1" ];
          move-to-workspace-2 = [ "<ctrl><alt>2" ];
          move-to-workspace-3 = [ "<ctrl><alt>3" ];
          move-to-workspace-4 = [ "<ctrl><alt>4" ];
          move-to-workspace-5 = [ "<ctrl><alt>5" ];
          # move-to-monitor-left = [ "<super><alt>left" ];
          # move-to-monitor-right = [ "<super><alt>right" ];
        };
          

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          ];
          control-center = ["<Super>i"];
          home = ["<Super>e"];
          next = ["<Super>AudioRaiseVolume"];
          play = ["<Super>AudioMute"];
          previous = ["<Super>AudioLowerVolume"];

        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Control><Alt>t";
          command = "kgx";
          name = "open-terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Shift><Control>Escape";
          command = "resources";
          name = "Resources";
        };

        # "org/gnome/shell/extensions/search-light" = {
        #   shortcut-search = ["<Super>Space"];
        #   scale-width = "0,2";
        #   scale-height = "0,1";
        #   border-radius = "2,0";
        #   blur-brightness = "0,6";
        # };

        "org/gnome/shell/extensions/system-monitor" = {
          show-cpu = true;
          show-download = true;
          show-memory = true;
          show-swap = false;
          show-upload = false;
        };

        "org/gnome/shell/extensions/Battery-Health-Charging" = {
          amend-power-indicator = true;
          charging-mode = "max";
          show-battery-panel2 = false;
          show-preferences = false;
          show-system-indicator = false;
        };

        # "org/gnome/shell/extensions/caffeine" = {
        #   enable-fullscreen = true;
        #   restore-state = true;
        #   show-indicator = true;
        #   show-notification = false;
        # };
        # "org/gnome/shell/extensions/blur-my-shell" = {
        #   brightness = 0.9;
        # };
        # "org/gnome/shell/extensions/blur-my-shell/panel" = {
        #   customize = true;
        #   sigma = 0;
        # };
        # "org/gnome/shell/extensions/blur-my-shell/overview" = {
        #   customize = true;
        #   sigma = 0;
        # };
      };
  };
}
