var version = "1.0.0";
var platform = window.navigator.platform;
var link = document.getElementById("link");
var small = document.getElementById("small");

if (platform === "MacIntel") {
  small.innerHTML = ".dmg";
  link.href = "https://github.com/Focus/BibtexImport/releases/download/v" + version + "/BibtexImport.app.zip";
  link.innerHTML += "OS X 64bit";
}
