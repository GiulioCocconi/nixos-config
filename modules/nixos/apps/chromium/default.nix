# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.apps.chromium;
  gui = config.cogisys.system.gui;
  features = (unique cfg.features ++
             (optionals cfg.useHardwareAcc [ "VaapiVideoDecodeLinuxGL" ]) ++
             [ "TouchpadOverscrollHistoryNavigation" ]);
in
{
  options.cogisys.apps.chromium = with types; {
    enable                  = mkBoolOpt false "Enable chromium.";
    addNixOSBookmarks       = mkBoolOpt true  "Add bookmarks related to NixOS.";
    addMathBookmarks        = mkBoolOpt false "Add bookmarks related to Math & science.";
    addProgrammingBookmarks = mkBoolOpt false "Add bookmarks related to programming.";
    useHardwareAcc          = mkBoolOpt true  "Force hardware video acceleration.";
    features = mkOption {
      type = listOf str;
      description = "List of features to be enabled in flag file.";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (mkAssertionModule gui "GUI" "Chromium")
    ];


    environment.variables.BROWSER = "chromium";

    programs.chromium = {
      enable = true;
      extraOpts = { # https://chromeenterprise.google/policies/
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "BookmarkBarEnabled" = true;
        "GenAiDefaultSettings" = 1;
        "ExtensionInstallForcelist" = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock Origin
          "emffkefkbkpkgpdeeooapgaicgmcbolj" # Wikiwand
	  "efaidnbmnnnibpcajpcglclefindmkaj" # Adobe Reader
        ];
        "ManagedBookmarks" = [{ toplevel_name = "CoGiSys Bookmarks"; }]
        ++ optionals cfg.addNixOSBookmarks [{
          name = "NixOS";
          children = [
            { name = "NixOS docs"; url = "nixos.org/learn"; }
            { name = "Nixpkgs"; url = "github.com/NixOS/nixpkgs"; }
            { name = "Snowfall"; url = "github.com/snowfallorg"; }
            { name = "NixOS discourse"; url = "discourse.nixos.org"; }
            { name = "The Nix hour"; url = "youtube.com/playlist?list=PLyzwHTVJlRc8yjlx4VR4LU5A5O44og9in"; }
            { name = "Twaeg"; url = "tweag.io"; }
            { name = "Determinate Systems"; url = "determinate.systems"; }
            { name = "Noogle"; url = "noogle.dev"; }
            { name = "Nix Versions"; url = "lazamar.co.uk/nix-versions"; }
            { name = "Nixpkgs PR Tracker"; url = "nixpk.gs/pr-tracker.html"; }
          ];
        }] ++ optionals cfg.addMathBookmarks [
          { name = "Math"; children = [
            { name = "Blogs"; children = [
              { name = "Terence Tao"; url = "terrytao.wordpress.com"; }
              { name = "Jeremy Kun"; url = "jeremykun.com"; }
              { name = "Math with bad drawings"; url = "mathwithbaddrawings.com"; }
              { name = "Math3ma"; url = "math3ma.com"; }
              { name = "Infinity is really big"; url = "infinityisreallybig.com"; }
              { name = "Wolfram Writings"; url = "writings.stephenwolfram.com"; }
            ];}
            { name = "Courses"; children = [
              { name = "Linear Algebra"; children = [
                { name = "Strang"; url = "ocw.mit.edu/courses/18-06-linear-algebra-spring-2010"; }
                { name = "Saracco"; url = "youtube.com/playlist?list=PLApKuB-HooHIcZ-JGUCYHrlZT3HLQH7l8"; }
                { name = "Matrix Methods"; url = "ocw.mit.edu/18-065S18"; }
                { name = "Graphic Linear Algebra"; url = "graphicallinearalgebra.net"; }
                { name = "Essence of LA"; url = "youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab"; }
              ];}
              { name = "Real Analysis"; children = [
                { name = "MIT 18.100"; url = "ocw.mit.edu/courses/18-100a-real-analysis-fall-2020"; }
                { name = "Francis Su"; url = "youtube.com/playlist?list=PL0E754696F72137EC"; }
                { name = "Bill Kinney"; url = "youtube.com/playlist?list=PLmU0FIlJY-MngWPhBDUPelVV3GhDw_mJu"; }
                { name = "Gobbino"; url = "pagine.dm.unipi.it/gobbino/Home_Page/AD_AM1_17.html"; }
                { name = "Camilli"; url = "youtube.com/playlist?list=PLAQopGWlIcyZlCmXWE_KvtMi57Mwbyf6C"; }

              ];}
            ];}
            { name = "Misc"; children = [
              { name = "Tex StackExchange"; url = "tex.stackexchange.com"; }
              { name = "ProofWiki"; url = "proofwiki.org"; }
              { name = "SageMath"; url = "sagemath.org"; }
              { name = "Lean Community"; url = "leanprover-community.github.io"; }
              { name = "Logic Calculator"; url = "erpelstolz.at/gateway/formular-uk-zentral.html"; }
            ];}
          ];}
          { name = "Science"; children = [];}
        ] ++ optionals cfg.addProgrammingBookmarks [
          { name = "Programming"; children = [
            { name = "Elixir Bootlin"; url = "elixir.bootlin.com"; }
          ];}
        ];
      };
    };
    environment.etc."chromium-flags.txt".text = ''
      # AUTOGENERATED FILE - DO NOT EDIT!
      --ozone-platform-hint=auto
      --enable-features=${concatStringsSep "," features}
    '';
  };
}
