program ConnectClass;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  MYX.Connect1 in '_LIBRARY\MYX.Connect1.pas',
  MYX.Connect2 in '_LIBRARY\MYX.Connect2.pas',
  MYX.Connect3 in '_LIBRARY\MYX.Connect3.pas',
  MYX.Connect4 in '_LIBRARY\MYX.Connect4.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
