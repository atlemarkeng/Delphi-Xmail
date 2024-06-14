unit mid_trx;

interface

uses
 mid_typs,
 P_edit,
 P_combo,
 P_memo,
 p_check,

 Windows,
 Messages,
 SysUtils,
 Classes,
 Graphics,
 Controls,
 Forms,
 Dialogs,
 ExtCtrls,
 StdCtrls,
 variants,

 DB,
 DBtables,
 DBClient,
 SimpleDS,
 FMTBcd,
 SqlExpr;

type

 TtrxFrm = class(TForm)
    fld1: Tfld;
    tblQry: TSQLQuery;
    seqQry: TSQLQuery;
    seqTbl: TSimpleDataSet;

 //trxQry: TQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

 private
    { Private declarations }

 public
     { Public declarations }
  col: array [1..MAXFLDS] of recbuf;
  cpy: array [1..MAXFLDS] of cpybuf;
  fnoAr: array [1..MAXFLDS] of Integer;

  //når felt-data til frmFlds[] er lastet inn i ptrx.pas
  frmDefStat: Integer;

  constructor Create(AOwner: Tcomponent); override;

  procedure clearTrx;
  procedure clearTrxData;
  //function  getfieldDataTyp(fldType: TfieldType): Integer;
  function getTableDefs(ff: pFrms): Integer;
  function  getTrxPos(fname: String; ff: pFrms): Integer;
  function copyTrxToTbl(dset: Tdataset;seqID: Longint; cmd: Integer; ff: pFrms): Integer;
  function copyTblToTrx(dset: Tdataset; seqid: Longint; ff: pFrms): Integer;
  function copyFldsToTrx(ff: pFrms): Integer;

  function copyFldsToTbl(dset: Tdataset;
                               seqId,cmd: Integer;
                               ff: pFrms): Integer;

  function copyTrxToFlds(ff: pFrms): Integer;

  function setTrxValue(fname: String; value: String; ff: pFrms): Integer;
  function getTrxValue(fname: String; ff: pFrms): String;
  function componentData(tobj: Tobject;fname: String;
              data: String; cmd: Integer): String;

  function getFldType(fname: String; ff: pFrms): TfieldType;
  function getField(fname: String; ff: pFrms): Tfield;

  procedure clearFlds(ff: pFrms);
  function  recordToCpy(dset: Tdataset; seqid: Longint; ff: pFrms): Integer;
  function  cpyToFlds(ff: pFrms): Integer;
  procedure  clearCpy;
  function  getFldData(fname: String;var strData: String;ff: pFrms): String;

  function  displayFldData(fname: String;data: String; ff: pFrms): Integer;

  procedure loadFdefs(ff: pFrms);
  function  getFrmFieldDef(ff: pFrms): Integer;
  procedure setFldFocus(fname: String; ff: pFrms);
  function  getFldObject(fname: String; var obj: Tobject;ff: pFrms): Integer;
  function  writeToTbl(dset: Tdataset;
   fname,fdata: String; ftype: TfieldType;cmd: Integer): Integer;

  function  makeSQL(dset: Tdataset;
   fname,fdata: String; ftype: TfieldType; cmd: Integer): String;

  function setTrxFnames(dset: TdataSet; ff: pFrms): Integer;

  procedure getDspType(obj: Tobject; var dspTyp: Integer; var tagVal: Integer);
  function  getfieldDataTyp(fldType: TfieldType): Integer;
  procedure  setFldColor(obj: Tobject; cmd: Integer);
  function  processMemoData(fname,fdata: String): String;

  function getTableName(dset: Tdataset): String;
 function setTableName(dset: Tdataset; tblName: String): Integer;

 function getDBTableType(dset: Tdataset): Tdataset;

 function getNextSeqID(tblname: String): Integer;

 function isDsetReadOnly(dset: Tdataset): Boolean;
 function isDsetExclusive(dset: Tdataset): Boolean;
 function setDsetExclusive(dset: Tdataset; ex: Boolean): Integer;
 //function emptyAllRecords(dset: Tdataset; var errmsg: String): Integer;

// function getGridData(grid: TcustomGrid; grd: pGridData): Integer;
// function setGridData(var grid: TcustomGrid; grd: pGridData): Integer;

 function getIndexFieldCount(dset: Tdataset): Integer;
 function getRecordCount(dset: Tdataset): Integer;

 //function getGridDataSource(grid: TcustomGrid): TdataSource;
 //function decodeWWselected(str: String; sld: pSelectData): Integer;
 function updateTblValues(tblname,flds,keys: String): Integer;

 function insertTblValues(tblname,flds,values: String): Integer;

 function deleteTblValues(tblname,keys: String): Integer;
 function queryTblValues(tblname,fld,keys: String): Integer;

 //function getNextSeqID(tblname: String): Integer;

 procedure listDataChange(frm: Tform; dset: TdataSet);

 function processRecord(tblname: String; action: Integer): Integer;

 function createSQLkey(fname,fdata,sortflds,sortdir: String): String;
 end;

 var
  trxFrm:TtrxFrm;

implementation

uses
 mid_units,
 mid_date,
 mid_ini;

{$R *.DFM}


//Functions

constructor TtrxFrm.Create(AOwner: Tcomponent);

begin

  inherited Create(AOwner);


 tobj :=TObject.create;
 if tobj = nil then
 begin
   MessageDlg('Cannot create component-object',
                 mtError,[mbOK],0);
  halt;

 end;

end;

function TtrxFrm.createSQLkey(fname,fdata,sortflds,sortdir: String): String;
var
 keys,str: String;
 fieldDataTyp,prec: Integer;
 dtyp: TfieldType;
 dtm: TdateTime;
begin


 keys :=fdata;

if fdata<>NUL then
begin


//ieldDataTyp :=trxFrm.getfieldDataTyp(lnk.pForms.dset.fieldByName(fname).field);
//else
// fieldDataTyp :=TEXT_KEY;

try
 dtyp :=mainForm.mediaQry.fieldByName(fname).DataType;
except
 dtyp :=ftString;
end;

case dtyp of

 ftString,ftMemo:
 begin

 keys :=unitFrm.strReplace(Pchar(fdata),'*',
  Pchar(iniFrm.qryBlock.text));

 // alle '?' med '_' (wild-card enkelt-tegn av keys)
 keys :=unitFrm.strReplace(Pchar(keys),'?',
  Pchar(iniFrm.qryChar.text));

 //alle ' må byttes ut. Hvis ikke kommer feilmelding fra query
 keys :=unitFrm.strReplace(Pchar(keys),'''',
  Pchar(iniFrm.qryChar.text));


   keys :=format('WHERE %s(%s) LIKE %s(''%s%s'')',
    [iniFrm.qryCmpcase.text,
    fname,
    iniFrm.qryCmpcase.text,
    keys,
    iniFrm.qryBlock.text]);
  end;
     ftSmallint,ftInteger,ftWord,ftFMTbcd:
      keys :=format('WHERE %s = %d',[fname,unitFrm.atoi(fdata)]);
     ftTime:
      keys :=format('WHERE %s = ''%s''',[fname,fdata]);

     ftDate:
     begin

      if not dateFrm.isDateFilled(fdata) then
        exit;

       keys :=format('WHERE %s = %s',[fname,
                         dateFrm.makeDateKey(fdata,SQL_BASED)]);

     end;


     ftDateTime,ftTimeStamp:
     begin

      if not dateFrm.isDateFilled(fdata) then
       exit;


      fdata :=dateFrm.setDateTimeYear(fdata,YEAR_4);

      dtm :=strToDateTime(fdata);

      keys :=format('WHERE %s = %s',[fname,
                dateFrm.makeDateTimeKey(dtm,SQL_BASED)]);
     end;

     ftFloat:
     begin
      //sjekk om feltdata inneholder komma eller punktum
      if (pos(COMMA,fdata)=0) AND (pos(DOT,fdata)=0) then
       prec :=0
      else
       prec :=MAX_FLOAT_PRECISION;

      try

      if fdata=NUL then
       str :=format('WHERE %s = %.*f',[fname,prec,0.00])
      else
       str :=format('WHERE %s = %.*f',[fname,prec,strToFloat(fdata)]);
      except
       str :=format('WHERE %s = %.*f',[fname,prec,0.00]);
      end;

      //Decimal-tall må inneholde punktum i SQL-setninger
      keys :=unitFrm.charReplace(str,COMMA,DOT);

      end;  //case ftFloat
   else
    exit;

 end;

 end; //if fdata<>NUL

  if sortFlds<>NUL then
   keys :=keys+format(' ORDER BY %s %s',[sortflds,sortdir]);


  Result :=keys;
end;

function TtrxFrm.getNextSeqID(tblname: String): Longint;
var
 val: Longint;
begin

Result :=ERROR_;

 if (tblname=NUL) then
  exit;


// if queryState(mainQry,dset,CLEAR_) <0 then
//   exit;


 with seqQry do
 begin
  close;
  //dataBaseName :=dset.dataBaseName;
  SQL.clear();

  SQL.add(format('SELECT MAX(%s) FROM %s',[SEQID_FLD,tblName]));
  //commandText :=format('SELECT MAX(%s) FROM %s',[SEQID_FLD,tblName]);
  //commandType :=ctQuery;

  try
   open;
   val :=fields[0].AsInteger;
  except
   raise;
   val :=ERROR_;
  end;

end; //with

 //Sjekk om det er første gang add på tabell (for SeqID)
 if val =0 then
 begin

 with seqTbl.DataSet do
 begin

  commandtext :=tblname;
  commandType :=ctTable;

 try
   open;

   //Ved første gang reg. på blank tabell
  if (recordCount=0)then
   val := 1
  else
   val :=ERROR_;

   close;
 except
  Result :=ERROR_;
  exit;
 end;

 end; //with

  Result :=val;
  exit;
 end;


 if val >0 then
 begin

  Result :=val
 end
 else
  Result :=ERROR_;


end;


function TtrxFrm.processRecord(tblname: String; action: Integer): Integer;
var
 rt,errs,mode: Integer;
 seq: Longint;
 lastFldValue: String;
begin

 //screen.cursor :=crDefault;

 Result :=ERROR_;
 seq :=0;
 errs :=0;
 lnk.pForms.newRec :=FALSE; //anta dette først

// if xutil.checkUserLevel(NUL,typFrm.operation) <0 then
//  exit;


 if (action=DELETE_) AND (lnk.seqid<=0) then
  exit;


 if (lnk.match=0) OR (lnk.pos=0) then
  lnk.eof :=TRUE;

 if (mainForm.pnlSaveStat(CHECK_) = OFF) AND
    (action <> DELETE_) then
 begin
  showMessage('pnlSaveStat');
  exit;
 end;

//Hvis alle check passerer, settes result til 0 sist.
if (action <> DELETE_) AND (not lnk.noValidCheck) then
if assigned(lnk.validFunc) then
 if lnk.validFunc(CHECK_) <0 then
 begin

  lastFldValue :=getTrxValue(lnk.pForms.fname,lnk.pForms);

  //Legg tilbake opprinnelig verdi hvis validering feilet
  if lastFldValue <> NUL then
   displayFldData(lnk.pForms.fname,lastFldValue,lnk.pForms);

  //showMessage('validFunc');
  exit;
 end;

if action =0 then
 action :=UPDATE_;

if (lnk.pos <=0) OR (lnk.seqid <=0) then
begin
 lnk.eof :=TRUE;
 lnk.seqid :=0;

 if lnk.pos <lnk.match then
  action :=INSERT_
 else
  action :=ADD_;

 end;

 //Ved nye records må neste seqID finnes
if lnk.eof then
begin

 //Finn neste ledige SeqID
 seq :=getNextSeqID(tblname);

 //mainForm.getNextMediaID(mainForm.clip_cat.text);

 //Ved feil eller tom tabell, hentes SeqID fra INI-fil

 if seq <=0 then
 begin

  //seq :=modulFrm.processSeqID(lnk.frm.name,READ_);

  if seq <0 then
  begin
   unitFrm.msgDlg(format('%s neste %s for %s '+FNUL+
   'Kan skyldes feil i tabellen eller at feltet mangler.',
     [NO_MATCH_,SEQID_FLD,tblname]),ERROR_);
   exit;

  end;


 end
 else
  inc(seq);

  lnk.seqID :=seq;

 end;

rt :=0;

//beep;
//Oppdaterer listTbl og listGrid
//OBS: Ved DELETE_ gjøres først et forsøk på å slette i master
//Hvis dette feiler slettes heller ingen record på liste
if (action <> DELETE_) then
begin

  //rt :=processMatchTbl(lnk.pForms.mTbl,lnk.pForms.lTbl,action);

 if rt<0 then
 begin
  action :=0;

  if (rt = ERROR_) then
  begin
   lnk.pForms.dset.cancel;
   unitFrm.msgDlg(format('%s', [NO_UPDATE_]),ERROR_);
  end;

  Result :=rt;
  exit;
 end;

end;


if rt >=0 then
begin

if lnk.eof then   //Ny record
 begin

  action :=ADD_;
  //qryFrm.matchInfo(action);  //Flyttet 04.01.98

   //For å kunne kopiere data fra forrige
   recordToCpy(lnk.pForms.dset,lnk.seqid,lnk.pforms);
 end;


//Bekreft/kanseller oppdatering
if (lnk.eof) then
begin

 if (lnk.pos<lnk.match) then
 begin

  if lnk.seqID <=0 then
  begin
   unitFrm.msgDlg(format('Uventet %s. %s',
    [SEQID_FLD,NO_UPDATE_]),ERROR_);
   Result :=ERROR_;
   exit;
  end;

  mode :=INSERT_;
 end
 else
 begin
  lnk.pForms.newRec :=TRUE;
  mode :=ADD_;
 end;

  if lnk.pForms.dset.active then
   if lnk.pForms.dset.state <> dsBrowse then
    lnk.pForms.dset.fieldByName(SEQID_FLD).AsInteger :=lnk.seqID;

 end
 else
  mode :=UPDATE_;

 copyFldsTotrx(lnk.pForms);

if action<>DELETE_ then
begin

lnk.pForms.dset.Tag :=LOCAL_;

 //Til dset (lokalt)
if lnk.pForms.dset.active then
 rt :=trxFrm.copyFldsToTbl(lnk.pForms.dset,
                           lnk.seqid,
                           mode,
                           lnk.pForms);

 lnk.pForms.dset.Tag :=SQL_BASED;

 //Til server
 rt :=trxFrm.copyFldsToTbl(lnk.pForms.dset,
                           lnk.seqid,
                           mode,
                           lnk.pForms);
end;


 if (rt >=0) then
 begin
  typFrm.triggInhibit(ONX);


  if (action = DELETE_) then
  begin

    deleteTblValues(tblname,format('%s=%d',[SEQID_FLD,lnk.seqID]));

    try
     if lnk.pForms.dset.Active then
      lnk.pForms.dset.Delete;

    except
    //
    end;

    mainForm.matchInfo(action);

  end
  else
  begin
   mainForm.matchInfo(action);
  // lnk.pForms.dset.post;
  end;

  typFrm.triggInhibit(OFF);
 end
 else
 begin

  //lnk.pForms.dset.cancel;

  inc(errs);
 end;


 if action = DELETE_ then
 begin

   //Iflg. reference for TTable vil neste record rykke opp som current
  //etter bruk av delete. Av ukjent grunn skjer dette bare i DBgrid
  //og ikke inne i underliggende tabell. Derfor et lite trick for
  //å synkronisere...

  with lnk.pForms.dset do
  begin
   disableControls;
   moveBy(-1);
   moveBy(1);
   enableControls;
  end;

  if lnk.match <1 then
   clearFlds(lnk.pForms);

  end

 end;

 if assigned(lnk.updateFunc) then
  lnk.updateFunc(UPDATE_);

  //Refresh InfoPower grid
 //if assigned(lnk.pForms.wwTbl) then
 // lnk.pForms.wwTbl.refresh;

 if (lnk.match=0) OR (lnk.pos=0) then
  lnk.eof :=TRUE
 else
  lnk.eof :=FALSE;

 if errs>0 then
  Result :=ERROR_
 else
  Result :=0;

end;

procedure TtrxFrm.listDataChange(frm: Tform; dset: TdataSet);
begin

//Av ukjent grunn trigges OnDataChange etter formClose
//Men lnk.frm er satt til nil i disconnect, derfor kan det
//testes på denne.

//lnk.droppedDown :=OFF;

try
 if lnk.frm = nil then
  exit;
except
 exit;
end;

try
 if dset.recordCount =0 then
  exit;
except
 exit;
end;

//Det er ikke nødvendig å laste inn record ved
//ved formCreate. OnDataChange trigges påny ved
//mainForm.attach()

 try
  lnk.seqid := dset.fieldByName(SEQID_FLD).AsInteger;
 except
  //
 end;


if lnk.frm.tag = CREATE_ then
begin
 //Må laste in felt-navn til col[].fname
 trxFrm.setTrxFnames(lnk.pForms.dset,lnk.Pforms);
end;


  //OBS: locate(), open() og andre relaterte funksjoner lager
  // event-triggere og kan gi uønskede bivirkninger.
  if  typFrm.triggInhibit(CHECK_) =OFF then
  begin

  typFrm.triggInhibit(ONX);

  //Skal ikke kunne skje ...
  if lnk.pForms.fldCnt <=0 then
  begin
    //beep;
   //Hver moduls feltdefinisjoner i skjema
   if trxFrm.getFrmFieldDef(lnk.pForms) <0 then;
    exit;

  end;

  {
    if getRecord(tbl,lnk.seqid) <0 then
     exit;
  }
    copyTblToTrx(dset,lnk.seqid,lnk.pForms);

    if trxFrm.copytrxToFlds(lnk.pForms) <0 then
     exit;

    //Vellykket load
    lnk.loaded :=ONX;

     //Data til felt med focus
     lnk.pForms.fdata :=getTrxValue(lnk.pForms.fname,lnk.pForms);
     lnk.touched :=FALSE;

     mainForm.pnlSaveStat(OFF);

    if lnk.match <=0 then
     lnk.pos :=0
    else
     try
      lnk.pos :=dset.recno;
     except
      lnk.pos :=0;
     end; 

    //qryFrm.qr.seqid :=lnk.seqid;

   //Blir -1 hvis ny record-linje er åpnet i bunn av DBgrid
    if lnk.pos <0 then
    begin
     lnk.pos := lnk.match+1;
     lnk.eof :=TRUE;
     mainForm.pnlInsertStat(OFF);

   end
   else
   begin
    lnk.eof :=FALSE;
    mainForm.pnlInsertStat(ONX);
   end;


 if ((lnk.pos=0) AND (lnk.match =0))then
 begin
  lnk.eof :=TRUE;
  mainForm.pnlInsertStat(OFF);
 end;


   mainForm.matchInfo(DISPLAY_);

   if (lnk.eof) OR
      ((lnk.pos=0) AND (lnk.match=0)) then
   begin

    try
      if assigned(lnk.showDefProc) then
       lnk.showDefProc();
     except
     //
     end;

    end;

//   trxFrm.setFldFocus(lnk.defaultFieldName);

     try
      if assigned(lnk.displayProc) then
      begin

        lnk.displayProc(NUL,NUL)

      end;
     except
     //
     end;

   //recFrm.syncWWtbl(lnk.pForms.lTbl,lnk.pForms.wwTbl,lnk.seqID,SYNC_);

   typFrm.triggInhibit(OFF);
 end;


end;


function TtrxFrm.insertTblValues(tblname,flds,values: String): Integer;
var
 str: String;
 cx,rt: Integer;
 state: TDataSetState;
 bm: TbookMark;
begin

Result :=ERROR_;

if (flds=NUL) OR (tblname=NUL) then
 exit;


with tblQry do
begin

 close;
 //dataBaseName :=dset.dataBaseName;
 SQL.clear;

 SQL.add(format('INSERT INTO %s ',[tblname]));
 SQL.add(format('( %s )',[flds]));
 SQL.add(' VALUES ');
 SQL.add(format('( %s )',[values]));

 //ORACLE bruker ' istedenfor " rundt string-variable

 for cx :=0 to pred(SQL.count) do
 begin
   str :=unitFrm.charReplace(SQL[cx],'"','''');
   if str<> NUL then
    SQL[cx] :=str;

 end;


 try
   execSQL;
   rt :=rowsaffected;

 except
  Result :=ERROR_;
  raise;
  exit;
 end;

end;

 Result :=rt;
end;


//**************************************************************

function TtrxFrm.deleteTblValues(tblname,keys: String): Integer;
var
 rt: Integer;
begin

Result :=ERROR_;

if (keys=NUL) OR (tblname=NUL) then
 exit;

with tblQry do
begin

 close;
 //tblQry.dataBaseName :=dset.dataBaseName;
 SQL.clear;

 SQL.add(format('DELETE FROM %s',[tblname]));

 SQL.add(format('WHERE %s',[keys]));

try
 execSQL;
 rt :=rowsaffected;

except
  screen.cursor :=crDefault;

 //if showTableErrorMsg('Kan ikke slette denne record.',dset) =0 then
  raise;

 exit;
end;

end; //with

 Result :=rt;
end;

function TtrxFrm.updateTblValues(tblname,flds,keys: String): Integer;
var
 cx,rt: Integer;
 str,tname: String;
begin

Result :=ERROR_;

if (flds=NUL) OR (tblname=NUL) then
 exit;


with tblQry do
begin
 close;
 //dataBaseName :=dset.dataBaseName;
 SQL.clear;

 SQL.add(format('UPDATE %s SET ',[tblname]));
 SQL.add(format(' %s ',[flds]));

if keys <> NUL then
 SQL.add(format('WHERE %s',[keys]));

//tblQry.SQL.add(' COMMIT ');


 //ORACLE bruker ' istedenfor " rundt string-variable
 for cx :=0 to pred(SQL.count) do
 begin
   str :=unitFrm.charReplace(SQL[cx],'"','''');
   if str<> NUL then
    SQL[cx] :=str;

 end;

  try

   execSQL;
   rt :=rowsaffected;
 except
  screen.cursor :=crDefault;

// if showTableErrorMsg('Kan ikke oppdatere denne record.',dset) =0 then
  raise;
  exit;
 end;

 end;


 Result :=rt;
end;

//**************************************************************

function TtrxFrm.queryTblValues(tblname,fld,keys: String): Integer;
var
 cnt: Integer;
begin

Result :=ERROR_;

if trim(tblname)=NUL then
 exit;

with tblQry do
begin

 close;
 SQL.clear;

 SQL.add(format('SELECT %s from %s',[fld,tblname]));

if keys <> NUL then
 SQL.add(format('WHERE %s',[keys]));

try
 open;
 cnt :=recordCount;
except
 close;
 unitFrm.msgDlg(format('%s til å søke i %s',[NO_ACCESS_,tblname]),INFO_);
 cnt :=ERROR_;
end;

close;

end; //with

 Result :=cnt;
end;

{
function TtrxFrm.setGridData(var grid: TcustomGrid; grd: pGridData): Integer;
begin

 Result :=ERROR_;
if not assigned(grid) then
 exit;

if AnsiCompareText(grid.className,DELPHI_GRID) =0 then
begin


 (grid as TDBgrid).titleFont :=grd.titleFont;
 (grid as TDBgrid).font :=grd.font;
 (grid as TDBgrid).color :=grd.color;


end;


if grid.className =IP_GRID then
begin
 (grid as TwwDBgrid).titleFont :=grd.titleFont;
 (grid as TwwDBgrid).font :=grd.font;
 (grid as TwwDBgrid).color :=grd.color;

end;


 Result :=0;
end;
}

{
function TtrxFrm.emptyAllRecords(dset: Tdataset; var errmsg: String): Integer;
var
 rt: Integer;
 str: String;
begin

rt :=0;

str :=NUL;
errmsg :=str;

str :=dset.className;

//unitFrm.msgDlg(str+' '+DELPHI_TABLE,INFO_);

try
 if str =DELPHI_TABLE then
 begin
  (dset as TTable).emptyTable;
 end;

 //if str = IP_TABLE then
 // (dset as TwwTable).emptyTable;

except

  on E:exception do
  begin
   errmsg :=E.message;
   rt :=ERROR_;
  end;

 end;


 Result :=rt;
end;
}

function TtrxFrm.isDsetExclusive(dset: Tdataset): Boolean;
var
 rt: Boolean;
begin

 rt :=FALSE;

 try
 if dset.className = DELPHI_TABLE then
  rt :=(dset as TTable).exclusive;

 //if dset.className = IP_TABLE then
 // rt :=(dset as TwwTable).exclusive;
except
 //raise;
 rt :=FALSE;
end;


 Result :=rt;
end;


function TtrxFrm.setDsetExclusive(dset: Tdataset; ex: Boolean): Integer;
var
 rt: Integer;
begin

rt :=0;

try
 if dset.className = DELPHI_TABLE then
  (dset as TTable).exclusive :=ex;

 //if dset.className = IP_TABLE then
 // (dset as TwwTable).exclusive :=ex;

except
 //raise;
 rt :=ERROR_;
end;


 Result :=rt;
end;


function TtrxFrm.isDsetReadOnly(dset: Tdataset): Boolean;
var
 rt: Boolean;
begin

 rt :=FALSE;

 if dset.className = DELPHI_TABLE then
  rt :=(dset as TTable).readOnly;

 //if dset.className = IP_TABLE then
 // rt :=(dset as TwwTable).readOnly;

 Result :=rt;

end;


function TtrxFrm.getTableName(dset: Tdataset): String;
var
 tblName:String;
begin

tblname :=NUL;

try
 if dset.className = DELPHI_TABLE then
  tblName :=(dset as TTable).tableName;

 //if dset.className = IP_TABLE then
 // tblName :=(dset as TwwTable).tableName;
except
 exit;
end;


 Result :=tblName;
end;

function TtrxFrm.setTableName(dset: Tdataset; tblName: String): Integer;
var
 rt: Integer;
begin

rt :=0;

try
 if dset.className = DELPHI_TABLE then
  (dset as TTable).tableName :=tblName;

 //if dset.className = IP_TABLE then
 // (dset as TwwTable).tableName :=tblName;

 except
  rt :=ERROR_;
 end;

 Result :=rt;;
end;


function TtrxFrm.getDBTableType(dset: Tdataset): Tdataset;
begin
 Result :=nil;

 try
 if dset.className = DELPHI_TABLE then
  Result :=(dset as TTable)
 else
 //if dset.className = IP_TABLE then
 // Result :=(dset as TwwTable);

 except
 //
 end;

end;

{
function TtrxFrm.getGridDataSource(grid: TcustomGrid): TdataSource;
begin
 Result :=nil;

 try
  if grid.className = DELPHI_GRID then
   Result  :=(grid as TDBgrid).dataSource;

  //if grid.className = IP_GRID then
   //Result  :=(grid as TwwDBgrid).dataSource;
 except
 //
 end;

end;
}

function TtrxFrm.getIndexFieldCount(dset: Tdataset): Integer;
var
 cnt: Longint;
begin

 cnt :=0;

try
 if dset.className = DELPHI_TABLE then
  cnt :=(dset as TTable).indexFieldCount;

 //if dset.className = IP_TABLE then
 // cnt :=(dset as TwwTable).indexFieldCount;

except
  cnt :=ERROR_;
end;

 Result :=cnt;
end;


function TtrxFrm.getRecordCount(dset: Tdataset): Integer;
var
 cnt: Longint;
begin

 cnt :=0;

try
 if dset.className = DELPHI_TABLE then
  cnt :=(dset as TTable).recordCount;

 //if dset.className = IP_TABLE then
 // cnt :=(dset as TwwTable).recordCount;

except
  cnt :=ERROR_;
end;

 Result :=cnt;
end;

{
function TtrxFrm.decodeWWselected(str: String; sld: pSelectData): Integer;
var
 tmpw: String;
 wwfldNo: Integer;
 cx,i,j,k,ps,len: Byte;
begin

 len :=length(str);

 //  Selected.Add('Field1' + #9 + '10' + #9 + 'Field1 Title');

 sld.fldName :='                    ';
 sld.colTitle :='                    ';
 tmpw :='    ';
 sld.colw :=0;
 sld.fno :=0;

 j :=1;
 ps :=0;

 //Feltnavn
 for i:=1 to len do
 begin
  inc(ps);

  if str[ps] =TAB then
   break;

   sld.fldName[j] :=str[ps];

   inc(j);
 end;

  k :=length(trim(sld.fldName));
  setLength(sld.fldName,k);

 //Kolonne-bredde
 j:=1;
 for i:=ps to len do
 begin
  inc(ps);

  if str[ps] =TAB then
   break;

   tmpw[j] :=str[ps];

  inc(j);
 end;

  k :=length(trim(tmpw));
  setLength(tmpw,k);
  sld.colw :=unitFrm.atoi(tmpw);

 //Kolonne-tittel
  j :=1;
 for i:=ps to len do
 begin
  inc(ps);
  if (str[ps] =TAB) OR (str[ps]=NUL) then
   break;

   sld.colTitle[j] :=str[ps];

  inc(j);
 end;


  k :=length(trim(sld.colTitle));
  setLength(sld.colTitle,k);

  //Finn feltnummer i dataset (ikke fieldNo i "original"-tabell)
  wwFldNo :=0;
  if assigned(sld.dset) then
  begin

   with sld.dset do
   begin

    if active then
    begin

    for cx:=0 to pred(fieldCount) do
    begin
     if AnsiCompareText(sld.fldName,fields[cx].fieldName) =0 then
     begin
      wwFldNo :=cx;
      break;
     end;
    end;

    end;
   end;
  end;


 Result :=wwfldNo;
end;
}

{
function TtrxFrm.getGridData(grid: TcustomGrid; grd: pGridData): Integer;
var
 colCnt,cx: Integer;
begin

 Result :=ERROR_;
if not assigned(grid) then
 exit;

 colCnt :=0;

if AnsiCompareText(grid.className,DELPHI_GRID) =0 then
begin

 grd.selectedIndex :=(grid as TDBgrid).selectedIndex;
 grd.selectedField :=(grid as TDBgrid).selectedField;
 grd.columns :=(grid as TDBgrid).columns;
 grd.titleFont :=(grid as TDBgrid).titleFont;
 grd.font :=(grid as TDBgrid).font;
 grd.color :=(grid as TDBgrid).color;

 //decodeWWselected(grid,grd);
 colCnt :=(grid as TDBgrid).columns.count;

 grd.fieldCount :=0;
 for cx :=0 to MAX_GRID_COLS do
 begin
  //if cx <(grid as TDBgrid).columns.Count then
  // grd.columns[cx] :=(grid as TDBgrid).columns[cx];

 try
  if cx <(grid as TDBgrid).dataSource.dataset.fieldCount then
  begin
   inc(grd.fieldCount);
   grd.fields[cx] :=(grid as TDBgrid).fields[cx];
  end;
 except
 //
 end;


 end;


end;

if AnsiCompareText(grid.className,IP_GRID) =0 then
begin

 grd.selectedIndex :=(grid as TwwDBgrid).selectedIndex;
 grd.selectedField :=(grid as TwwDBgrid).selectedField;
 //grd.cols.strings :=(grid as TwwDBgrid).selected.strings;
 grd.titleFont :=(grid as TwwDBgrid).titleFont;
 grd.font :=(grid as TwwDBgrid).font;
 grd.color :=(grid as TwwDBgrid).color;
 colCnt :=(grid as TwwDBgrid).selected.count;

 grd.fieldCount :=0;
 for cx :=0 to MAX_GRID_COLS do
 begin
  //if cx <(grid as TwwDBgrid).selected.Count then
  // grd.cols[cx] :=(grid as TwwDBgrid).selected.strings[cx];

 if cx <(grid as TwwDBgrid).dataSource.dataset.fieldCount then
 begin
  inc(grd.fieldCount);
  grd.fields[cx] :=(grid as TwwDBgrid).fields[cx];
 end;

 end;

end;

 Result :=colCnt;
end;
}


{
function TtrxFrm.setGridData(var grid: TcustomGrid; grd: pGridData): Integer;
begin

 Result :=ERROR_;
if not assigned(grid) then
 exit;

if AnsiCompareText(grid.className,DELPHI_GRID) =0 then
begin


 (grid as TDBgrid).titleFont :=grd.titleFont;
 (grid as TDBgrid).font :=grd.font;
 (grid as TDBgrid).color :=grd.color;


end;


if grid.className =IP_GRID then
begin
 (grid as TwwDBgrid).titleFont :=grd.titleFont;
 (grid as TwwDBgrid).font :=grd.font;
 (grid as TwwDBgrid).color :=grd.color;

end;

 Result :=0;
end;
}

{
function TtrxFrm.emptyAllRecords(dset: Tdataset; var errmsg: String): Integer;
var
 rt: Integer;
 str: String;
begin

rt :=0;

str :=NUL;
errmsg :=str;

str :=dset.className;

//unitFrm.msgDlg(str+' '+DELPHI_TABLE,INFO_);

try
 if str =DELPHI_TABLE then
 begin
  (dset as TTable).emptyTable;
 end;

// if str = IP_TABLE then
//  (dset as TwwTable).emptyTable;

except

  on E:exception do
  begin
   errmsg :=E.message;
   rt :=ERROR_;
  end;

 end;


 Result :=rt;
end;
}

function TtrxFrm.processMemoData(fname,fdata: String): String;
var
 str,psStr,crlfstr: String;
 ps,ps1,ps2,cx,loopLimit,loopCnt,len,fdataLen: Integer;
begin
 str :=fdata;

 ps :=pos(LFLF,str);

 //if AnsiCompareText(fname,'Merknad')=0 then
 // cx :=0;

 if ps>0 then
 begin

  loopLimit :=64;  //I tilfelle spinn...
  loopCnt :=0;

  crlfstr :=CRLF;
  psStr :=str;
  len :=length(LFLF);
  fdataLen :=length(str);

   while ((ps>0) AND (loopCnt<loopLimit)) do
   begin

    for cx:=1 to len do
    begin
     str[(ps-1)+cx] :=crlfstr[cx]
    end;

     ps2 :=(ps+len);
     //Midlertidig string for å sjekke videre framover
     psStr :=copy(str,ps2,(fdataLen-ps2)+1);

     ps1 :=pos(LFLF,psstr);
     if ps1>0 then
      ps :=(ps1+ps2)-1
     else
      ps :=0;

     inc(loopCnt);
   end;

  //ved blanke linjer blir det liggende 3 stk #$A etterhverandre.
  //Dette må sjekkes til slutt.
  ps :=pos(LFLF,str);
  if ps>0 then
  begin
    for cx:=1 to len do
    begin
     str[(ps-1)+cx] :=crlfstr[cx]
    end;
  end;


 end;

 Result :=str;
end;


procedure Ttrxfrm.setFldColor(obj: Tobject; cmd: Integer);
var
 fldColor, fontColor: Tcolor;
begin

fldColor :=clSilver;
fontColor :=clBlack;

if cmd=FOCUSED_ then
begin
 fldColor :=clLime;
 fontColor :=clBlack;
end
else
if cmd=NORMAL_ then
begin

 fldColor :=clBlue;
 fontColor :=clWhite;
end
else
if cmd=DISABLED_ then
begin
// fldStat :=FALSE;
 fldColor :=clSilver;
 fontColor :=clBlack;
end;


 if obj is Tfld then
 begin
  with (obj as Tfld) do
  begin
    color :=fldColor;
    font.color :=fontColor;
  end;
 end;

 if tobj is TcomboFld then
 begin
  with (obj as Tfld) do
  begin
    color :=fldColor;
    font.color :=fontColor;
  end;
 end;



end;

//*******************************************************************

function TtrxFrm.setTrxFnames(dset: TdataSet; ff: pFrms): Integer;
var
 pos,errs,cx,ex: Integer;
 fname: String;
begin

 Result :=ERROR_;

 //beep;
 errs :=0;
 pos :=0;

 if not dset.Active then
  exit;

 if ff.tblFldCnt <=0 then
  ff.tblFldCnt :=dset.FieldCount;

  //Fortsatt 0 ?
  if ff.tblFldCnt <=0 then
   exit;

  //Denne funksjonen aktiveres hver gang en modul blir 'attached'

  //Resett array (brukes som test på at felt ikke sjekkes to ganger)
 for ex:=1 to MAXFLDS do
  fnoar[ex] :=0;


 for cx :=0 to pred(ff.tblFldCnt) do
 begin
    try
     //Finn feltnavn
     fname :=dset.fieldDefs.items[cx].name;
    except
     inc(errs);
     continue;
    end;

     inc(pos);

    try
     trxFrm.col[pos].typ :=dset.fields[cx].dataType;
     trxFrm.col[pos].fname :=dset.fieldDefs.items[cx].name;
    except
     inc(errs);
     continue;
    end;


 trxFrm.col[pos].dspFld :=0;

 //Har dette tabell-felt et koresponderende felt i skjema ?
 for ex:=1 to ff.fldCnt do
 begin

  if fnoar[ex] =ONX then
   continue   //Allerede funnet
  else
  if  AnsiCompareText(fname,ff.fields[ex].fname) =0 then
  begin
   fnoar[ex] :=ONX;  //For å unngå at loop sjekker denne en gang til

   getFldObject(fname,trxFrm.col[pos].dspObj,ff);

   //Finn hvilken datatype som dette representerer i felt på skjema
   getDspType(trxFrm.col[pos].dspObj,trxFrm.col[pos].dspTyp,trxFrm.col[pos].tag);

   //trxFrm.col[pos].tag :=trxFrm.col[pos].dspObj.tag;
   trxFrm.col[pos].dspFld :=ONX;   //Ja, felt er på skjema
  end;

 end;

end;

  Result :=errs;
end;


procedure TtrxFrm.getDspType(obj: Tobject; var dspTyp: Integer; var tagVal: Integer);
begin

 dspTyp :=0;

 if obj = nil then
 begin
  exit;
 end;
{
 if (obj is TovcPictureField) then
 begin
  with (obj as TovcPictureField) do
  begin

   tagVal :=tag;
   case datatype of
    pftTime:    dspTyp :=TIME_FLD;
    pftString:  dspTyp :=STR_FLD;
    pftByte,pftInteger,pftLongint,pftShortint:  dspTyp :=NUM_FLD;
    pftReal,pftExtended,pftSingle,pftDouble: dspTyp :=FLOAT_FLD;
    pftDate: dspTyp :=DATE_FLD;
   end;

  end;
 end
 else
 }

 if (obj is Tfld) then
 begin
  with (obj as Tfld) do
  begin
   tagVal :=tag;
   dspTyp :=tag;  //Denne må være satt riktig under design iflg ptypdef

  end;
 end
 else

 if (obj is Tedit) then
 begin
  with (obj as Tedit) do
  begin
   tagVal :=tag;
   dspTyp :=tag;  //Denne må være satt riktig under design iflg ptypdef

  end;
 end
 else
 {
 if (obj is TwwDBLookupCombo) then
 begin
  with (obj as TwwDBLookupCombo) do
  begin
   tagVal :=tag;
  end;
 end;
//end;
}


end;



//**************************************************************

function  TtrxFrm.getFldObject(fname: String;
  var obj: Tobject; ff: pFrms): Integer;
var
 cx: Integer;
begin


//Finn Component object i definerte felt på form:
for cx :=1 to ff.fldCnt do
 begin
  if cx > MAXFLDS then
   break;

  if  AnsiCompareText(fname,ff.fields[cx].fname)=0 then
  begin
   obj :=ff.fields[cx].comp;
   Result :=cx;
   exit;
  end;

 end;

 obj :=nil;
 Result :=0;
end;


//**************************************************************

procedure TtrxFrm.setFldFocus(fname: String; ff: pFrms);
begin

if fname = NUL then
 exit;

getFldObject(fname,tobj,ff);

if tobj <> nil then
 componentData(tobj,fname,NUL,SET_FOCUS_);

end;

//**************************************************************

function TtrxFrm.getTableDefs(ff: pFrms): Integer;
var
 trxPos,cx: Integer;
 fname: String;

begin

//For å hindre unødig gjennomløp av denne funksjonen
{
if PRVtrxStat > 0 then
begin
 Result :=0;
 exit;
end;
}

 //Henter inn data uten å åpne tabell
 ff.dset.fieldDefs.update;
 ff.tblFldCnt :=ff.dset.fieldDefs.count;

 //Ta ut data om felt
 for cx :=1 to ff.tblFldCnt do
 begin
  fname :=ff.dset.fieldDefs.items[cx-1].name;  //string

  trxPos :=getTrxPos(fname,ff);

  if trxPos >0 then
   begin
     col[trxPos].fname :=fname;
   end;
  end;

 //Sett denne slit at funksjonen ikke brukes flere ganger
// PRVtrxStat :=ONX;

 Result :=0;
end;


//***********************************************************************


function TtrxFrm.getFldType(fname: String; ff: pFrms): TfieldType;
var
 cx: Integer;
begin

 cx :=getFldObject(fname,tobj,ff);

try

 if tobj=nil then
  Result :=ff.dset.fieldByName(fname).dataType
 else
 begin

 if (tobj <> nil) AND
    (assigned(ff.fields[cx].fdef)) then
  Result :=ff.fields[cx].fdef.dataType
 else
  Result :=ftUnknown;
 end;

except
 Result :=ftUnknown;
end


end;

//************************************************************
function TtrxFrm.getField(fname: String; ff: pFrms): Tfield;
var
 cx: Integer;
begin


cx :=getFldObject(fname,tobj,ff);

if tobj <> nil then
  Result :=ff.fields[cx].fdef
else
  Result :=nil;

end;


//*********************************************************

function  TtrxFrm.displayFldData(fname: String;data: String; ff: pFrms): Integer;
begin

getFldObject(fname,tobj,ff);

if tobj <> nil then
begin

  componentData(tobj,fname,data,DISPLAY_);

 Result :=0;
 exit;
end;

 //'fname' finnes ikke
 Result :=ERROR_;
end;


//*****************************************************************

{

function VarType(const V: Variant): Integer;

  varEmpty    = $0000;
  varNull     = $0001;
  varInteger = $0002;
  varInteger  = $0003;
  varSingle   = $0004;
  varDouble   = $0005;
  varCurrency = $0006;
  varDate     = $0007;
  varOleStr   = $0008;
  varDispatch = $0009;
  varError    = $000A;
  varBoolean  = $000B;
  varVariant  = $000C;
  varUnknown  = $000D;
  varByte     = $0011;
  varString   = $0100;
  varTypeMask = $0FFF;
  varArray    = $2000;
  varByRef    = $4000;
}



function TtrxFrm.getFldData(fname: String;var strData: String;ff: pFrms): String;
var
 typ: Integer;
 str: String;
 fldVar: String;
begin



//Sjekk at denne ikke brukes før frmFlds[] er initilaisert
if (ff.fldCnt <=0) OR
   (ff.fldCnt >= MAXFLDS) then
begin
 exit;
end;


    str :=NUL;
strData :=NUL;
 fldVar :=S_NUL;  //Indikerer evnt at felt ikke er funnet.

getFldObject(fname,tobj,ff);


if tobj <> nil then
begin

 fldVar :=componentData(tobj,fname,NUL,GET_);

 //Sjekk variant type for å kunne sette 'strData' riktig
 typ :=VarType(fldVar);

 if (typ <> varNull) AND (typ <> varEmpty) then
 begin

 if (typ = varString) then
  begin
   str := fldVar;

   //Sjekk om 'str' består av kun CR/LF (fra memo-felt)

   if length(str)=2 then
    if (str = MNUL) OR  (str = FNUL) then //((str[1] = #13) AND (str[2] = #10)) then
     str :=NUL;
  end;

  strData :=str;
 end
  else
   begin
    strData :=NUL;
   end;

  //break;
// end;
end;

 //Hvis 'fldName' ikke finnes i frmFlds[] vil dette gi
 //SNUL i retur.
 //Blankt felt gir NUL.

  Result := fldVar;
 end;

//*************************************************************

procedure TtrxFrm.clearCpy;
var
 cx: Integer;
begin

 for cx:=1 to MAXFLDS do
 begin
  cpy[cx].fname :=NUL;
  cpy[cx].data :=NUL;
 end;



end;


function  TtrxFrm.recordToCpy(dset: Tdataset; seqid: Longint; ff: pFrms): Integer;
var
 cx: Integer;
begin

Result :=ERROR_;

if dset = nil then
 exit;

if seqid <=0 then
 exit;

if copyTblToTrx(dset,seqid,ff) >=0 then
begin

 for cx:=1 to MAXFLDS do
 begin
  cpy[cx].fname :=trxFrm.col[cx].fname;
  cpy[cx].data :=trxFrm.col[cx].data;
 end;

end;

 Result :=0;
end;

//***********************************************************

function  TtrxFrm.cpyToFlds(ff: pFrms): Integer;
var
cx: Integer;
begin


 for cx:=1 to MAXFLDS do
 begin
  trxFrm.col[cx].fname :=cpy[cx].fname;
  trxFrm.col[cx].data :=cpy[cx].data;
 end;

 if copyTrxToFlds(ff) <=0 then
  Result :=ERROR_
 else
  Result :=0;

end;


//***********************************************************

function TtrxFrm.copyTrxToFlds(ff: pFrms): Integer;
var
 fname,fdata,datstr: String;
 rt,cx,dx,frmFld: Integer;
begin

 Result :=0;
 dx :=0;

//OBS: Dette tar tid hvis mange felt i tabell !!!
for cx:=1 to ff.tblFldCnt do
begin

 if cx >= MAXFLDS then
  break;

 fname :=trxFrm.col[cx].fname;

 //if AnsiCompareText(fname,'Dato')=0 then
 // rt :=0;

 //Har dette tabell-felt et koresponderende felt i skjema
 frmFld :=trxFrm.col[cx].dspFld;

if frmFld = ONX then
begin

 fdata :=trxFrm.col[cx].data;

 //Sjekk om 'fdata' skal ha annen form ved visening i skjema
 case trxFrm.col[cx].dspTyp of
  TIME_FLD:
   fdata :=unitFrm.StrMinToStrTime(fdata,2);

  NUM_FLD:
   begin
    if unitFrm.atoi(fdata)=0 then
    begin
     fdata :=NUL;   //Ikke vis 0
    end;
   end;
  {
  STR_FLD:
  NUM_FLD:
  MEM_FLD:
  DATE_FLD:
  FLOAT_FLD:
 }
  HOUR_FLD: fdata :=unitFrm.StrMinToStrTime(fdata,1);
  ONOFF_FLD:
  begin
   if fdata = ONEDIGIT then
    fdata :=XON
   else
    fdata :=NUL;

  end;

  DECI_FLD:
  begin
   fdata :=unitFrm.intToDeciStr(unitFrm.atoi(fdata));

  end;

  DATE_FLD:
  begin
   //Pass på at det blir riktig datoformat
   fdata :=dateFrm.setValidDate(fdata);
   
  end;

 end;


 if displayFldData(fname,fdata,ff) >=0 then
  inc(dx);

end
else
 fname :=NUL;


 end;

 Result :=dx;
end;

//******************************************************************

function  TtrxFrm.makeSQL(dset: Tdataset;
 fname,fdata: String; ftype: TfieldType; cmd: integer): String;
var
 rt,prec: Integer;
 dtm: TdateTime;
 sqls,str: String;
begin

 str :=NUL;
 Result :=str;


 if cmd = UPDATE_ then
 begin
   case ftype of
     ftString,ftMemo:
     begin
       //Alle ugyldige tegn må fjernes
       str :=unitFrm.safeSQL(fdata);
       sqls :=format('%s = ''%s''',[fname,str]);
     end;
     ftSmallint,ftInteger,ftWord,ftFMTbcd:
       sqls :=format('%s = %d',[fname,unitFrm.atoi(fdata)]);

     ftTime:
       sqls :=format('%s = ''%s''',[fname,fdata]);

//OBS
     ftDate:
     begin

      if not dateFrm.isDateFilled(fdata) then
        exit;

       sqls :=format('%s = %s',[fname,dateFrm.makeDateKey(fdata,dset.tag)]);

     end;


     ftDateTime,ftTimeStamp:
     begin

      if not dateFrm.isDateFilled(fdata) then
       exit;


      fdata :=dateFrm.setDateTimeYear(fdata,YEAR_4);

      dtm :=strToDateTime(fdata);

      sqls :=format('%s = %s',[fname,dateFrm.makeDateTimeKey(dtm,dset.tag)]);
     end;

     ftFloat:
     begin
      //sjekk om feltdata inneholder komma eller punktum
      if (pos(COMMA,fdata)=0) AND (pos(DOT,fdata)=0) then
       prec :=0
      else
       prec :=MAX_FLOAT_PRECISION;

      try

      if fdata=NUL then
       str :=format('%s = %.*f',[fname,prec,0.00])
      else
       str :=format('%s = %.*f',[fname,prec,strToFloat(fdata)]);
      except
       str :=format('%s = %.*f',[fname,prec,0.00]);
      end;

      //Decimal-tall må inneholde punktum i SQL-setninger
      sqls :=unitFrm.charReplace(str,COMMA,DOT);

      end;  //case ftFloat
    end;

 end;

 if cmd = INSERT_ then
 begin
   case ftype of
     ftString,ftMemo:
     begin
       //Alle ugyldige tegn må fjernes
      str :=unitFrm.safeSQL(fdata);
      sqls :=format('''%s''',[str]);
     end;

     ftSmallint,ftInteger,ftWord,ftFMTbcd:
      sqls :=format('%d',[unitFrm.atoi(fdata)]);

     ftTime:
      sqls :=format('''%s''',[fdata]);

//OBS
     ftDate:
     begin

      if not dateFrm.isDateFilled(fdata) then
       exit;

      sqls :=format('%s',[dateFrm.makeDateKey(fdata,dset.tag)]);

     end;

     ftDateTime,ftTimeStamp:
     begin

      fdata :=dateFrm.setDateTimeYear(fdata,YEAR_4);

      dtm :=strToDateTime(fdata);

      sqls :=format('%s',[dateFrm.makeDateTimeKey(dtm,dset.tag)]);

     end;

     ftFloat:
     begin
      //sjekk om feltdata inneholder komma eller punktum.
      //Hvis ikke, settes antall decimaler til 0
      if (pos(COMMA,fdata)=0) AND (pos(DOT,fdata)=0) then
       prec :=0
      else
       prec :=MAX_FLOAT_PRECISION;

      if fdata=NUL then
       str :=format('%.*f',[prec,0.00])
      else
       str :=format('%.*f',[prec,strToFloat(fdata)]);

       //Decimal-tall må inneholde punktum i SQL-setninger
      sqls :=unitFrm.charReplace(str,COMMA,DOT);

     end;  //case ftFloat
   end;

 end;


 Result :=sqls;
end;


//*******************************************************

function  TtrxFrm.writeToTbl(dset: Tdataset;
 fname,fdata: String; ftype: TfieldType; cmd: Integer): Integer;
var
 dat: String;
 ival: Integer;
begin

 Result :=0;

//typFrm.triggInhibit(ONX);

 try

 //'dset[<string>]' er variant-array og "vet" selv riktig datatype
// dset[fname] :=fdata;
{
if dset.tag<>SQL_BASED then
 if dset.state=dsBrowse then
  dset.edit;
}
    //Sjekk at riktig datatype lagres.
    case ftype of
     ftMemo:
      dset[fname] :=fdata;
     ftString:
       dset.fieldByName(fname).AsString :=fdata;
     ftSmallint,ftInteger,ftWord,ftFMTbcd:
      begin
       ival :=unitFrm.atoi(fdata);
       dset.fieldByName(fname).AsInteger :=ival;
      end;

     ftDate:
     begin

      if not dateFrm.isDateFilled(fdata) then
      begin
       exit;
       //Dagens dato for å unngå feilmelding
       //fdata := dateFrm.setDateYear(dateFrm.getDateFromDateTime(date),YEAR_AUTO);
      end
      else
      begin

       //må ha 4 siffret årstall etter år 2000
       fdata :=dateFrm.setDateYear(fdata,YEAR_4);
      end;

        //Endret 16/10-97 pgr.mistanke om trøbbel med år 00
       //dset.fieldByName(fname).AsDateTime :=tmpDate;
        dset.fieldByName(fname).asString :=fdata;
     end;

     ftDateTime,ftTimeStamp:
     begin

      if not dateFrm.isDateFilled(fdata) then
      begin
       exit;
       //Dagens dato for å unngå feilmelding
       //fdata := dateFrm.setDateYear(dateFrm.getDateFromDateTime(date),YEAR_4);
      end
      else
      begin
       //må ha 4 siffret årstall etter år 2000
        fdata :=dateFrm.setDateTimeYear(fdata,YEAR_4);

      end;

      dset.fieldByName(fname).asString :=fdata;
     end;

     ftFloat:
     begin
      //strToFloat() gir dessverre feilmelding på NUL (som er 0)

      try
       if fdata=NUL then
        dset.fieldByName(fname).value :=0 //ZERO_FLOAT
       else
        dset.fieldByName(fname).AsFloat :=strToFloat(fdata);
      except
       dset.fieldByName(fname).AsFloat :=0.00;
      end;


     end;
     end;

    except
     typFrm.triggInhibit(OFF);

     Result :=ERROR_;
     raise;

    end;

//   typFrm.triggInhibit(OFF);

end;


function TtrxFrm.copyFldsToTbl(dset: Tdataset;
                               seqId,cmd: Integer;
                               ff: pFrms): Integer;
var
 sqlStr,sqlFlds, sqlValues,sqlUpdate: String;
 rt: Integer;
 cx,trxPos: Byte;
 fname: String;
begin

Result :=ERROR_;

if (dset = nil) then
 exit;


if (dset.tag=SQL_BASED) then
begin
 sqlFlds :=NUL;
 sqlValues :=NUL;
 sqlUpdate :=NUL;
end;


 for cx:=1 to ff.fldCnt do
 begin

  if cx >= MAXFLDS then
   break;

  fname :=upperCase(ff.fields[cx].fname);

  if fname <> NUL then
  begin

  // copyFldsToTrx MÅ være kjørt tidligere for å laste inn felt-data
   trxPos :=getTrxPos(fname,ff);

   if trxPos >0 then
   begin

     rt :=0;

   if (dset.tag=SQL_BASED) then
   begin

   if cmd = UPDATE_ then
   begin

   sqlStr :=makeSQL(dset,fname,
           trxFrm.col[trxPos].data,
           trxFrm.col[trxPos].typ,UPDATE_);

    if sqlStr<>NUL then
     sqlUpdate :=sqlUpdate+sqlStr+', '

   end
   else
   begin

    //Bare utfyllte felt
    if length(trxFrm.col[trxPos].data)>0 then
    begin

    sqlStr :=makeSQL(dset,fname,
           trxFrm.col[trxPos].data,
           trxFrm.col[trxPos].typ,INSERT_);

     //verdier
    if sqlStr<>NUL then
    begin
     sqlFlds := sqlFlds + fname +', ';
     sqlValues :=sqlValues+sqlStr+', ';
    end;

   end;

   end;


   end
   else

     //Write ett og ett felt fysisk
      rt :=writeToTbl(dset,fname,
           trxFrm.col[trxPos].data,
           trxFrm.col[trxPos].typ,cmd);

     case rt of
      WARNING_: continue;
      CANCEL_: continue;
      ERROR_:
      begin
       Result :=rt;
       exit;
      end;
     end;

   end;

   end;

  end;

if (dset.tag=SQL_BASED) then
begin

 if (cmd = ADD_) OR (cmd= INSERT_) then

  //?? hvorfor 
  if dset.Active then
   dset[SEQID_FLD] :=lnk.seqID;
{
 try
  tbl.post;    //Dette gjøres i recFrm.savedata;
 except
   unitFrm.msgDlg(format('Cannot commit record on %s:%s'+FNUL+
   'Table may not be available.',
    [tbl.dataBaseName,tbl.tableName]),ERROR_);
  // screen.cursor :=crDefault;
 end;
}
end;


//Hvis SQL mode
if (dset.tag=SQL_BASED) then
begin

//pgr. komma atter hver verdi i loop

unitFrm.stripLastChr(sqlUpdate,',','');
//unitFrm.stripLastChr(sqlUpdate,'''','');

unitFrm.stripLastChr(sqlFlds,',',NUL);

unitFrm.stripLastChr(sqlValues,',',NUL);
{
len := length(sqlUpdate);
if len >3 then
 sqlUpdate[len-1] :=BLANK;

len := length(sqlFlds);
if len >3 then
 sqlFlds[len-1] :=BLANK;

len := length(sqlValues);
if len >3 then
 sqlValues[len-1] :=BLANK;
}

if cmd = UPDATE_ then
begin

 if updateTblValues(ff.tblname,sqlUpdate, format('%s = %d',
   [upperCase(SEQID_FLD),seqId])) <0 then

 begin
  Result :=ERROR_;
  exit
 end;
end;



if (cmd = ADD_) OR (cmd = INSERT_) then   //Ved ny record
begin

if length(sqlFlds) <2 then
 exit;

 sqlFlds :=sqlFlds +', '+SEQID_FLD;
 sqlValues :=sqlValues+', '+format('%d',[lnk.seqID]);

 if insertTblValues(ff.tblname,sqlFlds,sqlValues) <0 then
  exit;

end;

end;



 Result :=cx;
end;


//******************************************************************

function TtrxFrm.copyFldsToTrx(ff: pFrms): Integer;
var
 rt,trxPos,cx,dx: Integer;
 fname,strval: String;
 trxdata,fdata: String;
begin


dx :=0;
for cx:=1 to ff.fldCnt do
begin

 if cx >= MAXFLDS then
  break;

 fname :=ff.fields[cx].fname;
 if fname = NUL then
  continue;

 fdata:=getFldData(fname,strVal,ff);


 //Endrer ikke data for felt som er i col[]
 //men ikke i fields[].
 //SNUL betyr at felt ikke finnes.
 if (fdata <> NULL) AND (fdata <> S_NUL) then
 begin
  trxPos :=trxFrm.getTrxPos(fname,ff);
  if trxPos >0 then
  begin
   //Sjekk om 'fdata' skal ha annen type ved lagring
   case trxFrm.col[trxpos].dspTyp of
    TIME_FLD: fdata :=unitFrm.strTimeToStrMin(fdata);
    {
    STR_FLD:
    NUM_FLD:
    MEM_FLD:
    DATE_FLD:
    FLOAT_FLD:
    }
   HOUR_FLD: fdata :=unitFrm.strTimeToStrMin(fdata);
   ONOFF_FLD:
   begin
    if fdata = XON then
     fdata :=ONEDIGIT
    else
     fdata :=NULLDIGIT;
   end;

  DECI_FLD:
  begin
   fdata :=format('%d',[unitFrm.DeciStrToInt(fdata)]);
  end;


  end;

   //Modul-funksjon for å konvertere bestemte felt
  if assigned(lnk.recordFieldFunc) then
   trxdata :=lnk.recordFieldFunc(fname,fdata)
  else
   trxdata :=fdata;

   trxFrm.col[trxPos].data :=trxdata;
  end;

 end;

// ShowMessage(trxFrm.col[cx].name + BLANK+strVal);
 if length(strVal)>0 then
  inc(dx);

 end;

 //Filter for data i bestemte felt f.eks tidskode
 //if assigned(lnk.recordFieldFunc) then
 // lnk.recordFieldFunc(NUL,NUL);

 Result :=dx;  //dx blir 0 hvis alle felt er tomme
end;

//***********************************************************

function TtrxFrm.getTrxValue(fname: String; ff: pFrms): String;
var
 cx: Integer;
 data: String;
begin

data :=NUL;
Result :=data;

if fname = NUL then
 exit;


for cx :=1 to ff.tblFldCnt do
begin

 if cx >= MAXFLDS then
  break;


 if 0 = AnsiCompareText(trxFrm.col[cx].fname,fname) then
  begin
   data :=trxFrm.col[cx].data;
   //Result :=data;
   //exit;
  end
end;


 Result :=data;  //fld er ikke funnet i trxFrm.col[].name
end;


//******************************************************************

function TtrxFrm.setTrxValue(fname:String; value: String; ff: pFrms): Integer;
var
 cx: Integer;
begin


for cx :=1 to ff.fldCnt do
begin

 if cx >= MAXFLDS then
  break;

 if AnsiCompareText(trxFrm.col[cx].fname,fname)=0 then
  begin
   trxFrm.col[cx].data := value;
   Result :=cx;
   exit;
  end
end;

 Result :=0;  //fld er ikke funnet i trxFrm.col[].name
end;

//******************************************************************

procedure TtrxFrm.clearFlds(ff: pFrms);
var
 cx,pos: Integer;
 fname: String;
begin


for cx:=1 to ff.fldCnt do
begin

 try
  fname :=ff.fields[cx].fname;
  if (fname <> NUL) then
  begin
   //Hvis dette felt ikke er knyttet til data-tabell, ikke slett
   pos :=getTrxPos(fname,ff);

   if (pos>0) AND (pos<MAXFLDS) then
   begin

 //  {$IFNDEF ROAD }   //Fjernet 24/10-98
    if col[pos].tag <0 then
    begin
     pos :=0;
     continue;
    end;
//  {$ENDIF }

   {
   if pos<=0 then
    continue;
   }
   displayFldData(fname,NUL,ff);

   end;
  end;

 except
  continue;
 end;

end;

 clearTrxData();
 //lnk.seqid :=0;

end;

//******************************************************************

procedure TtrxFrm.clearTrxData;
var
 cx: Integer;
begin

 for cx :=1 to MAXFLDS do
  begin
   col[cx].data :=NUL;
  end;

end;


procedure TtrxFrm.clearTrx;
var
 cx: Integer;
begin

 for cx :=1 to MAXFLDS do
  begin
   col[cx].fname :=NUL;
   col[cx].data :=NUL;
  end;

  frmDefStat :=OFF;
//  PRVtrxStat :=0;

end;

//******************************************************************

function TtrxFrm.copyTblToTrx(dset: Tdataset;
   seqid: Longint; ff: pFrms): Integer;
var
 cx,dx,rt,trxPos,errs,pos: Integer;
 fname,fdata: String;
 ftyp: TfieldType;
begin

 errs :=0;
Result :=ERROR_;

if not assigned(dset) then
 exit;

if seqid <0 then
 exit;

clearTrxData();

 dx :=1;
 for cx :=0 to pred(ff.tblFldCnt) do
 begin

    try
     //Finn feltnavn
     fname :=dset.fieldDefs.items[cx].name;
    except
     inc(errs);
     continue;
    end;

     trxPos :=getTrxPos(fname,ff);

    //Hvis 'fname' finnes i 'frmFlds', blir 'trxPos' >0
    //Hvis ikke,blir felt-data og navn lagt til trxFrm.col[] etter trxFrm.col[dx]
     if trxPos >0 then
     begin
      pos :=trxPos;
     end
     else
      begin
       pos :=dx;
       inc(dx);
      end;


    try

// unitFrm.TCtoStrTime(dset.fields[cx].AsDateTime)
{
    if dset.fields[cx].dataType = ftTime then
     trxFrm.col[pos].data :=unitFrm.TCtoStrTime(dset.fields[cx].AsDateTime)
    else
}

   fdata :=dset.fields[cx].AsString;


   ftyp :=dset.fields[cx].dataType;

   //Av ukjent grunn lagres CRLF som LFLF i ORACLE
   //Dette må erstattes når data hentes inn igjen

  if (ftyp=ftString) OR (ftyp=ftMemo) then
   fdata :=processMemoData(fname,fdata);


   //Modul-funksjon for å konvertere bestemte felt
  if assigned(lnk.recordFieldFunc) then
   fdata :=lnk.recordFieldFunc(fname,fdata);


     if (ftyp=ftDateTime) OR (ftyp=ftTimeStamp) then
     begin
                                               //sysUtil variabel
      //trxFrm.col[pos].data :=copy(fdata,1,length(shortDateFormat));
      trxFrm.col[pos].data :=fdata; //dateFrm.setValidDate(fdata);

     end
     else
       trxFrm.col[pos].data :=fdata;

     //Sjekk om col[].fname må oppdateres
     if trxPos<=0 then
     begin
       trxFrm.col[pos].typ :=ftyp;

       trxFrm.col[pos].fname :=dset.fieldDefs.items[cx].name;
     end;
     except
       inc(errs);
      end;

    end;


 //errs vil nå være antall felt som ikke har blitt oppdaterte
 Result :=errs;
end;


//******************************************************************
{
ftUnkown	Unknown or undetermined
ftString	Character or string field
ftSmallint	16-bit integer field
ftInteger	32-bit integer field
ftWord	16-bit unsigned integer field
ftBoolean	Boolean field
ftFloat	Floating-point numeric field
ftCurrency	Money field
ftBCD	Binary-Coded Decimal field
ftDate	Date field
ftTime	Time field
ftDateTime	Date and time field
ftBytes	Fixed number of bytes (binary storage)
ftVarBytes	Variable number of bytes (binary storage)

ftAutoInc	Auto-incrementing 32-bit integer counter field
ftBlob	Binary Large OBject field
ftMemo	Text memo field
ftGraphic	Bitmap field
ftFmtMemo	Formatted text memo field
ftParadoxOle	Paradox OLE field
ftDBaseOle	dBASE OLE field
ftTypedBinary	Typed binary field
}


function TtrxFrm.copyTrxToTbl(dset: Tdataset;seqID: Longint; cmd: Integer; ff: pfrms): Integer;
var
 str,sqlFlds, sqlValues,sqlUpdate: String;
 rt,cx,errs: Integer;
 trxPos: Byte;
 ftyp: TfieldType;
 fname,fdata: String;
begin

 Result :=ERROR_;
 errs :=0;
 rt :=0;


 if dset=nil then
  exit;

 //Hvis ikke typFrm.eventInhibit settes til 1,
 //blir det recursive loop på gotoRecord() ...
 typFrm.triggInhibit(ONX);

if (dset.tag=SQL_BASED) then
begin
 sqlFlds :=NUL;
 sqlValues :=NUL;
 sqlUpdate :=NUL;

 for cx:=1 to ff.tblFldCnt do
 begin

  if cx >= MAXFLDS then
   break;

  //fname :=upperCase(ff.fields[cx].fname);

  fname :=trxFrm.col[cx].fname;
  fdata :=trxFrm.col[cx].data;
  ftyp :=trxFrm.col[cx].typ;

  if fname=NUL then
   trxpos :=0;


  if fname <> NUL then
  begin

  // copyFldsToTrx MÅ være kjørt tidligere for å laste inn felt-data
   trxPos :=getTrxPos(fname,ff);

  if (trxpos=1) AND (AnsiCompareText(fname,SEQID_FLD)<>0) then
  begin
   unitFrm.msgDlg(format('Intern feil i felt-definisjoner.'+FNUL+
                         'Forventet %s, men funnet %s'+FNUL+
                         'Avslutt programmet og forsøk påny.',
                         [SEQID_FLD,fname]),ERROR_);
   exit;
  end;


   if trxPos >0 then
   begin

     rt :=0;

   if (dset.tag=SQL_BASED)  then
   begin

   if cmd = UPDATE_ then
   begin
     str :=makeSQL(dset,fname,fdata,ftyp,UPDATE_);

     //Bygg komma-separert string
     if str<>NUL then
      sqlUpdate :=sqlupdate+format('%s%s ',[str,COMMA]);


   end
   else
   begin

    //Bare utfylte felt
    if length(fdata)>0 then
    begin
     //Felt-navn
     sqlFlds := sqlFlds + format('%s%s ',[fname,COMMA]);

     str :=makeSQL(dset,fname,fdata,ftyp,INSERT_);
     //verdier
    if str <> NUL then
     sqlValues :=sqlValues+format('%s%s ',[str,COMMA]);

    end;

   end;


   end
   else

     //Write ett og ett felt fysisk
      //rt :=writeToTbl(dset,fname,fdata,ftyp,cmd);
      rt :=0;

     case rt of
      WARNING_: continue;
      CANCEL_: continue;
      ERROR_:
      begin
       Result :=rt;
       exit;
      end;
     end;

   end;

   end;

  end;

if (dset.tag=SQL_BASED) then
begin

 if (cmd = ADD_) OR (cmd= INSERT_) then
  dset[SEQID_FLD] :=lnk.seqID;
{
 try
  tbl.post;    //Dette gjøres i recFrm.savedata;
 except
   unitFrm.msgDlg(format('Cannot commit record on %s:%s'+FNUL+
   'Table may not be available.',
    [tbl.dataBaseName,tbl.tableName]),ERROR_);
  // screen.cursor :=crDefault;
 end;
}
end;


//Hvis SQL mode
if (dset.tag=SQL_BASED)  then
begin

//pgr. komma atter hver verdi i loop

unitFrm.stripLastChr(sqlUpdate,',','');
//unitFrm.stripLastChr(sqlUpdate,'''','');

unitFrm.stripLastChr(sqlFlds,',',NUL);

unitFrm.stripLastChr(sqlValues,',',NUL);

rt :=0;

if cmd = UPDATE_ then
begin

 if updateTblValues(ff.tblname,sqlUpdate, format('%s = %d',
   [upperCase(SEQID_FLD),seqId])) <0 then

 begin
  Result :=ERROR_;
  exit
 end;
end;



if (cmd = ADD_) OR (cmd = INSERT_) then   //Ved ny record
begin

 if length(sqlFlds) <2 then
  exit;


 if insertTblValues(ff.tblname,sqlFlds,sqlValues) <0 then
  exit;

end;


 end;
end
else
begin    //Hvis ikke SQL-basert

 for cx :=1 to ff.tblFldCnt do begin

     if trxFrm.col[cx].data = NUL then
      continue
     else

     rt :=writeToTbl(dset,
           trxFrm.col[cx].fname,
           trxFrm.col[cx].data,
           trxFrm.col[cx].typ,cmd);

     case rt of
      CANCEL_: inc(errs);  //Går videre selv om forrige feilet
      ERROR_: break;     //Avbryter
     end;


  end;
 end;

 typFrm.triggInhibit(OFF);


 Result :=errs;
end;

//******************************************************************

function TtrxFrm.getTrxPos(fname: String; ff: pFrms): Integer;
var
 cx: Integer;
begin

//Finn fld's pos i frmFlds[] og dermed trxFrm.col[]
Result :=0;
for cx:=1 to ff.tblFldCnt do
begin

 if cx >= MAXFLDS then
  break;

 if 0 =AnsiCompareText(trxFrm.col[cx].fname,fname) then
 begin
  Result :=cx;
  break;
 end
end;

end;


//*************************************************************

function TtrxFrm.componentData(tobj: Tobject;fname: String;
            data: String; cmd: Integer): String;
var
 strVal: String;
begin

//************************************************************
// Pr. dato er det ukjent hvordan Tfld, TcombFld og TmemoFld
// kan substitueres med en placeholder variabel.
// Derfor en noe "bustete" typecast komposisjon... Sorry
//*************************************************************

// OBS: Blank felt vil gi NUL slik at det er mulig
// å detektere om 'strVal' er satt i fra blankt felt iflg. 'fname'
strVal :=NUL;
Result :=strVal;

if tobj.classType = Tfld then
begin

     with tobj as TFld do
     begin

      case cmd of
       LOAD_:
        strVal :=name;

       DISPLAY_:
        begin
         text :=data;
         strVal :=fname;
        end;
       GET_:  strVal := text;

       SET_FOCUS_:
       try
        setFocus;
       except
        //
       end;
      end;

    end;


  Result :=strVal;
  exit;
 end;


if tobj.classType = TcomboFld then
begin

  with tobj as TcomboFld do
   begin
      case cmd of
       LOAD_:
        strVal :=name;

       DISPLAY_:
        begin
         text :=data;
         strVal :=fname;
        end;
       GET_:  strVal := text;
       SET_FOCUS_:
        try
         setFocus;
        except
        //
        end;
      end;

    end;

  Result :=strVal;
  exit;
 end;


 if tobj.classType = TmemoFld then
 begin

   with tobj as TmemoFld do
     begin
      case cmd of
       LOAD_:
        strVal :=name;

       DISPLAY_:
        begin
         text :=data;
         strVal :=fname;
        end;
       GET_:  strVal := text;
       SET_FOCUS_:
        try
         setFocus;
        except
        //
        end;
      end;

     end;

  Result :=strVal;
  exit;
 end;

{
if tobj.classType = TovcSimpleField then
begin

   with tobj as TovcSimpleField do
    begin
      case cmd of
       LOAD_:
        strVal :=name;

       DISPLAY_:
        begin
         text :=data;
         strVal :=fname;
        end;
       GET_:  strVal := text;
       SET_FOCUS_:
        try
         setFocus;
        except
        //
        end;

      end;
   end;

  Result :=strVal;
  exit;
 end;
}

{
if tobj.classType = TwwDBLookupCombo then
begin

   with tobj as TwwDBLookupCombo do
    begin
      case cmd of
       LOAD_:
        strVal :=name;

       DISPLAY_:
        begin
         text :=data;
         strVal :=fname;
        end;
       GET_:  strVal := text;
       SET_FOCUS_:
        try
         setFocus;
        except
        //
        end;

      end;
   end;

  Result :=strVal;
  exit;
 end;



 if tobj.classType = TovcPictureField then
 begin

   with tobj as TovcPictureField do
      begin
      case cmd of
       LOAD_:
        strVal :=name;

       DISPLAY_:
        begin
         text :=data;
         strVal :=fname;
        end;
       GET_:  strVal := text;
       SET_FOCUS_:
       try
         setFocus;
        except
        //
        end;

      GET_MASK_: strVal :=pictureMask;
      end;
    end;

  Result :=strVal;
  exit;

 end;
}

if tobj.classType = TcheckFld then
begin

  with tobj as TcheckFld do
   begin
      case cmd of
       LOAD_:
        strVal :=name;

       DISPLAY_:
        begin

         if data = XON then
          checked :=TRUE
         else
          checked :=FALSE;

         strVal :=fname;
        end;
       GET_:
        begin
        if checked then
         strVal :=XON
        else
         strVal :=NUL;

        end;

       SET_FOCUS_:
        try
         setFocus;
        except
        //
        end;
      end;

    end;

  Result :=strVal;
  exit;
 end;


 Result :=strVal;
end;


//*********************************************************

procedure TtrxFrm.loadFdefs(ff: pFrms);
var
 cx,errs: Byte;
begin

if ff = nil then
begin
 cx :=0;
 exit;
end;
//beep;


 errs :=0;
for cx :=1 to ff.fldCnt do
 begin
  if cx >= MAXFLDS then
   break;

//Denne er litt farlig hvis det er problem med tabellen ...
//Hvis form inneholder Tfld,TlistFld,Tmemo som ikke
//har felt i tabell, vil 'errs' øke. Dette er ikke
//nødvendigvis feil ...
   try
    ff.fields[cx].fDef :=ff.dset.fieldByName(ff.fields[cx].fname);
   except
    inc(errs);
    continue;
   end;

 end;

end;

//**************************************************************

function TtrxFrm.getFrmFieldDef(ff: pFrms): Integer;
var
 cx,dx: Integer;
 fname: String;
begin


Result :=ERROR_;

try

if (not assigned(ff)) OR
   (not assigned(ff.frm)) then
begin
 exit;
end;

except
 exit
end;

//Finn alle felt-navn med type
//Tfld,TcomboFld,TmemoFld,TcheckFld og TOvcPictureField
//Alle komponenter på 'frm' sjekkes. Bare første gang (formShow)
cx :=0;
ff.FldCnt :=0;
 dx :=0;

for cx:=0 to pred(ff.frm.componentCount) do
begin

 tobj :=ff.frm.components[cx];

{
 if tobj is TgroupBox then
 begin
  with (tobj as TgroupBox) do
   color :=StringToColor(iniFrm.grpBoxColor.text);
 end;

 if tobj is Tpanel then
 begin
  with (tobj as Tpanel) do
   color :=StringToColor(iniFrm.pnlBtnColor.text);
 end;
}

 //Returnerer felt-navn ved cmd = LOAD_;
 //'fname' blir NUL hvis 'tobj' ikke er definert datafelt
 fname :=componentData(tobj,NUL,NUL,LOAD_);

 if (fname <> NUL) then
 begin

 inc(dx);

 if dx>= MAXFLDS then
 begin
  unitFrm.msgDlg(format('Skjema %s har for mange felt (%d)',
  [ff.frm.caption,MAXFLDS]),ERROR_);
  break;
 end;

  ff.FldCnt :=dx;

  try
   ff.fields[dx].fname:=fname;
   ff.fields[dx].comp :=tobj;

   
   //if ff.lTbl.tableName <> NUL then
   //begin
    ff.fields[dx].fdef :=ff.dset.fieldByName(fname);
    ff.fields[dx].no :=ff.fields[dx].fDef.fieldNo;
   //end;
  except
  //
  end;


  fname :=NUL;
 end

end;


 Result :=ff.FldCnt;
end;

function TtrxFrm.getfieldDataTyp(fldType: TfieldType): Integer;
begin

Result :=ERROR_;

if (fldType in
   [ftSmallint,ftInteger,ftWord,ftFMTbcd]) then
begin
  Result :=INTEGER_KEY;
end
else

if (fldType in
   [ftFloat]) then
begin
  Result :=FLOAT_KEY;
end
else


if (fldType in [ftString]) then
begin
 Result :=TEXT_KEY;
end
else

if (fldType in [ftMemo]) then
begin
 Result :=MEMO_KEY;
end
else

if (fldType in [ftDate]) then
begin
  Result :=DATE_KEY;
end
else
if (fldType in [ftTime,ftDateTime]) then
begin
 Result :=DATETIME_KEY;
end
else
if (fldType in [ftCurrency]) then
begin
 Result :=CURRENCY_KEY;
end
else

if (fldType in [ftGraphic]) then
begin
 exit;
end;


end;


procedure TtrxFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action :=cafree;
 trxFrm :=nil;
end;

initialization
 trxFrm :=nil;
{
 trxFrm :=TtrxFrm.create(trxFrm);
  if trxFrm =nil then
   halt;
 }

end.
