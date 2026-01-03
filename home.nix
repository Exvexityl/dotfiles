{ config, pkgs, ... }:

{
  home.username = "exvexityl";
  home.homeDirectory = "/home/exvexityl";

home.stateVersion = "25.11"; # make sure this exists

wayland.windowManager.hyprland = {
  enable = true;
  xwayland.enable = true;
  extraConfig = ''
    source ${./hypr/hyprland.conf}
  '';
};

  programs.kitty.enable = true;
xdg.configFile."kitty/kitty.conf".source = ./kitty.conf;
xdg.configFile."kitty/kitty.conf".force = true;

xdg.configFile."hypr/hyprland.conf".source = ./hyprland.conf;
xdg.configFile."hypr/hyprland.conf".force = true;

home.packages = with pkgs; [
  quickshell
  kitty
  grim
  slurp
  wl-clipboard
  mako
  swaybg
  brightnessctl
  playerctl
  fastfetch
] ++ [
  (pkgs.runCommand "ambxst" { } ''
     mkdir -p $out/bin
     ln -s ${./ambxst}/ambxst $out/bin/ambxst
  '')
];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };

}
