# libarchive-for-Delphi-Free-Pascal-Lazarus
libarchive - pack/unpack archives in Delphi, Free Pascal, Lazarus

## Supported archives - reading

TAR, CPIO, SHAR, AR, ISO, XAR, LZH/LHA, RAR, 7ZIP, ZIP, GZIP, BZIP2, XZ

## Supported archives - writing

7ZIP, ZIP, TAR, TAR.GZ, TAR.BZ2, TAR.XZ

## Usage examples - packing
```
var A: TPacker;
begin
  A := TPacker.Create('output.tar.xz', 'tar', 'xz');
  A.AddFile('test.txt', 'test1.txt');
  A.AddFile('test.txt', 'test2.txt');
  A.AddDirectory('testdir');
  A.Free;
```

```
var A: TPacker;
begin
  A := TPacker.Create('output.zip', 'zip', '');
  A.AddFile('test.txt', 'test1.txt');
  A.Free;
```


```
var A: TPacker;
begin
  A := TPacker.Create('output.7z', '7zip', 'ppmd');
  A.AddFile('test.txt', 'test1.txt');
  A.Free;
```

## Usage examples - listing files in archive
```
var A: TUnpacker;
    Info: TFileInfo;
begin
  A := TUnpacker.Create('archive.7z');

  while A.NextInfo(Info) do begin
    Memo1.Lines.Add(Info.Path);
  end;

  A.Free;
end;
```

## Usage examples - unpacking
```
var A: TUnpacker;
    Info: TFileInfo;
    F: TFileStream;
    Path: String;
begin
  A := TUnpacker.Create('archive.7z');

  while A.NextInfo(Info) do begin
    Path := 'out_dir\' + Info.Path;

    ForceDirectories(ExtractFileDir(Path));

    if Info.IsDir then continue;

    F := TFileStream.Create(Path, fmCreate);

    A.ExtractTo(F);

    F.Free;
  end;

  A.Free;
end;
```
