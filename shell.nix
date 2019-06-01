{ pkgs ? import <nixpkgs> {}
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    darkhttpd
    entr
    git
    gnumake
    google-fonts
    imagemagick
    minify
    pandoc
    texlive.combined.scheme-medium
  ];
}
