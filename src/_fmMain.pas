unit _fmMain;

interface

uses
  JsonData, Magnetic, Disk,
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
    procedure btCloseClick(Sender: TObject);
    procedure btRecordChanged(Sender: TObject);
    procedure SwitchButtonbtClick(Sender: TObject);
    procedure btHomeClick(Sender: TObject);
  private
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
  Core;

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
  if btRecord.SwitchOn then begin
    // TODO:
  end else begin
    //
  end;

  btMonitor.Enabled := not btRecord.SwitchOn;
  btMic.Enabled     := not btRecord.SwitchOn;
  btSetup.Enabled   := not btRecord.SwitchOn;
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

procedure TfmMain.rp_ShowOptionControl(AParams: TJsonData);
begin
  if AParams.Values['Target'] = '' then btMonitor.SwitchOn := false;
end;

procedure TfmMain.SwitchButtonbtClick(Sender: TObject);
var
  SwitchButton : TSwitchButton absolute Sender;
begin
  if btRecord.SwitchOn then Exit;

  if Sender <> btMonitor then btMonitor.SwitchOn := false;
  if Sender <> btMic     then btMic.SwitchOn     := false;
  if Sender <> btSetup   then btSetup.SwitchOn   := false;

  if not SwitchButton.SwitchOn then
    TCore.Obj.View.sp_ShowOptionControl(SwitchButton.HelpKeyword)
  else
    TCore.Obj.View.sp_ShowOptionControl('');
end;

end.



