unit DeviceList;

interface

uses
  DebugTools, Strg, Disk, AsyncTasks,
  Windows, SysUtils, Classes;

type
  TDeviceList = class
  private
    FResultList : string;
    FVideoList : TStringList;
    FAudioList : TStringList;
    procedure parseList(AResult:string);
  private
    function GetDefaultAudioName: string;
    function GetDefaultVideoId: string;
    function GetDefaultVideoName: string;
    function GetDefaultAudioId: string;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TDeviceList;

    procedure Update;

    property DefaultVideoName : string read GetDefaultVideoName;
    property DefaultVideoId : string read GetDefaultVideoId;

    property DefaultAudioName : string read GetDefaultAudioName;
    property DefaultAudioId : string read GetDefaultAudioId;
  end;

implementation

uses
  Core;

{ TDeviceList }

var
  MyObject : TDeviceList = nil;

class function TDeviceList.Obj: TDeviceList;
begin
  if MyObject = nil then MyObject := TDeviceList.Create;
  Result := MyObject;
end;

procedure TDeviceList.parseList(AResult: string);
var
  i: Integer;
  deviceName : string;
  deviceId : string;
  strList : TStringList;
  deviceList : TStringList;
begin
  strList := TStringList.Create;
  try
    strList.StrictDelimiter := true;
    strList.Delimiter := '[';
    strList.DelimitedText := AResult;

    deviceList := FVideoList;
    for i := 0 to strList.Count-1 do begin
      if Pos('dshow', strList[i]) < 1 then Continue;

      if Pos('DirectShow video devices', strList[i]) > 0 then deviceList := FVideoList;
      if Pos('DirectShow audio devices', strList[i]) > 0 then deviceList := FAudioList;

      if Pos(']  "', strList[i]) > 0 then deviceName := MiddleStr(strList[i], '"', '"');
      if Pos('Alternative name', strList[i]) > 0 then begin
        Trace(strList[i]);
        deviceId := MiddleStr(strList[i], '"', '"');
        deviceList.Values[deviceName] := deviceId;
      end;
    end;
  finally
    StrList.Free;
  end;
end;

procedure TDeviceList.Update;
begin
  TCore.Obj.View.sp_DeviceListUpdating;

  FResultList := '';
  FVideoList.Clear;
  FAudioList.Clear;

  AsyncTask(
    procedure (AUserData:pointer)
    var
      DeviceList : TDeviceList absolute AUserData;
    begin
      try
        FResultList := GetDosOutput(GetExecPath+'ffmpeg.exe', '-list_devices true -f dshow -i dummy', GetExecPath);
      except
        Trace('TDeviceList.Update - GetDosOutput');
      end;
    end,

    procedure (AUserData:pointer)
    var
      DeviceList : TDeviceList absolute AUserData;
    begin
      parseList(DeviceList.FResultList);
      Trace(DefaultVideoId);
      Trace(DefaultAudioId);
      TCore.Obj.View.sp_DeviceListUpdated(FVideoList.Text, FAudioList.Text);
    end,

    Self
  );
end;

constructor TDeviceList.Create;
begin
  inherited;

  FVideoList := TStringList.Create;
  FAudioList := TStringList.Create;

  Update;
end;

destructor TDeviceList.Destroy;
begin
  FreeAndNil(FVideoList);
  FreeAndNil(FAudioList);

  inherited;
end;

function TDeviceList.GetDefaultAudioId: string;
begin
  if FAudioList.Count > 0 then Result := FAudioList.ValueFromIndex[0]
  else Result := '';
end;

function TDeviceList.GetDefaultAudioName: string;
begin
  if FAudioList.Count > 0 then Result := FAudioList.Names[0]
  else Result := '';
end;

function TDeviceList.GetDefaultVideoId: string;
begin
  if FVideoList.Count > 0 then Result := FVideoList.ValueFromIndex[0]
  else Result := '';
end;

function TDeviceList.GetDefaultVideoName: string;
begin
  if FVideoList.Count > 0 then Result := FVideoList.Names[0]
  else Result := '';
end;

initialization
  MyObject := TDeviceList.Create;
end.
