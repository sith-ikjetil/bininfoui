unit FormMain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Menus, BinInfo, Types, Clipbrd, FormAbout;

type

  { TFormMain }

  TFormMain = class(TForm)
    ButtonAnalyzeFile: TButton;
    ComboBoxAnalyzeArgs: TComboBox;
    EditAnalyzeFile: TEdit;
    LabelResult: TLabel;
    LabelOptions: TLabel;
    LabelFileName: TLabel;
    MainMenu: TMainMenu;
    MemoAnalyzeResult: TMemo;
    MenuItemRootFile: TMenuItem;
    MenuItemRootHelp: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemFileExit: TMenuItem;
    MenuItemCopy: TMenuItem;
    OpenDialogAnalyzeFile: TOpenDialog;
    PopupMenuAnalyzeResult: TPopupMenu;
    procedure ButtonAnalyzeFileClick(Sender: TObject);
    procedure ComboBoxAnalyzeArgsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MemoAnalyzeResultContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemFileExitClick(Sender: TObject);
    procedure MenuItemCopyClick(Sender: TObject);
    function GetIncExports(): Boolean;
    function GetIncImports(): Boolean;
    function GetIncSections(): Boolean;
  private

  public

  end;

var
  FMain: TFormMain;
  bFileIsAnalyzed: Boolean;

implementation

{$R *.lfm}

{ TFormMain }

//
// Function: AnalyzeFile
//
// (i): Analyzes file.
//
function AnalyzeFile(filename: String; incExports: Boolean; incImports: Boolean; incSections: Boolean) : String;
var
  P: PChar;
begin
  P := bininfo_analyze_json(PChar(filename), incExports, incImports, incSections);
  if P <> nil then
  begin
    Result := String(P);
    bininfo_free(P);
  end
  else
    Result := '';
end;
//
// Function: TFormMain.ButtonAnalyzeFileClick
//
// (i): Handles Analyze File... button click.
//
procedure TFormMain.ButtonAnalyzeFileClick(Sender: TObject);
begin
  if OpenDialogAnalyzeFile.Execute then
  begin
    bFileIsAnalyzed := true;
    EditAnalyzeFile.Text := OpenDialogAnalyzeFile.FileName;
    MemoAnalyzeResult.Text := AnalyzeFile(OpenDialogAnalyzeFile.FileName, GetIncExports(), GetIncImports(), GetIncSections());
    MemoAnalyzeResult.PopupMenu := PopupMenuAnalyzeResult;
  end;
end;
//
// Procedure: TFormMain.ComboBoxAnalyzeArgsChange
//
// (i): ComboBox options change handler updating information.
//
procedure TFormMain.ComboBoxAnalyzeArgsChange(Sender: TObject);
begin
  if Length(EditAnalyzeFile.Text) > 0 then
  begin
    MemoAnalyzeResult.Text := AnalyzeFile(EditAnalyzeFile.Text, GetIncExports(), GetIncImports(), GetIncSections());
    MemoAnalyzeResult.PopupMenu := PopupMenuAnalyzeResult;
  end;
end;
//
// Function: TFormMain.FormCreate
//
// (i): Initialization of things.
//
procedure TFormMain.FormCreate(Sender: TObject);
begin
     bFileIsAnalyzed := false;
     MemoAnalyzeResult.Text := '';
end;
//
// Function: TFormMain.FormResize
//
// (i): Handles form control resizes.
//
procedure TFormMain.FormResize(Sender: TObject);
const
  Margin = 8;
  Gap = 8;
begin
  LabelFileName.Top := Gap;
  LabelFileName.Height := 18;

  EditAnalyzeFile.Left := Margin;
  EditAnalyzeFile.Top := LabelFileName.Height + Margin + Gap;
  EditAnalyzeFile.Width := ClientWidth - ButtonAnalyzeFile.Width - (Margin * 2) - Gap;

  ButtonAnalyzeFile.Left := EditAnalyzeFile.Left + EditAnalyzeFile.Width + Gap;
  ButtonAnalyzeFile.Top := LabelFileName.Height + Margin + Gap;

  LabelOptions.Top := EditAnalyzeFile.Top + EditAnalyzeFile.Height + Gap;
  LabelOptions.Height := 18;

  ComboBoxAnalyzeArgs.Left := Margin;
  ComboBoxAnalyzeArgs.Top := LabelOptions.Top + LabelOptions.Height + Gap;
  ComboBoxAnalyzeArgs.Width :=
    ClientWidth - ButtonAnalyzeFile.Width - (Margin * 2) - Gap;

  LabelResult.Top := ComboBoxAnalyzeArgs.Top + ComboBoxAnalyzeArgs.Height + Gap;
  LabelResult.Height := 18;

  MemoAnalyzeResult.Left := Margin;
  MemoAnalyzeResult.Top := LabelResult.Top + LabelResult.Height + Gap;

  MemoAnalyzeResult.Width :=
    ClientWidth - (Margin * 2);

  MemoAnalyzeResult.Height :=
    ClientHeight - MemoAnalyzeResult.Top - Margin;
end;
//
// Procedure: TFormMain.MemoAnalyzeResultContextPopup
//
// (i): Handler right click context menu popup handled or not.
//
procedure TFormMain.MemoAnalyzeResultContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  if not bFileIsAnalyzed then
    Handled := true;
end;
//
// Procedure: TFormMain.MenuItemAboutClick
//
// (i): Creates and shows the about dialog.
//
procedure TFormMain.MenuItemAboutClick(Sender: TObject);
var
  AboutForm: TFormAbout;
begin
  AboutForm := TFormAbout.Create(Self);
  try
    AboutForm.ShowModal;
  finally
    AboutForm.Free;
  end;
end;
//
// Procedure: TFormMain.MenuItemFileExitClick
//
// (i): Terminates the application.
//
procedure TFormMain.MenuItemFileExitClick(Sender: TObject);
begin
     Application.Terminate();
end;
//
// Procedure: TFormMain.MenuItemCopyClick
//
// (i): Handle copy click in popup menu.
//
procedure TFormMain.MenuItemCopyClick(Sender: TObject);
begin
  if MemoAnalyzeResult.SelLength > 0 then
      Clipboard.AsText := MemoAnalyzeResult.SelText
    else
      Clipboard.AsText := MemoAnalyzeResult.Text;
end;
//
// Function: TFormMain.GetIncExports
//
// (i): Returnes bool true/false if include exports is set in current combobox.
//
function TFormMain.GetIncExports(): Boolean;
begin
     Result := Pos('--include-exports',ComboBoxAnalyzeArgs.Text) > 0;
end;
//
// Function: TFormMain.GetIncImports
//
// (i): Returnes bool true/false if include imports is set in current combobox.
//
function TFormMain.GetIncImports(): Boolean;
begin
  Result := Pos('--include-imports', ComboBoxAnalyzeArgs.Text) > 0;
end;
//
// Function: TFormMain.GetIncSections
//
// (i): Returnes bool true/false if include sections is set in current combobox.
//
function TFormMain.GetIncSections(): Boolean;
begin
  Result := Pos('--include-sections', ComboBoxAnalyzeArgs.Text) > 0;
end;


end.

