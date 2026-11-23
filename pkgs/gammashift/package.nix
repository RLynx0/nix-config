{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "gammashift";
  version = "0.1.0-unstable-2026-11-21";

  src = fetchFromGitHub {
    owner = "RLynx0";
    repo = "gammashift";
    rev = "a3632c9fdd04c0b44a8d202c0722e52ed1cdde1c";
    hash = "sha256-6dUW19SyFo1GJZ4GXq6utAejXnvndReTjupl/i1+kCU=";
  };

  cargoHash = "sha256-pBcVJC7mXepRzOppk939M2wtlLpUHjrz10zN8fdSUDw=";

  meta = {
    description = "Smooth gamma transitions for wl-gammarelay";
    homepage = "https://github.com/RLynx0/gammashift";
    mainProgram = "gammashift";
    platforms = lib.platforms.linux;
  };
}
