unit _fmOptions;

interface

uses
  JsonData, Magnetic,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, BitmapWindow,
  _frSetup, _frMic, _frMonitor;

type
  TfmOptions = class(TMagneticSubForm)
    BitmapWindow: TBitmapWindow;
    plClient: TPanel;
    frMonitor: TfrMonitor;
    frMic: TfrMic;
    frSetup: TfrSetup;
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure rp_ShowOptionControl(AParams:TJsonData);
  end;

var
  fmOptions: TfmOptions;

implementation

uses
  Core, Options;

{$R *.dfm}

constructor TfmOptions.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfmOptions.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfmOptions.rp_ShowOptionControl(AParams: TJsonData);
begin
  Caption := AParams.Text;

  if AParams.Values['Target'] = '' then begin
    Close;
    Exit;
  end;

  Left := Application.MainForm.Left;
  Top  := Application.MainForm.Top + Application.MainForm.Height;

  Show;
end;

end.
