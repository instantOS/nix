{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, instantAssist
, instantConf
, instantUtils
, instantWallpaper
, arandr
, arc-theme
, autorandr
, bc
, blueman
, firaCodeNerd
, gnome-disk-utility
, gufw
, hicolor-icon-theme
, lxappearance
, neovim
, papirus-icon-theme
, pavucontrol
, st
, system-config-printer
, udiskie
, xfce4-power-manager
}:
let
  utilities = [
    instantAssist
    instantUtils
    instantConf
    instantWallpaper
    arandr
    autorandr
    bc
    blueman
    gnome-disk-utility
    gufw
    lxappearance
    neovim
    pavucontrol
    st
    system-config-printer
    udiskie
    xfce4-power-manager
    firaCodeNerd
    papirus-icon-theme
    arc-theme
    hicolor-icon-theme
  ];
in
stdenv.mkDerivation {

  pname = "instantSettings";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantSETTINGS";
    rev = "1df5b79de5927f3ae7c4f7e8fbfb108dc3c58303";
    sha256 = "1cqf6hp46dysvy83xn36faim03nax73cpzsi061mp2zifbya8jlm";
  };

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = utilities;

  postPatch = ''
    substituteInPlace settings.sh \
      --replace "/usr/share/instantassist" "$out/share/instantassist"
  '';

  installPhase = ''
    mkdir -p "$out/share/applications"
    cp *.desktop "$out/share/applications"
    install -Dm 555 settings.sh "$out/bin/instantsettings"
    ln -s "$out/bin/instantsettings" "$out/bin/instantos-control-center"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/instantsettings" \
      --prefix PATH : ${lib.makeBinPath utilities}
  '';

  meta = with lib; {
    description = "Simple settings app for instant-OS";
    license = licenses.gpl2;
    homepage = "https://github.com/instantOS/instantSETTINGS";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
