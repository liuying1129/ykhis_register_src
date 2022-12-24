program ykhis_register;

uses
  Forms,
  UfrmMain in 'UfrmMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
