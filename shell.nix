{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    entr
    gnumake
    google-fonts
    pandoc
    python3
    texlive.combined.scheme-medium
  ];
}
