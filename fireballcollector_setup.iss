#define MyAppName "UKMON Fireball Analyser"

[Setup]
AppName=UKMON Fireball Analyser
AppVersion="1.0.0"
AppPublisher=UK Meteor Network
AppPublisherURL=https://www.ukmeteornetwork.org
DefaultDirName={localappdata}\programs\fbAnalyser
DefaultGroupName=UKMON
UninstallDisplayIcon={app}\fireballCollector.exe
Compression=lzma2
SolidCompression=yes
OutputDir=e:\temp
OutputBaseFilename=setup_fireballCollector
PrivilegesRequired=lowest

[Files]
Source: ".\dist\fireballCollector.exe"; DestDir: "{app}"
Source: ".\noimage.jpg"; DestDir: "{app}"
Source: ".\ukmda.ico"; DestDir: "{app}"
Source: ".\download_events.sh"; DestDir: "{app}";AfterInstall: AdjustTextFile;
Source: ".\config.ini.sample"; DestDir: "{app}"; Permissions: users-modify
Source: ".\README.html"; DestDir: "{app}"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; 

[Icons]
Name: "{group}\Fireball Analyser"; Filename: "{app}\fireballCollector.exe"; IconFilename: "{app}\ukmda.ico"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\fireballCollector.exe"; Tasks: desktopicon; WorkingDir: {app}; IconFilename: "{app}\ukmda.ico"

[code]
procedure AdjustTextFile();
var
  path : String;
  data : String;
begin
  path := ExpandConstant(CurrentFileName)
  LoadStringFromFile(path, data);
  StringChangeEx(data, #13#10, #10, True);
  SaveStringToFile(path, data, False);
end;