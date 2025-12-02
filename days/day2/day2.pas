program day2;

uses
  SysUtils, Classes;

function CountInvalidFirst(left, right: Int64): Int64;
var
  counter: Int64;
  i: LongInt;
  stringValue: string;
  newLeft: Int64;
  newRight: Int64;
  betweenValue: Int64;
begin
  counter := 0;
  for i := 0 to right - left do
  begin
    betweenValue := left + i;
    stringValue := Format('%d', [betweenValue]);
    if Length(stringValue) mod 2 = 1 then
    begin
      Continue;
    end;
    newLeft := StrToInt64(Copy(stringValue, 1, Length(stringValue) div 2));
    newRight := StrToInt64(Copy(stringValue, (Length(stringValue) div 2) + 1, Length(stringValue)));
    if newLeft = newRight then
    begin
      counter := counter + betweenValue;
    end;
  end;
  Exit(counter);
end;

function CountInvalidSecond(left, right: Int64): Int64;
var
  counter: Int64;
  i: LongInt;
  stringValue: string;
  j: LongInt;
  k: LongInt;
  allSame: Boolean;
  subString: string;
  occurrences: LongInt;
  position: LongInt;
  betweenValue: Int64;
begin
  counter := 0;
  for i := 0 to right - left do
  begin
    betweenValue := left + i;
    stringValue := Format('%d', [betweenValue]);
    for j := 1 to Length(stringValue) div 2 do
    begin
      if j = 1 then
      begin
        for k := 2 to Length(stringValue) do
        begin
          allSame := True;
          if stringValue[k] <> stringValue[1] then
          begin
            allSame := False;
            Break;
          end;
        end;
        if allSame then
        begin
          counter := counter + betweenValue;
          Break;
        end;
        Continue;
      end;
      if Length(stringValue) mod j <> 0 then
      begin
        Continue;
      end;
      subString := Copy(stringValue, 1, j);
      occurrences := 0;
      position := 1;
      repeat
        position := Pos(subString, stringValue, position);
        if position > 0 then
        begin
          Inc(occurrences);
          position := position + Length(subString);
        end;
      until position = 0;
      if occurrences >= Length(stringValue) div Length(subString) then
      begin
        counter := counter + betweenValue;
        Break;
      end;
    end;
  end;
  Exit(counter);
end;

var
  inputFile: TextFile;
  line: AnsiString;
  fileName: string;
  ranges: TStringList;
  i: LongInt;
  rangePart: TStringList;
  leftLongNumber: Int64;
  rightLongNumber: Int64;
  firstPartCounter: Int64;
  secondPartCounter: Int64;

begin
  fileName := 'input.txt';
  Assign(inputFile, fileName);
  {$I-} // Turn off I/O checking
  Reset(inputFile);
  {$I+} // Turn I/O checking back on

  if IOResult <> 0 then
  begin
    WriteLn('Error opening file: ', fileName);
    Exit;
  end;

  ReadLn(inputFile, line);
  Close(inputFile);

  ranges := TStringList.Create;
  ExtractStrings([','], [], PChar(line), ranges);

  firstPartCounter := 0;
  secondPartCounter := 0;

  for i := 0 to ranges.Count - 1 do
  begin
    rangePart := TStringList.Create;
    ExtractStrings(['-'], [], PChar(ranges[i]), rangePart);
    leftLongNumber := StrToInt64(rangePart[0]);
    rightLongNumber := StrToInt64(rangePart[1]);
    firstPartCounter := firstPartCounter + CountInvalidFirst(leftLongNumber, rightLongNumber);
    secondPartCounter := secondPartCounter + CountInvalidSecond(leftLongNumber, rightLongNumber);
  end;

  WriteLn('First part: ', firstPartCounter);
  WriteLn('Second part: ', secondPartCounter);
end.
