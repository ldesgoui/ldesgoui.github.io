{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    entr
    gnumake
    google-fonts
    minify
    pandoc
    python3
    texlive.combined.scheme-medium
  ];
}
