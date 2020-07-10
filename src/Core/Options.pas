unit Options;

interface

uses
  Windows,
  SysUtils, Classes;

type
  TScreenSource = (ssRegion, ssFull, ssWindow);

  TScreenOption = record
  private
    FScreenSource : TScreenSource;
    FLeft, FTop, FWidth, FHeight : integer;
    FTargetWindow : THandle;
    function GetLeft: integer;
    function GetTop: integer;
    function GetCanCapture: boolean;
  public
    WithCursor : boolean;
    procedure Init;
    procedure SetScreenRegion(ALeft,ATop,AWidth,AHeight:integer);
    procedure SetFullScreen;
    procedure SetTargetWindow(const Value: THandle);
  public
    property CanCapture : boolean read GetCanCapture;
    property ScreenSource : TScreenSource read FScreenSource;
    property Left : integer read GetLeft;
    property Top : integer read GetTop;
    property Width : integer read FWidth;
    property Height : integer read FHeight;
    property TargetWindow : THandle read FTargetWindow;
  end;

  TAudioOption = record
    Mic : integer;
    SystemAudio : boolean;
    VolumeMic : real;
    VvolumeSystem : real;
    procedure Init;
  end;

  TYouTubeOption = record
    OnAir : boolean;
    StreamKey : string;
    procedure Init;
  end;

  TOptions = class
  private
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TOptions;

    procedure SaveToFile;
  public
    ScreenOption : TScreenOption;
    AudioOption : TAudioOption;
    YouTubeOption : TYouTubeOption;
  end;

implementation

{ TScreenOption }

function TScreenOption.GetCanCapture: boolean;
begin
  Result := not ((FScreenSource = ssWindow) and (FTargetWindow = 0));
end;

function TScreenOption.GetLeft: integer;
var
  WindowRect : TRect;
begin
  Result := FLeft;

  if FTargetWindow > 0 then begin
    GetWindowRect(FTargetWindow, WindowRect);
    Result  := WindowRect.Left;
  end;
end;

function TScreenOption.GetTop: integer;
var
  WindowRect : TRect;
begin
  Result := FTop;

  if FTargetWindow > 0 then begin
    GetWindowRect(FTargetWindow, WindowRect);
    Result  := WindowRect.Top;
  end;
end;

procedure TScreenOption.Init;
begin
  FScreenSource := ssFull;
  FLeft := 0;
  FTop := 0;
  FWidth := 0;
  FHeight := 0;
  FTargetWindow := 0;
  WithCursor := true;
end;

procedure TScreenOption.SetFullScreen;
begin
  FScreenSource := ssFull;
  FLeft := 0;
  FTop := 0;
  FWidth := GetSystemMetrics(SM_CXSCREEN);
  FHeight := GetSystemMetrics(SM_CYSCREEN);
  FTargetWindow := 0;
end;

procedure TScreenOption.SetScreenRegion(ALeft, ATop, AWidth, AHeight: integer);
begin
  FScreenSource := ssRegion;
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
  FTargetWindow := 0;
end;

procedure TScreenOption.SetTargetWindow(const Value: THandle);
var
  WindowRect : TRect;
begin
  FScreenSource := ssWindow;

  FTargetWindow := Value;

  if FTargetWindow > 0 then begin
    GetWindowRect(FTargetWindow, WindowRect);
    FWidth  := WindowRect.Width;
    FHeight := WindowRect.Height;
  end;
end;

{ TAudioOption }

procedure TAudioOption.Init;
begin
  Mic := -1;
  SystemAudio := false;
  VolumeMic := 1.0;
  VvolumeSystem := 1.0;
end;

{ TYouTubeOption }

procedure TYouTubeOption.Init;
begin
  OnAir := false;
  StreamKey := '';
end;

{ TOptions }

var
  MyObject : TOptions = nil;

class function TOptions.Obj: TOptions;
begin
  if MyObject = nil then MyObject := TOptions.Create;
  Result := MyObject;
end;

procedure TOptions.SaveToFile;
begin
 // TODO:
end;

constructor TOptions.Create;
begin
  inherited;

end;

destructor TOptions.Destroy;
begin

  inherited;
end;

initialization
  MyObject := TOptions.Create;
  MyObject.ScreenOption.Init;
  MyObject.YouTubeOption.Init;
end.
