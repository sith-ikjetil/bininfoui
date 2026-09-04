unit BinInfo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ctypes;

const
  LIBBININFO = 'libbininfo.so';

  function bininfo_analyze_json(filename: PChar; incExports: Boolean; incImports: Boolean; incSections: Boolean): PChar; cdecl;
    external LIBBININFO name 'bininfo_analyze_json';

  function bininfo_version: cint; cdecl;
    external LIBBININFO name 'bininfo_version';

  procedure bininfo_free(p: PChar); cdecl;
    external LIBBININFO name 'bininfo_free';

implementation

end.

