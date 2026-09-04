program bininfoui;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, FormMain, MyTest, BinInfo, FormAbout;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='bininfoui';
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TFormMain, FMain);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.Run;
end.

