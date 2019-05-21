{ pkgs ? import <nixpkgs> {} }:

with pkgs;

bundlerEnv rec {
  name = "smart-village-server-${version}";
  version = "0";
  gemdir = ./.;
  ruby = ruby_2_6;
}
