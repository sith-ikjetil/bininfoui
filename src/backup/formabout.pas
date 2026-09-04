unit FormAbout;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFormAbout }

  TFormAbout = class(TForm)
    ButtonOK: TButton;
    ImageAbout: TImage;
    LabelTribute: TLabel;
    LabelVersion: TLabel;
    LabelInfo: TLabel;
    LabelAppName: TLabel;
  private

  public

  end;

var
  FAbout: TFormAbout;

implementation

{$R *.lfm}

end.

