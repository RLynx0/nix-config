{ lib, ... }:
{
  options.meta = {
    username = lib.mkOption { type = lib.types.str; };
    keyboardLayout = lib.mkOption { type = lib.types.str; };
    cursor = {
      name = lib.mkOption { type = lib.types.str; };
      size = lib.mkOption { type = lib.types.ints.positive; };
    };
  };

  config.meta = {
    username = "lynx";
    keyboardLayout = "at";
    cursor = {
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}
