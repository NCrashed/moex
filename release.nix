let
  pkgs = import ./pkgs.nix { inherit config; };
  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override { overrides = haskOverrides; };
    };
  };
  gitignore = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner  = "siers";
    repo   = "nix-gitignore";
    rev    = "ce0778ddd8b1f5f92d26480c21706b51b1af9166";
    sha256 = "1d7ab78i2k13lffskb23x8b5h24x7wkdmpvmria1v3wb9pcpkg2w";
  }) {};
  ignore = gitignore.gitignoreSourceAux ''
    .stack-work
    dist
    dist-newstyle
    .ghc.environment*
    '';
  haskOverrides = new: old: let
    call = name: path: args: new.callCabal2nix name (ignore path) args;
    in rec {
    moex-api = call "moex-api" ./moex-api {};
    moex-client = call "moex-client" ./moex-client {};
  };
in {
  inherit pkgs;
  packages = { inherit (pkgs.haskellPackages) moex-api moex-client; };
}
