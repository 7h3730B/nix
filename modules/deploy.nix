{ config, lib, ... }: 
with lib;
let
	cfg = config.deploy;
in {
	options.deploy = {
		enable = mkOption {
			type = types.bool;
			default = false;
			description = "Enable remote deployment for this host";
		};

		ip = mkOption {
			type = types.nullOr types.str;
			default = null;
			description = "Overwrite the IP to use for connecting via SSH";
		};

		port = mkOption {
			type = types.int;
			default = 22;
			description = "Change the ssh port";
		};

		system = mkOption {
			type = types.string;
			default = "x86_64-linux";
			description = "System architecture";
		};
	};

	config = { };
}