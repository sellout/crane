{ lib
}:

let
  minSupported = "24.05";
  current = lib.concatStringsSep "." (lib.lists.sublist 0 2 (lib.splitVersion lib.version));
  isUnsupported = lib.versionOlder current minSupported;
  msg = "crane requires at least nixpkgs-${minSupported}, supplied nixpkgs-${current}";

  pureLib =
    let
      internalCrateNameFromCargoToml = import ./internalCrateNameFromCargoToml.nix { inherit lib; };
      internalCrateNameForCleanSource = import ./internalCrateNameForCleanSource.nix {
        inherit internalCrateNameFromCargoToml;
      };

      filterCargoSources = import ./filterCargoSources.nix { inherit lib; };

      registryFromDownloadUrl = import ./registryFromDownloadUrl.nix { inherit lib; };
    in
    {
      inherit filterCargoSources registryFromDownloadUrl;

      cleanCargoSource = import ./cleanCargoSource.nix {
        inherit filterCargoSources internalCrateNameForCleanSource lib;
      };
      cleanCargoToml = import ./cleanCargoToml.nix { };

      crateNameFromCargoToml = import ./crateNameFromCargoToml.nix {
        inherit internalCrateNameFromCargoToml lib;
      };

      findCargoFiles = import ./findCargoFiles.nix { inherit lib; };

      path = import ./path.nix {
        inherit internalCrateNameForCleanSource lib;
      };

      registryFromGitIndex = import ./registryFromGitIndex.nix { inherit registryFromDownloadUrl; };
      registryFromSparse = import ./registryFromSparse.nix { inherit registryFromDownloadUrl lib; };
    };
in
lib.warnIf isUnsupported msg pureLib
