# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:
with lib;
with lib.cogisys;

let
  domainName = "fo.co.gi";
  rewrite = domain: answer: [ 
  	{inherit domain answer;}
	  {inherit answer; domain = "*.${domain}";}
  ];
in
{

  imports = [ ./hardware.nix ];

  cogisys = {
    suites.development = enabled;
    tools.gnupg = enabled;
    system.gui = disabled;
    system.audio = disabled;
    system.printing = disabled;

  };

  services = {
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {


        cloud = {
          serverName = "cloud.${domainName}";
          listen = [{addr = "0.0.0.0"; port = 8081;}];
          locations."/".proxyPass = "http://127.0.0.1";
        };

        
        dns = {
          serverName = "dns.${domainName}";
          listen = [{addr = "0.0.0.0"; port = 80;}];
          locations."/".proxyPass = "http://127.0.0.1:27701";
        };


        fallback = {
          serverName = "*.${domainName}";
          #TODO: Implementare destination
        };

        home = {
          serverName = domainName;
          listen = [{addr = "0.0.0.0"; port = 80;}];
          #TODO: Creare webpage
          locations."/" = {
            return = "200 '<html><body>Home</body></html>'";
            extraConfig = ''
               default_type text/html;
            '';
          };
        };
      };
    };
    
    nextcloud = {
      enable = true;
      hostName = "cloud.${domainName}";

      # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud30;

      # Let NixOS install and configure the database automatically.
      database.createLocally = true;

      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;

      # Increase the maximum file upload size to avoid problems uploading videos.
      maxUploadSize = "16G";

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts notes tasks;

      };

      config = {
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = (pkgs.writeText "nextcloudPass" "admin").outPath;
      };
    };
    adguardhome = {
      enable = true;
      host = "127.0.0.1";
      port = 27701;
      openFirewall = true;
      allowDHCP = false;
      mutableSettings = false;
      settings = {
        dns = {
          upstream_dns = [
            "https://dns.cloudflare.com/dns-query"
            "https://dns.google/dns-query"
            "https://doh.mullvad.net/dns-query"
          ];
          bootstrap_dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
        filtering.rewrites = rewrite domainName "100.126.103.65";
        filters = [
          {
            name = "AdGuard DNS filter";
            url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
            enabled = true;
          }
          {
            name = "AdAway Default Blocklist";
            url = "https://adaway.org/hosts.txt";
            enabled = true;
          }
          {
            name = "OISD (Big)";
            url = "https://big.oisd.nl";
            enabled = true;
          }
        ];
      };
    };
  };


  networking.firewall.allowedTCPPorts = [ 80 443 53 ];



  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
    packages = with pkgs; [ nmap ];
  }];

  system.stateVersion = "24.11";

}
