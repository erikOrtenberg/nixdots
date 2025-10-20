{
  programs.ssh.matchBlocks.serverburken = {
    host = "serverburken";
    hostname = "kryddan.xyz";
    user = "kryddan";
  };
  programs.ssh.matchBlocks.rat-old = {
    host = "rat-old";
    hostname = "rotarypub.se";
    user = "kryddan";
    setEnv = {
      TERM = "xterm-256color";
    };
  };
  programs.ssh.matchBlocks.rat = {
    host = "rat";
    hostname = "rotarypub.se";
    port = 222;
    user = "kryddan";
  };
  programs.ssh.matchBlocks.link = {
    host = "link";
    hostname = "link.cse.chalmers.se";
    user = "dhack";
  };
  programs.ssh.matchBlocks.zelda = {
    host = "zelda";
    hostname = "zelda.cse.chalmers.se";
    user = "dhack";
  };
  programs.ssh.matchBlocks.ganon = {
    host = "ganon";
    hostname = "ganon.dhack.se";
    port = 222;
    user = "kryddan";
  };
  programs.ssh.matchBlocks.medli = {
    host = "medli";
    hostname = "pub.dhack.se";
    port = 222;
    user = "hacke";
  };
  programs.ssh.matchBlocks.black-tower = {
    host = "black-tower";
    hostname = "kraft.ortenberg.se";
    port = 6226;
    user = "kryddan";
  };
}
