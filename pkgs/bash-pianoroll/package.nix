{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
}:

stdenv.mkDerivation {
  pname = "bash-pianoroll";
  version = "0-unstable-2026-11-22";

  src = fetchFromGitHub {
    owner = "bahamas10";
    repo = "pianoroll";
    rev = "fc700c1b39b044173e6714bc0c0da5b03bec05ea";
    hash = "sha256-QmnGK3TV7yT8gjkR3eO1fQFzFdtTAfSjJW2IX7FuC58=";
  };

  buildInputs = [ bash ];
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 pianoroll "$out/bin/pianoroll"
    install -Dm644 parsers/receivemidi.awk "$out/share/pianoroll/parsers/receivemidi.awk"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    ${lib.getExe bash} -n "$out/bin/pianoroll"
    runHook postInstallCheck
  '';

  meta = {
    description = "Terminal piano visualizer written in Bash";
    homepage = "https://github.com/bahamas10/pianoroll";
    license = lib.licenses.mit;
    mainProgram = "pianoroll";
    platforms = lib.platforms.unix;
  };
}
