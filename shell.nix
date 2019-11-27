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
    potrace
    texlive.combined.scheme-medium
  ];
}
