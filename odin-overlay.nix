final: prev: {
  odin = prev.odin.overrideAttrs (oldAttrs: {
    version = "dev-1a4139b25c8d7ed780641a94ef628e8867a5e332";
    src = prev.fetchFromGitHub {
      owner = "odin-lang";
      repo = "Odin";
      rev = "1a4139b25c8d7ed780641a94ef628e8867a5e332";
      hash = "sha256-popRCrI/qslLWE2PG6oAUyLJ9kIBN3jg1hSnDBGy20o=";
    };
    buildInputs = [final.sdl3];
    nativeBuildInputs = [final.git final.which] ++ oldAttrs.nativeBuildInputs;

    patches = [
      ./darwin-remove-impure-links.patch
    ];
  });

  ols = prev.ols.overrideAttrs (oldAttrs: rec {
    version = "dev-56a6c4ef51116f9a7e33b9a4b5fda95baaa0f5a0";
    src = prev.fetchFromGitHub {
      owner = "DanielGavin";
      repo = "ols";
      rev = "56a6c4ef51116f9a7e33b9a4b5fda95baaa0f5a0";
      hash = "sha256-01eDnrQDrYqMMnW/2Eh/Kq/RqEvfPLQy7UtCLBwIzNk=";
    };
    nativeBuildInputs = [final.git] ++ oldAttrs.nativeBuildInputs;

    postPatch = oldAttrs.postPatch + ''
      substituteInPlace src/main.odin --replace-fail "VERSION :: \"dev-2024-11-9:g584f01b\"" "VERSION :: \"${version}\""
    '';
  });
}
