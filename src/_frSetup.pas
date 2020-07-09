unit _frSetup;

interface

uses
  FrameBase, JsonData,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrSetup = class(TFrame, IFrameBase)
    Label1: TLabel;
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

{ TfrSetup }

procedure TfrSetup.AfterShow;
begin

end;

procedure TfrSetup.BeforeShow;
begin

end;

procedure TfrSetup.BeforeClose;
begin

end;

constructor TfrSetup.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfrSetup.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfrSetup.rp_ShowOptionControl(AParams: TJsonData);
begin
  Visible := AParams.Values['Target'] = HelpKeyword;
end;

end.