unit MyTest;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

function GetAppMessage() : String;

implementation

function GetAppMessage() : String;
begin
  GetAppMessage := 'Message from me!';
end;

end.

