var version = "1.0.1";
var cpu = window.navigator.cpuClass;
var link = document.getElementById("link");
var small = document.getElementById("small");

if (platform.os.family === "OS X") {
  small.innerHTML = ".dmg";
  link.href = "https://github.com/Focus/BibtexImport/releases/download/v" + version + "/BibtexImport.dmg";
  link.innerHTML += "OS X 64bit";
}
else if (platform.os.family.indexOf("Windows") != -1 && platform.os.architecture === 64){
  if(platform.os.architecture === 64){
    small.innerHTML  = ".exe";
    link.href = "https://github.com/Focus/BibtexImport/releases/download/v" + version + "/BibtexImportSetup64.exe";
    link.innerHTML += "Win 64bit";
  }
  else {
    small.innerHTML  = ".exe";
    link.href = "https://github.com/Focus/BibtexImport/releases/download/v" + version + "/BibtexImportSetup32.exe";
    link.innerHTML += "Win 32bit";
  }
}
else if (/Ubuntu|Debian|Fedora|Red Hat|SuSE/.test(platform.os.family)){
  if(platform.os.architecture === 64){
    small.innerHTML  = ".deb";
    link.href = "https://github.com/Focus/BibtexImport/releases/download/v" + version + "/BibtexImportSetup64.deb";
    link.innerHTML += "Linux 64bit";
  }
  else {
    small.innerHTML  = ".deb";
    link.href = "https://github.com/Focus/BibtexImport/releases/download/v" + version + "/BibtexImportSetup32.deb";
    link.innerHTML += "Linux 32bit";
  }
}
