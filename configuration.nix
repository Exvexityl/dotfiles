{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  #################################
  # Boot
  #################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #################################
  # Networking
  #################################
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  #################################
  # Time & Locale
  #################################
  time.timeZone = "Europe/London";
  services.power-profiles-daemon.enable = false;
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  #################################
  # Keyboard
  #################################
  services.xserver.xkb.layout = "gb";
  console.keyMap = "uk";

  #################################
  # Display / Login
  #################################
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Keep KDE Plasma
  services.desktopManager.plasma6.enable = true;

  #################################
  # Hyprland
  #################################
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  #################################
  # Flatpak
  #################################
  services.flatpak.enable = true;

  #################################
  # Printing
  #################################
  services.printing.enable = true;
  services.auto-cpufreq.enable = true;
services.auto-cpufreq.settings = {
  battery = {
     governor = "powersave";
     turbo = "never";
  };
  charger = {
     governor = "powersave";
     turbo = "never";
  };
};

  #################################
  # Audio
  #################################
  security.rtkit.enable = true;
  home-manager.users.exvexityl = import ./home.nix;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  #################################
  # Graphics (Intel + NVIDIA)
  #################################
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "intel" "nvidia" ];

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  #################################
  # User
  #################################
  users.users.exvexityl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
  };

  #################################
  # Programs
  #################################
  programs.firefox.enable = true;
  programs.steam.enable = true;

  #################################
  # System Packages
  #################################
  environment.systemPackages = with pkgs; [
    wget
    git
    micro
    steam
    fastfetch
    # MangoHud (installed as a package)
    mangohud

    # Hyprland essentials
    hyprland
    waybar
    rofi
    kitty
    foot
    grim
    slurp
    wl-clipboard
    mako
    swaybg
    wlr-randr
    xdg-desktop-portal-hyprland
    qt6.qtwayland
    qt5.qtwayland
  ];

  #################################
  # Nix
  #################################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  #################################
  # State
  #################################
  system.stateVersion = "25.11";
}
