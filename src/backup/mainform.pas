unit mainForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtDlgs, StdCtrls,
  Menus, BinInfo, Types, Clipbrd;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonAnalyzeFile: TButton;
    EditAnalyzeFile: TEdit;
    MemoAnalyzeResult: TMemo;
    MenuItemCopy: TMenuItem;
    OpenDialogAnalyzeFile: TOpenDialog;
    PopupMenuAnalyzeResult: TPopupMenu;
    procedure ButtonAnalyzeFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MemoAnalyzeResultContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MenuItemCopyClick(Sender: TObject);
  private

  public

  end;

var
  FormMain: TFormMain;
  bFileIsAnalyzed: Boolean;


implementation

{$R *.lfm}

{ TFormMain }

function AnalyzeFile(filename: String) : String;
var
  P: PChar;
  S: String;
begin
  P := bininfo_analyze(PChar(filename), false, false, false);
  if P <> nil then
  begin
    Result := String(P);
    bininfo_free(P);
  end
  else
    Result := '';
end;

procedure TFormMain.ButtonAnalyzeFileClick(Sender: TObject);
begin
  if OpenDialogAnalyzeFile.Execute then
  begin
    bFileIsAnalyzed := true;
    EditAnalyzeFile.Text := OpenDialogAnalyzeFile.FileName;
    MemoAnalyzeResult.Text := AnalyzeFile(OpenDialogAnalyzeFile.FileName);
    MemoAnalyzeResult.PopupMenu := PopupMenuAnalyzeResult;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
     bFileIsAnalyzed := false;
     MemoAnalyzeResult.Text := '';
end;

procedure TFormMain.FormResize(Sender: TObject);
const
  Margin = 8;
  Gap = 8;
begin
  EditAnalyzeFile.Left := Margin;
  EditAnalyzeFile.Top := Margin;
  EditAnalyzeFile.Width :=
    ClientWidth - ButtonAnalyzeFile.Width - (Margin * 2) - Gap;

  ButtonAnalyzeFile.Left :=
    EditAnalyzeFile.Left + EditAnalyzeFile.Width + Gap;
  ButtonAnalyzeFile.Top := Margin;

  MemoAnalyzeResult.Left := Margin;
  MemoAnalyzeResult.Top :=
    EditAnalyzeFile.Top + EditAnalyzeFile.Height + Gap;

  MemoAnalyzeResult.Width :=
    ClientWidth - (Margin * 2);

  MemoAnalyzeResult.Height :=
    ClientHeight - MemoAnalyzeResult.Top - Margin;
end;

procedure TFormMain.MemoAnalyzeResultContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  if not bFileIsAnalyzed then
    Handled := true;
end;

procedure TFormMain.MenuItemCopyClick(Sender: TObject);
begin
  if MemoAnalyzeResult.SelLength > 0 then
      Clipboard.AsText := MemoAnalyzeResult.SelText
    else
      Clipboard.AsText := MemoAnalyzeResult.Text;
end;



end.

