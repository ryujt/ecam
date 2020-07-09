unit _frMonitor;

interface

uses
  FrameBase, JsonData,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.StdCtrls;

type
  TfrMonitor = class(TFrame, IFrameBase)
    Image: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    rbRegion: TRadioButton;
    rbFull: TRadioButton;
    rbWindow: TRadioButton;
    Label4: TLabel;
    procedure SelectCaptureSource(Sender: TObject);
  private
    procedure BeforeShow;
    procedure AfterShow;
    procedure BeforeClose;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure rp_ShowOptionControl(AParams:TJsonData);
  end;

implementation

uses
  Core;

{$R *.dfm}

{ TfrMonitor }

procedure TfrMonitor.AfterShow;
begin

end;

procedure TfrMonitor.BeforeShow;
begin

end;

procedure TfrMonitor.BeforeClose;
begin

end;

constructor TfrMonitor.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfrMonitor.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfrMonitor.SelectCaptureSource(Sender: TObject);
begin
  TCore.Obj.View.sp_SetSelectRegionVisible(rbRegion.Checked);
  TCore.Obj.View.sp_SetSelectWindowVisible(rbWindow.Checked);
end;

procedure TfrMonitor.rp_ShowOptionControl(AParams: TJsonData);
begin
  rbFull.Checked := true;
  Visible := AParams.Values['Target'] = HelpKeyword;
end;

end.