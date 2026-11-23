{
  lib,
  writeShellApplication,
  receivemidi,
  bash-pianoroll,
  gawk,
}:

writeShellApplication {
  name = "midi-pianoroll-tui";
  runtimeInputs = [
    receivemidi
    gawk
    bash-pianoroll
  ];

  text = ''
    if ! devices=$(receivemidi list); then
      echo "Failed to list MIDI input devices." >&2
      exit 1
    fi
    if [[ -z "$devices" ]]; then
      echo "No MIDI input devices found." >&2
      exit 1
    fi
    mapfile -t choices <<< "$devices"
    declare selected
    select selected in "''${choices[@]}"; do
      [[ -n "''${selected:-}" ]] && break
    done </dev/tty
    [[ -n "$selected" ]] || exit 1
    receivemidi dev "$selected" note nn \
      | awk -f ${bash-pianoroll}/share/pianoroll/parsers/receivemidi.awk \
      | pianoroll
  '';

  meta = {
    description = "Interactive MIDI-driven terminal piano roll";
    mainProgram = "midi-pianoroll-tui";
    platforms = lib.platforms.linux;
  };
}
