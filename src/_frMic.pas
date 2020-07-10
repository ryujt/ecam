unit _frMic;

interface

uses
  FrameBase, JsonData, AudioDevice, Strg,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrMic = class(TFrame)
    cbSystemAudio: TCheckBox;
    cbMic: TComboBox;
    Label1: TLabel;
    procedure cbMicKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbMicKeyPress(Sender: TObject; var Key: Char);
    procedure cbMicDropDown(Sender: TObject);
    procedure cbSystemAudioClick(Sender: TObject);
    procedure cbMicChange(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    procedure rp_ShowOptionControl(AParams:TJsonData);
  end;

implementation

uses
  Core, Options;

{$R *.dfm}

{ TfrMic }

function delete_whitespace(const text:string):string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(text) do
    if text[i] <> ' ' then Result := Result + text[i];
end;

function is_device_in_the_list(list:TStrings; name:string):boolean;
var
  i: Integer;
begin
  Result := false;

  name := delete_whitespace(name);
  for i := 0 to list.Count-1 do
    if name = delete_whitespace(list[i]) then begin
      Result := true;
      Exit;
    end;
end;

procedure TfrMic.cbMicChange(Sender: TObject);
begin
  TOptions.Obj.AudioOption.Mic := -1;

  if cbMic.ItemIndex > -1 then begin
    TOptions.Obj.AudioOption.Mic := Integer(cbMic.Items.Objects[cbMic.ItemIndex]);
  end;
end;

procedure TfrMic.cbMicDropDown(Sender: TObject);
var
  i: Integer;
  device_name : string;
begin
  cbMic.Items.Clear;
  cbMic.Items.AddObject('기본 장치', TObject(-1));

  LoadAudioDeviceList;
  for i := 0 to GetAudioDeviceCount-1 do begin
    device_name := Trim(GetAudioDeviceName(i));

    if GetAudioDeviceInputChannels(i) = 0 then Continue;
    if is_device_in_the_list(cbMic.Items, device_name) then Continue;
    if Pos('@', device_name) > 0 then Continue;

    cbMic.Items.AddObject(device_name, TObject(i));
  end;
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

procedure TfrMic.cbSystemAudioClick(Sender: TObject);
begin
  TOptions.Obj.AudioOption.SystemAudio := cbSystemAudio.Checked;
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