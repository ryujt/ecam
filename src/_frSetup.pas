unit _frSetup;

interface

uses
  FrameBase, JsonData,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrSetup = class(TFrame)
    Label1: TLabel;
    cbYouTube: TCheckBox;
    edStreamKey: TEdit;
  private
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