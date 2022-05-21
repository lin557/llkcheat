program llk;

uses
  Vcl.Forms,
  uFrmLlk in 'source\uFrmLlk.pas' {FrmQqGame},
  uGameLlk in 'source\uGameLlk.pas',
  uGameMnzc in 'source\uGameMnzc.pas',
  uGameDzlzc in 'source\uGameDzlzc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmQqGame, FrmQqGame);
  Application.Run;
end.
