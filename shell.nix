{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    gnumake
    google-fonts
    pandoc
    texlive.combined.scheme-medium
  ];
}
