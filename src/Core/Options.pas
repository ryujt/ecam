unit Options;

interface

uses
  Strg,
  Windows, SysUtils, Classes, Dialogs;

type
  TScreenSource = (ssRegion, ssFull, ssWindow);

  TScreenOption = record
  strict private
    FScreenSource : TScreenSource;
    FLeft, FTop, FWidth, FHeight : integer;
    FTargetWindow : integer;
    function GetLeft: integer;
    function GetTop: integer;
    function GetCanCapture: boolean;
  public
    WithCursor : boolean;
    procedure Init;
    procedure SetScreenRegion(ALeft,ATop,AWidth,AHeight:integer);
    procedure SetFullScreen;
    procedure SetTargetWindow(const Value: integer);
  private
    function GetBitmapHeight: integer;
    function GetBitmapWidth: integer;
  public
    property CanCapture : boolean read GetCanCapture;
    property ScreenSource : TScreenSource read FScreenSource;
    property Left : integer read GetLeft;
    property Top : integer read GetTop;
    property Width : integer read FWidth;
    property Height : integer read FHeight;
    property BitmapWidth : integer read GetBitmapWidth;
    property BitmapHeight : integer read GetBitmapHeight;
    property TargetWindow : integer read FTargetWindow;
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
    FRID : string;
    FVideoFilename : string;
    function GetFFmpegExecuteParams: string;
    function GetFFmpegControllerParams: string;
  public
    constructor Create;
    destructor Destroy; override;

    class function Obj:TOptions;

    procedure SaveToFile;
  public
    ScreenOption : TScreenOption;
    AudioOption : TAudioOption;
    YouTubeOption : TYouTubeOption;

    property VideoFilename : string read FVideoFilename;

    property FFmpegControllerParams: string read GetFFmpegControllerParams;
    property FFmpegExecuteParams: string read GetFFmpegExecuteParams;
  end;

implementation

{ TScreenOption }

function TScreenOption.GetBitmapHeight: integer;
const BITMAP_CELL_HEIGHT = 2;
begin
  Result := FHeight;
  if (Result mod BITMAP_CELL_HEIGHT) <> 0 then Result := Result + BITMAP_CELL_HEIGHT - (Result mod BITMAP_CELL_HEIGHT);
end;

function TScreenOption.GetBitmapWidth: integer;
const BITMAP_CELL_WIDTH = 8;
begin
  Result := FWidth;
  if (Result mod BITMAP_CELL_WIDTH) <> 0 then Result := Result + BITMAP_CELL_WIDTH - (Result mod BITMAP_CELL_WIDTH);
end;

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
  FTargetWindow := -1;
  WithCursor := true;
end;

procedure TScreenOption.SetFullScreen;
begin
  FScreenSource := ssFull;
  FLeft := 0;
  FTop := 0;
  FWidth := GetSystemMetrics(SM_CXSCREEN);
  FHeight := GetSystemMetrics(SM_CYSCREEN);
  FTargetWindow := -1;
end;

procedure TScreenOption.SetScreenRegion(ALeft, ATop, AWidth, AHeight: integer);
begin
  FScreenSource := ssRegion;
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
  FTargetWindow := -1;
end;

procedure TScreenOption.SetTargetWindow(const Value: integer);
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

  FRID := RandomStr(16);
  FVideoFilename := RandomStr(16) + '.mp4';
end;

destructor TOptions.Destroy;
begin

  inherited;
end;

function TOptions.GetFFmpegControllerParams: string;
const
  fmt : string = '{"rid": "%s", "mic": %d, "system-audio": %s, "volume-mic": %f, "volume-system": %f, "window-handle": %d, "speed": "%s", "left": %d, "top": %d, "width": %d, "height": %d, "with-cursor": %s}';
begin
  Result := Format(fmt,
    [
       FRID, AudioOption.Mic, LowerCase(BoolToStr(AudioOption.SystemAudio, true)), AudioOption.VolumeMic, AudioOption.VvolumeSystem,
       ScreenOption.TargetWindow, 'veryfast', ScreenOption.Left, ScreenOption.Top, ScreenOption.Width, ScreenOption.Height, LowerCase(BoolToStr(ScreenOption.WithCursor, true))
    ]
  );
end;

function TOptions.GetFFmpegExecuteParams: string;
const
  fmt_live : string = '-framerate 20 -f rawvideo -pix_fmt rgb32 -video_size %dx%d -i \\.\pipe\video-%s -f f32le -acodec pcm_f32le -ar 44100 -ac 1 -i \\.\pipe\audio-%s -f flv rtmp://a.rtmp.youtube.com/live2/%s';
  fmt_file : string = '-framerate 20 -f rawvideo -pix_fmt rgb32 -video_size %dx%d -i \\.\pipe\video-%s -f f32le -acodec pcm_f32le -ar 44100 -ac 1 -i \\.\pipe\audio-%s %s';
begin
  if YouTubeOption.OnAir then begin
    Result := Format(fmt_live,
      [ScreenOption.BitmapWidth, ScreenOption.BitmapHeight, FRID, FRID, YouTubeOption.StreamKey]
    );
  end else begin
    FVideoFilename := RandomStr(16) + '.mp4';
    Result := Format(fmt_file,
      [ScreenOption.BitmapWidth, ScreenOption.BitmapHeight, FRID, FRID, FVideoFilename]
    );
  end;
end;

initialization
  MyObject := TOptions.Create;
  MyObject.AudioOption.Init;
  MyObject.ScreenOption.Init;
  MyObject.ScreenOption.SetFullScreen;
  MyObject.YouTubeOption.Init;
end.


// ffmpeg -framerate 20 -f rawvideo -pix_fmt rgb32 -video_size 1920x1080 -i \\.\pipe\video-1234 -f f32le -acodec pcm_f32le -ar 44100 -ac 1 -i \\.\pipe\audio-1234 test.mp4
// ffmpeg -framerate 10 -f rawvideo -pix_fmt rgb32 -video_size 1920x1080 -i \\.\pipe\pipe-video -f s16le -acodec pcm_s16le -ar 44100 -ac 1 -i \\.\pipe\pipe-audio -f flv rtmp://a.rtmp.youtube.com/live2/62eu-pfcr-y6g5-1tp7-cq8j

