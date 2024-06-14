unit unMailClient;

interface

uses
  mid_typs,
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  IdSMTP,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdMessageClient,
  IdPOP3,
  Buttons,
  StdCtrls,
  IdMessage,
  IdCoder,
  IdCoder3To4,
  unProcs,
  ExtCtrls,
  DateUtils,
  Mask,
  JvExMask,
  JvToolEdit,
  ComCtrls,
  Grids,
  DBGrids,
  DBXpress,
  DB,
  DBClient,
  SimpleDS,
  SqlExpr,
  Menus,
  JvExDBGrids,
  JvDBGrid,
  JvDBUltimGrid,
  iniFiles,
  JvComponent,
  JvAppStorage,
  JvAppIniStorage,
  FileCtrl,
  JvDriveCtrls, LMDCustomButton, LMDButton;

const
  MAX_INI_LINES = 100;
  MAX_MEMO_LINES=1000;
  min5=5/(24*60);
  INI_FILE_NAME ='xmail.ini';
  GRID_FILE_NAME ='listgrid.ini';
  IDX_NAME ='mIdx';

type
  TMainForm = class(TForm)
    pgCtrlMail: TPageControl;
    tsMail: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LblPOP3: TLabel;
    mailText: TMemo;
    pnlBtns: TPanel;
    SpbtnReceive: TSpeedButton;
    btnSendMail: TSpeedButton;
    SpbtnPause: TSpeedButton;
    LogUpdateBtn: TSpeedButton;
    pnlTimer: TPanel;
    chkSendFile: TCheckBox;
    chkAttachFile: TCheckBox;
    mailTo: TEdit;
    mailSubject: TEdit;
    mailAttachment: TJvFilenameEdit;
    todoFileName: TEdit;
    IdPOP3: TIdPOP3;
    IdSMTP: TIdSMTP;
    IdMessageS: TIdMessage;
    MainTimer: TTimer;
    IdMessageR: TIdMessage;
    btnTimer: TTimer;
    dbCnct: TSQLConnection;
    empQry: TSimpleDataSet;
    dbSrc: TDataSource;
    tsLog: TTabSheet;
    LoggMemo: TMemo;
    Label6: TLabel;
    mailFrom: TEdit;
    gridstore: TJvAppIniFileStorage;
    resGrpQry: TSimpleDataSet;
    mnuPopFile: TPopupMenu;
    mnuPopDeleteFile: TMenuItem;
    mnuPopMoveFile: TMenuItem;
    sendTimer: TTimer;
    pnlMailListMain: TPanel;
    pnlMailFilesMain: TPanel;
    pnlMailList: TPanel;
    Label5: TLabel;
    btnLoadMailList: TBitBtn;
    resGrp: TComboBox;
    pgCtrlFiles: TPageControl;
    tsFilesSend: TTabSheet;
    tsFilesMoved: TTabSheet;
    filesReadyList: TJvFileListBox;
    pnlFilesReady: TPanel;
    pgsBar: TProgressBar;
    btnStopSend: TBitBtn;
    filesSendtList: TJvFileListBox;
    pnlFilesSendt: TPanel;
    btnDeleteSendt: TBitBtn;
    btnSetup: TSpeedButton;
    btnCheckMailAdress: TBitBtn;
    mnuSendFile: TMenuItem;
    DBGrid1: TDBGrid;
    pdfCnt: TEdit;
    empCnt: TEdit;
    mnuFileListUpdate: TMenuItem;
    loadTimer: TTimer;
    btnSendMailList: TLMDButton;
    pnlInfo: TPanel;
    Label7: TLabel;
    fileListBox: TListBox;
    procedure btnSendMailClick(Sender: TObject);
    procedure IdSMTPConnected(Sender: TObject);
    procedure IdSMTPDisconnected(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure SpbtnReceiveClick(Sender: TObject);
    procedure IdPOP3Connected(Sender: TObject);
    procedure IdPOP3Disconnected(Sender: TObject);
    procedure SpbtnPauseClick(Sender: TObject);
    procedure btnTimerTimer(Sender: TObject);
    procedure btnLoadMailListClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuSetupClick(Sender: TObject);
    procedure dbCnctAfterConnect(Sender: TObject);
    procedure dbCnctBeforeConnect(Sender: TObject);
    procedure listGridTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure pgCtrlMailChange(Sender: TObject);
    procedure btnDeleteSendtClick(Sender: TObject);
    procedure mnuPopDeleteFileClick(Sender: TObject);
    procedure mnuPopMoveFileClick(Sender: TObject);
    procedure btnSendMailListClick(Sender: TObject);
    procedure sendTimerTimer(Sender: TObject);
    procedure btnStopSendClick(Sender: TObject);
    procedure pgCtrlFilesChange(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
    procedure dbSrcDataChange(Sender: TObject; Field: TField);
    procedure btnCheckMailAdressClick(Sender: TObject);
    procedure filesReadyListClick(Sender: TObject);
    procedure mnuSendFileClick(Sender: TObject);
    procedure mnuPopFilePopup(Sender: TObject);
    procedure mnuFileListUpdateClick(Sender: TObject);
    procedure loadTimerTimer(Sender: TObject);
    procedure pnlBtnsDblClick(Sender: TObject);



  private
    Procs 		: Tprocs;

    PRVfirst_time          : boolean;

    PRVprog_dir,PRVprog_name, PRVprog_ext: string;

    PRVcaptionstr          : String;

    PRVlastLogDay,PRVlastInfoHour  : word;

    PRVdebugging		: boolean;

    PRVtodoDir,PRVdoneDir,PRVlogDir: String;

    PRVlogfile		: textfile;
    PRVlogDT               : TDateTime;

    PRVlogList            : Tstringlist;
    PRVdestinationList    : Tstringlist;

    PRVsendLastChecked     : boolean;

    PRVprgDir: String;
    PRVsortDir: String;

    PRVsqlServername: String;
    PRVfileSendPos: Integer;
    PRVskippedFileSend: Integer;

//Av en eller annen grunn har ikke JvFileListBox.items count property
    PRVfileListCnt: Integer;

    function delete_File(totname:string):boolean;
    function rename_File(oldname,newname:string):boolean;

    function  copy_File(flname,destDir: String): boolean;

    function  move_File(flname,destDir: String): boolean;

    Procedure add_to_loggmemo(txt:string);
//    Procedure read_ini_file;
    Procedure SaveInfoLog;
    function _ValidTTVfile(totfilename:string):boolean;
    { Private declarations }
    function loadTodoFile(flname: String): Integer;
    function getTodoFile: String;
    function deleteTodoFile(flname: String): Integer;
    function dbConnect(stat: Boolean): Integer;
    procedure gridSort(dset: TClientDataset; fname: String);

    function sendMail(mail_From,mail_To,mail_Subject,mail_Txt,mail_Attach: String;
                        cmd: Integer): Integer;
    function getMailListFile(lnr: Integer): String;

    function getMailAdress(sgn,flname: String): String;
    function verifyMailList: Boolean;

    procedure setBtnStat(bstat: Boolean);
  public
    { Public declarations }

    function loadEmpQry(fname,fdata,sortflds,sortdir: String; cmd: Integer): Integer;
    function sendMailList(cmd: Integer): Integer;
    function checkMailList(cmd: Integer): Integer;

  end;

var
  MainForm: TMainForm;

implementation

uses
 mail_ini,
 mid_units,
 mid_cnct,
 mid_date;

{$R *.dfm}

 procedure TmainForm.setBtnStat(bstat: Boolean);
 begin
  //empQry.EnableControls :=not bstat;
  //filesReadyList.visible :=not bstat;

  sendTimer.enabled :=bstat;
  btnSendMailList.enabled :=not bstat;
  btnStopSend.enabled :=bstat;
  sendTimer.enabled :=bstat;

 end;

function TmainForm.verifyMailList: Boolean;
var
 rt: Integer;
begin

 Result :=FALSE;
typFrm.triggInhibit(ONX);

 //Sjekk først om mail-adresser er lastet inn
with dbSrc.DataSet do
begin
  if not active then
   rt :=(-1)
  else
  begin
  if recordCount=0 then
   rt :=(-1)
  else
   rt :=recordCount;

  end;
end;

{
 if rt<0 then
 begin
  setBtnStat(FALSE);
  unitFrm.msgDlg('Mail liste er blank',INFO_);
  exit;
 end;
}
typFrm.triggInhibit(OFF);

 if rt>0 then
  Result :=TRUE;
end;

function TmainForm.getMailListFile(lnr: Integer): String;
var
 flname: String;
begin
 flname :=NUL;
 Result :=flname;

 if lnr<0 then
  exit;

 with filesReadyList do
 begin
  if items.count=0 then
   exit;

 //Filene fjernes ettehvert.
 //De som ikke blir sendt på grunn av manglende e-mail adresse,
 //blir liggende igjen øverst  
  try
   flname :=items[PRVskippedFileSend];
  except
   flname :=NUL
  end;

 end;


 Result :=flname;
end;

function TmainForm.checkMailList(cmd: Integer): Integer;
var
 cnt,cx: Integer;
 flname,mailadr: String;
begin
 Result :=ERROR_;

 if not verifyMailList() then
 begin

  setBtnStat(FALSE);
  unitFrm.msgDlg('Mail liste er blank',INFO_);
  exit;
 end;

cnt :=0;

dbSrc.dataset.DisableControls;
fileListBox.Items.Clear;

screen.Cursor :=crHourGlass;

with filesReadyList do
begin

 for cx :=0 to pred(items.Count) do
 begin
  flname :=items[cx];

  mailadr :=getMailAdress(NUL,flname);
  if mailadr<>NUL then
   inc(cnt)
  else
   fileListBox.Items.add(flname);

 end;


end;

dbSrc.dataset.enableControls;
screen.Cursor :=crDefault;

 Result :=cnt;
end;



function TmainForm.sendMailList(cmd: Integer): Integer;
var
 cx,cnt,sentCnt: Integer;
 flname,sgn: String;
begin
Result :=ERROR_;

sentCnt :=0;

PRVskippedFileSend :=0;

pgsBar.Position :=0;
pgsbar.step :=1;

PRVfileSendPos :=0;

if not directoryExists(iniFrm.doneDir.Text) then
begin
 unitFrm.msgDlg(format('Katalog %s for sendte filer '+FNUL+
                       'er ikke tilgjengelig.',
                        [iniFrm.doneDir.Text]),ERROR_);
 exit;

end;

fileListBox.Items.Clear;

sendTimer.enabled :=TRUE;
sendTimer.Interval :=unitFrm.atoi(iniFrm.sendInterval.text);

btnSendMailList.enabled :=FALSE;
btnStopSend.enabled :=TRUE;
//dbSrc.dataset.disableControls;

filesReadyList.Hide;

//filesReadyList.visible :=FALSE;
//pnlmailList.Visible :=FALSE;
//fileListBox.Items :=filesReadyList.items;

//cnt :=fileListBox.Items.count;
cnt :=filesReadyList.items.count;
pgsbar.max :=cnt;

{
with empQry do
begin
  if not active then
   exit;

  cnt :=recordCount;
  pgsbar.max :=cnt;

  disableControls;
  first;
  for cx :=1 to cnt do
  begin
   sgn :=fieldByName('Sign').asString;


   try
    next;
    pgsBar.stepit;
    inc(sentCnt);
   except
    break;
   end;

  end;

 enableControls;
end;
}

 Result :=cnt;
end;

function TmainForm.getMailAdress(sgn,flname: String): String;
var
 flsgn,mailadr: String;
 ps: Integer;
begin

mailadr :=NUL;

Result :=mailadr;
if (trim(flname)=NUL) AND (trim(sgn)=NUL) then
 exit;

typFrm.triggInhibit(ONX);

//basert på at signaturen ligger først i filen
//f.eks. MAR_12285_23.04.06-21.05.06.PDF


if sgn<>NUL then
 flsgn :=sgn
else
begin

ps :=pos('_',flname);
if ps>0 then
begin
 flsgn :=copy(flname,1,(ps-1));
end;

end;

with dbSrc.dataset do
begin
  if not active then
   exit;

 // filter :=format('Sign=''%s*''',[flsgn]);
 // filtered :=TRUE;
 //  if recordCount>0 then


 //Fordi underscore alltid er separator
 //Dette var feil fram til 01.06.07 som gjorde at f.eks. VIH fikk
 //skjema for VI
 //flsgn :=flsgn;


 if locate('Sign',flsgn,[locaseInsensitive]) then
   mailadr :=fieldByName('Email').asString;

  //filtered :=FALSE;

end;

typFrm.triggInhibit(OFF);

 Result :=mailadr;
end;

procedure TmainForm.gridSort(dset: TClientDataset; fname: String);
const
  NONSORTABLE: Set of TFieldType=[ftBlob,ftMemo,ftOraBlob,ftOraCLob];
begin


  with dset do
  begin
    if IsEmpty or (FieldByName(fname).DataType in NONSORTABLE) then
      Exit;

    if (IndexFieldNames=fname) then
    begin
       IndexDefs.Update;
       if IndexDefs.IndexOf(IDX_NAME)>-1  then
       begin
         DeleteIndex(IDX_NAME);
         IndexDefs.Update;
       end;
       AddIndex(IDX_NAME,fname,[ixDescending,ixCaseInsensitive],'','',0);
       IndexName:=IDX_NAME;
    end
    else
    begin
       IndexFieldNames := fname;
    end;
  end;


 end;


function TmainForm.dbConnect(stat: Boolean): Integer;
begin
 Result :=ERROR_;

  if dbCnct.connected=stat then
    exit;

 with dbCnct do
 begin

   try
    screen.Cursor :=crHourGlass;

    connected :=stat;
   except

    screen.Cursor :=crDefault;
    try
     cnctFrm.Close;
    except
    //
    end;

    unitFrm.msgDlg(Format('Kan ikke koble til %s:%s'+FNUL+
                          'Sjekk om server er tilgjengelig.',
             [dbCnct.driverName,PRVsqlServerName]),ERROR_);

    raise;


    //halt;
    //dbCnct.driverName :=NUL;
    exit;
    //appTerminate();
   end;

 end;

 screen.Cursor :=crDefault;

 Result :=0;
end;



function TmainForm.loadEmpQry(fname,fdata,sortflds,sortdir: String; cmd: Integer): Integer;
 function loadResGrps: Integer;
 var
  cnt: Integer;
  qry,tblname: String;

 begin

 Result :=ERROR_;

 if resGrp.items.count>0 then
  exit;


tblname :=trim(iniFrm.empTableName.text);
if tblname=NUL then
 exit;

// keys :='WHERE Email is not null ';

 qry :=format('SELECT Distinct ResGrp FROM %s '+
              'ORDER BY ResGrp',[tblname]);


 screen.Cursor :=crHourGlass;


 with resGrpQry do
 begin

  close;
  dataset.Close;
  IndexDefs.Clear; //Fordi sortering går via SQL
  //dataset.IndexDefs.Clear;


  //SQL.Add(format('SELECT * FROM %s',[MEDIA_TABLE]));
  dataset.commandText :=qry;
   //SQL.Add(format('ORDER BY %s',[orderflds]));


   try
    open;
    dataset.Active :=TRUE;
    cnt :=recordCount;
   except
    screen.Cursor :=crDefault;

    raise;
    exit;
   end;


 resGrp.items.clear;

 while not eof do
 begin
  resGrp.items.add(fields[0].asString);

  try
   next;
  except
   break;
  end;

 end;

  close;
 end;


 screen.Cursor :=crDefault;

 Result :=cnt;
end;

var
 cnt: Integer;
 qry,keys,tblname: String;
begin
 Result :=ERROR_;
 cnt :=0;
 lnk.match :=cnt;

//if not allowDBoperation then
// exit;

 if trim(fname)=NUL then
  exit;

 tblname :=trim(iniFrm.empTableName.text);
 if tblname=NUL then
  exit;

 loadResGrps();

 keys :=NUL; //trxFrm.createSQLkey(fname,fdata,sortflds,sortdir);

 keys :='WHERE Email is not null ';

 if (fdata<>NUL) then
  keys :=keys + format('AND %s(%s) LIKE %s(''%s%s'') ',
       [iniFrm.qryCmpCase.text,
         fname,
        iniFrm.qryCmpCase.text,
         fdata,
         iniFrm.qryBlock.text]);

 qry :=format('SELECT Distinct Sign,Ansatt,Navn,Email FROM %s ',[tblname]);

 if cmd=EMPTY_ then
  qry :=qry+format('WHERE %s=%d ',[SEQID_FLD,0])  //SeqID 0 skal ikke eksistere
 else
  qry :=qry+keys;

  qry :=qry+'ORDER BY Sign ';

// if sortFlds<>NUL then//   qry :=qry+format('ORDER BY %s',[sortflds]);

 screen.Cursor :=crHourGlass;


 with empQry do
 begin

  close;
  dataset.Close;
  IndexDefs.Clear; //Fordi sortering går via SQL
  //dataset.IndexDefs.Clear;


  //SQL.Add(format('SELECT * FROM %s',[MEDIA_TABLE]));
  dataset.commandText :=qry;
   //SQL.Add(format('ORDER BY %s',[orderflds]));


   try
    open;
     dataset.Active :=TRUE;
    cnt :=recordCount;
   except
    screen.Cursor :=crDefault;

    raise;
    exit;
   end;


 end;

 screen.Cursor :=crDefault;

 lnk.match :=cnt;

 Result :=cnt;
end;

Procedure TmainForm.add_to_loggmemo(txt:string);
  var
    i : integer;
    ts : string;
  begin
  if LogUpdateBtn.down then LoggMemo.lines.beginupdate;
  if LoggMemo.lines.count > MAX_MEMO_LINES then
    begin
    if not LogUpdateBtn.down then LoggMemo.lines.beginupdate;
    while LoggMemo.lines.count > MAX_MEMO_LINES-100 do LoggMemo.lines.delete(0);
    if not LogUpdateBtn.down then LoggMemo.lines.endupdate;
    end;

  for i:=1 to length(txt) do
   if txt[i]<' ' then
    txt[i]:='~';

  if (HourOf(now) div 3)<>(PRVlastLogDay div 3) then
    begin
    PRVlastInfoHour:=HourOf(now);
    //ts:=procs._tekst02(MonthOf(date))+'.'+procs._tekst02(DayOf(date));
    ts:=DateToStr(date);
    LoggMemo.lines.add('Dato = '+ts);
    PRVlogList.add      ('Dato = '+ts);
    end;
  LoggMemo.lines.add(timeToStr(time)+': '+txt);
  PRVlogList.add      (timeToStr(time)+': '+txt);
  PRVlogDT:=Now;
  if LogUpdateBtn.down then LoggMemo.lines.endupdate;

 end;  //Procedure TmainForm.add_to_loggmemo

function TmainForm.move_File(flname,destDir: String): boolean;
var
 destPath: PChar;
 filename: String;
begin
 Result :=FALSE;

 if trim(flname)=NUL then
  exit;

 if trim(destDir)=NUL then
  exit;

 if copy_file(flname,destDir) then
 begin
  Result :=deleteFile(flname);   //Må inneholde full path

  filename :=extractFileName(flname);

  destPath:=Pchar(unitFrm.addFileToPath(destDir,filename));
                              //False=overwrite
  add_to_loggmemo('Moved: '+flname+' to '+destPath)
 end
 else
 begin
  add_to_loggmemo('Error moving: '+flname+' to '+destPath);
  Result :=FALSE;
 end;

end;


function TmainForm.copy_File(flname,destDir: String): boolean;
var
 destPath: PChar;
 filename: String;
begin
 Result :=FALSE;

 if trim(flname)=NUL then
  exit;

 if trim(destDir)=NUL then
  exit;

 filename :=extractFileName(flname);

destPath:=Pchar(unitFrm.addFileToPath(destDir,filename));
                              //False=overwrite
	if copyfile(PChar(flname),destPath,false) then
  begin
    add_to_loggmemo('Copied: '+flname+' to '+destPath);
    Result :=TRUE;
	end
  else
  begin
   add_to_loggmemo('Error copying: '+flname+' to '+destPath);
   Result :=FALSE;
  end;

end;

function TMainForm.Delete_File(totname:string):boolean;
  begin

  Result:=FALSE;

  if not FileExists(totName) then
   exit;

  Result:=deletefile(totname);

 end; // function TMainForm._Delete_File(totname:string):boolean;



function TMainForm.Rename_File(oldname,newname:string):boolean;
  begin

  Result:=FALSE;

  if FileExists(newname) then
    if not delete_file(newname) then
      exit;

  Result:=RenameFile(oldname,newname);

 end; // function TMainForm._Delete_File(totname:string):boolean;



procedure TMainForm.IdSMTPConnected(Sender: TObject);
  begin
  add_to_loggmemo('SMTP Connected: '+iniFrm.MailServerSMTP.text);
  end;

procedure TMainForm.IdSMTPDisconnected(Sender: TObject);
  begin
  add_to_loggmemo('SMTP DisConnect: '+iniFrm.MailServerSMTP.text);
  end;


procedure TMainForm.FormCreate(Sender: TObject);
var
 inif: TiniFile;
begin

  PRVfirst_time:=true;

  procs := Tprocs.create;
  PRVlogList:=Tstringlist.Create;
  PRVdestinationList:=Tstringlist.Create;

  PRVprog_dir:=ExtractFileDir(ExpandFileName(paramstr(0)));
  PRVprog_dir:=procs._dirtext(PRVprog_dir);  // med \ til slutt
  PRVprog_name:=ExtractFileName(ExpandFileName(paramstr(0)));
  PRVprog_ext:=ExtractFileExt(ExpandFileName(paramstr(0)));

  delete(PRVprog_name,
         length(PRVprog_name)+1-length(PRVprog_ext),
         length(PRVprog_ext));

  PRVdebugging:=true;

  ShortDateFormat:='YYYY-MM-DD';
  TimeSeparator  :=':';
  ShortTimeFormat:='hh:mm:ss';
  LongTimeFormat :='hh:mm:ss';
  DateSeparator  :='.'; //'-';
  PRVlogDT  :=now-1;


PRVprgDir :=extractFileDir(paramStr(0));

//gridstore.filename :=format('%s\gridstore.ini',[ExtractFileDir(paramstr(0))]);

 //Er ini-fil spesifisert ved oppstart ?
 if paramStr(1) <> NUL then
 begin

  iniFrm.PUBsourceIniFile :=trim(unitFrm.charReplace(paramStr(1),FILE_SUFFIX,BLANK));
  gridstore.filename :=format('%s\%s',[ExtractFileDir(paramStr(1)),GRID_FILE_NAME]);

  //iniFrm.PUBsourceIniFile :=paramStr(1);

  //Av ukjent grunn tar det veldig lang tid å lese ini-filer fra
  //fra L-disk på nye XP-installasjoner.
  if copy(paramStr(1),1,1)=PRIVATE_DRIVE then
  begin
   //iniFrm.PUBiniFile :=toolFrm.copyIniFile(paramStr(1),X98_LOCAL_PATH+'\TMP');

  end
  else
   iniFrm.PUBiniFile :=iniFrm.PUBsourceIniFile;
   //unitFrm.charReplace(paramStr(1),FILE_SUFFIX,BLANK);

 end
 else
 begin
  //gridstore.filename :=format('%s\%s',[PRVprgDir,INI_FILE_NAME]);

  iniFrm.PUBiniFile :=unitFrm.addFileToPath(PRVprgDir,INI_FILE_NAME);
  gridstore.filename :=format('%s\%s',[ExtractFileDir(paramStr(0)),GRID_FILE_NAME]);

  iniFrm.PUBsourceIniFile :=iniFrm.PUBiniFile;
 end;


//Hvis noen av try..except feiler, gå bare videre
//slik at det blir mulig ?omme inn i programmet
//for å redigere INI-fil.

if not fileExists(iniFrm.PUBiniFile) then
begin
 unitFrm.msgDlg(format('%s %s. Programmet avsluttes.',
 [NO_MATCH_,iniFrm.PUBiniFile]),ERROR_);

 //appterminate();
 application.Terminate();
end;

if iniFrm.processIniFile(iniFrm.PUBiniFile,READ_) <0 then
begin
 unitFrm.msgDlg(format('%s av %s.',
 [NO_LOAD_,iniFrm.PUBiniFile]),ERROR_);

 //appterminate();
end;

 typFrm.setLocaleFormats(NUL);

 //rtb :=setCurrentDir(iniFrm.progrDir.text);

//Ved f? gangs start kommer INI-form opp slik
//at path til alias kan settes riktig.
 if iniFrm.init.checked then
 begin
  inif :=TiniFile.create(iniFrm.PUBiniFile);
  if inif <> nil then
  begin
   iniFrm.init.checked := FALSE;
   inif.writeBool(iniFrm.PUBifs[SECT_SYSTEM], 'init',
     iniFrm.init.checked);
  end;

  inif.free;

  mnuSetupClick(Sender);

 end;


  PRVlogList.AddStrings(LoggMemo.Lines);
  with IdSMTP do
    begin

    if iniFrm.chkLoginSMTP.checked then
    begin
     Password:=iniFrm.mailPassword.text;
     UserName:=iniFrm.mailUsername.text;
     IdSMTP.AuthenticationType :=atLogin;
    end
    else
     IdSMTP.AuthenticationType :=atNone;

    Host:=iniFrm.MailServerSMTP.text;
    end;
  with IdPOP3 do
    begin
    Password:=iniFrm.mailPassword.text;
    UserName:=iniFrm.mailUsername.text;;
    Host:=iniFrm.MailServerPOP3.text;
    end;

  PRVfirst_time:=false;

  PRVLastInfoHour:=99;
  PRVLastLogDay:=99;
  PRVSendLastChecked:=true;
  PRVfileListCnt :=0;

  MainTimer.Interval:=500;


  PRVtodoDir:=ExpandFileName(iniFrm.todoDir.text);
  PRVdoneDir:=ExpandFileName(iniFrm.doneDir.text);
  PRVlogDir :=ExpandFileName(iniFrm.logDir.text);


  try
   filesReadyList.Directory :=ExpandFileName(iniFrm.xprintDir.text);
   filesReadyList.mask :=format('*.%s',[iniFrm.xprintExt.text]);
  except
   //
  end;

  filesReadyList.update;
  pdfCnt.text :=intToStr(filesreadyList.Items.Count);

  //listGrid.TitleButtons :=iniFrm.chkGridButtons.Checked;

  PRVsortdir :=ASC;

 pgCtrlMail.ActivePage :=tsMail;
{
 if (typFrm.userMode<>ADMIN_) AND
    (typFrm.userMode<>ALL_ACCESS_) then
  mnuSetup.Enabled :=FALSE
 else
  mnuSetup.Enabled :=TRUE;
}

 //PRVinhibitOpen :=FALSE;
  try
//   listGrid.LoadFromAppStore(gridStore,'GRID');
  except
   //
  end;

  mailTo.Text :=iniFrm.mailDestination.text;;
  mailFrom.Text :=iniFrm.mailSender.text;

  mailSubject.text :=iniFrm.mailSubject.text;

  resGrp.Text :=iniFrm.empResGrp.text;

  //Laster inn mailadresser etter 0,5 sek
  if (iniFrm.chkXnrkLogon.Checked) AND
     (iniFrm.defUsername.text<>NUL) then
  loadTimer.enabled :=TRUE;

 end; // procedure TMainForm.FormCreate...


{
Procedure Tmainform.read_ini_file;
  var
    lnr,i	: integer;
    pint        : integer;
    ta,inistr		: string;
    setup_line	: setup_array;
  //
  function _no_backslash_at_end(st:shortstring):shortstring;
    begin
    if procs._last_char(st)='\' then
      delete(st,length(st),1);
    result:=st;
    end; //  function _no_backslash_at_end..
  //
  begin  //Procedure Tmainform.read_ini_file;
  //for i:=3 to maxports do clear_port_info(i);
  if not procs._loaded_as_setupfile(prog_dir+prog_name+'.ini',setup_line) then
    begin
    ShowMessage('Finner ikke : '+prog_dir+prog_name+'.ini');
    close;
    end;
  if setup_line[0]=NUL then
    begin
    ShowMessage('Mangler innhold i : '+prog_dir+prog_name+'.ini');
    close;
    end;
  debugging:=false;
  lnr:=0;
  while (lnr<MAX_INI_LINES) and (setup_line[lnr]<>NUL) do
  begin

  //inistr :=uppercase(setup_line[lnr]);
 inistr :=setup_line[lnr];

    if pos('LOGDIR=',inistr)=1 then
      begin
      LogDir:=procs._dirtext(procs._text_after('=',inistr));
      LogDir:=ExpandFileName(LogDir);
      //setup_line[lnr]:=NUL;
      end
    else
    if pos('DAYSTOKEEPLOG=',inistr)=1 then
    begin
      pint:=strtointdef(procs._text_after('=',inistr),0);
      if (pint>0) and (pint<600) then
        begin
        DaysToKeepLog:=Pint;
        end
      else
        DaysToKeepLog:=7;
      end
    else
    if pos('TODODIR=',inistr)=1 then
    begin
      TodoDir:=procs._dirtext(procs._text_after('=',inistr));
      TodoDir:=ExpandFileName(TodoDir);
    end
    else
    if pos('DONEDIR=',inistr)=1 then
    begin
      DoneDir:=procs._dirtext(procs._text_after('=',inistr));
      DoneDir:=ExpandFileName(DoneDir);
    end
    else
    if pos('DEBUG=',inistr)=1 then
    begin
      ta:=procs._text_after('=',setup_line[lnr]);
      debugging:=ansiuppercase(trim(ta))='ON';
    end
    else
    if pos('DELETEMAIL=',inistr)=1 then
    begin
      ta:=procs._text_after('=',inistr);
      DeleteMail:=ansiuppercase(trim(ta))<>'OFF';
    end
    else
    if pos('MAILSERVERSMTP=',inistr)=1 then
    begin
      MailServerSMTP:=procs._text_after('=',inistr);
    end
    else
    if pos('MAILSERVERPOP3=',inistr)=1 then
    begin
      MailServerPOP3:=procs._text_after('=',inistr);
    end
    else
    if pos('MAILUSER=',inistr)=1 then
    begin
      MailUser:=procs._text_after('=',inistr);
    end
    else
    if pos('MAILPASSWORD=',inistr)=1 then
      begin
      MailPassword:=procs._text_after('=',inistr);
    end
    else
    if pos('POLLINTERVAL=',inistr)=1 then
    begin
      pint:=strtointdef(procs._text_after('=',inistr),0);
      if (pint>0) and (pint<3600) then
        begin
        PollInterval:=Pint;
        end;
      end
    else
    if pos('SENDER=',inistr)=1 then
    begin
      SenderName:=procs._text_after('=',inistr);
    end
    else
    if pos('SOURCE=',inistr)=1 then
    begin
      SourceName:=AnsiUpperCase(procs._text_after('=',inistr));
    end
    else
    if pos('DESTINATION=',inistr)=1 then
      begin
      ta:=procs._text_after('=',setup_line[lnr]);
      if procs._Nu_params(ta)=2 then
        begin
        procs.set_param(1,AnsiUpperCase(procs._param_nr(1,ta)),ta);
        DestinationListe.Add(ta);
        end;
      end
    else
    if pos('PERSONDB=',inistr)=1 then
    begin
      ta:=procs._text_after('=',inistr);
      if procs._Nu_params(ta)=1 then
        begin
        procs.set_param(1,AnsiUpperCase(procs._param_nr(1,ta)),ta);
        PRVempTblName :=ta;
        end;
      end;


     setup_line[lnr]:=NUL;

    inc(lnr);
    end; //while


  ta:=NUL;
  for i:=0 to lnr-1 do
  begin

    if setup_line[i] <> NUL then
    begin

  if ta=NUL then
	begin   //first message

	ta:='Ugyldig(e) oppsett i fil :';
	LoggMemo.lines.add(ta);
	LoggMemo.lines.add('-> '+prog_dir+prog_name+'.ini');

	end;    //first message
   LoggMemo.lines.add(setup_line[i]);
    end;
   end;

  LoggMemo.lines.add('Aktive parametere:');
  LoggMemo.lines.add('MailServerSMTP = '+MailServerSMTP);
  LoggMemo.lines.add('MailServerPOP3 = '+MailServerPOP3);
  LoggMemo.lines.add('MailUser = '+  MailUser);
  //LoggMemo.lines.add('MailPassword = '+ MailPassword);
  LoggMemo.lines.add('PollInterval = '+inttostr(PollInterval)+' s');
  if DeleteMail then ta:='ON' else ta:='OFF';
  LoggMemo.lines.add('DeleteMail = '+ta);
  LoggMemo.lines.add('LogDir = '+LogDir);
  LoggMemo.lines.add('TodoDir = '+tododir);
  LoggMemo.lines.add('DoneDir = '+donedir);
  LoggMemo.lines.add('DaysToKeepLog = '+inttostr(DaysToKeepLog));
  LoggMemo.lines.add('SENDER = ' +SenderName);
  LoggMemo.lines.add('SOURCE= '+SourceName);
  LoggMemo.lines.add('PersonDB= '+PRVempTblName);

  if DestinationListe.Count=0 then
    begin
    showmessage('Ingen mottagere angitt med DESTINATION=  i fil '+prog_dir+prog_name+'.ini');
    close;
    end;
  for i:=0 to DestinationListe.Count-1 do
    LoggMemo.lines.add('DESTINATION = '+DestinationListe[i]);

  end;
}



procedure TMainForm.FormShow(Sender: TObject);
  begin

  iniFrm.iniWinPos(mainForm,READ_);

  if not PRVfirst_time then
   exit;


  PRVcaptionstr:=caption+' ver: '+
                procs._date_of_file(PRVprog_dir+PRVprog_name+'.exe')
	   +'     Startet: '+procs._MyDatetimestr+'   ';
  caption:=PRVcaptionstr;

  loggmemo.Lines.Clear;
  loggmemo.Lines.Add(Timetostr(time)+': Startet: '+DateTostr(date));

  //read_ini_file;

  if not ForceDirectories(PRVlogDir) then
    add_to_loggmemo('Error creating '+PRVlogDir);
  if not ForceDirectories(PRVtodoDir) then
    add_to_loggmemo('Error creating '+PRVtoDoDir);
  if not ForceDirectories(PRVdoneDir) then
    add_to_loggmemo('Error creating '+PRVdoneDir);

  //maintimer.Enabled:=true;

  //mailTo.Text :=procs._param_nr(2,PRVsenderName);

 end;  // procedure TMainForm.FormShow...



procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin

  if not PRVdebugging then
    begin
    CanClose:=false;
    if MessageDlg('Skal '+PRVprog_name+' avsluttes ?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      CanClose:=true;
    end;
  if CanClose then
    begin
    add_to_loggmemo('Program terminated: '+DateTostr(date));
    PRVlogList.Add(NUL);
    SaveInfoLog;
    end;

  try
//   listGrid.SaveToAppStore(gridStore,'GRID');
  except
   //
  end;

 iniFrm.iniWinPos(mainForm,WRITE_);

 dbConnect(FALSE);
 end;  // procedure TMainForm.FormCloseQuery...



procedure TMainForm.FormDestroy(Sender: TObject);
  begin
  MainTimer.Enabled:=false;
  PRVdestinationList.Free;
  PRVlogList.Free;
  Procs.Free;
  end; //procedure TMainForm.FormDestroy...


Procedure TmainForm.SaveInfoLog;
  var
    i 	      : integer;
    logfname  : shortstring;
    SearchRec : TSearchRec;
    info,
    fname,dname: string;
    FileList  : TstringList;
    //Dok       : boolean;
  //
  begin // Procedure TExecForm.check_logging...
  if PRVlogList.Count=0 then
    exit;

  DateSeparator  :='-';
  ShortDateFormat:='YYYY-MM-DD';
  logfname:=PRVlogDir+PRVprog_name+DateToStr(date)+'.log';
  assignfile(PRVlogfile,logfname);
  {$I-}
  append(PRVlogfile);
  if ioresult<>0 then
    rewrite(PRVlogfile);   {logfilen fantes ikke}
  {$I+}
  if ioresult=0 then
    begin
    for i:=0 to PRVlogList.Count-1 do
      writeln(PRVlogfile,PRVlogList[i]);
    CloseFile(PRVlogfile);
    end;
  PRVlogList.Clear;

  if PRVLastLogDay=DayOf(Date) then
    EXIT;
  //
  PRVLastLogDay:=DayOf(Date);
  if FindFirst(PRVLogDir+'*.log', faAnyFile, SearchRec)<>0 then
    begin
    FindClose(SearchRec);
    EXIT; //No files found
    end;

  FileList:=Tstringlist.Create;
  FileList.Add(extractfilename(SearchRec.name));

  while findnext(SearchRec) = 0 do
    FileList.Add(extractfilename(SearchRec.name));
  FindClose(SearchRec);
  //
  //dname:=Prog_name+DateToStr(date-PRVDaysToKeepLog)+'.log';
  dname:=PRVprog_name+DateToStr(date-unitFrm.atoi(iniFrm.daysToKeepLog.Text))+'.log';

  i:=0;
  while i<FileList.Count do
    begin
    fname:=FileList[i];
    if length(dname)=length(fname) then
      if fname<dname then
        if Deletefile(PRVLogDir+fname) then
          add_to_loggmemo('Deleted file: '+fname)
        else
          add_to_loggmemo('Error deleting: '+fname);
    inc(i);
    end; // while i<FileList.Count do
  end; //Procedure TmainForm.SaveInfoLog;



procedure TMainForm.MainTimerTimer(Sender: TObject);
  begin

  //exit;

 pnlTimer.Color :=clLime;

  MainTimer.Enabled:=false;
  MainTimer.Interval:=unitFrm.atoi(iniFrm.pollInterval.text) * 1000;
  if (Now-PRVlogDT>=min5) and (PRVlogList.Count>0) then
    SaveInfoLog;
{
  if SendLastChecked then
    SpbtnReceiveClick(self)
  else
}

  loadTodoFile(getTodoFile());

//
  btnTimer.Enabled :=TRUE;

  MainTimer.Enabled:=True;
 end; // procedure TMainForm.MainTimerTimer(Sender: TObject);

function TmainForm.getTodoFile: String;
  var
    DstPk       : integer;
    atm         : TIdAttachment;
    InfoTxt,
    FileName,
    DestName    : string;
    flname: String;
    FileTime    : longint;
    Fok         : boolean;
    SearchRec	: TSearchRec;
begin

 flname :=NUL;
 Result :=flname;


  //Begin: Find oldest matching file
  if FindFirst(PRVtodoDir+iniFrm.mailSource.text+'*.txt',
              faAnyFile, SearchRec)<>0 then
    begin
    FindClose(SearchRec);
    EXIT; //No files found
  end;

//  SpbtnSend.Enabled:=false;
//  SpbtnReceive.Enabled:=false;

  FileTime:=SearchRec.time;
  FileName:=extractfilename(SearchRec.name);

  while findnext(SearchRec) = 0 do
    begin
    if (FileTime > SearchRec.time) then
      begin
      FileTime:=SearchRec.time;
      FileName:=extractfilename(SearchRec.name);
      end;
    end;

      FindClose(SearchRec);
  //End : Find oldest matching file
  //Begin: Check if valid filename
  DstPk:=-1;
  Fok:=false;
  while not Fok and (DstPk<PRVdestinationList.Count-1) do
    begin
    inc(DstPk);
    DestName:=procs._param_nr(1,PRVdestinationList[DstPk]);
    Fok:=pos(iniFrm.mailSource.text+DestName,FileName)>0;
  end; // while


 flname :=PRVtododir+filename;

 todoFileName.text :=flname;

 if chkAttachFile.Checked then
  mailAttachment.Text :=flname;

 Result :=flname;
end;

function TmainForm.deleteTodoFile(flname: String): Integer;
begin
 Result := -1;

 if trim(flname)=NUL then
  exit;
  
//    add_to_loggmemo('Unknown file : '+filename+' is deleted');

    if not delete_file(flName) then
      add_to_loggmemo('Error deleting: '+flName);


 Result :=0;
end;

function TmainForm.loadTodoFile(flname: String): Integer;
begin


 with fileListBox do
 begin
  items.Clear;

  try
  if trim(flname)<>NUL then
   items.loadFromFile(flName)
  else
   todoFileName.Text :=NUL;

  except
  todoFileName.Text :=NUL;

  end;


 end;

  Result :=fileListBox.Items.Count;
end;

function TmainForm.sendMail(mail_From,mail_To,mail_Subject,mail_Txt,mail_Attach: String;
                       cmd: Integer): Integer;
var
    DstPk       : integer;
    atm         : TIdAttachment;
    InfoTxt,
    FileName,
    DestName    : string;
    FileTime    : longint;
    Fok         : boolean;
    SearchRec	: TSearchRec;
  begin // procedure TMainForm.SpbtnSendClick(Sender: TObject);

Result :=ERROR_;

if trim(mail_from)=NUL then
begin
 unitFrm.msgDlg('Avsender'+ENTER_REQ_,INFO_);
 mailFrom.setFocus();
 exit;
end;

if trim(mail_to)=NUL then
begin
 unitFrm.msgDlg('Mottaker'+ENTER_REQ_,INFO_);
 mailTo.setFocus();
 exit;
end;

if trim(mail_subject)=NUL then
begin
 unitFrm.msgDlg('Mail emne'+ENTER_REQ_,INFO_);
 mailSubject.setFocus();
 exit;
end;

if trim(mail_txt)=NUL then
begin
 unitFrm.msgDlg('Mail tekst'+ENTER_REQ_,INFO_);
 mailText.setFocus();
 exit;
end;


  PRVSendLastChecked:=true;
{
  //Begin: Find oldest matching file
  if FindFirst(TodoDir+SourceName+'*.ttv', faAnyFile, SearchRec)<>0 then
    begin
    FindClose(SearchRec);
    EXIT; //No files found
    end;
  SpbtnSend.Enabled:=false;
  SpbtnReceive.Enabled:=false;
  FileTime:=SearchRec.time;
  FileName:=extractfilename(SearchRec.name);
  while findnext(SearchRec) = 0 do
    begin
    if (FileTime > SearchRec.time) then
      begin
      FileTime:=SearchRec.time;
      FileName:=extractfilename(SearchRec.name);
      end;
    end;

      FindClose(SearchRec);
  //End : Find oldest matching file
  //Begin: Check if valid filename
  DstPk:=-1;
  Fok:=false;
  while not Fok and (DstPk<DestinationListe.Count-1) do
    begin
    inc(DstPk);
    DestName:=procs._param_nr(1,DestinationListe[DstPk]);
    Fok:=pos(SourceName+DestName,FileName)>0;
    end; // while

  }

  //  if not Fok then
//    begin
//    add_to_loggmemo('Unknown file : '+filename+' is deleted');
//    if not _delete_file(TodoDir+FileName) then
//      add_to_loggmemo('Error deleting: '+TodoDir+FileName);
//    SpbtnSend.Enabled:=true;
//    SpbtnReceive.Enabled:=true;
//    EXIT;
//    end;
  //End: Check if valid filename
  IdMessageS.Clear;
  //IdMessageS.Body.add('From '+SenderName);
  //IdMessageS.Body.add('Sendt: '+datetimetostr(now));
  IdMessageS.Body.add(mail_txt);

  idMessageS.Recipients.Add;
  //idMessageS.Recipients[0].Address:=procs._param_nr(2,DestinationListe[DstPk]);

  idMessageS.Recipients[0].Address:=mail_To;


  IdMessageS.Subject:=mailSubject.text; //'Nordic Page Exchange from '+SourceName;
  //
  with IdMessageS.From do
    begin
    Address:=procs._param_nr(2,mail_from);
    Name   :=procs._param_nr(1,mail_from);
    //Text   :='TekstTV1';
    end;
  //
  with IdMessageS.Sender do
    begin
    Address:=procs._param_nr(2,mail_from);
    Name   :=procs._param_nr(1,mail_from);
    end;

  //Vedlegg

    if trim(mailAttachment.text)<>NUL then
    begin
     atm:=TIdAttachment.Create(IdMessageS.MessageParts,mail_Attach);
     atm.ContentTransfer :='base64';
    end;

    screen.cursor :=crHourGlass;

  //

  try
   IdSMTP.Connect;
  except
   screen.cursor :=crDefault;

   btnStopSendClick(Self);

   add_to_loggmemo('Error connecting: '+iniFrm.MailServerSMTP.text);

   Result :=ERROR_;
   exit;
  end;

  try
    //InfoTxt:='Error sending: '+atm.FileName;

    IdSMTP.send(IdMessageS);
    add_to_loggmemo('File '+filename+' sent to '+IdMessageS.Recipients[0].Address);
//    if not _Rename_File(TodoDir+filename,DoneDir+filename) then
//      InfoTxt:='Error renaming: '+TodoDir+filename+' to '+DoneDir+filename
//    else
     InfoTxt:=NUL;
  except
   screen.cursor :=crDefault;

   btnStopSendClick(Self);

   IdSMTP.DisConnect;

   add_to_loggmemo('Error sending: '+IdMessageS.Recipients[0].Address);

   //raise;
   Result :=CANCEL_;  //Kanseller, ikke stopp
   exit;
  end;


  // if InfoTxt<>NUL then
  //  add_to_loggmemo(InfoTxt);

  IdSMTP.DisConnect;

  btnSendMail.Enabled:=true;
  SpbtnReceive.Enabled:=true;
  screen.cursor :=crDefault;

 Result :=0;
end;

procedure TMainForm.btnSendMailClick(Sender: TObject);
begin
 sendMail(mailFrom.Text,
          mailTo.Text,
          mailSubject.text,
          mailText.Text,
          mailAttachment.text,
          SEND_);

end;  //procedure TMainForm.SpbtnSendClick(Sender: TObject);


Function TMainForm._ValidTTVfile(totfilename:string):boolean;
  var
    Fok    : boolean;
    i,j,ct : integer;
    pglist : Tstringlist;
    st     : string;
  begin
  PgList:=Tstringlist.Create;
  try
    PgList.LoadFromFile(totfilename);
    Fok:=true;
  except
    Fok:=false;
    end;
  ct:=PgList.Count;
  if (ct>0)and ((ct mod 24)=1) then
    begin
    PgList.Delete(ct-1);
    ct:=PgList.Count;
    try PgList.SaveToFile(TotFileName) except end;
    end;
  Fok:=Fok and (ct>0) and (ct<=80*24) and ((ct mod 24)=0);
  i:=0;
  while Fok and (i<PgList.Count) do
    begin
    st:=PgList[i];
    Fok:=length(st)=40;
    if Fok then
      for j:=1 to 40 do
        Fok:=Fok and (st[j] in [#32..#127,#224..#255]);
    inc(i);
    end;
  Result:=Fok;
  PgList.Free;
  end; // procedure TMainForm._ValidTTVfile(totfilename:string):boolean;



Procedure TMainForm.SpbtnReceiveClick(Sender: TObject);  //POP3
  var
    i,pk,fsize,
    NuMess      : integer;
    Sok         : boolean;
    Rok         : array[1..10]of boolean;
    atm         : TIdAttachment;
    fname,
    sname       : string;
  //
  function _ValidAttachmentName(atname,FromAddr:string):boolean;
    var
      i    : integer;
      st   : string;
    begin
    result:=false;
    atname:=AnsiUpperCase(ExtractFileName(atname));
    FromAddr:=AnsiLowerCase(FromAddr);
    if ExtractFileExt(atname)<>'.TTV' then
      EXIT;
    i:=0;
    while i<PRVdestinationList.Count do
      begin
      st:=AnsiLowerCase(procs._param_nr(2,PRVdestinationList[i]));
      if st=FromAddr then
        begin // st=FromAddr
        st:=procs._param_nr(1,PRVdestinationList[i]);
        if pos(st+iniFrm.mailSource.text,atname)=1 then
          begin
          result:=true;
          exit;
          end;
        end;  // st=FromAddr
      inc(i);
      end;
    end; //   function _ValidAttachmentName(atname:string):boolean;
  //
  function _ValidFromAddress(FrAddr:string):boolean;
    var
      i    : integer;
      st   : string;
    begin
    result:=false;
    FrAddr:=AnsiLowerCase(FrAddr);
    i:=0;
    while i<PRVdestinationList.Count do
      begin
      st:=AnsiLowerCase(procs._param_nr(2,PRVdestinationList[i]));
      if st=FrAddr then
        begin
        result:=true;
        exit;
        end;
      inc(i);
      end;
    end; //  function _ValidFromAddress(FrAddr:string):boolean;
  //
  begin // procedure TMainForm.SpbtnReceiveClick(Sender: TObject);  //POP3
  SpbtnReceive.Enabled:=false;
  btnSendMail.Enabled:=false;
  PRVSendLastChecked:=false;

  if not IdPOP3.Connected then
    IdPOP3.Connect;
  NuMess:=IdPOP3.CheckMessages;
  if NuMess>0 then
    BEGIN
    add_to_loggmemo('Received '+IntToStr(NuMess)+' Message(s) in '+iniFrm.MailServerPOP3.text);
    if NuMess>10 then NuMess:=10;
    //
    for pk:=1 to NuMess do
      begin

    if trim(mailAttachment.text)<>NUL then
    begin

      with IdMessageR.MessageParts do
       begin
         atm:=TidAttachment.Create(IdMessageR.MessageParts);
         atm.ContentTransfer :='base64';
        end;

     end;

      IdMessageR.Clear;
      Rok[pk]:=idPop3.Retrieve(pk,IdMessageR);
      if rok[pk] then
        begin
        add_to_loggmemo('POP3 Retrived new message nr: '+
        IntToStr(pk)+' from '+iniFrm.MailServerPOP3.text);

        if _ValidFromAddress(IdMessageR.From.Address) then
          begin
          add_to_loggmemo('Mail from: '+IdMessageR.From.Name+' ['+IdMessageR.From.Address+']');
          add_to_loggmemo('Mail subject: '+IdMessageR.Subject);
          for i:=0 to IdMessageR.MessageParts.Count-1 do
            begin
            sname:= IdMessageR.MessageParts.Items[i].ClassName;
            if sname='TIdAttachment' then
              begin //Attachment
              Sok:=false;
              atm:=IdMessageR.MessageParts.Items[i] as TIdAttachment;
              fname:=PRVtodoDir+atm.FileName;
              if _ValidAttachmentName(fname,IdMessageR.From.Address) then
                begin
                if not delete_file(fname) then
                  add_to_loggmemo('Error Deleting: '+fname);
                try
                  Sok:=atm.SaveToFile(fname);
                  add_to_loggmemo('File Stored: '+fname);
                except
                  add_to_loggmemo('Error Storing File: '+fname);
                  end;
                end
              else
                add_to_loggmemo('Unvalid Attachment FileName: '+ExtractFileName(fname));
              if Sok then
                if not _ValidTTVfile(fname) then
                  begin
                  Sok:=delete_file(fname);
                  add_to_loggmemo('Unvalid TTVfile: '+ExtractFileName(fname));
                  end;
              end;  //Attachment
            end; //for i:=0 to IdMessageR.MessageParts.Count-1
          end //_ValidFromAddress..
        else
          add_to_loggmemo('UnValid Sender: '+IdMessageR.From.Address);
        end; //Rok
      end; //  for pk:=1 to NuMess do
    //
    i:=0;
    if iniFrm.chkDeleteMail.Checked then
      begin
      for pk:=1 to NuMess do
        begin
        if Rok[pk] then
          if IdPOP3.Delete(pk) then
            inc(i)
          else
            add_to_loggmemo('Error deleting : '+
            IntToStr(pk)+' from '+iniFrm.MailServerPOP3.text);
        end; //  for pk:=1 to NuMess do
      if i>0 then add_to_loggmemo('Deleted '+IntToStr(i)+' Messages');
      end;
    END; // if NuMess>0 then
  //
  IdPOP3.DisConnect;
  SpbtnReceive.Enabled:=true;
  btnSendMail.Enabled:=true;
  end; // procedure TMainForm.SpbtnReceiveClick(Sender: TObject);  //POP3



procedure TMainForm.IdPOP3Connected(Sender: TObject);
  begin
  LblPOP3.Caption:=TimeToStr(time)+' POP3 Connected: '+iniFrm.MailServerPOP3.text;
  end;

procedure TMainForm.IdPOP3Disconnected(Sender: TObject);
  begin
  LblPOP3.Caption:=TimeToStr(time)+' POP3 DisConnect: '+iniFrm.MailServerPOP3.text;
  end;


procedure TMainForm.SpbtnPauseClick(Sender: TObject);
  begin

  if SpbtnPause.Down then
    begin
    MainTimer.Enabled:=true;
    add_to_loggmemo('Program startet');
    end
  else
    begin
    MainTimer.Enabled:=false;
    MainTimer.Interval:=100;

    add_to_loggmemo('Program stoppet');
    end;
  end; // procedure TMainForm.SpbtnPauseClick(Sender: TObject);


procedure TMainForm.btnTimerTimer(Sender: TObject);
begin
 btnTimer.Enabled :=FALSE;
 pnlTimer.Color :=pnlBtns.Color;

  if chkSendFile.Checked then
   if trim(TodoFilename.text)<>NUL then
    btnSendMailClick(self);


 deleteTodoFile(toDoFileName.text);
end;

procedure TMainForm.btnLoadMailListClick(Sender: TObject);
begin

 if not dbCnct.Connected then
  dbConnect(TRUE);

 //Laster inn blankt dataset for å kunne starte med ny
// if dbCnct.Connected then
 //begin
  //
// end;

 loadEmpQry('ResGrp',trim(resGrp.text),'Sign','ASC',LOAD_);
end;

procedure TMainForm.mnuExitClick(Sender: TObject);
begin
 close;
end;

procedure TMainForm.mnuSetupClick(Sender: TObject);
begin
  IniFrm.showModal;
end;

procedure TMainForm.dbCnctAfterConnect(Sender: TObject);
begin

 try
  cnctFrm.Close;
 except
 //
 end;

end;

procedure TMainForm.dbCnctBeforeConnect(Sender: TObject);
var
 idx: Integer;
begin

  //Boks som viser at oppkobling pågår
  if not assigned(cnctFrm) then
   Application.CreateForm(TcnctFrm,cnctFrm);


 if iniFrm.chkDbOracle.Checked then
 begin
  PRVsqlServername :=iniFrm.oraServerName.Text;
  //dbCnct.DriverName :='Oracle';
  //dbCnct.Assign(dbOra);
 end
 else
 if iniFrm.chkDbMsSQL.Checked then
 begin
  PRVsqlServername :=iniFrm.mssqlServerName.Text;
  //dbCnct.DriverName :='MSSQL';
  //dbCnct.assign(dbMSSQL);
 end
 else
 if iniFrm.chkDbMy.Checked then
 begin
  PRVsqlServername :=iniFrm.mysqlServerName.Text;
  //dbCnct.DriverName :='MYSQL';
  //dbCnct :=dbMySQL;
 end;

 try
  cnctFrm.show;
  cnctFrm.srvinfo.Text :=format('%s: %s',[dbCnct.drivername,PRVsqlServername]);
  cnctFrm.Refresh;
 except
 //
 end;

 with dbCnct do
 begin
   try

    if not connected then
    begin
     idx :=params.IndexOfName('HostName');

     if idx>0 then
      params[idx] :=format('HostName=%s',[PRVsqlServername]);

     idx :=params.IndexOfName('User_name');
     if idx>0 then
      params[idx] :=format('User_name=%s',[iniFrm.defUserName.Text]);

     idx :=params.IndexOfName('Password');

     if idx>0 then
      params[idx] :=format('Password=%s',[iniFrm.defPassword.Text]);

     if iniFrm.chkDbOracle.Checked then
     begin

       idx :=params.IndexOfName('LocaleCode');

      if idx>0 then
       params[idx] :=format('LocaleCode=%s',[iniFrm.oraCharSet.Text]);

     end;
    end;

   except
     cnctFrm.close;

   end;

  end;

end;

procedure TMainForm.listGridTitleBtnClick(Sender: TObject; ACol: Integer;
  Field: TField);
var
  idx: String;
begin

// PRVinhibitOpen :=TRUE;


 gridSort(TclientDataSet(dbSrc.DataSet),field.FieldName);

  if PRVsortdir=ASC then
   PRVsortdir :=DESC
  else
  if PRVsortdir=DESC then
   PRVsortdir :=ASC;

  //Ellers kommer det feilmelding fra en Jedi komponent 
  abort; 
end;

procedure TMainForm.pgCtrlMailChange(Sender: TObject);
begin

//
end;

procedure TMainForm.btnDeleteSendtClick(Sender: TObject);
var
 cnt,cx,rt: Integer;
 path,flname: String;
begin

rt :=unitFrm.msgDlg(format('Slett %d filer ?',[filesSendtList.Items.count]),
                    QUESTION_);

if (rt=mrNo) OR (rt=mrCancel) then
 exit;


fileListBox.items :=filesSendtList.Items;
screen.cursor :=crHourGlass;

with fileListBox do
begin
 cnt :=items.count;

 for cx :=0 to pred(cnt) do
 begin

  flname :=items[cx];
  path :=unitFrm.addFileToPath(filesSendtList.directory,flname);

  deleteFile(path);
  rt :=0;

 end;

end;

 add_to_loggmemo(format('%d filer slettet fra ''Sendte filer''',[cnt]));

 filesSendtList.update;

 screen.cursor :=crDefault;
end;

procedure TMainForm.mnuPopDeleteFileClick(Sender: TObject);
var
 cnt,cx,rt: Integer;
 path,flname: String;
begin

with filesReadyList do
begin

  flname :=filename;

  if flname=NUL then
   exit;

rt :=unitFrm.msgDlg(format('Slett %s ?',[flname]),
                    QUESTION_);

if (rt=mrNo) OR (rt=mrCancel) then
 exit;

 deleteFile(flname);
 add_to_loggmemo(format('%s slettet', [flname]));

 filesReadyList.update;
 pdfCnt.text :=intToStr(filesreadyList.Items.Count);

end;

end;

procedure TMainForm.mnuPopMoveFileClick(Sender: TObject);
var
 flname: String;
 rt: Integer;
begin

with filesReadyList do
begin

  flname :=filename;
  if flname=NUL then
   exit;

rt :=unitFrm.msgDlg(format('Flytt %s ?',[flname]),
                    QUESTION_);

if (rt=mrNo) OR (rt=mrCancel) then
 exit;

 move_file(flname,ExpandFileName(iniFrm.doneDir.text));

 filesReadyList.update;
 pdfCnt.text :=intToStr(filesreadyList.Items.Count);

end;

end;

procedure TMainForm.btnSendMailListClick(Sender: TObject);
var
 rt: Integer;
begin

 if not verifyMailList() then
 begin

  setBtnStat(FALSE);
  unitFrm.msgDlg(format('Mail liste er blank (%d)',
   [dbSrc.DataSet.RecordCount]),INFO_);
  exit;
 end;


rt :=unitFrm.msgDlg(format('Start mail utsendelse av %d filer ?',
                    [filesreadyList.Items.Count]),QUESTION_);

 if (rt=mrNo) OR (rt=mrCancel) then
  exit
 else
  sendMailList(SEND_);

end;

procedure TMainForm.sendTimerTimer(Sender: TObject);
var
 flname,path,mailadr: String;
 rt: Integer;
begin

 if not verifyMailList() then
 begin
  setBtnStat(FALSE);
  unitFrm.msgDlg('Mail liste er blank',INFO_);
  exit;
 end;

 Application.ProcessMessages;

 //sendMailList(PREVIEW_);
 flname :=getMailListFile(PRVfileSendPos);

 path :=unitFrm.addFileToPath(iniFrm.xprintDir.Text,flname);

 //Så ikke timer aktiveres før filen er kopiert og sendt
 sendTimer.enabled :=FALSE;

 mailadr :=getMailAdress(NUL,flname);

 if mailadr<>NUL then
 begin

  mailTo.Text :=mailadr;
  mailAttachment.Text :=path;

  if not iniFrm.chkSimulate.Checked then
  begin

  rt :=sendMail(mailFrom.Text,
          mailTo.Text,
          mailSubject.text,
          mailText.Text,
          mailAttachment.text,
          SEND_);

  end
  else
   rt :=0;

  if rt>=0 then
  begin
   if not move_file(path,iniFrm.doneDir.Text) then
   begin
    btnStopSendClick(sender);  //Noe alvorlig feil
    exit;
   end;

   filesReadyList.Update;
   pdfCnt.text :=intToStr(filesreadyList.Items.Count);

  end
  else
  begin
   if rt=ERROR_ then
   begin
    btnStopSendClick(sender);  //Noe alvorlig feil
    exit;
   end
   else
   begin
    inc(PRVskippedFileSend);
    fileListBox.items.add(extractFileName(flname));
   end;

  end;

 end
 else
  if PRVfileSendPos<pgsBar.max then
  begin
   inc(PRVskippedFileSend);
   fileListBox.items.add(extractFileName(flname));
  end;

 inc(PRVfileSendPos);
 if PRVfileSendPos>pgsBar.max then
 begin
  setBtnStat(FALSE);

  filesReadyList.show;

  if PRVskippedFileSend>0 then
  begin
   unitFrm.msgDlg(format('%d filer utelatt på grunn av manglende e-mail adresse.'+FNUL+
                         'Se liste over.',[PRVskippedFileSend]),INFO_);

  end;

  exit;
 end;

 pgsBar.stepIt;

 sendTimer.enabled :=TRUE;

end;


procedure TMainForm.btnStopSendClick(Sender: TObject);
begin

 setBtnStat(FALSE);

 filesReadyList.show;

 sendTimer.enabled :=FALSE;
 btnStopSend.enabled :=FALSE;
 btnSendMailList.enabled :=TRUE;


 //pnlMailList.Visible :=TRUE;
end;

procedure TMainForm.pgCtrlFilesChange(Sender: TObject);
begin

 if pgCtrlFiles.ActivePage=tsFilesSend then
 begin

  try
  filesReadyList.Directory :=ExpandFileName(iniFrm.xprintDir.text);
  filesReadyList.mask :=format('*.%s',[iniFrm.xprintExt.text]);
  except
   //
  end;

  filesReadyList.update;
  pdfCnt.text :=intToStr(filesreadyList.Items.Count);

 end
 else
 if pgCtrlFiles.ActivePage=tsFilesMoved then
 begin

  try
   filesSendtList.Directory :=ExpandFileName(iniFrm.doneDir.text);
   filesSendtList.mask :=format('*.%s',[iniFrm.xprintExt.text]);
  except
   //
  end;

   filesSendtList.update;
 end;

end;

procedure TMainForm.btnSetupClick(Sender: TObject);
begin
 iniFrm.showModal;
end;

procedure TMainForm.dbSrcDataChange(Sender: TObject; Field: TField);
var
 sgn: String;
begin
//

if typFrm.triggInhibit(CHECK_)=ONX then
 exit;

 with dbSrc.dataset do
 begin
   sgn :=fieldByName('Sign').asString;

   mailto.Text :=getMailAdress(sgn,NUL);

   empCnt.Text :=intToStr(recordCount);
 end;

end;

procedure TMainForm.btnCheckMailAdressClick(Sender: TObject);
var
 mcnt,lcnt: Integer;
begin

 mcnt :=checkMailList(PREVIEW_);

 if mcnt<0 then
  exit;

 lcnt :=filesReadyList.Items.count;

 if mcnt<lcnt then
 begin
  unitFrm.msgDlg(format('%d filer mangler tilhørende mail-adresse.'+FNUL+
                        'Se liste over.',[lcnt-mcnt]),INFO_);

 end;

end;

procedure TMainForm.filesReadyListClick(Sender: TObject);
var
 flname: String;
begin

 //todoFileName.text := filesReadyList.fileName;

 flname :=extractFileName(filesReadyList.fileName);
 //todoFileName.text :=flname;

 mailto.Text :=getMailAdress(NUL,flname);
 if trim(mailTo.Text)<>NUL then
  mailAttachment.Text :=filesReadyList.fileName;

end;

procedure TMainForm.mnuSendFileClick(Sender: TObject);
var
 rt: Integer;
 flname: String;
begin

 flname :=extractFileName(filesReadyList.fileName);
 //todoFileName.text :=flname;

 mailto.Text :=getMailAdress(NUL,flname);
 if trim(mailTo.Text)<>NUL then
 begin
  mailAttachment.Text :=filesReadyList.fileName;
  rt :=unitFrm.msgDlg(format('Send %s til %s ?',
   [flname,mailto.Text]),QUESTION_);

  if (rt=mrNo) or (rt=mrCancel) then
   exit
  else
   btnSendmailClick(sender);

 end
 else
 begin
  unitFrm.msgDlg(format('%s har ingen tilhørende mail-adresse',
   [flname]),INFO_);
  exit;

 end;


end;

procedure TMainForm.mnuPopFilePopup(Sender: TObject);
begin

 if not verifyMailList() then
  mnuSendFile.enabled :=FALSE
 else
  mnuSendFile.enabled :=TRUE;

end;

procedure TMainForm.mnuFileListUpdateClick(Sender: TObject);
begin
  filesReadyList.update;
  pdfCnt.text :=intToStr(filesreadyList.Items.Count);

end;

procedure TMainForm.loadTimerTimer(Sender: TObject);
begin

 loadTimer.enabled :=FALSE;
 btnLoadMailListClick(Sender);

end;

procedure TMainForm.pnlBtnsDblClick(Sender: TObject);
begin
 btnSetup.Visible :=not btnSetup.Visible;
end;

end.
