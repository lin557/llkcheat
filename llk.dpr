program llk;

uses
  Vcl.Forms,
  uFrmLlk in 'source\uFrmLlk.pas' {FrmLlk},
  uGame in 'source\uGame.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmLlk, FrmLlk);
  Application.Run;
end.
