{ pkgs
, config
, lib
, ...
}:
let
  dir = "~/tasks";
in
{
  programs.taskwarrior = {
    enable = true;
    # colorTheme = "solarized-dark-256";
    config = {
      dataLocation = "${dir}";
      # TODO: use age to manage secrets to be able to use them on multiple devices quickly
      taskd = {
        certificate = "${dir}/keys/public.cert";
        key = "${dir}/keys/private.key";
        ca = "${dir}/keys/ca.cert";
        server = "tasks.int.teo.beer:53589";
        credentials = "main/teo/5b50236a-e6cb-4646-8741-a4c904a2097f";
      };
    };
  };
}
