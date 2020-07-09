unit _frMic;

interface

uses
  FrameBase, JsonData,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrMic = class(TFrame, IFrameBase)
    cbSystemAudio: TCheckBox;
    cbMic: TComboBox;
    Label1: TLabel;
    procedure cbMicKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbMicKeyPress(Sender: TObject; var Key: Char);
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

{ TfrMic }

procedure TfrMic.AfterShow;
begin

end;

procedure TfrMic.BeforeShow;
begin

end;

procedure TfrMic.cbMicKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key := 0;
end;

procedure TfrMic.cbMicKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TfrMic.BeforeClose;
begin

end;

constructor TfrMic.Create(AOwner: TComponent);
begin
  inherited;

  TCore.Obj.View.Add(Self);
end;

destructor TfrMic.Destroy;
begin
  TCore.Obj.View.Remove(Self);

  inherited;
end;

procedure TfrMic.rp_ShowOptionControl(AParams: TJsonData);
begin
  Visible := AParams.Values['Target'] = HelpKeyword;
end;

end.