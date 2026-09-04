unit main;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtDlgs, StdCtrls, MyTest, BinInfo;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CalendarDialog1: TCalendarDialog;
    ColorDialog1: TColorDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage('Hi again!');
  CalendarDialog1.Execute();
  ColorDialog1.Execute();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ShowMessage(GetAppMessage());
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  P: PChar;
  S: String;
begin
  P := bininfo_analyze('/usr/bin/ls');
  if P <> nil then
  begin
    S := String(P);
    ShowMessage(S);
    bininfo_free(P);
  end;
end;

end.

