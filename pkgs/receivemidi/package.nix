{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  coreutils,
}:

stdenv.mkDerivation {
  pname = "receivemidi";
  version = "1.6.2-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "gbevin";
    repo = "ReceiveMIDI";
    rev = "6dbd5d6a5e8b8bd2e4b15edc44861654f5c1e451";
    hash = "sha256-Eke1knPXB0zeD3Aqrv+v5dT78x1LfcfEIunWr67N3Y4=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ alsa-lib ];

  postPatch = ''
    substituteInPlace Tests/ReceiveTests.cpp \
      --replace-fail /bin/echo ${lib.getExe' coreutils "echo"}
  '';

  buildPhase = ''
    runHook preBuild
    make -C Builds/LinuxMakefile CONFIG=Release
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    make -C Tests/Builds/LinuxMakefile CONFIG=Release
    ./Tests/Builds/LinuxMakefile/build/ReceiveMIDITests
    ./Builds/LinuxMakefile/build/receivemidi --version | grep -q "receivemidi v"
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 Builds/LinuxMakefile/build/receivemidi "$out/bin/receivemidi"
    runHook postInstall
  '';

  meta = {
    description = "Command-line tool for monitoring MIDI messages";
    homepage = "https://github.com/gbevin/ReceiveMIDI";
    license = lib.licenses.gpl3Plus;
    mainProgram = "receivemidi";
    platforms = lib.platforms.linux;
  };
}
