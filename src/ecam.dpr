program ecam;

uses
  Vcl.Forms,
  _fmMain in '_fmMain.pas' {fmMain},
  _fmOptions in '_fmOptions.pas' {fmOptions},
  View in 'Core\View.pas',
  Core in 'Core\Core.pas',
  _frMonitor in '_frMonitor.pas' {frMonitor: TFrame},
  _frMic in '_frMic.pas' {frMic: TFrame},
  _frSetup in '_frSetup.pas' {frSetup: TFrame},
  _fmSelectRegion in '_fmSelectRegion.pas' {fmSelectRegion},
  _fmSelectWindow in '_fmSelectWindow.pas' {fmSelectWindow},
  Options in 'Core\Options.pas',
  DeviceList in 'Core\DeviceList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Berryful Live - Sender';
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmOptions, fmOptions);
  Application.CreateForm(TfmSelectRegion, fmSelectRegion);
  Application.CreateForm(TfmSelectWindow, fmSelectWindow);
  Application.Run;
end.
