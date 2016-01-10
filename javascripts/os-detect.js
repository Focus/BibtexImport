var version = "1.0.1";
var platform = window.navigator.platform;
var cpu = window.navigator.cpuClass;
var link = document.getElementById("link");
var small = document.getElementById("small");

if (platform === "MacIntel") {
  small.innerHTML = ".dmg";
  link.href = "https://github.com/Focus/BibtexImport/releases/download/v" + version + "/BibtexImport.dmg";
  link.innerHTML += "OS X 64bit";
}
else if (platform === "Win32" && cpu === "x64"){
  small.innerHTML  = ".exe";
  link.href = "https://github.com/Focus/BibtexImport/releases/download/v" + version + "/BibtexImportSetup64.exe";
  link.innerHTML += "Win 64bit";
}
