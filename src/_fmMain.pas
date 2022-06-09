unit _fmMain;

interface

uses
  JsonData, Magnetic, Disk, FFmpegController, ProcessUtils,
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
    btMinimize: TBitmapButton;
    Params: TMemo;
    procedure btCloseClick(Sender: TObject);
    procedure btRecordChanged(Sender: TObject);
    procedure SwitchButtonbtClick(Sender: TObject);
    procedure btHomeClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btMinimizeClick(Sender: TObject);
    procedure lbTitleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FProcessList : TProcessList;
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
  Core, Options, DeviceList;

{$R *.dfm}

procedure TfmMain.btCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.btHomeClick(Sender: TObject);
begin
  ShellExecuteFile('http://e-cam.s3-website.ap-northeast-2.amazonaws.com/', '', '')
end;

procedure TfmMain.btMinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TfmMain.btRecordChanged(Sender: TObject);
begin
  if btRecord.SwitchOn and  TOptions.Obj.MinimizeOnRecording then Application.Minimize;
  
  if btRecord.SwitchOn then begin
//    if TOptions.Obj.ScreenOption.CanCapture = false then begin
//      MessageDlg('ĸ���� �����찡 ���õ��� �ʾҽ��ϴ�.', mtError, [mbOK], 0);
//      btRecord.SwitchOn := false;
//      TCore.Obj.View.sp_ShowOptionControl('Monitor');
//      Exit;
//    end;
//
//    if open_ffmpeg(TOptions.Obj.FFmpegControllerParams) = false then begin
//      MessageDlg('��ȭ �غ� ���� ������ �߻��Ͽ����ϴ�.', mtError, [mbOK], 0);
//      btRecord.SwitchOn := false;
//      Exit;
//    end;

    Params.Text := TOptions.Obj.FFmpegExecuteParams;

    // TODO: ���� ó��
    ShellExecuteHide(GetExecPath+'ffmpeg.exe', TOptions.Obj.FFmpegExecuteParams, GetExecPath);
  end else begin
    do_close_ffmpeg;
  end;

  TCore.Obj.View.sp_OnAir(btRecord.SwitchOn);

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

  FProcessList := TProcessList.Create;

  TCore.Obj.View.Add(Self);
end;

destructor TfmMain.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  FreeAndNil(FProcessList);

  inherited;
end;

procedure TfmMain.do_close_ffmpeg;
begin
  // TODO: �ڵ�� ���̱�
  FProcessList.Update;
  FProcessList.KillByName('ffmpeg.exe');

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
    result := MessageDlg('��ȭ���Դϴ�. �����Ͻðڽ��ϱ�?', mtConfirmation, [mbYes, mbNo], 0);
    if result <> mrYes then begin
      Action := caNone;
      Exit;
    end;

    do_close_ffmpeg;
  end;

  TOptions.Obj.SaveToFile;
end;

procedure TfmMain.lbTitleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  Perform(WM_SysCommand, $F012, 0);
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

