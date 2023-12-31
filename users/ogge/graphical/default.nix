{ hostType, pkgs, ... }: {
  imports = [
    (
      if hostType == "nixos" || hostType == "homeManager" then ./sway
      else if hostType == "darwin" then ./darwin.nix
      else throw "Unknown hostType '${hostType}' for users/ogge/graphical"
    )
    ./mpv.nix
    ./code.nix
    ./alacritty.nix
    ./mangohud.nix
    ./stylix.nix
    ./gtk.nix
    #./steam.nix # not working in home-manager
  ];



  home.packages = with pkgs; [
    helvum
    pavucontrol
    brave
    gopass
    libsecret
    polkit
    polkit_gnome
    vulkan-tools
    gnome.nautilus # best file explorer imho
    evince # document viewer (pdf etc.)
    libnotify
    #gnome3.adwaita-icon-theme # default gnome cursors
    #breeze-icons
    #breeze-gtk
    #wl-clipboard
    # wl-gammactl

    # xwayland # for legacy apps
    # waybar # configured as separate module
    #kanshi # autorandr
    # dmenu
    # wofi # replacement for dmenu
    #brightnessctl
    #gammastep # make it red at night!
    # sway-contrib.grimshot # screenshots
    # swayr #Swayr, a window-switcher & more for sway

    # https://discourse.nixos.org/t/some-lose-ends-for-sway-on-nixos-which-we-should-fix/17728/2?u=senorsmile

    #glib # gsettings
    #dracula-theme # gtk theme (dark)
    #gnome.networkmanagerapplet


    xdg-utils
  ] ++ lib.filter (lib.meta.availableOn stdenv.hostPlatform) [
    authy
  ] ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
    psst
  ];

  programs.alacritty.enable = true;

  
}
