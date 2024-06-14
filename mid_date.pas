unit mid_date;

interface

uses
  mid_typs,
  p_edit,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  ComCtrls,
  StdCtrls,
  Dialogs,
  dateUtils,

  DB,
  DBTables,
  xprocs;


type
  TdateFrm = class(TForm)
    //cal: TOvcCalendar;
    //OvcController1: TOvcController;
    dateBar: TStatusBar;
    holidayQry: TQuery;
    dateFld: TEdit;
    divQry: TQuery;
   // calDato: TCalComp;

    procedure calMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure calClick(Sender: TObject);
    procedure calKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure calChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //procedure calDrawItem(Sender: TObject; Day, Month, Year: Integer; const Rect: TRect);
  private
    { Private declarations }
   dateChanged: Integer;
  public
    { Public declarations }
   dvr: dateVars;

  //constructor Create(AOwner: TComponent); override;
  function getDayNameByNum(day,len: Integer): String;
  function getDayNumByName(dayName: String): Integer;

  //function checkDate(fromDate,toDate: TovcPictureField; data: String): Integer;
  function addToDate(dt: String; days: Integer): String;
  function dateToNum(dat: String): Real;
  function timeToNum(dat: String): Real;
  function dateDif(d1,d2: String): Longint;
  function makeValidDate(dat: String; mode: Integer): String;
  procedure dateError(dat: String);

  //function getCalDate(fname: String): String;
  //function setCalDate(fname:String; dat: String): Integer;
  //function showCalendar(fname,dat: String): Integer;
  //function processDateFld(fld: TovcPictureField): Integer;

  function getDayName(var fld: Tedit; dat: String; len: Word): String;

  //; var hdaytyp: String
  function getDayTyp(dat: String; var startkl: Integer): Integer;

  function getYearStr(dat: String; len: Word): String;
  function firstYearDateStr(dateStr: String; len: Integer): String;

  function getWeekNo(pdt: pDates): Integer;
  function getWeekNoDates(weekNo,inyear: Word; var fromDt,toDt: TdateTime): Integer;

  function getYearDay(pdt: pDates): Integer;
  function getWeekDayNo(dat: String): Integer;

  function yearDayToDateStr(ydayno,yearno: Integer): String;


  function ORAweekDaynoToDateStr(var fld: Tedit;
     wdayno,weekno,yearno: Integer): String;
  function dateStrToYrwk(dat: String; refYear,len: Integer): String;
  function yrwkToDateStr(yrwk,dayNo: Integer): String;

  function setDateYear(dat: String; yearMode: Integer): String;
  function setDateTimeYear(dat: String; yearMode: Integer): String;

  function dateToORAdate(dtm: TdateTime): String;

  function SQLdateRange(dateFld,fromDate,toDate,keyToken: String; cmd: Integer): String;
  function SQLdateTimeRange(dateFld,keyToken: String; fromDtm,toDtm: TdateTime; cmd: Integer): String;


  function makeDateKey(dat: String; cmd: Integer): String;

  function makeDateTimeKey(dtm: TdateTime; cmd: Integer): String;
  function makeDateTimeFilterKey(dtm: TdateTime): String;

  procedure writeCanvas(str: String; sender: Tobject; rect: Trect;
       fldColor,fontColor: Tcolor);
  //function  loadHolidays: Integer;
 // function  getDateTimeRange(dset: TDBdataset): String;
  function getMondayDateInWeek(dat: String; cmd: Integer): String;
  function IsLeapYear(Year: Word): Boolean;
  function decode_date(dt: TdateTime; var year,mon,day: Word): Integer;
  function encode_date(year,mon,day: Word): TdateTime;
  function dateY2(dt: TdateTime): TdateTime;
  function str2date(dat: String): TdateTime;
  function weekOfYear(dt: TDateTime): Integer;
  function weeksInYear(Year: Integer): Integer;
  function getYear(dt: TdateTime): Integer;

  function MacDateToDateStr(dat: String): String;
  function dateStrToMacDate(dat: String): String;

  function date2str(dt: TdateTime): String;
  function date4str(dt: TdateTime): String;


  function isDateHoly(dat: String): Boolean;
  function isDateHalfHoly(dat: String): Boolean;

  function isDateHyppExcept(dat: string): Boolean;

  function isDateWeekEnd(dat: String): Boolean;
  function isDateSaturday(dat: String): Boolean;
  function isDateSunday(dat: String): Boolean;


  function getDayNoOfWeek(dat: String): Integer;
  function getDateFmt(sep: Char): String;

  function makeFormulaDate(dat: String; yrlen: Integer): String;
  function getOffsetFromMonday(dat: String): Integer;

  function slideDate(dat: String; offset: Integer): String;
  function slideDateTime(dtm: TdateTime; offset: Single): TdateTime;

  function addMinToDateTime(dtm: TdateTime; min: Integer): TdateTime;
  //function slideDateTimeByMin(dtm: TdateTime;
 //                             var toKl: Integer; min: Integer): TdateTime;

  function stripTime(dtm: TdateTime): Integer;
  function dateTimeToStrTime(dtm: TdateTime): String;
  function dateTimeToMin(dtm: TdateTime): Integer;
  function dtmToStr(dtm: TdateTime): String;


  function makeDateTime(dat: String; min: Integer): TdateTime;
  function makeDateTimeStr(datstr,timestr: String): String;

  function difDateTimeMins(fromDtm,toDtm: TdateTime): Integer;

  function correctDateOverflow(dtm: TdateTime; mins: Integer): TdateTime;
  function makeVkDtm(var fromDtm,toDtm: TdateTime; vst,vend: Integer): Integer;

  function roundDateTimeSec(dtm: TdateTime): TdateTime;


  function filterDateRange(fromDateFld,toDateFld,fromDat,toDat: String): String;
  function filterDateTimeRange(fromDateFld,toDateFld: String;
                  fromdtm,todtm: TdateTime; cmd: Integer): String;

  function dateDifHours(fromDate,fromKl,toDate,toKl: String): Real;

  //function setDateMask(dateFld: TovcPictureField): String;
  function setValidDate(dat: String): String;
  function isDateFilled(dat: String): Boolean;

  function makeSingleDateTimeKey(dat,fname: String; tbltyp: Integer): String;

  function getCompositeDates(datkey: String; var fromDtm,toDtm: TdateTime): Integer;

  function getDateFromDateTimeStr(dat: String): String;
  function getTimeFromDateTimeStr(dat: String): String;

  function getDateFromDateTime(dtm: TdateTime): String;

  function convertUsDateTime(dtmstr: String): TdateTime;
  function isDateTimeStrUS(dtmstr: String): Boolean;

  function getHolyCntInPeriod(fromdat,todat: String;
                              var holyNotWeekEndCnt: Integer): Single;

  function isDatePeriodValid(dat,fromdat,todat: String): Boolean;

  function dateToNumDate(dat: String): Longint;
  function numDateToDate(datnum: Longint): String;

  function dateTimeStrToDtm(dat: String): Tdatetime;

  function makeSQLdateTimeStamp(dsetTyp: Integer): String;
  function getWorkingDays(fromdat,todat: String): Single;

  function GetWeekNumberEx(dat: tdatetime;var yy:word): string;
  Function GetWeekNumber(dat: tdatetime): string; //ukenummer for gitt dato. uke 0 er alle dager før første mandag.

 end;

var
  dateFrm: TdateFrm;

implementation

uses
 mid_units,
 mail_ini;
 //pxutil,
 //pcmp;


{$R *.DFM}
{
constructor TdateFrm.Create(AOwner: TComponent);
begin

//Kjører også FormCreate()
inherited Create(AOwner);


end;
}
Function TdateFrm.GetWeekNumber(dat: tdatetime): string; //ukenummer for gitt dato. uke 0 er alle dager før første mandag.
var DayNumber,temp:integer;
    yy,mm,dd:word;
    tempdat:tdatetime;
    uke:integer;

begin
  decodedate(dat,yy,mm,dd);
  tempdat:=encodedate(yy,1,1);
  DayNumber:=trunc(int(dat))-trunc(int(tempdat));
  temp:=DayOfWeek(TempDat);
  temp:=temp-1;

  if temp=0 then
   temp:=7;

  if temp=1 then
   temp:=7
  else
   temp:=temp-1;

  uke:=(DayNumber+temp) div 7;

  result:=inttostr(uke+1);
end;

function TdateFrm.GetWeekNumberEx(dat: tdatetime;var yy:word): string;
 Function NDayofweek(value:tdatetime;tpr:boolean):integer;
 var D:integer;
 begin
  D:=DayOfWeek(value);
  if tpr then
  begin
   D:=D-1;
   If D=0 then D:=7;
 end;

 Result:=D;
end;

var fromdat,todat:tdatetime;
    mm,dd:word;
    uke:integer;
    d1,d2,diff:integer;
begin

// uke :=strToInt(getWeekNumber(dat));

{
  decodedate(dat,yy,mm,dd);
  fromdat:=encodedate(yy,1,4);
  d1:=NDayofweek(fromdat,true);
  fromdat:=fromdat+1-d1;
  d2:=Ndayofweek(dat,true);

  todat:=dat+1-d2;
  uke:=trunc((int(todat)-int(fromdat))/7)+1;

  if uke=53 then
  begin
    //uke:=1;
    inc(yy);
  end;
  if uke=0 then
  begin
    uke:=53;
    dec(yy);
  end;
}
  uke :=WeekOfTheYear(dat);

  result:=inttostr(uke);
end;


function TdateFrm.getWorkingDays(fromdat,todat: String): Single;
var
 cx,totdays,holyNotWeekEndCnt: Integer;
 loopDtm: Tdatetime;
 dat: String;
 workingdays,holycnt: Single;
begin
 Result :=0;

 totdays :=dateFrm.dateDif(fromDat,toDat)+1;
 if totdays<=0 then
  exit;

loopdtm :=strTodate(fromdat);
workingdays :=0;

 //Finn antall hverdager
 for cx :=1 to totdays do
 begin

  dat :=dateToStr(loopDtm);


  if (not isDateWeekEnd(dat)) then
   workingdays :=workingdays+1;

  { //nei, fordi høytidsdager teller som arbeidstid selv om en får fri
  begin

    if (isDateHoly(dat)) then
    begin
      holycnt :=getHolyCntInPeriod(dat,dat,holyNotWeekEndCnt);
      if holycnt<1 then
       workingdays :=workingdays+holycnt;

    end
    else
     workingdays :=workingdays+1;

  end;
  }

  loopDtm :=dateFrm.slideDateTime(loopDtm,1);

 end;


 Result :=workingdays;
end;

function TdateFrm.makeSQLdateTimeStamp(dsetTyp: Integer): String;
var
 datStr,timeStr,dtmStr: String;
 dtm: TdateTime;
begin

 datStr :=setDateTimeYear(getDateFromDateTime(date),YEAR_4);
 timeStr :=unitFrm.dtmTimeToStr(now);

 dtmStr :=makeDateTimeStr(datStr,timeStr);

 dtm :=strToDateTime(dtmStr);

 Result :=format('%s',[makeDateTimeKey(dtm,dsetTyp)]);
end;


function TdateFrm.dateTimeStrToDtm(dat: String): Tdatetime;
var
 min: Integer;
begin

 Result :=strToDateTime(dat);

end;

function TdateFrm.numDateToDate(datnum: Longint): String;
var
 str,dats,years,mnds,days: String;
begin

  dats :=NUL;
  Result :=dats;

  if datnum<=0 then
   exit;

  str :=format('%8d',[datnum]);
  years :=copy(str,1,4);
  mnds :=copy(str,5,2);
  days :=copy(str,7,2);

 dats :=format('%s%s%s%s%s',
 [days,
  dateSeparator,
  mnds,
  dateSeparator,
  years]);

  Result :=dats;
end;


function TdateFrm.dateToNumDate(dat: String): Longint;
var
 datsn: String;
 datnum: Longint;
 dtm: TdateTime;
 year,mon,day: Word;
begin
 datnum:=0;
 Result :=datnum;

 if not isDateFilled(dat) then
  exit
 else
  dtm :=strToDate(dat);


  decodeDate(dtm,year,mon,day);

  //Sjekk år 2000 (year 00)
 if (year <LONG_YEAR_REF) then
  year := year +100
 else
 if (year>FUTURE_DATE_REF) then
  year :=year-100;

  datsn :=format('%d%2.2d%2.2d',[year,mon,day]);

  datnum :=unitFrm.atoi(datsn);

 Result :=datnum;
end;

function TdateFrm.isDatePeriodValid(dat,fromdat,todat: String): Boolean;
var
 dtm,fromdtm,todtm: TdateTime;
begin

 Result :=FALSE;

 if not isDateFilled(dat) then
  exit
 else
  dtm :=strToDate(dat);


  if (not isDateFilled(fromDat)) AND
     (not isDateFilled(todat)) then
  begin
   //Hvis det ikke er oppgitt periode, og er 'dat' gyldig
   Result :=TRUE;

  end
  else

  if (isDateFilled(fromDat)) AND (not isDateFilled(todat)) then
  begin
    fromdtm :=strTodate(fromdat);
    if dtm>=fromdtm then
     Result :=TRUE;


  end
  else
  if (not isDateFilled(fromDat)) AND (isDateFilled(todat)) then
  begin

    todtm :=strTodate(todat);
    if dtm<=todtm then
     Result :=TRUE;


  end
  else
  if (isDateFilled(fromDat)) AND (isDateFilled(todat)) then
  begin

    fromdtm :=strTodate(fromdat);
    todtm :=strTodate(todat);

    if (dtm>=fromdtm) AND (dtm<=todtm) then
     Result :=TRUE;


  end;


end;


function TdateFrm.getHolyCntInPeriod(fromdat,todat: String;
                              var holyNotWeekEndCnt: Integer): Single;
var
 cx,days,dayLimit,dayNum: Integer;
 holyCnt: Single;
 dtm: TdateTime;
 dayStr: STring;
begin
  holyCnt :=0;
  holyNotWeekEndCnt :=0;  //helligdager mandag til fredag

  Result :=holyCnt;

  if (not isDateFilled(fromDat)) OR
     (not isDateFilled(toDat)) then
     exit;


 days :=dateDif(fromDat,toDat)+1;

 dtm :=strTodate(fromDat);

 with holidayQry do
 begin

  if not active then
   exit;


  //Sjekk alle dager i perioden
  for cx:=1 to days do
  begin

    dayNum :=dayOfWeek(dtm);  //xproc funksjon
    if (dayNum<>1) AND
       (dayNum<>7) then
    begin

    if locate('Dato',dtm,[]) then
    begin

      dayLimit :=fieldByName('TidsGrense').asInteger;

      //Egentlig er det tiden etter kl 13 som skal trekkes
      //ut på julaften og onsdag før påske. Men da må vaktkoden
      //med tider være kjent. Derfor gjøres et "snitt" med å sette 0,5
      if dayLimit>0 then
       holycnt :=holyCnt+0.5
      else
       holyCnt :=holyCnt+1;

       if not isDateWeekEnd(dateToStr(dtm)) then
        inc(holyNotWeekEndCnt);

     end; //if locate

    end;

    dtm :=dtm+1;
   end; //cx loop

  end; //with


  Result :=holyCnt;
end;


function TdateFrm.isDateTimeStrUS(dtmstr: String): Boolean;
begin

if (pos('/',dtmstr)>0) OR (pos('\',dtmstr)>0) then
 Result :=TRUE
else
 Result :=FALSE; 

end;

function TdateFrm.convertUsDateTime(dtmstr: String):TdateTime;
 function getSepPos(startpos: Integer): Integer;
 var
  ps,stpos,len: Integer;
  str: String;
 begin
  ps :=0;

  if startpos<1 then
   stPos :=1
  else
   stPos :=startpos;

  len :=length(dtmstr);

  str :=copy(dtmstr,startPos,(len-startpos)+1);

 ps :=pos('/',str);

 if ps=0 then
  ps :=pos('.',str);

 if ps=0 then
  ps :=pos('-',str);

 if ps=0 then
  ps :=pos('\',str);

  if ps>0 then
   Result :=ps+(stPos-1)
  else
   result :=0;

 end;

var
 dats,day,mnd,yr,timestr: String;
 ps,lastps,mins,yrlen: Integer;
 dtm: TdateTime;
begin
 dtm :=0;
 Result :=dtm;

 if dtmstr=NUL then
  exit;

 if not isDateTimeStrUS(dtmstr) then
 begin
  Result :=strToDateTime(dtmstr);
  exit;
 end;

 //        mnd dag  år
 // f.eks. '09/16/1999'

 ps :=getSepPos(1);  //Finn sep. mellom mnd og dag
 if ps<=0 then
  exit
 else
  mnd :=copy(dtmstr,1,(ps-1));

  lastPs :=ps+1;

 ps :=getSepPos(lastps);  //Finn sep. mellom dag og år
 if ps<=0 then
  exit
 else
  day :=copy(dtmstr,lastps,(ps-lastPs));

  lastps :=ps;

  ps :=pos(' ',dtmstr);

  if ps>0 then
   yrlen :=((ps-1)-lastps)
  else
   yrlen :=2; 

  if yrlen<0 then
    yrlen :=2;

  yr :=copy(dtmstr,lastps+1,yrlen);

 dats :=format('%s%s%s%s%s',
 [day,
  dateSeparator,
  mnd,
  dateSeparator,
  yr]);

 ps :=pos(' ',dtmstr);

 if ps>0 then
 begin
  timeStr :=trim(copy(trim(dtmstr),ps+1,6));
  mins :=unitFrm.strTimeToMin(timeStr);

  dtm :=makeDateTime(dats,mins);
 end
 else
  dtm :=strTodate(dats);

 Result :=dtm;
end;

function TdateFrm.getDateFromDateTime(dtm: TdateTime): String;
var
 dats: String;
begin

 dats := dtmToStr(dtm);

 dats :=unitFrm.removeAmPm(dats);

 dats :=getDateFromDateTimeStr(dats);

 Result :=dats;
end;


function TdateFrm.getDateFromDateTimeStr(dat: String): String;
var
 ps,len: Integer;
 datstr: String;
begin
 datstr :=NUL;
 Result :=datstr;

 datstr :=trim(dat);

 len :=length(datstr);
 if len<DATE_FLD_LEN then
  exit;

 //Er dette datetime f.eks. 29.02.00 12:00:00
 if len>LONG_DATE_LEN then
 begin
  ps :=pos(BLANK,datstr);
  if ps>0 then
   datstr :=trim(copy(datstr,1,(ps-1)))

 end;

 Result :=datstr;
end;

function TdateFrm.getTimeFromDateTimeStr(dat: String): String;
var
 ps,len: Integer;
 datstr,timestr: String;
begin
 timestr :=TIME_00;
 Result :=timestr;

 datstr :=trim(dat);

 len :=length(datstr);
 if len<DATE_FLD_LEN then
  exit;

 //Er dette datetime f.eks. 29.02.00 12:00:00
 if len>LONG_DATE_LEN then
 begin
  ps :=pos(BLANK,datstr);
  if ps>0 then
   timestr :=trim(copy(datstr,(ps+1),(len-ps)))

 end;

 Result :=timestr;
end;



function TdateFrm.getCompositeDates(datkey: String; var fromDtm,toDtm: TdateTime): Integer;
var
 fromDat,toDat: String;
 ps,len: Integer;
begin
 Result :=CANCEL_;

 if datkey=NUL then
  exit;

  len :=length(datkey);
  ps :=pos(CONCAT,datkey);

  if ps=0 then
   exit;  //Datoer er ikke separert med CONCAT

  fromDat :=trim(copy(datkey,1,(ps-1)));
  toDat :=trim(copy(datkey,(ps+(length(CONCAT))),(len-ps)));

  try
   fromDtm :=str2date(fromdat);
   toDtm :=str2date(toDat);
  except
   Result :=ERROR_;
   exit;  //noe feil med datoer
  end;

 Result :=0;
end;



function TdateFrm.isDateFilled(dat: String): Boolean;
begin

 if (length(trim(dat))<DATE_FLD_LEN) OR
     (dat=SHORT_NULL_DATE) OR
     (dat=LONG_NULL_DATE) then
  Result :=FALSE
 else
  Result :=TRUE;

end;


function TdateFrm.setValidDate(dat: String): String;
var
 dtm: TdateTime;
 ps,len: Integer;
 datstr: String;
begin

 datstr :=trim(dat);
 len :=length(datstr);

 Result :=datstr;

 if not isDateFilled(datstr) then
  exit;
  //datstr :=dateToStr(date); //legg inn dagens deato for å unngå feil

 //Er dette datetime f.eks. 29.02.00 12:00:00
 if len>LONG_DATE_LEN then
 begin
  datstr :=getDateFromDateTimeStr(datstr);
{
  ps :=pos(BLANK,datstr);
  if ps>0 then
   datstr :=copy(datstr,1,(ps-1))
 }
   
 end;

 try
  datstr :=setDateYear(datstr,YEAR_4);
  dtm := strToDateTime(dat);
  Result :=getDateFromDateTime(dtm); //dateToStr(dtm);
 except
  Result :=datstr;
 end;

end;



function TdateFrm.dateDifHours(fromDate,fromKl,toDate,toKl: String): Real;
var
 dat1,dat2,kl1,kl2: STring;
 from_Kl,to_Kl: Integer;
 fromDtm,toDtm: TdateTime;
 hours: Real;
begin

 Result :=0;

 if (fromdate=NUL) then
  exit
 else
  dat1 :=fromDate;

 if toDate=NUL then
  dat2 :=fromdate
 else
  dat2 :=toDate;

 if fromKl =NUL then
  kl1 :=NULLTIME
 else
  kl1 :=fromKl;

 if toKl=NUL then
  kl2 :=TIME_24
 else
  kl2 :=toKl;

  from_Kl :=unitFrm.strTimeToMin(kl1);
  to_Kl :=unitFrm.strTimeToMin(kl2);

  fromDtm :=dateFrm.makeDateTime(dat1,from_Kl);
  toDtm :=dateFrm.makeDateTime(dat2,to_Kl);

  //Hvor mange minutter er dette totalt ?
  hours := ((toDtm-fromDtm)/ONE_DTM_MIN)/60;

  Result :=hours;
end;


function TdateFrm.slideDateTime(dtm: TdateTime; offset: Single): TdateTime;
var
 //dat: STring;
 dt: TdateTime;
begin

 dt :=dtm+offset;


{
 dat :=dateToStr(dtm);

//Korriger for at dtm :=dtm +1 ikke blir riktig på 29.02.00
if cmd=FWD_ then
begin

 if (dat='28.02.00') OR
    (dat='28.02.2000') then
  dt :=strToDate(DATE_290200)
 else
  dt :=dtm+1;

 end
 else
 if cmd=REW_ then
 begin

  if (dat='01.03.00') OR
     (dat='01.03.2000') then
   dt :=strToDate(DATE_290200)
  else
   dt :=dtm-1;

 end;
}

 Result :=dt;
end;

function TdateFrm.filterDateRange(fromDateFld,toDateFld,fromDat,toDat: String): String;
var
 flt,fromDate,toDate: String;
begin

 fromDate :=setDateYear(fromDat,YEAR_4);
 toDate :=setDateYear(toDat,YEAR_4);

    flt :=format('([%s]=''%s'' AND [%s] =''%s'')',
     [fromDateFld,fromdate,toDateFld,toDate]);

    flt :=flt+' OR ';

    flt :=flt+format('(([%s]>=''%s'' AND [%s] <=''%s'')',
     [fromDateFld,fromdate,fromDateFld,toDate]);

    flt :=flt+' OR ';

    flt :=flt+format('([%s]>=''%s'' AND [%s] <=''%s'')',
     [toDateFld,fromdate,toDateFld,toDate]);

    flt :=flt+' OR ';

    flt :=flt+format('([%s] <''%s'' AND [%s] >''%s''))',
     [fromDateFld,fromdate,toDateFld,toDate]);


  Result :=flt;
end;


function TdateFrm.filterDateTimeRange(fromDateFld,toDateFld: String;
                   fromdtm,todtm: TdateTime; cmd: Integer): String;
var
 flt,fromDate,toDate: String;
begin

 fromDate :=makeDateTimeFilterKey(fromdtm);
 toDate :=makeDateTimeFilterKey(todtm);

    flt :=format('([%s]=%s AND [%s] =%s)',
     [fromDateFld,fromdate,toDateFld,toDate]);

    flt :=flt+' OR ';

    flt :=flt+format('(([%s]>=%s AND [%s] <=%s)',
     [fromDateFld,fromdate,fromDateFld,toDate]);

    flt :=flt+' OR ';

    flt :=flt+format('([%s]>=%s AND [%s] <=%s)',
     [toDateFld,fromdate,toDateFld,toDate]);

    flt :=flt+' OR ';

    flt :=flt+format('([%s] <%s AND [%s] >%s))',
     [fromDateFld,fromdate,toDateFld,toDate]);


  Result :=flt;
end;

function TdateFrm.dateTimeToMin(dtm: TdateTime): Integer;
var
 str: String;
begin

 str :=dateTimeToStrTime(dtm);

 Result :=unitFrm.strTimeToMin(str);

 //unitFrm.msgDlg(format('%s  %s',[str,dats]),INFO_);

end;


function TdateFrm.dtmToStr(dtm: TdateTime): String;
var
 str,dats: String;
begin

 str :=dateTimeToStr(dtm);

 dats :=unitFrm.removeAmPm(str);

  //unitFrm.msgDlg(format('%s  %s',[str,dats]),INFO_);

 Result :=dats;
end;

function TdateFrm.dateTimeToStrTime(dtm: TdateTime): String;
var
 mins: Integer;
begin

 mins :=stripTime(dtm);

 Result :=unitFrm.minToStrTime(mins,2);

end;

function TdateFrm.makeSingleDateTimeKey(dat,fname: String; tbltyp: Integer): String;
var
 keystr,datstr: String;
 fromDtm,toDtm: TdateTime;
 fromDt,toDt:String;
begin
 keystr :=NUL;
 Result :=keystr;

 if (fname=NUL) OR (dat=NUL) then
  exit;

  datstr :=getDateFromDateTimeStr(dat);


   //lag interval på en dag
   fromDtm :=strToDate(setdateYear(datstr,YEAR_4));

   toDtm :=fromDtm;
   toDtm :=dateFrm.addMinTodateTime(trunc(fromdtm),DAY_MIN_LEN);
   toDtm :=dateFrm.correctDateOverflow(toDtm,DAY_MIN_LEN);

   fromDt :=dateFrm.makeDateTimeKey(fromdtm,tblTyp);
   toDt :=dateFrm.makeDateTimeKey(todtm,tblTyp);

   keystr :=format('(%s>=%s AND %s<=%s)',
                        [fname,fromDt,fname,toDt]);

 Result :=keystr;
end;

function TdateFrm.makeDateTimeStr(datstr,timestr: String): String;
var
 str,dat: String;
begin
 str :=NUL;
 Result :=str;

 if not isDateFilled(datstr) then
 begin
  str :=getDateFromDateTime(date); //dateToStr(date);  //dagens dato ved NUL inn
 end
 else
 begin

  dat :=setDateYear(datstr,YEAR_4);
  str :=format('%s %s',[dat,timestr]);

 end;

 Result :=str;
end;

function TdateFrm.makeDateTime(dat: String; min: Integer): TdateTime;
var
 dtm: TdateTime;
 datstr: String;
begin

  datstr :=setDateYear(dat,YEAR_4);

  dtm :=addMinToDateTime(strToDate(datstr),min);

  dtm :=dateFrm.correctDateOverflow(dtm,min);

  Result :=dtm;
end;


function TdateFrm.roundDateTimeSec(dtm: TdateTime): TdateTime;
var
 dt,dtd: TdateTime;
 Year, Month, Day, Hour, Min, Sec, MSec: Word;
 hours,mins,secs: Integer;
begin

 dt :=dtm;

 dtd :=trunc(dtm);

 decodeTime(dtm, Hour, Min, Sec, MSec);

 hours :=hour;
 mins :=min;
 secs :=sec;

 if (sec>=30) then
 begin
   sec :=0;
   inc(mins);
 end;

   if mins=60 then
   begin
    mins :=0;
    inc(hours);
   end
   else
   if mins<0 then
   begin
    mins :=0;
    dec(hours);
   end;

   if hours>=24 then
    hours :=0
   else
   if hours<0 then
   begin
     hours :=0;
     mins :=0;
     secs :=0;
   end;

  msec :=0;
  hour :=hours;
  min  :=mins;
  secs :=sec;

  dt :=dtd+encodeTime(Hour, Min, Sec, MSec);

 Result :=dt;
end;


function TdateFrm.makeVkDtm(var fromDtm,toDtm: TdateTime; vst,vend: Integer): Integer;
var
 datstr,dtmStr: String;
 v_end,vlen: Integer;
begin

 if vend<vst then
  vlen :=(vend+DAY_MIN_LEN)-vst
 else
  vlen :=vend-vst;


 if vend>DAY_MIN_LEN then
  v_end :=vend-DAY_MIN_LEN
 else
  v_end :=vend;

  fromDtm :=dateFrm.addMinToDateTime(trunc(fromdtm),vst);

  if v_end<vst then
   toDtm :=dateFrm.addMinToDateTime(trunc(todtm+1),v_end)
  else
   toDtm :=dateFrm.addMinToDateTime(trunc(todtm),v_end);

 toDtm :=dateFrm.correctDateOverflow(toDtm,v_end);

 Result :=vlen;
end;


function TdateFrm.correctDateOverflow(dtm: TdateTime; mins: Integer): TdateTime;
var
 dtmStr,datStr,timekey: String;
 minDtm: Integer;
 cdtm: Tdatetime;
begin

  timekey :=unitFrm.dtmTimeToStr(dtm);

  minDtm :=unitFrm.strTimeToMin(timekey);
  //f.eks. hvis 18.02.04 uten tid bak
  if (minDtm=0) AND (mins>0) then //DAY_MIN_LEN) then
  begin
   datStr :=setDateYear(dtmToStr(dtm-1),YEAR_4);
   dtmstr :=format('%s %s',[datStr,TIME_235959_DOT]);

   //Av ukjent grunn blir av og til 23.59.59 til 23.00.00
   //hvis settinger i kontroll-panel har kolon som separator
   //Forsøk derfor samme operasjon med kolone i 23:59:59
   cdtm :=strToDateTime(dtmstr);
   timekey :=unitFrm.dtmTimeToStr(cdtm);
   minDtm :=unitFrm.strTimeToMin(timekey);

   if mindtm=(DAY_MIN_LEN-60) then
   begin
    datStr :=setDateYear(dtmToStr(dtm-1),YEAR_4);
    dtmstr :=format('%s %s',[datStr,TIME_235959]);
    cdtm :=strToDateTime(dtmstr);
   end;

   Result :=cdtm;
  end
  else
   Result :=dtm;

end;

function TdateFrm.difDateTimeMins(fromDtm,toDtm: TdateTime): Integer;
var
 difMin,totmins,fromMin,toMin,days: Integer;
 timeStr: String;
begin

 //totmins :=0;

 //fromMin :=round(DAY_MIN_LEN*frac(fromDtm));
 //toMin :=round(DAY_MIN_LEN*frac(toDtm));

 totMins :=round(DAY_MIN_LEN*(todTm-fromDtm));
 
 Result :=totmins;
end;


function TdateFrm.stripTime(dtm: TdateTime): Integer;
var
 mins: Integer;
 timeKey: STring;
begin

  timeKey :=unitFrm.dtmTimeToStr(dtm);

  //Opprinnelig minuttdel til parameter variabel 'mins'
  mins :=unitFrm.strTimeToMin(timeKey);

  //Tiden blir borte ved dateToStr()
  //datstr :=setDateYear(dateToStr(dtm),YEAR_4);

 Result :=mins;
end;

{
function TdateFrm.slideDateTimeByMin(dtm: TdateTime;
                              var toKl: Integer; min: Integer): TdateTime;
var
 hour,minute,sec,sec100: Word;
 dt: TdateTime;
 days,hours,mins,rMins,rHours,difMin: Integer;
 timeStr,datstr: String;
begin


// timestr :=timeToStr(dtm);


 //Rest etter divisjon med 1440

 //days :=trunc(min/DAY_MIN_LEN);

 //difMin  :=min-(days*DAY_MIN_LEN);



 if difMin>0 then
 begin
  rMins :=difmin mod 60;
  rHours :=trunc(difmin/60);
 end
 else
 begin
  rMins :=0;
  rHours :=0;
 end;


 DecodeTime(dtm,hour,minute,sec,sec100);

 //Juster opprinnelig tid
 hours :=hour+rHours;
 mins :=minute+rMins;


 if mins>=60 then
 begin
  mins :=mins-60;
  inc(hours);
 end;


 if hours>=24 then
 begin
  hours :=hours-24;
  inc(days);
 end;

 toKl :=(hours*60)+mins;

 dt :=addMinToDateTime((dtm+days),toKl);

 //toDtm :=dt;

 Result :=dt;
end;
}

function TdateFrm.addMinToDateTime(dtm: TdateTime; min: Integer): TdateTime;
var
 dt: TdateTime;
 days,mins: Integer;
 datStr,klStr,timeStr: String;
begin
 dt :=0;

 Result :=dtm;

 if dtm=0 then
  exit;


  dt :=dtm+min/DAY_MIN_LEN;

  //dette blir dato med 4 siffret årstall
  //datStr :=setDateYear(dateToStr(dtm),YEAR_4);

  //kan være både positiv og negativ
 {
  mins :=min;

  //hours :=trunc(min/60);
  //minute :=mins mod 60;

  days :=trunc(mins/(DAY_MIN_LEN));

  //if (days>0) AND (mins>DAY_MIN_LEN) then
  mins :=mins-(days*DAY_MIN_LEN);

  dt :=dtm+days;

  klStr :=unitFrm.formatTime(mins);

  //lag DateTime på string format
  timeStr :=format('%s %s',[dateToStr(dt),klStr]);

  dt :=strToDateTime(timeStr);
 }

 Result :=dt;
end;

function TdateFrm.slideDate(dat: String; offset: Integer): String;
var
 tmpdat,datstr: String;
 dtm: TdateTime;
begin

  datstr :=NUL;
  Result :=datstr;

 if dat=NUL then
  exit;

  //tmpdat :=setDateYear(dat,YEAR_4);

  //dtm :=strToDate(tmpdat)+offset;

  dtm :=str2date(dat)+offset;
  //datstr :=dateFrm.date4str(dtm);
  datstr :=getDateFromDateTime(dtm); //dateToStr(dtm);

 Result :=datstr;
end;


function TdateFrm.getOffsetFromMonday(dat: String): Integer;
var
  offset: Integer;
  mon_day,this_day: Integer;
  mon_dat: String;
begin

 Result :=ERROR_;

 if dat=NUL then
  exit;

 this_day :=getWeekDayNo(dat);

 mon_dat :=getMondayDateInWeek(dat,REW_);

 mon_day :=getWeekDayNo(mon_dat);

 offset :=this_day-mon_day;

// if offset<0 then
//  offset :=0;

 Result :=offset;

end;


function TdateFrm.makeFormulaDate(dat: String; yrlen: Integer): String;
var
 datStr: String;
 mn,dy,yr: String;
 dt: TdateTime;
 year,mon,day: Word;
begin

 datStr :=NUL;
 Result :=datStr;

if trim(dat)=NUL then
 exit;

 dt :=dateY2(strToDate(dat));
 decode_date(dt,year,mon,day);


 datStr :=setDateYear(dat,YEAR_4);

  if datstr=NUL then
  exit
 else
 begin
  if yrlen=YEAR_2 then
   yr :=copy(datStr,length(datStr)-1,2)
  else
  if yrlen=YEAR_4 then
   yr :=copy(datStr,length(datStr)-3,4)


 end;
 //yr :=unitFrm.charReplace(format('%2d',[year]),BLANK,NULLDIGIT);
 mn :=unitFrm.charReplace(format('%2d',[mon]),BLANK,NULLDIGIT);
 dy :=unitFrm.charReplace(format('%2d',[day]),BLANK,NULLDIGIT);

 datStr :=format('%s%s%s',[yr,mn,dy]);

 Result :=datStr;
end;

function TdateFrm.getDateFmt(sep: Char): String;
var
 fmt,fmts: String;
 begin
               //variabel i SysUtils
 fmt :=lowercase(shortDateFormat);

 //Fjern evnt. å
 fmts :=unitFrm.charReplace(fmt,'å','y');
 fmts :=unitFrm.charReplace(fmt,'Å','y');

 //fmts :=unitFrm.charReplace(fmt,DOT,sep);

 Result :=fmts;
end;


function TdateFrm.getDayNoOfWeek(dat: String): Integer;
var
 datstr: String;
 dayNum: Integer;
begin
 Result :=ERROR_;

 datstr :=setDateYear(dat,YEAR_4);
 if datstr=NUL then
  exit;

 //OBS: dayOfWeek MÅ ha 4 siffret årstall !!!
try
 dayNum :=dayOfWeek(strToDate(datstr));
except
 exit;
end;

 //dayOfWeek bruker søndag som ref. Endre dette til mandag

 Result :=dayNum;
end;

function TdateFrm.isDateHalfHoly(dat: String): Boolean;
begin
 Result :=FALSE;

 if not isDateFilled(dat) then
  exit;

    if (copy(dat,1,5)='24.12') OR
       (copy(dat,1,5)='31.12') then
     Result :=TRUE;


end;


function TdateFrm.isDateHoly(dat: String): Boolean;
begin

  getDayName(dateFld,dat,1);

 if (dateFld.font.color = HOLY_COLOR) then
  Result :=TRUE
 else
  Result :=FALSE;

end;

function TdateFrm.isDateHyppExcept(dat: string): Boolean;
begin
 Result :=FALSE;

 if dat=NUL then
  exit;

     //Pgr. regelverk om hypp på helligdager
    if (copy(dat,1,5)='24.12') OR
       (copy(dat,1,5)='25.12') OR
       (copy(dat,1,5)='31.12') then
     Result :=TRUE;

end;


function TdateFrm.isDateWeekEnd(dat: String): Boolean;
begin

  getDayName(dateFld,dat,3);

 if (dateFld.text=SATURDAY_CODE) OR (dateFld.text=SUNDAY_CODE)then
  Result :=TRUE
 else
  Result :=FALSE;


end;

function TdateFrm.isDateSaturday(dat: String): Boolean;
begin

  getDayName(dateFld,dat,3);

 if (dateFld.text=SATURDAY_CODE) then
  Result :=TRUE
 else
  Result :=FALSE;


end;

function TdateFrm.isDateSunday(dat: String): Boolean;
begin

  getDayName(dateFld,dat,3);

 if (dateFld.text=SUNDAY_CODE) then
  Result :=TRUE
 else
  Result :=FALSE;


end;


function TdateFrm.date2str(dt: TdateTime): String;
var
 dtm: TdateTime;
 dats: String;
begin

 dtm :=dateY2(dt);
 dats :=getDateFromDateTime(dt);
 //Returnerer dato med bare 2 siffer i årstall

 Result :=setDateYear(dats,YEAR_2);
end;

function TdateFrm.date4str(dt: TdateTime): String;
var
 dats: String;
begin

 dats :=getDateFromDateTime(dateY2(dt));
 //Returnerer dato med bare 4 siffer i årstall
 Result :=setDateYear(dats,YEAR_4);
end;


function TdateFrm.MacDateToDateStr(dat: String): String;
var
 dtm: TdateTime;
 datStr,str: String;
 year,mon,day: Integer;
begin
 //Maconomy dato har syntaks 'YYYY.MM.DD';

str :=NUL;
Result :=str;

if not isDateFilled(dat) then
 exit;

 year :=unitFrm.atoi(copy(dat,1,4));
 mon :=unitFrm.atoi(copy(dat,6,2));
 day :=unitFrm.atoi(copy(dat,9,2));

 dtm :=encode_date(year,mon,day);
 datStr :=getDateFromDateTime(dtm); //dateToStr(dtm);

 Result :=datStr;
end;

function TdateFrm.dateStrToMacDate(dat: String): String;
var
 dt: TdateTime;
 datStr: String;
 mn,dy: String;
 year,mon,day: Word;
begin
 //Maconomy dato har syntaks 'YYYY.MM.DD';

datstr :=NUL;
Result :=datstr;

if trim(dat)=NUL then
 exit;

 dt :=dateY2(strToDate(dat));

 decode_date(dt,year,mon,day);

 mn :=unitFrm.charReplace(format('%2d',[mon]),BLANK,NULLDIGIT);
 dy :=unitFrm.charReplace(format('%2d',[day]),BLANK,NULLDIGIT);

 datStr :=format('%d.%s.%s',[year,mn,dy]);

 Result :=datStr;
end;


function TdateFrm.str2date(dat: String): TdateTime;
var
 dtm: TdateTime;
begin

 dtm :=strToDate(setDateYear(dat,YEAR_4));
 Result :=dateY2(dtm);

end;

function TdateFrm.weeksInYear(Year: Integer): Integer;
var
 //dt: TdateTime;
 dat: String;
 weeks,yearStartDay: Integer;
 leap: Boolean;
begin

Result :=ERROR_;

//yearStartDay :=dayOfWeek(dateY2(strToDate(format('01.01.%d',[year]))))-1;
dat :=getDateFromDateTime(dateY2(strToDate(format('01.01.%d',[year]))));

yearStartDay :=getWeekDayNo(dat);  //Mandag er dag 1

if yearStartDay<=0 then
 exit;

leap :=isLeapYear(year);

//Uklart hvorfor det blir slik.
//Uansett blir det feil i 2004, derfor hardkodet lenger ned
{
if ((yearStartDay=3) AND leap) OR
   ((yearStartDay=4) AND (NOT leap)) then
 weeks :=53
else
 weeks :=52;
}

//Hardkodet på grunn av usikkerhet i logikk over
 case year of
  4,2004,9,2009,15,2015,20,2020:
   weeks :=53
  else
   weeks :=52;

 end;


 Result :=weeks;
end;


function TdateFrm.getYear(dt: TdateTime): Integer;
var
 year,mon,day: Word;
begin

 decodeDate(dt,year,mon,day);

  //Sjekk år 2000 (year 00)
 if (year <LONG_YEAR_REF) then
  year := year +100
 else
 if (year>FUTURE_DATE_REF) then
  year :=year-100;


 Result :=year;
end;


function TdateFrm.dateY2(dt: TdateTime): TdateTime;
var
 yr,mn,dy: Word;
begin

 //Dekod først med Borland's funksjon (som ikke er 2000 kompatibel)
 decodedate(dt,yr,mn,dy);

 //Korriger for at 00 blir 1900
 if (yr<LONG_YEAR_REF) then
  yr :=yr+100
 else
 if (yr>FUTURE_DATE_REF) then
  yr :=yr-100;

 Result :=encodeDate(yr,mn,dy);
end;


function TdateFrm.decode_date(dt: TdateTime; var year,mon,day: Word): Integer;
begin

 Result :=ERROR_;

 if dt=0 then
  exit;

 //Dekod først med Borland's funksjon (som ikke er 2000 kompatibel)
 decodedate(dt,year,mon,day);

 //Korriger for at 00 blir 1900
 if (year<LONG_YEAR_REF) then
  year :=year+100
 else
 if (year>FUTURE_DATE_REF) then
  year :=year-100;


 Result :=year;
end;

function TdateFrm.encode_date(year,mon,day: Word): TdateTime;
var
 dt: TdateTime;
begin

  //Sjekk år 2000 (year 00)
 if (year <LONG_YEAR_REF) then
  year := year +100
 else
 if (year>FUTURE_DATE_REF) then
  year :=year-100;


 dt :=encodeDate(year,mon,day);

 Result :=dt;
end;



function TdateFrm.IsLeapYear(Year: Word): Boolean;
begin
  Result := (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;


function TdateFrm.WeekOfYear(dt: TDateTime): Integer;
 function DayOfYear(dt: TDateTime): Integer;
 begin
  Result:=Trunc(dt-dateBeginOfYear(dt))+1;
 end;
const
  t1: array[1..7] of ShortInt = ( -1,  0,  1,  2,  3, -3, -2);
  t2: array[1..7] of ShortInt = ( -4,  2,  1,  0, -1, -2, -3);
var
  weekNo,doy1,doy2: Integer;
  yearFirstDate,yearLastDate : TDateTime;
  year,mon,day: Word;
  dats: String;
begin

  weekNo :=0;

  //'dt' er dato i en uke.
  decode_date(dt,year,mon,day);

  //Årets første dato
  yearFirstDate :=encode_Date(year,1,1);

  //Årets siste dato
  yearLastDate:=encode_Date(year,12,31);

  //årsdag + ukedag for årets start
 // doy1 := DayofYear(dt) + t1[DayOfWeek(yearFirstDate)];
  dats :=getDateFromDateTime(yearFirstDate);
  doy1 := DayofYear(dt) + t1[getDayNoOfWeek(dats)];

  //årsdag + ukedag for 'dt'
 // doy2 := DayofYear(dt) + t2[DayOfWeek(dt)];
  dats :=getDateFromDateTime(dt);
  doy2 := DayofYear(dt) + t2[getDayNoOfWeek(dats)];

  if doy1 <= 0 then
    weekNo := weekOfYear(yearFirstDate-1)  //OBS: rekursiv !!!
  else
  if (doy2 >= DayofYear(yearLastDate)) then
   weekNo:= 1
  else
   weekNo:=(doy1-1) div 7+1;


 Result :=weekNo;
end;


function TdateFrm.getMondayDateInWeek(dat: String; cmd: Integer): String;
var
 cx: Integer;
 dtm: TdateTime;
 dayName,mondaydat,tmpDat: String;
begin

 if trim(dat)=NUL then
  exit;


 try
  dtm :=strToDate(setDateYear(dat,YEAR_4));
 except
  exit; //Noe feil
 end;

 //Første dato som sjekkes, er 'dat'
 {
 while ((AnsiCompareText(dayName,'Man')<>0) AND
        (AnsiCompareText(dayName,'Mon')<>0)) AND
        (cx<7) do
 begin

  if cmd=FWD_ then
   tmpdat :=dateToStr(dt+cx)
  else
  if cmd=REW_ then
   tmpdat :=dateToStr(dt-cx)
  else
   exit;

  dayName :=getDayName(dateFld,tmpdat,3);

 end;
 }

 mondayDat :=NUL;

 //Finn hvilken dato som er mandag i denne uke
 for cx :=0 to 6 do
 begin

 if cmd=FWD_ then
  tmpdat := getDateFromDateTime(dtm+cx) //dateToStr(dtm+cx)
 else
 if cmd=REW_ then
  tmpdat :=getDateFromDateTime(dtm-cx) //dateToStr(dtm-cx)
 else
  exit;

 dayName :=getDayName(dateFld,tmpdat,3);

  if (AnsiCompareText(dayName,'Man')=0) OR
     (AnsiCompareText(dayName,'Mon')=0) then
  begin
   mondayDat :=getDateFromDateTime(dtm-cx); //dateToStr(dtm-cx);
   break;
  end;
 end;


 Result :=mondayDat;
end;

{
function  TdateFrm.getDateTimeRange(dset: TDBdataset): String;
var
 tblName: String;
begin

 Result :=NUL;  

 if not assigned(dset) then
  exit;

 if not dset.active then
  exit;

 if dset.recordCount=0 then
  exit;

 tblName :=trxFrm.getTableName(dset);

 if length(tblName)<1 then
  exit;

//if dset.recordCount>1 then
//begin

  with divQry do
  begin
   close;
   SQL.clear();

   filtered :=FALSE;
   dataBaseName :=dset.dataBaseName;

   SQL.add(format('SELECT MIN(Dato),MAX(dato) FROM %s',[tblname]));

  try
   open;
   dvr.fromDate :=fields[0].asDateTime;
   dvr.todate :=fields[1].asDateTime;
  except
   exit;
  end;

   divQry.close;

  end;

  if (dvr.fromDate>0) AND (dvr.toDate>0) then
  begin
   dvr.dat :=dvr.fromDate;
   dvr.weekNoStr :=intToStr(getWeekNo(@dateFrm.dvr));
  end
  else
   dvr.weekNoStr :=NUL;

  Result :=dvr.weekNoStr;
end;
}

{
function TdateFrm.loadHolidays: Integer;
var
 cnt: Integer;
begin
 Result :=ERROR_;

 if xutil.tableMapping('holliday',dateFrm.holidayQry)<0 then
  exit;

 cnt :=0;

with dateFrm.holidayQry do
begin
 close;
 SQL.clear();
 SQL.add(format('SELECT * FROM %s',[mtd.mTblName]));
try
 open;
 cnt :=recordCount;
except
 unitFrm.msgDlg(format('Feil ved innlasting av %s for høytidsdager.',
 [mtd.mTblName]),INFO_);
  cnt :=ERROR_;
 raise;
end;

end;

 Result :=cnt;
end;
}

function TdateFrm.getDayNameByNum(day,len: Integer): String;
var
 dayName: String;
begin

 case day of
  1: dayName :='Mandag';
  2: dayName :='Tirsdag';
  3: dayName :='Onsdag';
  4: dayName :='Torsdag';
  5: dayName :='Fredag';
  6: dayName :='Lørdag';
  7: dayName :='Søndag';

 else
  dayName :=NUL;
 end;

 setLength(dayName,len);

 Result :=dayName;
end;


function TdateFrm.getDayNumByName(dayName: String): Integer;
var
 dayNum,len: Integer;
begin

 Result :=0;
 if dayName=NUL then
  exit;

 len :=length(dayName);

 dayNum :=0;

 if strLcomp(PChar(lowerCase(dayName)),'mandag',len)=0 then
  dayNum :=1
 else
 if strLcomp(PChar(lowerCase(dayName)),'tirsdag',len)=0 then
  dayNum :=2
 else
 if strLcomp(PChar(lowerCase(dayName)),'onsdag',len)=0 then
  dayNum :=3
 else
 if strLcomp(PChar(lowerCase(dayName)),'torsdag',len)=0 then
  dayNum :=4
 else
 if strLcomp(PChar(lowerCase(dayName)),'fredag',len)=0 then
  dayNum :=5
 else
 if strLcomp(PChar(lowerCase(dayName)),'lørdag',len)=0 then
  dayNum :=6
 else
 if strLcomp(PChar(lowerCase(dayName)),'søndag',len)=0 then
  dayNum :=7;

 Result :=dayNum;
end;


procedure TdateFrm.writeCanvas(str: String; sender: Tobject; rect: Trect;
     fldColor,fontColor: Tcolor);
begin


//if typFrm.triggInhibit(CHECK_) =ONX then
//  beep;
//begin

 {
if sender is TOvcCalendar then
 with (sender as TOvcCalendar).canvas do
 begin

   if fldColor <> clNone then
     Brush.Color :=fldColor;

   if fontColor <> clNone then
    Font.color :=fontColor;

    //setTextAlign(handle,TA_RIGHT);

    FillRect(Rect);
    TextRect(Rect,Rect.Left+2,Rect.Top+2, str);
 end;
 }

end;


function TdateFrm.makeDateKey(dat: String; cmd: Integer): String;
var
 dateKey,dats: String;
 yrw: Integer;
begin

//denne funksjonen brukes i alle SQL der dato inngår i søkekravet

 dateKey :=dat;

      //Sjekk om datoformat må konverteres
     if (cmd=SQL_BASED) AND
        (iniFrm.sqlDateFunk.text <> NUL) then
     begin
                                           //8
     if iniFrm.chkDbOracle.checked then
     begin

      if (pos(ORA_RR,iniFrm.nlsDateFormat.text)>0) then
       dats :=setDateYear(dat,YEAR_2)  //dd.mm.RR bruker bare 2 siffret årstall
      else
      if length(iniFrm.nlsDateFormat.text)=SHORT_DATE_LEN then
       dats :=setDateYear(dat,YEAR_2)   //Normalt
      else
      if length(iniFrm.nlsDateFormat.text)=LONG_DATE_LEN then
       dats :=setDateYear(dat,YEAR_4)
      else
       dats :=dat;

       dateKey :=format('%s(''%s'',''%s'')',
        [inifrm.sqldateFunk.text,
         dats,
         iniFrm.nlsDateFormat.text]);

      end
      else
      if iniFrm.chkDbMSSQL.checked then
      begin
       dats :=setDateYear(dat,YEAR_4);

       dateKey :=format('%s(%s,''%s'',%d)',
        [inifrm.sqldateFunk.text,
         MS_datetime,
         dats,
         MS_ddmmyyyy]);

      end;

      end
      else
      begin

      if length(trim(iniFrm.nlsDateFormat.text))<=DATE_FLD_LEN then
       dats :=dateFrm.setDateYear(dat,YEAR_2)
      else
       dats :=dat;

       //dats :=dateFrm.setDateYear(dat,YEAR_4); //getYearLen());

       dateKey :=format('''%s''',[dats]);  //Paradox
      end;

 Result :=dateKey;
end;



function TdateFrm.makeDateTimeKey(dtm: TdateTime; cmd: Integer): String;
var
 dateKey,timeKey,dats: String;
begin

 //denne funksjonen brukes i alle SQL der dato inngår i søkekravet

 dateKey :=getDateFromDateTime(dtm); //dateToStr(dtm);
 dats :=datekey;
 //timeKey :=timeToStr(dtm);


 //OBS: pass på at det ikke kommer inn AM og PM
 //Ny 20.11.2001 pgr. feil i win 2000
 //timeKey :=removeAmPm(timeKey);
 timeKey :=unitFrm.dtmTimeToStr(dtm);
{
 unitFrm.msgDlg(format('%s  %s'+FNUL+
                       '%s',
                        [datekey,
                         timekey,
                         dateTimeToStr(dtm)]),INFO_);
 }

      //Sjekk om datoformat må konverteres
    if (cmd=SQL_BASED) AND
       (iniFrm.sqlDateFunk.text <> NUL) then
    begin

     if iniFrm.chkDbOracle.checked then
     begin
                                           //8
      if (pos(ORA_RR,iniFrm.nlsDateFormat.text)>0) then
       dats :=setDateYear(dateKey,YEAR_2)  //dd.mm.RR bruker bare 2 siffret årstall
      else
      if length(iniFrm.nlsDateFormat.text)=SHORT_DATE_LEN then
       dats :=setDateYear(dateKey,YEAR_2)   //Normalt
      else
      if length(iniFrm.nlsDateFormat.text)=LONG_DATE_LEN then
       dats :=setDateYear(dateKey,YEAR_4)
      else
       dats :=dateKey;

       datekey :=format('%s(''%s,%s'',''%s,%s'')',
        [inifrm.sqldateFunk.text,
         timeKey,
         dats,
         'HH24:MI:SS',
         iniFrm.nlsDateFormat.text]);


      end
      else
      if iniFrm.chkDbMSSQL.checked then
      begin
       dats :=setDateYear(dateKey,YEAR_4);

       dateKey :=format('%s(%s,''%s'',%d)',
        [inifrm.sqldateFunk.text,
         MS_datetime,
         dats,
         MS_ddmmyyyy]);

      end;


      end
      else
       dateKey :=format('''%s''',[dtmToStr(dtm)]); //format(' ''%s'' ',[dat]);  //Paradox

 Result :=dateKey;
end;

{
function TdateFrm.makeDateKey(dat: String; cmd: Integer): String;
var
 dateKey,dats: String;
begin

//denne funksjonen brukes i alle SQL der dato inngår i søkekravet

 dateKey :=dat;

      //Sjekk om datoformat må konverteres
      if (cmd=SQL_BASED) AND
         (iniFrm.sqlDateFunk.text <> NUL) then
      begin
                                           //8
      if (pos(ORA_RR,iniFrm.nlsDateFormat.text)>0) then
       dats :=setDateYear(dat,YEAR_2)  //dd.mm.RR bruker bare 2 siffret årstall
      else
      if length(iniFrm.nlsDateFormat.text)=SHORT_DATE_LEN then
       dats :=setDateYear(dat,YEAR_2)   //Normalt
      else
      if length(iniFrm.nlsDateFormat.text)=LONG_DATE_LEN then
       dats :=setDateYear(dat,YEAR_4)
      else
       dats :=dat;

       dateKey :=format('%s(''%s'',''%s'')',
        [inifrm.sqldateFunk.text,dats,
         iniFrm.nlsDateFormat.text]);
      end
      else
      begin

      if length(trim(iniFrm.nlsDateFormat.text))<=DATE_FLD_LEN then
       dats :=dateFrm.setDateYear(dat,YEAR_2)
      else
       dats :=dat;

       dateKey :=format('''%s''',[dats]);  //Paradox
      end;

 Result :=dateKey;
end;




function TdateFrm.makeDateTimeKey(dtm: TdateTime; cmd: Integer): String;
var
 dateKey,timeKey,dats: String;
begin

 //denne funksjonen brukes i alle SQL der dato inngår i søkekravet

 dateKey :=dateToStr(dtm);
  timeKey :=timeToStr(dtm);

      //Sjekk om datoformat må konverteres
      if (cmd=SQL_BASED) AND
         (iniFrm.sqlDateFunk.text <> NUL) then
      begin
                                           //8
      if (pos(ORA_RR,iniFrm.nlsDateFormat.text)>0) then
       dats :=setDateYear(dateKey,YEAR_2)  //dd.mm.RR bruker bare 2 siffret årstall
      else
      if length(iniFrm.nlsDateFormat.text)=SHORT_DATE_LEN then
       dats :=setDateYear(dateKey,YEAR_2)   //Normalt
      else
      if length(iniFrm.nlsDateFormat.text)=LONG_DATE_LEN then
       dats :=setDateYear(dateKey,YEAR_4)
      else
       dats :=dateKey;

       datekey :=format('%s(''%s,%s'',''%s,%s'')',
        [inifrm.sqldateFunk.text,
         timeKey,
         dats,
         'HH24:MI:SS',
         iniFrm.nlsDateFormat.text]);
      end
      else
       dateKey :=format('''%s''',[dtmToStr(dtm)]); //format(' ''%s'' ',[dat]);  //Paradox

 Result :=dateKey;
end;
}

function TdateFrm.makeDateTimeFilterKey(dtm: TdateTime): String;
var
 datekey,timekey,dts: String;
begin

  dts :=dtmToStr(dtm);
  
  datekey :=getDateFromDateTime(dtm); //dateToStr(dtm);

  //timekey :=timeToStr(dtm);
  //timeKey :=removeAmPm(timeKey);

  timeKey :=unitFrm.dtmTimeToStr(dtm);

  datekey :=setDateYear(dateKey,YEAR_4);

  Result :=format('''%s %s''',[dateKey,timekey]);

end;


function TdateFrm.SQLdateRange(dateFld,fromDate,toDate,keyToken: String; cmd: Integer): String;
var
 fromDat,toDat,sqlStr: String;
begin

//denne funksjonen brukes i alle SQL der dato skal
//være innenfor et tidsrom

   //Sjekk om datoformat må konverteres
   if (cmd=SQL_BASED) AND
      (iniFrm.sqlDateFunk.text <> NUL) then
   begin

   if length(trim(iniFrm.nlsDateFormat.text))=SHORT_DATE_LEN then
   begin
     fromDat :=setDateYear(fromDate,YEAR_2);
     toDat :=setDateYear(toDate,YEAR_2);
   end
   else
   if length(trim(iniFrm.nlsDateFormat.text))=LONG_DATE_LEN then
   begin
     fromDat :=setDateYear(fromDate,YEAR_4);
     toDat :=setDateYear(toDate,YEAR_4);
   end
   else
   begin
     fromDat :=fromdate;
     toDat :=todate;
   end;


    sqlStr :=(format('%s (%s BETWEEN %s(''%s'',''%s'') '+FNUL+
    'AND %s(''%s'',''%s''))',
    [keyToken,
     dateFld,
     inifrm.sqldateFunk.text,
     fromDat,
     iniFrm.nlsDateFormat.text,

     inifrm.sqldateFunk.text,
     toDat,
     iniFrm.nlsDateFormat.text]))
   end
   else
    sqlStr :=(format('%s (%s BETWEEN ''%s'' AND ''%s'')',
    [keyToken,dateFld,fromDate,toDate]));   //Paradox


 Result :=sqlStr;
end;


function TdateFrm.SQLdateTimeRange(dateFld,keyToken: String; fromDtm,toDtm: TdateTime; cmd: Integer): String;
var
 fromDts,toDts,sqlStr: String;
begin

 //'keyToken' kan være WHERE eller AND

   fromDts :=makeDateTimeKey(fromDtm,cmd);
   toDts :=makeDateTimeKey(toDtm,cmd);

   sqlStr :=(format('%s (%s BETWEEN %s AND %s)',
    [keyToken,dateFld,fromDts,toDts]));


 Result :=sqlStr;
end;


function TdateFrm.dateToORAdate(dtm: TdateTime): String;
var
 monStr,dateStr,yrStr: String;
 year,mon,day: Word;
begin

 Result :=NUL;

 try
  decode_Date(dtm,year,mon,day);
 except
  //unitFrm.msgDlg(format('%s for konvertering: %s',
  // [BAD_DATE_,dateToStr(dtm)]),ERROR_);
  exit;
 end;

case mon of
 1: monStr :='JAN';
 2: monStr :='FEB';
 3: monStr :='MAR';
 4: monStr :='APR';
 5: monStr :='MAY';
 6: monStr :='JUN';
 7: monStr :='JUL';
 8: monStr :='AUG';
 9: monStr :='SEP';
 10: monStr :='OCT';
 11: monStr :='NOV';
 12: monStr :='DEC';
end;

 yrStr :=copy(intToStr(year),3,2);

 datestr :=format('%02d-%s-%s',[day,monStr,yrStr]);

 Result :=datestr;
end;

function TdateFrm.setDateTimeYear(dat: String; yearMode: Integer): String;
var
 ps,len: Integer;
 inpdatstr,datstr,timestr,str: String;
begin
 str :=NUL;
 Result :=str;

 inpdatstr :=trim(dat);
 len :=length(inpdatstr);

 if len<DATE_FLD_LEN then
  inpdatstr :=getDateFromDateTime(date); //dateToStr(date);

 datstr :=inpdatstr;  //Anta dette først

 //Er dette datetime f.eks. 29.02.00 12:00:00
 if len>LONG_DATE_LEN then
 begin
  ps :=pos(BLANK,inpdatstr);
  if ps>0 then
  begin
   datstr :=trim(copy(inpdatstr,1,(ps-1)));
   timestr :=trim(copy(inpdatstr,(ps+1),(len-ps)));
  end;
 end;

 datstr :=setDateYear(datstr,yearmode);

 if timeStr<>NUL then
  str :=format('%s %s',[datstr,timestr])
 else
  str :=format('%s',[datstr]);

 Result :=str;
end;



function TdateFrm.setDateYear(dat: String; yearMode: Integer): String;
var
 yri2,yri4,datlen: Integer;
 yr,yr2Str,yr4str,datstr,inpDat: String;
 yrSlide: Boolean;
begin

//Er dette datetime med tider. Isåfall, ikke gjør noe
if length(trim(dat)) > LONG_DATE_LEN then
begin
 Result :=dat;
 exit;
end;

//OBS:
//Funksjonen fungerer bare for dato-format dd.mm.yy eller dd.mm.yyyy
datStr :=NUL;
yrSlide :=FALSE;
yri2 :=(-1);
yri4 :=(-1);

inpDat :=trim(dat);
datlen :=length(inpdat);

if datlen<SHORT_DATE_LEN then
begin
 //Mangler årstall ?

 inpdat :=makeValidDate(dat,0);
 datlen :=length(inpdat);

 //fortsatt ugyldig ?
 if datlen<SHORT_DATE_LEN then
 begin
  Result :=datstr;  //NUL
  exit;
 end;
end;

//dd.mm.yy
if datlen=SHORT_DATE_LEN then
begin

 yr :=copy(inpdat,SHORT_DATE_LEN-1,2);  //

try
 yri2 :=strToInt(yr);
except
 Result :=datStr; //Årstall er muligens feil
 exit;
end;

//Hvis yri2 < 80 legg til 2000 for å lage yri4
 if yri2<SHORT_YEAR_REF then
 begin
  yri4 :=yri2+YEAR2000;
  yrSlide :=TRUE;
 end
 else
  yri4 :=yri2+YEAR1900;

end
else
if datlen=LONG_DATE_LEN then
begin

 yr :=copy(inpdat,LONG_DATE_LEN-3,4);

try
 yri4 :=strToInt(yr);
except
 Result :=datStr;
 exit;
end;

//Ta ut bare de siste 2 siffer
 yr :=copy(inpdat,LONG_DATE_LEN-1,2);
try
 yri2 :=strToInt(yr);
except
 Result :=datstr;
 exit;
end

end;

//lag begge formater
yr2str :=format('%s%2.2d',[copy(inpdat,1,6),yri2]);
yr4str :=format('%s%4.4d',[copy(inpdat,1,6),yri4]);


if yearMode = YEAR_2 then   //alltid 2 siffret
 datStr :=yr2str
else
begin
if (yearMode=YEAR_4) then   //alltid 4 siffret
 datStr :=yr4str
else
begin

  if (yearMode = SQL_BASED) then
  begin

  if (pos(ORA_RR,iniFrm.nlsDateFormat.text)>0) then
    datStr :=yr2str
  else

   if (yrSlide) OR (datlen=LONG_DATE_LEN) then
    datStr :=yr4str
   else
    datStr :=yr2str;

  end
  else
  if (yearMode = YEAR_2_4) OR (yearMode=0) then
  begin

    //Fjernet 14.04.99 fordi ny driver gir riktig resultat
     //i filter og locate med 4-siffet årstall
   if (yrSlide) OR (datlen=LONG_DATE_LEN) then
    datStr :=yr4str
   else
    datStr :=yr2str;

    //datStr :=yr4str;

  end;


 end;
end;


 Result :=datStr;
end;


function TdateFrm.yrwkToDateStr(yrwk,dayNo: Integer): String;
var
 len,yearno,weekNo: Integer;
 yrwkStr,str: String;
begin
 str :=NUL;
 Result :=str;

 if yrwk<=0 then
  exit;

 yrwkStr :=format('%0.4d',[yrwk]);

 yearno :=unitFrm.atoi(copy(yrwkStr,1,2));
 weekNo :=unitFrm.atoi(copy(yrwkStr,3,2));

 //OBS: dayNo=0 er Mandag (pgr ORACLE)

 str :=ORAweekDaynoTodateStr(dateFld,dayNo,weekNo,yearno);

{
 if str='29.02.00' then
  str :=DATE_290200;
}

 Result :=str;
end;


function TdateFrm.dateStrToYrwk(dat: String; refYear,len: Integer): String;
var
 yrwk,yr: String;
 year,mon,day: Word;
 wk: Integer;
 fromDtm,toDtm: TdateTime;
begin

 dvr.dat :=strTodate(setdateYear(dat,YEAR_4));

 wk :=getWeekNo(@dvr);

 yrwk :=NUL;
 Result :=yrwk;

 if refYear=0 then
 begin

 try
  decode_Date(dvr.dat,year,mon,day);
 except
  unitFrm.msgDlg(format('%s %s',[BAD_DATE_,dat]),ERROR_);
  exit;
 end;

 end
 else
  year :=refYear;


 if len = 2 then
  yr :=copy(intToStr(year),3,len)
 else
  yr :=copy(intToStr(year),1,len);

 //PRiNS år/uke-nr format
 yrwk :=format('%s%2.2d',[yr,wk]);

 Result :=yrwk;
end;


function TdateFrm.firstYearDateStr(dateStr: String; len: Integer): String;
var
 firstDateStr: String;
begin

  firstDateStr :=format('01.01.%s',[getYearStr(dateStr,len)]);

 Result :=firstDateStr;
end;



function TdateFrm.yearDayToDateStr(ydayno,yearno: Integer): String;
var
 tmp,dateStr: String;
 dtm: TdateTime;
begin

 if yearNo=0 then
  yearNo :=YEAR2000;

 //Finn 01.01
 tmp :=format('01.01.%d',[yearno]);

 dtm :=strToDate(tmp)+(ydayno-1);
 dateStr :=getDateFromDateTime(dtm); //dateToStr(dtm);

 Result :=dateStr;
end;


function TdateFrm.ORAweekDaynoToDateStr(var fld: Tedit;
 wdayno,weekno,yearno: Integer): String;
var
 fromDt,toDt,dt:TdateTime;
 ydayno: Integer;
 dayName,dateStr: String;
begin

if (weekno<=0) OR (weekno>53) then
 exit;

if (wdayno<0) OR (wdayno>6) then
 exit;


 //OBS: PRiNS bruker Mandag som dag 0 (ikke 1)
 //Litt i tvil om PRiNS er konsekvent med 0 på mandag (og ikke søndag)
case wdayno of
 0: dayName:='Mandag';
 1: dayName:='Tirsdag';
 2: dayName:='Onsdag';
 3: dayName:='Torsdag';
 4: dayName:='Fredag';
 5: dayName:='Lørdag';
 6: dayName:='Søndag';
end;


//Første dag i 'yearno' som referanse
dvr.dat := strToDate(format('01.01.%d',[yearno]));

//Finn første og siste dato i denne uke
getWeekNoDates(weekno,yearno,fromDt,toDt);

//Aktuell dato er ukens første dato + ukedag
dateStr :=getDateFromDateTime(fromDt+wdayno); //dateToStr(fromDt+wdayno);

 //Setter også riktig farge på 'fld'
if fld <> nil then
 dayName :=getDayName(fld,dateStr,7);

 Result :=dateStr;
end;



function TdateFrm.getWeekDayNo(dat: String): Integer;
var
 //dx,year,mon,day,weekCnt: Word;
 dayNo,dayNum: Integer;
begin

 Result :=ERROR_;

 if dat=NUL then
  exit;

 dayNum :=getDayNoOfWeek(dat);
 //OBS: Søndag er 1, konverter med Mandag som dag 1

 case dayNum of
  1: dayNo :=7;
  2: dayNo :=1;
  3: dayNo :=2;
  4: dayNo :=3;
  5: dayNo :=4;
  6: dayNo :=5;
  7: dayNo :=6;
 else
  dayNo :=ERROR_;

 end;

{
 decode_Date(strTodate(dat),year,mon,day);

 dx :=1;
 weekCnt :=0;

 //Denne er helt feil, men fungerer for bruk i generering av turnus
 //Uklart hvordan dette henger sammen ....
 while (day>0) do
 begin
  dec(day);

   if dx=7 then
   begin
    inc(weekCnt);
    dx :=1;
   end
   else
    inc(dx);

 end;

 day :=dx;
}

 Result :=dayNo;
end;


function TdateFrm.getYearDay(pdt: pDates): Integer;
var
 yearDay: Integer;
 year,mon,day: Word;
 dats: String;
begin
 Result :=ERROR_;

 decode_Date(pdt.dat,year,mon,day);

 day :=1;
 mon :=1;
 pdt.year :=year;

 pdt.firstDate :=encode_Date(year,mon,day);

 day :=31;
 mon :=12;

 pdt.lastdate :=encode_Date(year,mon,day);

 //pdt.firstDay :=dayOfWeek(pdt.firstdate)-1;  //Fordi Mandag = 2
 dats :=getDateFromDateTime(pdt.firstdate);
 pdt.firstDay :=getDayNoOfWeek(dats)-1;  //Fordi Mandag = 2

 pdt.yearDays :=round(pdt.lastdate-pdt.firstdate)+1;

 if pdt.yearDays > 365 then
  pdt.leapYear := 1
 else
  pdt.leapYear := 0;


 yearDay :=round(pdt.dat-pdt.firstDate);

 try
  pdt.dayOfYear :=yearDay;
 except
 //  unitFrm.msgDlg(format('%s av årsdag for %s',
 //  [NO_CALC_,dateToStr(pdt.dat)]),INFO_);
  exit;
 end;

 Result :=pdt.dayOfYear;
end;


function TdateFrm.getWeekNo(pdt: pDates): Integer;
begin

// getYearDay(pdt);

 pdt.weekNo :=weekOfYear(pdt.dat);

 Result :=pdt.weekNo;
end;


function TdateFrm.getWeekNoDates(weekNo,inyear: Word; var fromDt,toDt: TdateTime): Integer;
var
{
 dat: String;
 yearStartDate: TdateTime;
 rt: Integer;
 leap: Boolean;
 day,mon,firstWeekYear,year: Word;
}
 dat,dats: String;
 jan4dt,initDt: TdateTime;
 wiy,jan4day,initYear,yr: Word;
begin

 Result :=ERROR_;
 yr :=inyear;

 //Hvis uke 53, sjekk om denne starter i forrige år
if weekno=53 then
begin
 wiy :=weeksInYear(inyear);
 if wiy<>weekNo then
 dec(yr);

end;

 //Uke 1 skal inneholde 4 januar
 //eller uke 1 er den som inneholder første torsdag
 dat :=format('%s.%d',[WEEK_REF_DATE,yr]);
 jan4dt :=dateY2(strToDate(dat));

 //jan4day :=dayOfweek(jan4dt)-1;
//jan4day :=getDayNoOfWeek(dateToStr(jan4dt))-1;
// if jan4day=0 then
//  jan4day :=7;

 dats :=getDateFromDateTime(jan4dt);
 jan4day :=getWeekDayNo(dats);

 initDt :=jan4dt-(jan4day-1);
 //initDt :=(jan4dt-(jan4day))+1;

 fromDt :=initDt+((weekNo-1)*7);

 toDt :=fromDt+6;


 Result :=weekNo;

{
 //Finn 01.01 for referanse-dato
 yearStartDate :=dateBeginOfYear(pdt.dat);

 decode_date(yearStartDate,year,mon,day);

 //Sjekk hvilken uke dette året starter i
 pdt.thisYearStartWeekNo :=weekOfYear(yearStartDate);

 //Antall uker dette året
 pdt.weeksInYear :=weeksInYear(year);

 //Ukedag for 01.01
 pdt.weekDay :=dayOfWeek(yearStartDate-1);

 if pdt.weekDay=0 then
  pdt.weekDay :=7;    //Fordi søndag skal være 7 (og ikke 1)

 //Startdato for årets første uke
 pdt.firstDate :=yearStartDate-(pdt.weekDay-1);

 //Har første uke start i forrige år ?
 decode_date(pdt.firstDate,firstWeekYear,mon,day);

 //leap :=isLeapYear(firstWeekyear);

 if (firstWeekYear<year) AND (weekNo=pdt.thisYearStartWeekNo) then
 begin
  pdt.firstDate :=pdt.firstDate+((pdt.weeksInYear*7)-1);
 end
 else
  pdt.firstDate :=yearStartDate+(((weekNo-1)*7)-(pdt.weekDay-1));

 //Korriger for hvis året starter i uke 52 eller 53
 if (pdt.thisYearStartWeekNo>=52) then
  pdt.firstDate :=pdt.firstDate+7
 else
  pdt.firstDate :=pdt.firstDate;

 pdt.lastdate :=pdt.firstDate+6;  //Søndag i denne uke

 //Resturner dato for Mandag
 dat :=dateToStr(pdt.firstDate);

 Result :=dat;
}


end;


function TdateFrm.getYearStr(dat: String; len: Word): String;
var
 str: String;
 year,mon,day: Word;
begin

str :=NUL;

try
 decode_Date(strToDate(dat),year,mon,day);

  //Sjekk år 2000 (year 00)
// if (year <LONG_YEAR_REF) then
 // year := year +100;

if (len=2) OR (len=YEAR_2) then
  str :=copy(intToStr(year),3,2)
 else
  str :=copy(intToStr(year),1,len);

except
 //
end;

 Result :=str;
end;


function TdateFrm.getDayName(var fld: Tedit; dat: String; len: Word): String;
var
 day,dlen: Word;
 limH: Integer;
 dtm: TdateTime;
 dats,dayName,larttyp:String;
begin

dayName :=NUL;
Result :=dayname;

//'fld' kan være et dummy-felt som mottar resultatet

if trim(dat)=NUL then
begin
 fld.text :=NUL;
 exit;
end
else
 dats :=setDateYear(dat,YEAR_4);

if dats=NUL then
 exit;


try
 day :=getWeekDayNo(dats);  //Denne bruker Mandag som dag 1
except
 fld.text :=NUL;
 exit;
end;

case day of
 1: dayName:='Mandag';
 2: dayName:='Tirsdag';
 3: dayName:='Onsdag';
 4: dayName:='Torsdag';
 5: dayName:='Fredag';
 6: dayName:='Lørdag';
 7: dayName:='Søndag';
 else
  dayName :=UNDF;
end;


 fld.font.color :=clBlack;
 fld.tag :=0;       //Brukes for å vise type lønnart
 //fld.maxlength :=0;  //Brukes for å vise tidsgrense for høytids-lønnarter

 //Sjekk om dato er annen høytidsdag.
 //hollidayQry blir lastet inn i oppstart fra main()

 try

 with holidayQry do
 begin

  if active then
  begin

   try
    dtm :=strTodate(dats);
   except
    dtm :=0;
   end;

   if locate('Dato',dtm,[]) then
   begin

     //ikke returner spesial-navn ved len <4
     if len>3 then
      dayName :=fieldByName('Beskrivelse').AsString;

      //Finn lønnart type avhengig av type helligdag
      lartTyp :=fieldByName('LART_TYPE').AsString;

      if AnsiCompareText(lartTyp,'H1')=0 then
       fld.tag :=LART_H1
      else
      if AnsiCompareText(lartTyp,'H2')=0 then
       fld.tag :=LART_H2
{
      else
      if AnsiCompareText(lartTyp,'D1')=0 then
       fld.tag :=LART_D1
      else
      if AnsiCompareText(lartTyp,'D2')=0 then
       fld.tag :=LART_D2
 }
      else
      if AnsiCompareText(lartTyp,'YY')=0 then
       fld.tag :=LART_YY;

    {
     //Ny 04.01.00
     //Tidgrense for når høytids lønnarter skal slå til (kl 13:00)
     limH :=fieldByName('Tidsgrense').asInteger;

     //OBS: Dette er litt "dirty", men 'fld' er alltid et readonly-felt
     //som bare brukes for å vise dagnavn. Maxlength brukes aldri til
     //noe annet.
     if limH>0 then
      fld.maxlength :=limH
     else
      fld.maxlength :=0;
     }

     //fld.tag :=getDayTyp(dats,limH);

     fld.font.color :=HOLY_COLOR;
   end; //   if locate('Dato',dats,[loCaseInsensitive])

  end; //  if active

end; // with hollidayQry

except
//  locate() har feilet
end;


 if fld.font.color <> clPurple then
 if (day =6) OR (day=7) then
   fld.font.color :=WEEKEND_COLOR
 else
   fld.font.color :=NORMAL_COLOR;

 if (len>length(dayName)) OR (len = 0) then
  dlen :=length(dayName)
 else
  dlen :=len;


 fld.text :=copy(dayName,1,dlen);

 Result :=fld.text;
end;

//; var hdaytyp: String
function TdateFrm.getDayTyp(dat: String; var startkl: Integer): Integer;
var
 lartStr: STring;
 dtm: TdateTime;
 lartTyp: Integer;
begin

 lartstr :=NUL;
 Result :=0;
 startKl :=0;
 lartTyp :=0;
 //hdaytyp :=lartstr; //Pgr. NUL

//Sjekk om dette er julaften,nyttårsaften eller annen høytidsdag
//der 100% overtid starter før normalt
if dateFrm.isDateFilled(dat) then
 dtm :=dateFrm.str2date(dat)
else
 exit;

 //Alle høytidsdager må være lagt inn i X_HOLIDAY
 with holidayQry do
 begin

  if not active then
   exit;

   if locate('Dato',dtm,[]) then
   begin

     try
      lartStr :=fieldByName('LART_TYPE').AsString;

     //Finn lønnart type avhengig av type helligdag

      if AnsiCompareText(lartStr,'H1')=0 then
       lartTyp :=LART_H1
      else
      if AnsiCompareText(lartStr,'H2')=0 then
       lartTyp :=LART_H2
    {
      else
      if AnsiCompareText(lartStr,'D1')=0 then
       lartTyp :=LART_D1
      else
      if AnsiCompareText(lartStr,'D2')=0 then
       lartTyp :=LART_D2
    }
      else
      if AnsiCompareText(lartStr,'YY')=0 then
       lartTyp :=LART_YY;

      //Ny 04.01.00
      //Tidgrense for når høytids lønnarter skal slå til (kl 13:00)
      startKl :=fieldByName('Tidsgrense').asInteger;

      //Ny 03.06.2002
      // hdaytyp :=fieldByName('Bevegelig').asString;

     except
      //
     end;

   end; //   if locate

end; // with hollidayQry

 Result :=lartTyp;
end;


function TdateFrm.addToDate(dt: String; days: Integer): String;
var
 dtm: TdateTime;
 sumDt: String;
 begin


 sumDt :=NUL;

 try
  dtm :=strToDate(dt);

  //For TdateTime gjelder:
  //Integral part er antall dager siden 1899
  //Fractional part er tid på døgnet
  sumDt :=dtmToStr(Int(dtm)+days);
 except
 //
 end;

 Result :=sumDt;

end;


{
function TdateFrm.setDateMask(dateFld: TovcPictureField): String;
begin

 //Sett dato format
 if length(shortDateFormat)>DATE_FLD_LEN then
  dateFld.picturemask :=LONG_DATE_FLDMASK
 else
  dateFld.picturemask :=SHORT_DATE_FLDMASK;

 Result :=dateFld.picturemask;
end;


function TdateFrm.processDateFld(fld: TovcPictureField): Integer;
var
 fldValue: String;
begin

 //Forsøk å lage komplett dato,
 //evnt med årets siffer år hvis dette er utelatt
 fldValue :=makeValidDate(fld.text,0);

 //Hvis OK, gå til neste felt
 if length(fldValue)>=DATE_FLD_LEN then
 begin
  fld.text :=fldValue;
  try
   lnk.pForms.frm.perform(WM_NEXTDLGCTL,0,0);
  except
  //
  end;
  Result :=0;
 end
 else
  Result :=ERROR_;


end;
function TdateFrm.checkDate(fromDate,toDate: TovcPictureField; data: String): Integer;
var
 d1,d2: real;
 begin

Result :=ERROR_;

if FromDate.text = NUL then
begin
  FromDate.setFocus();
  dateFrm.dateError('''Fra-dato'' '+FromDate.text);
  exit;
end
 else
  begin
  FromDate.text :=unitFrm.strReplace(Pchar(FromDate.text),'/','.');
  FromDate.text :=unitFrm.strReplace(Pchar(FromDate.text),'-','.');
  end;

d1 :=dateFrm.dateToNum(FromDate.text);
if d1 <=0 then
begin
  FromDate.setFocus();
  dateFrm.dateError('''Fra-dato'' '+FromDate.text);
  exit;
end;



if toDate.text = NUL then
begin
  toDate.setFocus();
  dateFrm.dateError('''Til-dato'' '+toDate.text);
  exit;
end
 else
 begin
  toDate.text :=unitFrm.strReplace(Pchar(toDate.text),'/','.');
  toDate.text :=unitFrm.strReplace(Pchar(toDate.text),'-','.');
 end;

 d2 := dateFrm.dateToNum(toDate.text);
 if d2 <=0 then
 begin
  toDate.setFocus();
  dateFrm.dateError('''Til-dato'' '+toDate.text);
  exit;
 end;


 if dateFrm.dateDif(fromDate.text,toDate.text) <0 then
 begin
  unitFrm.msgDlg(BAD_DATE_RANGE_,INFO_);
  exit;
 end;


 Result :=0;
end;

}


//**********************************************************
//OBS: Denne viser også dato i felt som er aktivt
{
function TdateFrm.getCalDate(fname: String): String;
var
 year,mon,day: Word;
 dt: TdateTime;
 datstr: String;
begin

  datStr :=NUL;
  Result :=datStr;

 year :=cal.year;
 mon :=cal.month;
 day :=cal.day;

 dt :=encode_Date(year,mon,day);

 datstr :=getDateFromDateTime(dt); //dateTostr(dt);

 dateBar.panels[1].text :=datstr;

 lnk.dat :=datstr;
 //Vis dato hvis aktuellt felt er dato-felt.

if AnsiCompareText(fname,'Artist')=0 then
begin
try
 with artView.activeControl do
 begin
  if name = 'tilDato' then
   artView.tilDato.text :=datstr;
  if name = 'fraDato' then
   artView.fraDato.text :=datstr;

  exit;
 end;
 except
 //
 end;
end;

if bookCntDlg.visible = TRUE then
begin
 bookCntDlg.dato.text :=datstr;
 Result :=datstr;
 exit;
end;

if AnsiCompareText(fname,'Faktura')=0then
begin
 fakFrm.forfallDato.text :=datstr;
 Result :=datstr;
 exit;
end;


//Sjekk om felt-navn inneholder 'dato'
if (pos('dato',lowerCase(fname)) <> 0) then
begin

  trxFrm.displayFldData(fname,datstr,lnk.pForms);
  trxFrm.setTrxValue(fname,datstr,lnk.pforms);

 //prodFrm.update;

//OBS: Må sette cnctDisable fordi 'dateFrm' har focus. Dette gjør
//at underliggende forms OnActivate trigges ved musknapp ned og
//dermed connectFrm() som igjen loader aktuell record påny....
 try
  lnk.pForms.cnctDisable :=ONX;
 except
 //
 end;
  //Tobj er alltid siste felt-object brukt i trxFrm.displayFldData()
  //datstr[1] er bare dummy pgr. parameter match ...
  //mainForm.fldTouch(tobj,datstr[1]);


end;

 Result :=datstr;
end;
}
//**********************************************************
{
function TdateFrm.showCalendar(fname,dat: String): Integer;
begin

 self.visible :=TRUE;
 dateFrm.show;
 setCalDate(fname,dat);

 Result :=0;
end;
}

{
function TdateFrm.setCalDate(fname:String;dat: String):Integer;
var
 year,mon,day: Word;
 dt: TdateTime;
begin

 Result :=0;

//Sett inn dagens dato hvis blankt eller mangelfullt
 if length(trim(dat))<DATE_FLD_LEN then
 begin
  cal.setToday();
  dateBar.panels[0].text :=fname;
  exit;
 end;

 cal.initialize :=TRUE;

 dt:=strToDate(setDateYear(dat,YEAR_4));

 decode_Date(dt,year,mon,day);

 cal.year :=year;
 cal.month :=mon;
 cal.day :=day;

 dateBar.panels[0].text :=fname;
 dateBar.panels[1].text :=dat;

 Result :=0;
end;
}


//**********************************************************


function TdateFrm.makeValidDate(dat: String; mode: Integer): String;
var
 dta: ARFLDI;
 cx,len,year,mon,day: Word;
 dtm: TdateTime;
 tmpDt,datstr: String;
begin

tmpdt :=NUL;
datstr :=NUL;

Result :=datstr;

if dat=NUL then
 exit;

 len := length(trim(dat));

       //01.01.
 if len<6 then
  exit;

{
if len >1 then
begin
 if (dat[1]=DOT) OR (dat[1]='/') then
 begin
  exit
 end;
end;
}

 //datstr :=setDateYear(dat,YEAR_4);
 datstr :=dat;

 //For ikke å få feilmelding på decodeDate() ...
 datstr :=unitFrm.strReplace(PChar(datstr),'/',DOT);
 datstr :=unitFrm.strReplace(PChar(datstr),'-',DOT);
 datstr :=unitFrm.strReplace(PChar(datstr),'''',NUL);

 //Hvis årstall ikke er oppgitt, legg inn inneværende år
try

 //resett
 for cx :=1 to 4 do
  dta[cx] :=0;

 //Setter dag, måned og år til dta[]
 unitFrm.breakStrToInts(datstr,DOT,@dta);

 if (dta[3]<0) OR (len<DATE_FLD_LEN) then
  dta[3] :=dateYear(date); //Bruk årets år ved feil
{
 else
 if dta[3]=0 then
  dta[3] :=YEAR2000;
}

 //korriger for bug på 29.02.00
 if (dta[1]=29) AND (dta[2]=2) AND ((dta[3]=0) OR (dta[3]=2000)) then
  datstr :=DATE_290200
 else                     //dateToStr
  datstr :=getDateFromDateTime(encode_date(dta[3],dta[2],dta[1]));

 //datstr :=format('%2d.%2d.%2d',[dta[1],dta[2],dta[3]]);
 //datstr :=unitFrm.strReplace(PChar(datstr),BLANK,NULLDIGIT);

//Legg inn aktuellt årstall
 {
 if  len<DATE_FLD_LEN then
 begin

  decode_Date(date,year,mon,day);  //OBS: Inneværende år fra dagens dato

  //dt :=encode_Date(year,mon,day);

  //tmpDt :=dateToStr(dt);

  //datstr[DATE_FLD_LEN-1] :=tmpDt[DATE_FLD_LEN-1];
  //datstr[DATE_FLD_LEN] :=tmpDt[DATE_FLD_LEN];

  datstr :=format('%2d.%2d.%2d',[dta[1],dta[2],year]);
  datstr :=unitFrm.strReplace(PChar(datstr),BLANK,NULLDIGIT);

 end;
 }
except
 if mode>=0 then
  unitFrm.msgDlg(format('%s %s',[BAD_DATE_,dat]),ERROR_);

 exit;
end;

try
 decode_Date(strToDate(datstr),year,mon,day);
 except
  if mode>=0 then
   unitFrm.msgDlg(format('%s %s',[BAD_DATE_,datstr]),ERROR_);

  exit;
 end;

 //Sjekk år 2000 (year 00)
 if (year <LONG_YEAR_REF) then
  year := year +100
 else
 if (year>FUTURE_DATE_REF) then
  year :=year-100;


 dtm :=encode_Date(year,mon,day);

 datstr :=getDateFromDateTime(dtm); //dateToStr(dtm);

 if mode>=0 then
 begin

   if mode=SQL_BASED then
   begin

     //Inneholder dato-format RR ?
     if (pos(ORA_RR,iniFrm.nlsDateFormat.text)>0) then
      datstr :=dateFrm.setDateYear(datstr,YEAR_2)
     else
     if length(iniFrm.nlsDateFormat.text)=LONG_DATE_LEN then
      datstr :=dateFrm.setDateYear(datstr,YEAR_4)
     else
     if length(iniFrm.nlsDateFormat.text)=SHORT_DATE_LEN then
      datstr :=dateFrm.setDateYear(datstr,YEAR_2)

   end;

//   else
//    datstr :=dateFrm.setDateYear(datstr,YEAR_4)

 end;

 Result :=datstr;
end;


procedure TdateFrm.dateError(dat: String);
begin
 unitFrm.msgDlg(format('%s %s',[DATA_MISS_,dat]),INFO_);

end;

//*********************************************************

function TdateFrm.dateToNum(dat: String): Real;
var
  ADate: TDateTime;
begin

  Result :=0;

 try
  ADate := StrToDate(dat);
 except
  exit;
 end;

 Result:=Int(Adate);
end;

//************************************************************

function TdateFrm.timeToNum(dat: String): Real;
var
  ATime: TDateTime;
begin

 Result :=0;

 try
  ATime := StrToTime(dat);
 except
  exit;
 end;

  Result:=Frac(ATime);
end;

//****************************************************************

function TdateFrm.dateDif(d1,d2: String): Longint;
type
  dateData = record
  dat: TdateTime;
  year,mon,day: Word;
end;
var
 cx: Integer;
 dt: array [1..2] of dateData;
 dif: Longint;
 str: String;
begin

Result :=0;

if (d1=NUL) OR (d2=NUL) then
 exit;


cx :=0;

for cx :=1 to 2 do
begin

case cx of
 1: dt[cx].dat :=strToDate(setDateYear(d1,YEAR_4));
 2: dt[cx].dat :=strToDate(setDateYear(d2,YEAR_4));
end;

 decode_Date(dt[cx].dat,dt[cx].year,dt[cx].mon,dt[cx].day);

//Ved booking inn i år 2000 vil DecodeDate ta år 00 som 1900
//if (dt[cx].year <LONG_YEAR_REF) then
// dt[cx].year := dt[cx].year +100;

 dt[cx].dat :=encode_Date(dt[cx].year, dt[cx].mon, dt[cx].day);

end;


 //pgr. typecast til longint ...
try
 str :=format('%.0f',[(dt[2].dat-dt[1].dat)]);
except
 try
  str :=format('%,0f',[(dt[2].dat-dt[1].dat)]);
 except
  unitFrm.msgDlg(format('%s av datointerval',[NO_CALC_]), ERROR_);
  str :=NUL;
 end;
end;

 dif :=unitFrm.atoi(str);

 //dif kan bli negativ
 Result :=dif;
end;


//****************************************************************
procedure TdateFrm.calMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 rt: Integer;
begin

 if button = mbRight then
 begin
  //Når 'self' fjernes vil OnActivate trigges i 'lnk.pForms.frm'
  //Dette vil igjen føre til connect til mainForm, noe som
  //er helt unødvendig her. Derfor eventinhibit=ONX
  //typFrm.eventInhibit :=ONX;
  try
   lnk.pForms.cnctDisable :=ONX;
  except
   //
  end;
  self.visible :=FALSE;
 end;

 rt :=0;
end;


procedure TdateFrm.calClick(Sender: TObject);
begin

 // getCalDate(dateBar.panels[0].text);

end;

procedure TdateFrm.calKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

dateChanged :=OFF;

case key of
 //Trigger OnChange()
 VK_UP,VK_DOWN,VK_LEFT,VK_RIGHT: dateChanged :=ONX;

 VK_RETURN:
 begin
  //typFrm.eventInhibit :=ONX;
  try
   lnk.pForms.cnctDisable :=ONX;
  except
  //
  end;

  //getCalDate(dateBar.panels[0].text);
  self.visible :=FALSE;

try
  //mainForm.goCtrl(LAST_FLD);
 except
 //
 end;

 end;

end;

end;

procedure TdateFrm.calChange(Sender: TObject);
begin

if dateChanged =ONX then
begin
 dateChanged :=OFF;
 //getCalDate(dateBar.panels[0].text);
end;

end;

procedure TdateFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

 //holidayQry.close;
 // typFrm.eventInhibit :=ONX;
 try
  lnk.pForms.cnctDisable :=ONX;
 except
  //
 end;

 //Sett tilbake skalering
 //changeScale(StrToInt(iniFrm.scaleD.text),
 //            StrToInt(iniFrm.scaleM.text));

end;

procedure TdateFrm.FormCreate(Sender: TObject);
begin

 dateSeparator :=DOT;
 timeSeparator :=COLON;
 //OBS: timeseparator MÅ være kolon.
 //Hvis ikke, blir alle datetime med null tid i databasen.
 //Søk på datetimerange feiler også.
 //Denne manglet fram til 07.09.03, men gikk bra så lenge kontroll-panel
 //hadde : på Timeseparator

 shortDateFormat :=SHORT_DATE_FMT;

 //cal.initialize :=TRUE;
 dateChanged :=OFF;

 self.height :=200;
 self.width :=270;

end;

procedure TdateFrm.FormShow(Sender: TObject);
begin

 //changeScale(StrToInt(iniFrm.scaleM.text),
 //            StrToInt(iniFrm.scaleD.text));

end;

{
procedure TdateFrm.calDrawItem(Sender: TObject; Day, Month, Year: Integer;
  const Rect: TRect);
var
 str,dats: String;
 wdy: Integer;
begin


if ((day>0) AND (month>0) and (Year>0)) then
 with (sender as TOvcCalendar).canvas do
 begin

  //wdy :=DayOfWeek(encode_Date(word(year),word(month),word(day)));
  //dateToStr(encode_Date(word(year),word(month),word(day)))
 getDateFromDateTime(encode_Date(word(year),word(month),word(day)));
 wdy :=getDayNoOfWeek(dats);

  if (day=cal.day) AND (month=cal.month) then
  begin
    Brush.Color :=clLime;
    Font.color :=clBlack;
  end
  else
  begin

  if month=cal.month then
  begin

  //getDayNoOfWeek() bruker Søndag som dag 1
  if (wdy=1) OR (wdy=7) then
  begin
   Brush.Color :=$008080FF;  //Lyserød
   Font.color :=clBlack;
  end
  else
   begin
    Brush.Color :=clWhite;
    Font.color :=clBlack;
   end;
  end
  else
  begin
    Brush.Color :=clSilver;
    Font.color :=clGray;
  end;
  end;

    //setTextAlign(cal.handle,TA_CENTER);
    str :=intToStr(day);
    FillRect(Rect);
    TextRect(Rect,Rect.Left+2,Rect.Top+2, str);

 end;



end;
}

initialization
  dateFrm :=TdateFrm.create(dateFrm);
  if dateFrm =nil then
   halt;


end.
