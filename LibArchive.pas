unit LibArchive;

{$mode delphi}{$H+}

interface

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
// Description:	LibArchive - pack/unpack archives with libarchive             //
// Version:	0.1                                                           //
// Date:	26-JUL-2025                                                   //
// License:     MIT                                                           //
// Target:	Win64, Free Pascal, Delphi                                    //
// Copyright:	(c) 2025 Xelitan.com.                                         //
//		All rights reserved.                                          //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

  const LIB_DLL = 'libarchive.dll';

  type
    PArchive = type Pointer;
    PArchiveEntry = type Pointer;
    PBytes = ^TBytes;

  const
    ARCHIVE_OK = 0;
    ARCHIVE_EOF = 1;
    ARCHIVE_WARN = -20;
    ARCHIVE_RETRY = -10;
    ARCHIVE_FATAL = -30;

    AE_IFMT = $F000;
    AE_IFDIR = $4000;

    // Callback types
   type
   TReadCallback = function (archive: PArchive; client_data: Pointer; var buffer: Pointer): Integer; cdecl;
   TSkipCallback = function (archive: PArchive; client_data: Pointer; request: Integer): Int64; cdecl;
   TOpenCallback = function (archive: PArchive; client_data: Pointer): Integer; cdecl;
   TCloseCallback = function (archive: PArchive; client_data: Pointer): Integer; cdecl;
   TWriteCallback = function(archive: PArchive; client_data: Pointer; const buffer: Pointer; length: NativeUInt): NativeInt; cdecl;

   PCloseCallback = ^TCloseCallback;
   PReadCallback = ^TReadCallback;
   PSkipCallback = ^TSkipCallback;
   POpenCallback = ^TOpenCallback;

   TPassCallback = function (archive: PArchive; client_data: Pointer): PAnsiChar; cdecl;
   PPassCallback = ^TPassCallback;

  function archive_read_new: PArchive; cdecl; external LIB_DLL;
  function archive_read_support_format_zip(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_read_support_format_tar(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_read_support_filter_all(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_read_support_format_all(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_read_open_filename(a: PArchive; filename: PAnsiChar; block_size: LongWord): Integer; cdecl; external LIB_DLL;
  function archive_read_next_header(a: PArchive; var entry: PArchiveEntry): Integer; cdecl; external LIB_DLL;
  function archive_entry_pathname(entry: PArchiveEntry): PAnsiChar; cdecl; external LIB_DLL;
  function archive_entry_pathname_w(entry: PArchiveEntry): PWideChar; cdecl; external LIB_DLL;
  function archive_entry_filetype(entry: PArchiveEntry): Integer; cdecl; external LIB_DLL;
  function archive_entry_size(entry: PArchiveEntry): Int64; cdecl; external LIB_DLL;
  function archive_read_data(a: PArchive; buffer: Pointer; size: NativeUInt): Integer; cdecl; external LIB_DLL;
  function archive_read_free(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_read_close(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_read_open(a: PArchive; client_data: Pointer; OpenCallback: POpenCallback; ReadCallback: PReadCallback; CloseCallback: PCloseCallback): Integer; cdecl; external LIB_DLL;

  function archive_read_open2(a: PArchive; client_data: Pointer; OpenCallback: TOpenCallback; ReadCallback: TReadCallback; SkipCallback: TSkipCallback; CloseCallback: TCloseCallback): Integer; cdecl; external LIB_DLL;

  function archive_entry_is_data_encrypted(entry: PArchiveEntry): Integer; cdecl; external LIB_DLL;
  function archive_entry_is_metadata_encrypted(entry: PArchiveEntry): Integer; cdecl; external LIB_DLL;
  function archive_read_add_passphrase(a: PArchive; const passphrase: PAnsiChar): Integer; cdecl; external LIB_DLL;
  function archive_read_has_encrypted_entries(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_entry_is_encrypted(entry: PArchiveEntry): Integer; cdecl; external LIB_DLL;
  function archive_read_set_passphrase_callback(a: PArchive; client_data: Pointer; archive_passphrase_callback: TPassCallback): Integer; cdecl; external LIB_DLL;
  function archive_error_string(pa: PArchive): PAnsiChar; cdecl; external LIB_DLL;

  //=================
  function archive_write_open(a: PArchive; client_data: Pointer; OpenCallback: TOpenCallback; WriteCallback: TWriteCallback; CloseCallback: TCloseCallback): Integer; cdecl; external LIB_DLL;

  function archive_write_set_option(a: PArchive; module: PAnsiChar; option: PAnsiChar; value: PAnsiChar): Integer; cdecl; external LIB_DLL;

  function archive_write_set_passphrase(a: PArchive; const Passphrase: PAnsiChar): Integer; cdecl; external LIB_DLL;

  function archive_write_new(): Parchive; cdecl; external LIB_DLL ;

  function archive_write_set_format_zip(a: Parchive): Integer; cdecl; external LIB_DLL;
  function archive_write_set_format_ustar(a: Parchive): Integer; cdecl; external LIB_DLL;
  function archive_write_set_format_7zip(a: Parchive): Integer; cdecl; external LIB_DLL;

  function archive_write_set_compression_lzma(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_write_set_compression_gzip(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_write_set_compression_bzip2(a: PArchive): Integer; cdecl; external LIB_DLL;
  function archive_write_set_compression_xz(a: PArchive): Integer; cdecl; external LIB_DLL;

  function archive_write_open_filename(a: Parchive; filename: PAnsiChar): Integer; cdecl; external LIB_DLL;
  function archive_entry_new(): Parchiveentry; cdecl; external LIB_DLL;
  procedure archive_entry_set_pathname(entry: Parchiveentry; pathname: PAnsiChar); cdecl; external LIB_DLL;
  procedure archive_entry_set_size(entry: Parchiveentry; size: Int64); cdecl; external LIB_DLL;
  procedure archive_entry_set_filetype(entry: Parchiveentry; filetype: UInt32); cdecl; external LIB_DLL;
  procedure archive_entry_set_perm(entry: Parchiveentry; perm: UInt32); cdecl; external LIB_DLL;
  function archive_write_header(a: Parchive; entry: Parchiveentry): Integer; cdecl; external LIB_DLL;
  function archive_write_data(a: Parchive; buff: Pointer; size: NativeUInt): NativeInt; cdecl; external LIB_DLL;
  procedure archive_entry_free(entry: Parchiveentry); cdecl; external LIB_DLL;
  function archive_write_close(a: Parchive): Integer; cdecl; external LIB_DLL;
  function archive_write_free(a: Parchive): Integer; cdecl; external LIB_DLL;

type
  TFileInfo = record
    Path: String;
    Size: Int64;
    IsDir: Boolean;
  end;

  { TUnpacker }

  TUnpacker = class
  private
    FArchive: PArchive;
    FEncrypted: Boolean;
    FPassword: String;
    FFilename: String;
    F: TFileStream;
    function FormatPath(Path: String): String;
    procedure _Open;
    procedure _Close;
  public
    function IsEncrypted: Boolean;
    procedure SetPassword(Pass: String);
    function NextInfo(out Info: TFileInfo): Boolean;
    function ExtractTo(Str: TStream): Boolean;
    constructor Create(Filename: String);
    destructor Destroy; override;
  end;

  { TPacker }

  TPacker = class
  private
    FArchive: PArchive;
    FPassword: String;
    FFilename: String;
    F: TFileStream;
    FMethod: String;
    FFormat: String;
    FLevel: Byte;
    FOpened: Boolean;
    procedure _Open;
  public
    procedure AddFile(Filename: String; AsFilename: String = '');
    procedure AddDirectory(AsFilename: String);
    procedure SetCompressionLevel(Level: Byte);
    procedure SetPassword(Password: String);
    constructor Create(Filename: String; Format: String = 'zip'; Method: String = '');
    destructor Destroy; override;
  end;

implementation


function PassF(archive: PArchive; client_data: Pointer): PAnsiChar; cdecl;
var Pass: String;
begin
  Pass := '';
  InputBox('Enter password', 'Password', Pass);

  Result := PAnsiChar(AnsiString(Pass));
end;

function ReadF(archive: PArchive; client_data: Pointer; var buffer: Pointer): Integer; cdecl;
type PFileStream = ^TFileStream;
var F: TFileStream;
    Size: Integer;
    buf: TBytes;
begin
  F := TFileStream(client_data);

  GetMem(buffer, 4096);
  Size := F.Read(buffer^, 4096);

  Result := Size;
end;

function OpenF(archive: PArchive; client_data: Pointer): Integer; cdecl;
begin
  Result := 0;
end;

function CloseF(archive: PArchive; client_data: Pointer): Integer; cdecl;
begin
  Result := 0;
end;

function SkipF(archive: PArchive; client_data: Pointer; request: Integer): Int64; cdecl;
var
  Stream: TFileStream;
  NewPos: Int64;
begin
  Stream := TFileStream(client_data);
  NewPos := Stream.Seek(request, soCurrent);
  Result := NewPos - Stream.Position;
end;

{ TUnpacker }

function TUnpacker.FormatPath(Path: String): String;
begin
  Path := StringReplace(Path, '/', '\', [rfReplaceAll]);

  while (Length(Path) > 0) and (Path[1] = '\') do Delete(Path, 1, 1);

  Result := Path;
end;

procedure TUnpacker._Open;
var R: Integer;
begin
  FArchive := archive_read_new();

  if not Assigned(FArchive) then
    raise Exception.Create('Could not initialize reader');

  R := archive_read_support_format_all(FArchive);
  if R <> ARCHIVE_OK then
    raise Exception.Create('Could not initialize decompressor.');

  R := archive_read_support_filter_all(FArchive);
  if R <> ARCHIVE_OK then
    raise Exception.Create('Could not initialize decompressor.');

  F := TFileStream.Create(FFilename, fmOpenRead);

  R := archive_read_open2(FArchive, F, OpenF, ReadF, SkipF, CloseF);
  if R <> ARCHIVE_OK then
    raise Exception.Create('Failed to open archive.');
end;

procedure TUnpacker._Close;
begin
  archive_read_close(FArchive);
  archive_read_free(FArchive);

  F.Free;
end;

function TUnpacker.IsEncrypted: Boolean;
begin
  Result := FEncrypted;
end;

procedure TUnpacker.SetPassword(Pass: String);
begin
  FPassword := Pass;
end;

function TUnpacker.NextInfo(out Info: TFileInfo): Boolean;
var FileType: Integer;
    R: Integer;
    Entry: PArchiveEntry;
begin
  R := archive_read_next_header(FArchive, Entry);
  if R = ARCHIVE_EOF then Exit(False);
  //Err := archive_error_string(FArchive);

  if R = ARCHIVE_FATAL then Exit(False);

  Info.Path := FormatPath(archive_entry_pathname_w(Entry));   //   UTF8ToString

  FileType := archive_entry_filetype(Entry);

  Info.IsDir := (FileType and AE_IFMT) = AE_IFDIR;

  Info.Size := archive_entry_size(Entry);

  Result := True;
end;

function TUnpacker.ExtractTo(Str: TStream): Boolean;
var Buffer: array[0..65535] of Byte;
    BytesRead: Integer;
begin
  repeat
    BytesRead := archive_read_data(FArchive, @Buffer[0], SizeOf(Buffer));

    if BytesRead < 0 then raise Exception.Create('Error reading file data.');

    Str.WriteBuffer(Buffer[0], BytesRead);
  until BytesRead = 0;
end;

constructor TUnpacker.Create(Filename: String);
var R: Integer;
    Entry: PArchiveEntry;
begin
  inherited Create;

  FEncrypted := False;

  FFilename := Filename;
  _Open;

  while True do begin
    R := archive_read_next_header(FArchive, Entry);

    if R = ARCHIVE_EOF then break;
    if R = ARCHIVE_FATAL then break;

    R := archive_entry_is_data_encrypted(Entry);
    if R <> 0 then FEncrypted := True;

    R := archive_entry_is_metadata_encrypted(Entry);
    if R <> 0 then FEncrypted := True;
  end;

  _Close;
  _Open;
end;

destructor TUnpacker.Destroy;
begin
  _Close;

  inherited Destroy;
end;

{ TPacker }

procedure TPacker.AddFile(Filename: String; AsFilename: String);
const AE_IFREG = $8000; //regular file
var F: TFileStream;
    entry: PArchiveentry;
    buf: array[0..8191] of Byte;
    bytesRead, res: Integer;
begin
  if not FOpened then _Open;

  F := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Entry := archive_entry_new();

    archive_entry_set_pathname(entry, PAnsiChar(AnsiString(AsFileName)));
    archive_entry_set_size(entry, F.Size);
    archive_entry_set_filetype(entry, AE_IFREG);
    // 0644 permissions
    archive_entry_set_perm(entry, 438);

    if archive_write_header(FArchive, entry) <> 0 then
      raise Exception.Create('Failed to write header');

    // stream file in chunks
    repeat
      bytesRead := F.Read(buf, SizeOf(buf));
      if bytesRead > 0 then begin
         res := archive_write_data(FArchive, @buf[0], bytesRead);

         if res < 0 then
           raise Exception.Create('Failed to write data');
      end;
    until bytesRead = 0;

    archive_entry_free(entry);

  finally
    F.Free;
  end;

end;

procedure TPacker.AddDirectory(AsFilename: String);
const AE_IFDIR = $4000; //directory
var entry: PArchiveentry;
begin
  if not FOpened then _Open;

  Entry := archive_entry_new();

  archive_entry_set_pathname(entry, PAnsiChar(AnsiString(AsFileName)));
  archive_entry_set_filetype(entry, AE_IFDIR);
  // 0644 permissions
  archive_entry_set_perm(entry, 438);

  if archive_write_header(FArchive, entry) <> 0 then
    raise Exception.Create('Failed to write header');

  archive_entry_free(entry);
end;

procedure TPacker.SetCompressionLevel(Level: Byte);
begin
  FLevel := Level;
end;

procedure TPacker.SetPassword(Password: String);
begin
  FPassword := Password;
end;

constructor TPacker.Create(Filename: String; Format: String = 'zip'; Method: String = '');
begin
  FPassword := '';
  FLevel := 6;
  FMethod := Method;
  FFormat := Format;
  FOpened := False;
  FFilename := Filename;
end;

procedure TPacker._Open;
var Format, Method: String;
    R: Integer;
begin
  FOpened := True;

  FArchive := archive_write_new();
  if FArchive = nil then
    raise Exception.Create('Failed to create archive');

  Format := Lowercase(FFormat);
  Method := Lowercase(FMethod);

  if Method = 'bz2' then Method := 'bzip2';
  if Method = 'gz'  then Method := 'gzip';

  if Format = 'zip' then begin
    //ZIP ============================================
    R := archive_write_set_format_zip(FArchive);
    if R <> 0 then raise Exception.Create('Failed to set format');

    R := archive_write_set_option(FArchive, 'zip', 'compression-level', PAnsiChar(IntToStr(FLevel)));
    if R <> 0 then raise Exception.Create('Failed to set format');

    if FPassword <> '' then begin
      R := archive_write_set_option(FArchive, 'zip', 'encryption', 'aes256');
      if R <> 0 then raise Exception.Create('Failed to set password');

      R := archive_write_set_passphrase(FArchive, PAnsiChar(AnsiString(FPassword)));
      if R <> 0 then raise Exception.Create('Failed to set password');
    end;
  end
  else if Format = 'tar' then begin
    //TAR ============================================
    R := archive_write_set_format_ustar(FArchive);
    if R <> 0 then raise Exception.Create('Failed to set format');

    if (Method = 'deflate') or (Method = 'gzip')  then R := archive_write_set_compression_gzip(FArchive)
    else if (Method = 'lzma2') or (Method = 'xz') then R := archive_write_set_compression_xz(FArchive)
    else if Method = 'bzip2'                      then R := archive_write_set_compression_bzip2(FArchive)
    else if Method = 'lzma'                       then R := archive_write_set_compression_lzma(FArchive);

    if R <> 0 then raise Exception.Create('Failed to set formato');

    if (Method = 'deflate') or (Method = 'gzip')  then R := archive_write_set_option(FArchive, 'gzip', 'compression-level', PAnsiChar(IntToStr(FLevel)))
    else if (Method = 'lzma2') or (Method = 'xz') then R := archive_write_set_option(FArchive, 'xz', 'compression-level', PAnsiChar(IntToStr(FLevel)))
    else if Method = 'bzip2'                      then R := archive_write_set_option(FArchive, 'bzip2', 'compression-level', PAnsiChar(IntToStr(FLevel)))
    else if Method = 'lzma'                       then R := archive_write_set_option(FArchive, 'lzma', 'compression-level', PAnsiChar(IntToStr(FLevel)));

    if R <> 0 then raise Exception.Create('Failed to set format');
  end
  else if Format = '7z' then begin
    //7ZIP ============================================
    R := archive_write_set_format_7zip(FArchive);
    if R <> 0 then raise Exception.Create('Failed to set format');

    if (Method = 'ppmd') or (Method = 'lzma2') or (Method = 'bzip2') or (Method = 'deflate') then begin
      R := archive_write_set_option(FArchive, '7zip', 'compression', PAnsiChar(Method));
      if R <> 0 then raise Exception.Create('Failed to set format');
    end;

    R := archive_write_set_option(FArchive, '7zip', 'compression-level', PAnsiChar(IntToStr(FLevel)));
    if R <> 0 then raise Exception.Create('Failed to set format');

    if FPassword <> '' then begin
      R := archive_write_set_option(FArchive, '7zip', 'encryption', 'aes256');
      if R <> 0 then raise Exception.Create('Failed to set password');

      R := archive_write_set_passphrase(FArchive, PAnsiChar(AnsiString(FPassword)));
      if R <> 0 then raise Exception.Create('Failed to set password');
    end;
  end;

  if archive_write_open_filename(FArchive, PAnsiChar(AnsiString(FFilename))) <> 0 then
    raise Exception.Create('Failed to write data');

end;

destructor TPacker.Destroy;
begin
  if archive_write_close(FArchive) <> 0 then
    raise Exception.Create('Failed to close archive');

  archive_write_free(FArchive);

  inherited Destroy;
end;

end.

