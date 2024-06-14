unit unProcs;

interface

uses
  sysutils,dateutils, classes;

const
  LinesBetweenLogwrite=30;
  STX = #2;
  EOT = #4;
  maxWSports = 30;
  nl	      = #13+#10;
  hexchar : array[0..15]of char=('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');
  TtvBlank = ('                                        ');
  //           1234567890123456789012345678901234567890
  baud_rates : array[1..8]of string[6]=
             ('1200','2400','4800','9600','19200','38400','57600','115200');

type
  str1  = string[1];
  str2	= string[2];
  str3	= string[3];
  str4	= string[4];
  str5	= string[5];
  str7	= string[7];
  str8	= string[8];
  str12 = string[12];
  str14 = string[14];
  str16 = string[16];
  str40	= string[40];
  str64	= string[64];
  str80 = string[80];
  pos_info = record x,ln,llength,top:word;end;
  OneHost  = record name,addr,port:string;end;
  subt_area= array[1..2]of str40; //
  MessageType=record PageNr,Language:Str4;Channel:char;Subtitle,dummy:shortstring;end;
  setup_array	= array[0..50]of shortstring;
  ClientCommand =(LOGON,SUBTITLE,LOGOFF,Unknown);
  PCmode =(Master,Standby);
  TProcs = Class(TObject)
  public
    //TTV_page	: ttv_area;
    procedure swap_year_and_day(var st:shortstring);
    function _DBdatotid(st:string):string;
    function _DBdato(st:string):string;
    function _DBtid(st:string):string;
    function _filtered(st:string):string;
    Function _CommandType(st:string;var cmd:shortstring):ClientCommand;
    function _CleanYDate(DT:TdateTime):shortstring;
    function _CleanDate:shortstring;
    function _CleanTime:shortstring;
    function _filedatest:shortstring;
    function _number8(nr:integer):str8;
    Function _realtime(ts:str7):longint;
    Function _timestring(time:longint):str7;
    Function _MyDatetimestr:str14;
    Function  _leading_blanks(st:str7):str7;
    Function _vortex_pnr(pnr:word):str4;
    Function  _pcfname(vaxtxt:shortstring):shortstring;
    //Procedure convert_steady_steady(side:str3;var tva:ttv_area);
    Procedure insert_end_of(var row:str40;txt:str40);
    Function _date_of_file(tot_file_name:string):string;
    function _ftime_today(tot_file_name:string):boolean;
    Function _text_after(c:char;tx:string):string;
    Function _loaded_as_setupfile(fname:string;var lines:setup_array):boolean;
    Function _timestr:str8;
    Function _legal_filename(st:string):string;
    Function _tekstlb5(nr:integer):str5; // length = 5, leading blank
    Function _tekstlb3(nr:integer):str3; // length = 3, leading blank
    Function _tekstlb2(nr:integer):str2; // length = 2, leading blank
    Function _tekst02(nr:integer):str2; // length = 2, leading zero
    Function _first_param(var st:string):string;
    Function _first_set(var st:string):string;
    function _last_set(var st:string):string;
    Function _param_nr(nr:integer;st:string):string;
    procedure set_param(nr:integer;prm:string;var st:string);
    Function _Nu_params(st:string):integer;
    Function _set_nr(nr:integer;st:string):string;
    Function _last_char(st:string):char;
    function _dirtext(tx:string):string;
    Function _pos_un_case(text1,text2:string):byte;
    Procedure overwrite(ostr:str40;var dstr:str40;op:byte);
    Procedure overwrite_l(ostr:str40;var dstr:str40;op:byte);
    Procedure convert_from_dos_to_win(var st:string);
    Procedure convert_from_Win_to_TTV(var st:shortstring);
  private
    //year,month,day	: word;
    //function _tottv(c:char):char;
    //Procedure insert_first_free(var row,tekst:str40);
  end;

var   procs : Tprocs;

implementation



procedure Tprocs.swap_year_and_day(var st:shortstring);
  var s1,s2:str2;
  begin
  if length(st)<8 then exit;
  s2:=copy(st,7,2);
  delete(st,7,2);
  s1:=copy(st,1,2);
  delete(st,1,2);
  st:=s2+copy(st,1,4)+s1+copy(st,5,length(st));
  end; // procedure Tprocs.swap_year_and_day(var st:shortstring);



function Tprocs._DBdatotid(st:string):string;
  var
    i   : integer;
    ta	: array[1..6]of integer;
    s	: string;
  begin
  while pos('  ',st)>0 do delete(st,pos('  ',st),1);
  for i:=1 to length(st) do
    if not (st[i] in ['0'..'9']) then st[i]:=';';
  for i:=1 to 6 do
    ta[i]:=strtointdef(_param_nr(i,st),0);
  s:='20';
  for i:=1 to 2 do
    s:=s+_tekst02(ta[i])+'-';
  s:=s+_tekst02(ta[3])+' ';
  for i:=4 to 5 do
    s:=s+_tekst02(ta[i])+':';
  s:=s+_tekst02(ta[6]);
  result:=s
  end; //function Tprocs._DBdatotid(st:string):string;


function Tprocs._DBdato(st:string):string;
  var
    i   : integer;
    ta	: array[1..3]of integer;
    s	: string;
  begin
  while pos(' ',st)>0 do delete(st,pos(' ',st),1);
  for i:=1 to length(st) do
    if not (st[i] in ['0'..'9']) then st[i]:=';';
  for i:=1 to 3 do
    ta[i]:=strtointdef(_param_nr(i,st),0);
  s:='20';
  for i:=1 to 2 do
    s:=s+_tekst02(ta[i])+'-';
  s:=s+_tekst02(ta[3]);
  result:=s
  end; //function Tprocs._DBdato(st:string):string;



function Tprocs._DBtid(st:string):string;
  var
    i   : integer;
    ta	: array[1..2]of integer;
    s	: string;
  begin
  while pos(' ',st)>0 do delete(st,pos(' ',st),1);
  for i:=1 to length(st) do
    if not (st[i] in ['0'..'9']) then st[i]:=';';
  for i:=1 to 2 do
    ta[i]:=strtointdef(_param_nr(i,st),0);
  s:=_tekst02(ta[1])+':'+_tekst02(ta[2])+':00';
  result:=s
  end; //function Tprocs._DBtid(st:string):string;


Function Tprocs._filtered(st:string):string;
  var
    i	: integer;
  begin
  for i:=1 to length(st) do
    case st[i] of
      #0..#31 : st[i]:=' ';
      ';' : st[i]:=',';
      end;
  while pos('  ',st)>0 do delete(st,pos('  ',st),1);
  while pos('""',st)>0 do delete(st,pos('""',st),1);
  result:=st;
  end; // Function Tprocs._filtered(st:string):string;




Function  Tprocs._CommandType(st:string;var cmd:shortstring):ClientCommand;
  begin
  cmd:=ansiuppercase(_param_nr(1,_set_nr(1,st))); // Command
  if cmd='SUBTITLE' then
    begin
    result:=SUBTITLE;
    exit;
    end;
  if cmd='LOGON' then
    begin
    result:=LOGON;
    exit;
    end;
  if cmd='LOGOFF' then
    begin
    result:=LOGOFF;
    exit;
    end;
  result:=unKnown;
  cmd:='UnKnown';
  end; //Function  Tprocs._CommandType...





function Tprocs._CleanDate:shortstring;
  var
    Y,M,D: Word;
  begin
  DecodeDate(Now, Y, M, D);
  result:=_tekst02(D)+_tekst02(M);
  //      '2611 26 november
  end; //function Tprocs._CleanDate...


function Tprocs._CleanYDate(DT:TdateTime):shortstring;
  var
    Y,M,D: Word;
  begin
  DecodeDate(DT, Y, M, D);
  result:=inttostr(Y)+_tekst02(M)+_tekst02(D);
  //      '20021230 30 desember 2002
  //result:=_tekst02(D)+_tekst02(M)+_tekst02(Y mod 100);
  //      '261102 26 november 2002
  end; //function Tprocs._CleanDate...


function Tprocs._CleanTime:shortstring;
  var
    Hour, Min, Sec, MSec: Word;
  begin
  DecodeTime(Now, Hour, Min, Sec, MSec);
  result:=_tekst02(hour)+_tekst02(Min)+_tekst02(sec);
  //      092345 - 09:23:45
  end; //function Tprocs._XMLdatest:shortstring;





function Tprocs._filedatest:shortstring;
  var
    Present: TDateTime;
    Year, Month, Day: Word;
  begin
  Present:= Now;
  DecodeDate(Present, Year, Month, Day);
  result:=_tekst02(day)+_tekst02(month)+_tekst02(year mod 100);
  //      '230402;
  end; //function Tprocs._filedatest:shortstring;


function Tprocs._number8(nr:integer):str8;
  var st:str8;
  begin
  st:=inttostr(nr);
  while length(st)<8 do st:='0'+st;
  result:=st;
  end;  //function Tprocs._number8(nr:integer):str8;



Function Tprocs._realtime(ts:str7):longint;
  var
    min,sec,s10:byte;
  begin
  min:=strtointdef(copy(ts,1,2),0);
  sec:=strtointdef(copy(ts,4,2),0);
  s10:=strtointdef(copy(ts,7,1),0);
  result:=min*600+sec*10+s10;
  end;   //Function Tprocs._realtime...


Function Tprocs._timestring(time:longint):str7;
  var
    min	    : str3;
    sec,s10 : str2;
    tens    : integer;
    //ts	    : str7;
  begin
  tens:=time mod 10;
  time:=time div 10;
  if time>=60 then
    begin
    min:=_tekstlb2(time div 60)+'.';
    sec:=_tekst02(time mod 60);
    end
  else
    begin
    min:='   ';
    sec:=_tekstlb2(time mod 60);
    end;
  //
  s10:=','+inttostr(tens);
  result:=min+sec+s10;
  end;   //Function Tprocs._timestring(time:real):str7;


Function Tprocs._MyDatetimestr:str14;
  var
    NowDT	: Tdatetime;
  begin
  NowDT:=date;
  result:=_tekst02(MonthOf(NowDT))+'-'+_tekst02(DayOf(NowDT))+' '+copy(timetostr(time),1,5);
  end; // Function Tprocs._MyDatetimestr:str14;




Function Tprocs._leading_blanks(st:str7):str7;
  begin
  while (st[1] in ['0','.']) and (length(st)>3) do delete(st,1,1);
  while length(st)<7 do st:=' '+st;
  result:=st;
  end; //Function Tprocs._leading_blanks(st:str7):str7;



Function Tprocs._vortex_pnr(pnr:word):str4;
  begin
  result:='    ';
  result:=inttostr(pnr div 100)+' '+inttostr(pnr mod 100);
  end; //Function Tprocs._vortex_pnr...


Function  Tprocs._pcfname(vaxtxt:shortstring):shortstring;
  var
   i,p1,p2:byte;
  begin
  if vaxtxt='' then
    begin
    result:='\?';
    exit;
    end;
  p1:=pos('<',vaxtxt);
  p2:=pos('>',vaxtxt);
  if (p1=0) or (p2=0) or (p1>p2) then
    begin
    result:='\'+vaxtxt;
    exit;
    end;
  for i:=p1 to p2 do
    if vaxtxt[i] in ['<','.','>'] then vaxtxt[i]:='\';
  result:=vaxtxt;
  end; //Function  Tprocs._pcfname(vaxtxt:shortstring):shortstring;




{
Procedure Tprocs.Insert_first_free(var row,tekst:str40);
  var p:byte;
  begin
  p:=pos('  ',row);
  if (tekst='') or (p<2) then exit;
  if length(tekst)>=2 then
    if (tekst[1]='.') and (tekst[2]<>'.') and (p>5) then dec(p);
  insert(tekst,row,p+1);
  end; //Procedure Tprocs.Insert_first_free(var row,tekst:str40);

function Tprocs._tottv(c:char):char;
  begin
  if ord(c)>223 then
    begin
    if ord(c)<>228 then
      result:=chr(255-ord(c))
    else
      result:='|';
    end
  else
    result:=c;
  end;  //  function Tprocs._tottv(c:char):char;
}


Procedure Tprocs.insert_end_of(var row:str40;txt:str40);
  begin
  while length(row)<40 do row:=row+' ';
  insert(txt,row,41-length(txt));
  end;



function Tprocs._date_of_file(tot_file_name:string):string;
  var
    SearchRec	: TSearchRec;
    DT          : Tdatetime;
    st          : string;
  begin
  if FindFirst(tot_file_name, faAnyFile, SearchRec)=0 then
    begin
    dt:=FileDateToDateTime(SearchRec.time);
    //st:=_tekst02(DayOf(DT))+'-'+_tekst02(MonthOf(DT))+'-'+inttostr(yearof(dt));
    st:=DateToStr(DT);
    end
  else  {2003-03-25 10:36:55}
    st:='          ';
  FindClose(SearchRec);
  //insert('  kl ',st,pos(' ',st)+1);
  result:=st;
  end;  { function date_of_file... }


  
function Tprocs._ftime_today(tot_file_name:string):boolean;
  var
    SearchRec	: TSearchRec;
    //Fdt		: Tdatetime;
  begin
  if FindFirst(tot_file_name, faAnyFile, SearchRec)=0 then
    result:=int(FileDateToDateTime(SearchRec.time))=int(now)
  else
    result:=false;
  FindClose(SearchRec);
  end;  { function _ftime_today... }


Function Tprocs._text_after(c:char;tx:string):string;
  var p:word;
  begin
  p:=pos(c,tx);
  if p>0 then
    _text_after:=trim(copy(tx,p+1,length(tx)-p))
  else
    _text_after:='';
  end; // function text_after...


Function Tprocs._loaded_as_setupfile(fname:string;var lines:setup_array):boolean;
  var
    i,totln,
    p	: integer;
    dev	: text;
    st	: shortstring;
  begin
  for i:=0 to 50 do lines[i]:='';
  assignfile(dev,fname);
  {$I-}
  reset(dev);
  {$I+}
  if ioresult<>0 then
    begin
    result:=false;
    exit;
    end;
  totln:=0;
  result:=true;
  while not eof(dev) and (totln<50) do
    begin
    readln(dev,lines[totln]);
    if (lines[totln] <> '')and((lines[totln,1]) <> ';')
      and (_pos_un_case('REM',lines[totln])<>1) then
      begin
      while pos(#9,lines[totln])>0 do
	delete(lines[totln],pos(#9,lines[totln]),1);

//      while pos(' ',lines[totln])>0 do
//	delete(lines[totln],pos(' ',lines[totln]),1);

      {for i:=length(lines[totln]) downto 2 do
	begin
	if (lines[totln,i]='/') and (lines[totln,i-1] <> ' ') then
	  insert(' ',lines[totln],i);
	end;}
      p:=pos('//',lines[totln]);
      if p>0 then
        delete(lines[totln],p,100);
      p:=pos('=',lines[totln]);
      if p>0 then  {Konverter tekst før = til upcase}
	begin
	st:=copy(lines[totln],1,p);
	delete(lines[totln],1,p);
	st:=ansiuppercase(st);
	lines[totln]:=st+lines[totln];
	end;
      if lines[totln]<>'' then inc(totln);
      end;
    end; //while
  closefile(dev);
  end; //Function Tprocs._loaded_as_setupfile...



Function Tprocs._timestr:str8;
  var
    a : str2;
    ts: str8;
    tm: TdateTime;
    Hour,Min,Sec,MSec	: word;
  begin
  tm:=time;
  DecodeTime(tm,Hour,Min,Sec,MSec);
  str(hour:2,ts);
  str(min:2,a);
  if a[1]=' ' then a[1]:='0';
  ts:=ts+':'+a;
  str(sec:2,a);
  if a[1]=' ' then a[1]:='0';
  _timestr:=ts+':'+a;
  end;  { Function _timestr...}


Function Tprocs._legal_filename(st:string):string;
  var i:integer;
  begin
  for i:=1 to length(st) do
    if not (st[i] in ['0'..'9','A'..'Z','a'..'z']) then st[i]:='_';
  while pos('__',st)>0 do
    delete(st,pos('__',st),1);
  result:=st
  end; //Function Tprocs._spaces_to_underscore(var st:string);


Function Tprocs._tekstlb5(nr:integer):str5; // length = 5, leading blank
  var st:str5;
  begin
  if (nr<-9999)or(nr>99999) then
    begin
    result:='     ';
    exit;
    end;
  str(nr:5,st);
  //if st[1]=' ' then st[1]:='0';
  result:=st;
  end;  //Function Tprocs._tekstlb5...

Function Tprocs._tekstlb3(nr:integer):str3; // length = 3, leading blank
  var st:str3;
  begin
  if (nr<-99)or(nr>999) then
    begin
    result:='   ';
    exit;    
    end;
  str(nr:3,st);
  //if st[1]=' ' then st[1]:='0';
  result:=st;
  end;  //Function Tprocs._tekstlb3...

Function Tprocs._tekstlb2(nr:integer):str2; // length = 2, leading blank
  var st:str2;
  begin
  if (nr<-9)or(nr>99) then
    begin
    result:='  ';
    exit;
    end;
  str(nr:2,st);
  //if st[1]=' ' then st[1]:='0';
  result:=st;
  end;  //Function Tprocs._tekstlb2...



Function Tprocs._tekst02(nr:integer):str2; // length = 2, leading zero
  var st:str2;
  begin
  if nr > 99 then
    begin
    result:='  ';
    exit;
    end;
  str(nr:2,st);
  if st[1]=' ' then st[1]:='0';
  result:=st;
  end;  //Function Tprocs._tekst02...



function Tprocs._first_param(var st:string):string;
  var
    p 	: integer;
  {Returnerer teksten fra starten til 1. semikolon (;) og sletter
   tom 1. semikolon i st}
  begin
  p:=pos(';',st);
  if p=0 then p:=length(st)+1;
  result:=trim(copy(st,1,p-1));
  delete(st,1,p);
  end; //function Tprocs._first_param




function Tprocs._first_set(var st:string):string;
  var
    p 	: integer;
  {Returnerer teksten fra starten til 1. vertikal bar (|) og sletter
   tom 1. vertikal bar}
  begin
  p:=pos('|',st);
  if p=0 then p:=length(st)+1;
  result:=trimright(copy(st,1,p-1));
  delete(st,1,p);
  end; //function Tprocs._first_set


function Tprocs._last_set(var st:string):string;
  var
    p,l	: word;
  {Returnerer teksten fra siste vertikal bar (|) og sletter fom siste vertikal bar}
  begin
  l:=length(st);
  p:=l+1;
    repeat
    dec(p);
    until (p=1)or(st[p]='|');
  result:=trim(copy(st,p+1,l-p));
  delete(st,p,l-p+1);
  end; //function Tprocs._first_set



function Tprocs._param_nr(nr:integer;st:string):string;
  var
    p1,p2,n,l	: integer;
  {Returnerer teksten i parameter nr}
  begin
  if _last_char(st)<>';' then st:=st+';';
  l:=length(st);
  p1:=1;
  n:=0;
  while (p1<=l) and (n<nr-1) do
    begin
    if st[p1]=';' then inc(n);
    inc(p1);
    end;
  p2:=p1;
  while (p2<=l) and (st[p2]<> ';') do
    inc(p2);
  st:=trimright(copy(st,p1,p2-p1));
  result:=st;
  end; //function Tprocs._param_nr



procedure Tprocs.set_param(nr:integer;prm:string;var st:string);
  var
    i		: integer;
    tmplist	: Tstringlist;
  {Setter parameter nr i semikolon-separert streng}
  begin
  if nr<1 then exit;
  st:=st+';'; //for å få rett antall parametere
  tmplist:=Tstringlist.create;
  tmplist.Clear;
  while st<>'' do
    tmplist.Add(_first_param(st));
  while tmplist.Count<nr do
    tmplist.Add('');
  //tmplist.SaveToFile('tmplist.txt');  
  tmplist[nr-1]:=prm;
  st:='';
  for i:=0 to tmplist.Count-1 do
    begin
    st:=st+tmplist[i];
    if i<tmplist.Count-1 then
      st:=st+';';
    end;
  tmplist.Free;
  end; //function Tprocs.set_param



Function Tprocs._Nu_params(st:string):integer;
  var
    i,n	: integer;
  begin
  st:=trim(st);
  n:=0;
  for i:=1 to length(st) do
    if st[i]=';' then inc(n);
  if _last_char(st)<>';' then inc(n);
  result:=n;
  end; //Function _Nu_params(st:string):integer;



function Tprocs._set_nr(nr:integer;st:string):string;
  var
    p1,p2,n,l	: integer;
  {Returnerer teksten i set nr}
  begin
  if _last_char(st)<>'|' then st:=st+'|';
  l:=length(st);
  p1:=1;
  n:=0;
  while (p1<=l) and (n<nr-1) do
    begin
    if st[p1]='|' then inc(n);
    inc(p1);
    end;
  p2:=p1;
  while (p2<=l) and (st[p2]<> '|') do
    inc(p2);
  result:=trimright(copy(st,p1,p2-p1));
  end; //function Tprocs._set_nr



Function Tprocs._last_char(st:string):char;
  begin
  if st<>'' then
    _last_char:=st[length(st)]
  else
    _last_char:=#0;
  end; {Function _last_char...}


Function Tprocs._dirtext(tx:string):string;
    begin
    if _last_char(tx) <> '\' then
      result:=tx+'\'
    else
      result:=tx;
    end; //  function _dirtext..


Function Tprocs._pos_un_case(text1,text2:string):byte;
  var i:byte;
  begin
  for i:=1 to length(text1) do text1[i]:=upcase(text1[i]);
  for i:=1 to length(text2) do text2[i]:=upcase(text2[i]);
  _pos_un_case:=pos(text1,text2);
  end;  {Function _pos_un_case...}


Procedure Tprocs.overwrite(ostr:str40;var dstr:str40;op:byte);
  var i:byte;
  begin
  i:=0;
  while (op+i <= length(dstr)) and (i < length(ostr)) do
    begin
    dstr[op+i]:=ostr[i+1];
    inc(i);
    end;
  end; // Procedure Tprocs.overwrite(ostr:str40;var dstr:str40;op:byte);


Procedure Tprocs.overwrite_l(ostr:str40;var dstr:str40;op:byte);
  var i:byte;
  begin
  if op=0 then exit;
  if op>length(dstr) then
    begin
    ostr:=copy(ostr,1,length(ostr)-(op-length(dstr)));
    op:=length(dstr);
    end;
  i:=0;
  while (i < op) and (i < length(ostr)) do
    begin
    dstr[op-i]:=ostr[length(ostr)-i];
    inc(i);
    end;
  end; //Procedure Tprocs.overwrite_l(ostr:str40;var dstr:str40;op:byte);


Procedure Tprocs.convert_from_dos_to_win(var st:string);
  var
    i: integer;
    c: char;
  begin
  for i:=1 to length(st) do
    begin
    case st[i] of
      #32..#126 : c:=st[i];
      #129	: c:='ü';
      #130	: c:='é';
      #131	: c:='â';
      #132	: c:='ü';
      #133	: c:='à';
      #134	: c:='å';
      #135	: c:=#231;
      #136	: c:='ê';
      #137	: c:='ë';
      #138	: c:='è';
      #139	: c:='ï';

      #140	: c:='î';
      #141	: c:='ì';
      #142	: c:='Ä';
      #143	: c:='Å';
      #144	: c:='É';
      #145	: c:='æ';
      #146	: c:='Æ';
      #147	: c:='ô';
      #148	: c:='ö';
      #149	: c:='ò';

      #150	: c:='û';
      #151	: c:='ù';
      #152	: c:='ÿ';
      #153	: c:='Ö';
      #154	: c:='Ü';
      #155	: c:='ø';
      #156	: c:='£';
      #157	: c:='Ø';
      #158	: c:=' ';
      #159	: c:=' ';

      #160	: c:='á';
      #161	: c:='í';
      #162	: c:='ó';
      #163	: c:='ú';
      #164	: c:='ñ';
      #165	: c:='Ñ';

      #237	: c:='Ø'; 
      else c:=' ';
      end;
    st[i]:=c;
    end;
  end; //Procedure Tprocs.convert_from_Dos_Win...


Procedure Tprocs.convert_from_Win_to_TTV(var st:shortstring);
  var i:integer;
  begin
  for i:=1 to length(st) do
    case st[i] of
      #00..#31  :;
      #32..#63  :;
      #64	  : st[i]:='#';
      #65..#90  :;
      #97..#122 :;
      #192..#195: st[i]:='A';
      #196,#198 : st[i]:=#$5b; //TTV Ä
      #197 {Å}  : st[i]:=#$5d; //TTV Å
      #200..#203: st[i]:=#$40; //TTV É
      #204..#207: st[i]:='I';
      #208	  : st[i]:='D';
      #209	  : st[i]:='N';
      #210..#213: st[i]:='O';
      #214,#216 : st[i]:=#$5c; //TTV Ö .
      #217,#220 : st[i]:=#$5e; //TTV Ü .
      #221	  : st[i]:='Y';
      #224..#227: st[i]:='a';
      #228 {ä}  : st[i]:=#$7b; //TTV ä
      #229 {å}  : st[i]:=#$7d; //TTV ä
      #230 {æ}  : st[i]:=#$7b; //TTV ä
      #232..#235: st[i]:=#$60; //TTV é
      #236..#239: st[i]:='i';
      #241	  : st[i]:='n';
      #242..#245: st[i]:='o';
      #246,#248 : st[i]:=#$7c; //TTV ö
      #249..#251: st[i]:='u';
      #252      : st[i]:=#$7e; //TTV ü.
      #253,#255 : st[i]:='y';
      else st[i]:=' ';
      end;
  end; //Procedure Tprocs.convert_from_Win_to_TTV(var st:string);


end.


