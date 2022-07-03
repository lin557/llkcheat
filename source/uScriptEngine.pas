unit uScriptEngine;

interface

uses
  WinAPI.Windows, System.Classes, System.SysUtils, uMMTimer, uIOCPTimer;

type
  TInputParam = record
    key: string;
    value: string;
  end;

  TInputParams = array of TInputParam;

  TScriptEngine = class(TObject)
  private
    FTimer: TMMTimer;
    FListScript: TStringList;
    FListTmp: TStringList;
    FLoop: Integer;
    FDelay: Cardinal;
    FGameHandle: THandle;
    FInputParams: TInputParams;
    FVarParams: TInputParams;
    procedure DoTimer(Sender: TObject);
    procedure AnalyseScript(vList: TStringList; vParams: TInputParams);
    procedure LoadScript(vParams: TInputParams);
    procedure PlayScript(vParams: TInputParams);
    // 获取变量值
    function GetVarValue(key: string; var value: string): Integer;
  public
    constructor Create();
    destructor Destroy; override;

    procedure Play(Loop: Integer; vParams: TInputParams);
    procedure Stop();

    property GameHandle: THandle read FGameHandle write FGameHandle;
  end;

implementation

{ TScriptEngine }

procedure TScriptEngine.AnalyseScript(vList: TStringList; vParams: TInputParams);
var
  i, j, c, uIndex: Integer;
  sTmp, sKey: string;
  vVarList: TStringList;
  vTmpList: TStringList;
  vOutList: TStringList;
  uCmd: Byte;
begin
  vVarList := TStringList.Create;
  vVarList.Delimiter := '=';
  vTmpList := TStringList.Create;
  vTmpList.Delimiter := ' ';
  vOutList := TStringList.Create;
  try
    SetLength(FVarParams, Length(vParams));
    for i := 0 to Length(vParams) - 1 do
    begin
      FVarParams[i].key := vParams[i].key;
      FVarParams[i].value := vParams[i].value;
    end;
    for i := 0 to vList.Count - 1 do
    begin
      sTmp := Trim(vList[i]);
      // 跳过空行
      if Length(sTmp) = 0 then
        Continue;
      uCmd := Ord(sTmp[1]);
      case uCmd of
        35:
          begin
            // # 注释 不管
            Continue;
          end;
        105:
          begin
            // i 逻辑判断
            vTmpList.DelimitedText := sTmp;
            vVarList.Clear;
            sTmp := vTmpList[1];
            vVarList.DelimitedText := Trim(sTmp);
            // 查找变量是否存在 
            sKey := vVarList[0];
            uIndex := GetVarValue(sKey, sTmp);
            if uIndex <> -1 then
            begin
              // 变量存在
              if SameText(sTmp, vVarList[1]) then
              begin
                // 符合条件 修改变量值
                for j := 2 to vTmpList.Count - 1 do
                begin
                  vVarList.Clear; 
                  sTmp := vTmpList[j];
                  vVarList.DelimitedText := Trim(sTmp);
                  sKey := vVarList[0];
                  uIndex := GetVarValue(sKey, sTmp);
                  if uIndex <> -1 then
                  begin
                    // 变量存在 赋新值
                    FVarParams[uIndex].value := vVarList[1];
                  end;
                end;
              end;  
            end;
          end;
        118:
          begin
            // v 变量
            vTmpList.DelimitedText := sTmp;
            //c := Length(FVarParams);
            //SetLength(FVarParams, c + vTmpList.Count - 1);
            for j := 1 to vTmpList.Count - 1 do
            begin
              vVarList.Clear;
              sTmp := vTmpList[j];
              vVarList.DelimitedText := Trim(sTmp);
              // 查找变量是否存在 
              sKey := vVarList[0];
              uIndex := GetVarValue(sKey, sTmp);
              if uIndex = -1 then
              begin
                // 不存在 增加
                c := Length(FVarParams);
                SetLength(FVarParams, c + 1);
                FVarParams[c].key := sKey;
                FVarParams[c].value := vVarList[1]; 
              end else
              begin
                // 存在 赋新值
                FVarParams[uIndex].value := vVarList[1]; 
              end;
            end;
          end;
      else
        if (Length(FVarParams) > 0) and (Pos('$', sTmp) > 0) then
        begin
          // 用了变量
          for j := 0 to Length(FVarParams) - 1 do
          begin
            sTmp := StringReplace(sTmp, FVarParams[j].key, FVarParams[j].value, [rfReplaceAll]);
          end;
        end;
        vOutList.Add(sTmp);
      end;
    end;
    vList.Clear;
    vList.AddStrings(vOutList);
  finally
    vVarList.Free;
    vTmpList.Free;
    vOutList.Free;
  end;
end;

constructor TScriptEngine.Create;
begin
  FTimer := TMMTimer.Create;
  FTimer.Interval := 5;
  FTimer.OnTimer := DoTimer;
  FTimer.Enabled := False;

  FListScript := TStringList.Create;
  FListTmp := TStringList.Create;
  FListTmp.Delimiter := ' ';
  FLoop := 1;
  FDelay := 0;
end;

destructor TScriptEngine.Destroy;
begin
  FTimer.Free;
  FListScript.Free;
  FListTmp.Free;
  inherited;
end;

procedure TScriptEngine.DoTimer(Sender: TObject);
begin
  PlayScript(FInputParams);
end;

function TScriptEngine.GetVarValue(key: string; var value: string): Integer;
var
  i: Integer;
begin
  for i := 0 to Length(FVarParams) - 1 do
  begin
    if SameText(FVarParams[i].key, key) then
    begin
      value := FVarParams[i].value;
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TScriptEngine.LoadScript(vParams: TInputParams);
var
  vList: TStringList;
begin
  FDelay := 0;
  // 加载脚本
  vList := TStringList.Create;
  try
    vList.LoadFromFile('c://ss.txt');
    AnalyseScript(vList, vParams);
    FListScript.Clear;
    FListScript.AddStrings(vList);
  finally
    vList.Free;
  end;
end;

procedure TScriptEngine.Play(Loop: Integer; vParams: TInputParams);
begin
  Stop();
  FLoop := Loop;
  FInputParams := vParams;
  LoadScript(vParams);
  FLoop := FLoop - 1;
  Self.FTimer.Enabled := True;
end;

procedure TScriptEngine.PlayScript(vParams: TInputParams);
var
 sTmp: string;
 uCmd, uAct, uBtn: Byte;
 x, y: Integer;
 uSleep: Cardinal;
 uLong: Int64;
 vRect: TRect;
begin
  if FListScript.Count = 0 then
  begin
    if FLoop > 0 then
    begin
      LoadScript(vParams);
      FLoop := FLoop - 1;
      Exit;
    end;
  end;
  sTmp := Trim(FListScript[0]);
  if Length(sTmp) < 3 then
    Exit;

  FListTmp.CommaText := sTmp;
  if FListTmp.Count < 2 then
    Exit;

  uCmd := Ord(FListTmp[0][1]);
  case uCmd of
    100:
      begin
        // d d = debug e = exit
        if SameText('e', FListTmp[1]) then
        begin
          Stop();
        end;
      end;
    107:
      begin
        // k 键盘
        uAct := Ord(FListTmp[1][1]);
        case uAct of
          112:
            begin
              // p press
              uBtn := StrToIntDef(FListTmp[2], 0);
              if uBtn > 0 then
              begin
                keybd_event(uBtn, 0, 0, 0);
                Sleep(25);
                keybd_event(uBtn, 0, KEYEVENTF_KEYUP, 0);
              end;
            end;
          100:
            begin
              // d down
            end;
          117:
            begin
              // u up
            end;
        end;
      end;
    109:
      begin
        // m 鼠标
        uAct := Ord(FListTmp[1][1]);
        case uAct of
          99:
            begin
              // c click
              uBtn := StrToIntDef(FListTmp[2], 0);
              case uBtn of
                0:
                  begin
                    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
                    Sleep(15);
                    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
                  end;
                1:
                  begin

                  end;
                2:
                  begin

                  end;
              end;
            end;
          100:
            begin
              // d mouse down
              uBtn := StrToIntDef(FListTmp[2], 0);
              case uBtn of
                0:
                  begin
                    mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
                  end;
                1:
                  begin

                  end;
                2:
                  begin

                  end;
              end;
            end;
          117:
            begin
              // u mouse up
              uBtn := StrToIntDef(FListTmp[2], 0);
              case uBtn of
                0:
                  begin
                    mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
                  end;
                1:
                  begin

                  end;
                2:
                  begin

                  end;
              end;
            end;
          109:
            begin
              // m move
              x := StrToIntDef(FListTmp[2], 0);
              y := StrToIntDef(FListTmp[3], 0);

              GetWindowRect(FGameHandle, vRect);
              SetCursorPos(vRect.Left + x, vRect.Top + y);
            end;
        end;
      end;
    115:
      begin
        // s sleep
        if (FDelay = 0) then
        begin
          uSleep := StrToIntDef(FListTmp[1], 0);
          FDelay := GetTickCount + uSleep;
        end else
        begin
          uLong := GetTickCount;
          uLong := uLong - FDelay;
          if uLong >= 0 then
            FDelay := 0;
        end;
      end;
  end;
  if FDelay = 0 then
    FListScript.Delete(0);

  if (FListScript.Count = 0) and (FLoop = 0) then
    Stop();
end;

procedure TScriptEngine.Stop;
begin
  Self.FTimer.Enabled := False;
end;

end.
