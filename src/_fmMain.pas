unit _fmMain;

interface

uses
  JsonData, Magnetic, Disk, FFmpegController,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, BitmapButton,
  Vcl.StdCtrls, BitmapWindow, SwitchButton;

type
  TfmMain = class(TMagneticMainForm)
    btRecord: TSwitchButton;
    BitmapWindow: TBitmapWindow;
    lbTitle: TLabel;
    btClose: TBitmapButton;
    btHome: TBitmapButton;
    plClient: TPanel;
    btMonitor: TSwitchButton;
    btMic: TSwitchButton;
    btSetup: TSwitchButton;
    SaveDialog: TSaveDialog;
    procedure btCloseClick(Sender: TObject);
    procedure btRecordChanged(Sender: TObject);
    procedure SwitchButtonbtClick(Sender: TObject);
    procedure btHomeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure do_close_ffmpeg;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure rp_ShowOptionControl(AParams:TJsonData);
  end;

var
  fmMain: TfmMain;

implementation

uses
  Core, Options;

{$R *.dfm}

procedure TfmMain.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.btHomeClick(Sender: TObject);
begin
  ShellExecuteFile('http://e-cam.s3-website.ap-northeast-2.amazonaws.com/', '', '')
end;

procedure TfmMain.btRecordChanged(Sender: TObject);
begin
  TCore.Obj.View.sp_OnAir(btRecord.SwitchOn);

  if btRecord.SwitchOn then begin
    if TOptions.Obj.ScreenOption.CanCapture = false then begin
      MessageDlg('캡쳐할 윈도우가 선택되지 않았습니다.', mtError, [mbOK], 0);
      btRecord.SwitchOn := false;
      TCore.Obj.View.sp_ShowOptionControl('Monitor');
      Exit;
    end;

    if open_ffmpeg(TOptions.Obj.FFmpegControllerParams) = false then begin
      MessageDlg('녹화 준비 도중 에러가 발생하였습니다.', mtError, [mbOK], 0);
      Exit;
    end;

    ShellExecuteHide(GetExecPath+'ffmpeg.exe', TOptions.Obj.FFmpegExecuteParams, GetExecPath);
  end else begin
    do_close_ffmpeg;
  end;

  btMonitor.SwitchOn := false;
  btMic.SwitchOn     := false;
  btSetup.SwitchOn   := false;

  btMonitor.Enabled := not btRecord.SwitchOn;
  btMic.Enabled     := not btRecord.SwitchOn;
  btSetup.Enabled   := not btRecord.SwitchOn;

  TCore.Obj.View.sp_ShowOptionControl('');
end;

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfmMain.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfmMain.do_close_ffmpeg;
begin
  close_ffmpeg;
  if TOptions.Obj.YouTubeOption.OnAir then Exit;

  if SaveDialog.Execute then begin
    MoveFileEx(PChar(TOptions.Obj.VideoFilename), PChar(SaveDialog.FileName), MOVEFILE_COPY_ALLOWED or MOVEFILE_REPLACE_EXISTING);
  end else begin
    DeleteFile(TOptions.Obj.VideoFilename)
  end;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  result : integer;
begin
  if btRecord.SwitchOn then begin
    result := MessageDlg('녹화중입니다. 종료하시겠습니까?', mtConfirmation, [mbYes, mbNo], 0);
    if result <> mrYes then begin
      Action := caNone;
      Exit;
    end;

    do_close_ffmpeg;
  end;

  TOptions.Obj.SaveToFile;
end;

procedure TfmMain.rp_ShowOptionControl(AParams: TJsonData);
begin
  btMonitor.SwitchOn := AParams.Values['Target'] = 'Monitor';
  btMic.SwitchOn     := AParams.Values['Target'] = 'Mic';
  btSetup.SwitchOn   := AParams.Values['Target'] = 'Setup';
end;

procedure TfmMain.SwitchButtonbtClick(Sender: TObject);
var
  SwitchButton : TSwitchButton absolute Sender;
begin
  if Sender <> btMonitor then btMonitor.SwitchOn := false;
  if Sender <> btMic     then btMic.SwitchOn     := false;
  if Sender <> btSetup   then btSetup.SwitchOn   := false;

  if not SwitchButton.SwitchOn then begin
    TCore.Obj.View.sp_ShowOptionControl(SwitchButton.HelpKeyword)
  end else begin
    TCore.Obj.View.sp_ShowOptionControl('');
  end;
end;

end.

