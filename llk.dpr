program llk;

uses
  Vcl.Forms,
  uFrmCheat in 'source\uFrmCheat.pas' {FrmCheat},
  uGameKyordai in 'source\uGameKyordai.pas',
  uGameMnzc in 'source\uGameMnzc.pas',
  uGameDzlzc in 'source\uGameDzlzc.pas',
  uGameTownship in 'source\uGameTownship.pas',
  uMMTimer in 'source\uMMTimer.pas',
  uIOCPTimer in 'source\uIOCPTimer.pas',
  uScriptEngine in 'source\uScriptEngine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmCheat, FrmCheat);
  Application.Run;
end.
