unit uFrmLlk;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,

  uGameLlk, Vcl.ComCtrls, Vcl.WinXPanels;

type
  TFrmQqGame = class(TForm)
    PnlMainLlk: TPanel;
    ImgLlk: TImage;
    PnlTopLlk: TPanel;
    LblMatch: TLabel;
    CardPanel: TCardPanel;
    CardLlk: TCard;
    CardMnzc: TCard;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FGameLlk: TGameLlk;

    procedure DoMatch(Sender: TObject; vBitmap: TBitmap; uMatch: Integer);
  public
    { Public declarations }
  end;

var
  FrmQqGame: TFrmQqGame;

implementation

{$R *.dfm}

procedure TFrmQqGame.DoMatch(Sender: TObject; vBitmap: TBitmap; uMatch: Integer);
begin
  ImgLlk.Picture.Bitmap := vBitmap;
  LblMatch.Caption := Format('Match = %d', [uMatch]);
end;

procedure TFrmQqGame.FormCreate(Sender: TObject);
begin
  FGameLlk := TGameLlk.Create;
  FGameLlk.OnMatch := DoMatch;
  // llk 436 599
end;

procedure TFrmQqGame.FormDestroy(Sender: TObject);
begin
  FGameLlk.Free;
end;

end.
