{ self, inputs, ... }: {
  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }:{
    imports =
      [ # Include the results of the hardware scan.
        self.nixosModules.myMachineHardware
      ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use Latest kernel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "nixos"; # Define your hostname.

    # Enable networking
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    programs.nix-ld.enable = true;
    services.upower.enable = true;
    virtualisation.libvirtd.enable = true;
    services.power-profiles-daemon.enable = true;

    # Set your time zone.
    time.timeZone = "Asia/Kolkata";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_IN";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."amrit" = {
      isNormalUser = true;
      description = "Amritanshu";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm"];
      packages = with pkgs; [
      #  thunderbird
      ];
      shell = pkgs.zsh;
    };

    # Install firefox.
    programs.firefox.enable = true;

    programs.niri.enable = true;
    programs.fuse.enable = true;
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      lazygit
      go
      gopls
      delve
      golangci-lint
      gotools
      air
      cava
      wtype
      qbittorrent
      gh
      jq
      steam-run
      sioyek
      appimage-run
      rustup
      intel-media-driver
      fragments
      libva
      vim
      wget
      avizo
      pciutils
      gnumake
      libva-utils
      virt-manager
      packet
      equibop
      pkg-config
      vscode-fhs
      pear-desktop
      curl
      tree
      eza
      zoxide
      gpu-screen-recorder
      bat
      fd
      ripgrep
      gnome-boxes
      antigravity-fhs
      fzf
      ninja
      btop
      unzip
      zip
      fastfetch
      bibata-cursors
      awww
      cliphist
      maple-mono.NF
      gnome-extension-manager
      cmake
      gcc
      sqlite
      vicinae
      grim
      slurp
      satty
      pavucontrol
      blueman
      networkmanagerapplet
      brightnessctl
      wl-clipboard
      catppuccin-gtk
      ghostty
      (pkgs.callPackage ../../../pkgs/helium.nix {})
      (pkgs.callPackage ../../../pkgs/brave-origin {})
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.zed-editor
    ];

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      extra-substituters = [
        "https://noctalia.cachix.org"
      ];

      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      histSize = 20000;
      ohMyZsh = {
        enable = true;
        theme = "agnoster";
        plugins = [
          "git"
          "sudo"
          "docker"
          "fzf"
          "colored-man-pages"
        ];
      };
      interactiveShellInit = ''eval "$(zoxide init zsh)"'';
    };




    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
    };
    programs.git.enable = true;


    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
