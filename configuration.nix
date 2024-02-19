### Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #    ./gtk.nix
  ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #Hostname
  networking.hostName = "framwok";
  #@marie pls fix this 
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];

  #Self doxx UwU
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  console.keyMap = "de";
  services.printing.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #my user account
  users.users.marie = {
    isNormalUser = true;
    description = "marie";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox #idk why this is still here, move it to the other pkgs at some point
    ];
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  #Nvidia Stuff for my eGPU
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    #Power mangement stuff for Turing or later
    powerManagement.finegrained = false;

    #Only for Turing or later
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    #Prime/eGPU 
    prime = {
      sync.enable = true;
      allowExternalGpu = true;
      nvidiaBusId = "PCI:04:0:0";
      intelBusId = "PCI:0:2:0";
    };

  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #Razer stuff, not working yet
  hardware.openrazer.enable = true;
  hardware.openrazer.users = [ "marie" ];
  #Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      false; # No remote play because security
    dedicatedServer.openFirewall =
      false; # # No remote play because security
  };
  #Snapcast
  #  services.snapserver = {
  #    enable = true;
  #    codec = "flac";
  #    streams = {
  #      pipewire = {
  #        type = "pipe";
  #        location = "/run/snapserver/pipewire";
  #      };
  #    };
  #  };

  #  systemd.user.services.snapcast-sink = {
  #    wantedBy = [ "pipewire.service" ];
  #    after = [ "pipewire.service" ];
  #    bindsTo = [ "pipewire.service" ];
  #    path = with pkgs; [ gawk pulseaudio ];
  #    script = ''
  #      pactl load-module module-pipe-sink file=/run/snapserver/pipewire sink_name=Snapcast format=s16le rate=48000
  #    '';
  #  };

  #  systemd.user.services.snapclient-local = {
  #    wantedBy = [ "pipewire.service" ];
  #    after = [ "pipewire.service" ];
  #    serviceConfig = { ExecStart = "${pkgs.snapcast}/bin/snapclient -h ::1"; };
  #  };

  #Services
  #zsh
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.ohMyZsh.theme = "crunch";
  #Network manager
  networking.networkmanager.enable = true;
  #Gnome
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  #X11 Server
  services.xserver.enable = true;
  #Mullvad VPN
  services.mullvad-vpn.enable = true;
  #Flakes
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  #Docker
  virtualisation.docker.enable = true;
  #All my Programms :3
  environment.systemPackages = with pkgs; [
    htop
    gimp
    etcher
    unzip
    thunderbird
    firefox
    vim
    davinci-resolve
    neofetch
    beeper
    qbittorrent
    openvpn3
    signal-desktop
    zsh
    putty
    nmap
    hyfetch
    go
    nil
    lshw
    traceroute
    speedtest-cli
    element-desktop
    rustc
    filezilla
    pciutils
    docker
    git
    vscode
    yuzu
    libreoffice
    python3
    veracrypt
    metasploit
    ecryptfs
    gnumake
    discord
    wireshark-qt
    superTuxKart
    cargo
    gcc
    vlc
    alacritty
    mullvad
    prusa-slicer
    cmatrix
    btop
    wget
    restic
    chromium
    winetricks
    helvum
    lutris
    polychromatic
    rclone
    woeusb
    antimicrox
    pavucontrol
    setserial
    wineWowPackages.wayland
    tor-browser
    gnome-themes-extra
    catppuccin-gtk
    spotify
    betterdiscordctl
    gtop
    openconnect
    freerdp
    killall
    gdown
    neovim
    gnomeExtensions.user-themes
    gnomeExtensions.media-controls
    gnomeExtensions.vitals
    python311Packages.pip
    gnome.gnome-tweaks
    vesktop
    spotifyd
    brlaser
    pipes
    spotify-tui
    telegram-desktop
  ];
  services.spotifyd.enable = true;
  #pkgs.catppuccin-gtk.override = {
  #accent = "pink";
  # size = "compact";
  # tweak =  "rimless";
  # variant = "macchiato";
  # };

  # OpenSSH Banner to fuck with ppl
  services.openssh.banner = "i hope your balls explode
   ";
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  programs.ssh.startAgent = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ 8080 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
