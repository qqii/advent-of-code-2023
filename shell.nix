{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
        cbqn-replxx
    ];
}