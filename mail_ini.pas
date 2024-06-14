unit mail_ini;

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
  Buttons,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  iniFiles,
  Mask,
  JvExMask,
  JvToolEdit;

  
type
  TiniFrm = class(TForm)
    pgCtrlIni: TPageControl;
    tsDirectory: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    Label16: TLabel;
    Label37: TLabel;
    Label42: TLabel;
    Label91: TLabel;
    Label98: TLabel;
    Label100: TLabel;
    masterdbDir: TEdit;
    aliasList: TComboBox;
    progrDir: TEdit;
    pictureDir: TEdit;
    networkDir: TEdit;
    masterDbAlias: TEdit;
    pictureAlias: TEdit;
    nrkDBdir: TEdit;
    nrkAlias: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label43: TLabel;
    Label39: TLabel;
    Label106: TLabel;
    Label9: TLabel;
    Label40: TLabel;
    matchDbDir: TEdit;
    packDir: TEdit;
    defDir: TEdit;
    paintProgrDir: TEdit;
    BDEprivateDir: TEdit;
    dbExt: TEdit;
    matchDbAlias: TEdit;
    packAlias: TEdit;
    defAlias: TEdit;
    mapTable: TEdit;
    BDE_dir: TEdit;
    bdeCfgProgr: TEdit;
    aliasInfo: TListBox;
    btnTbaleMap: TButton;
    grpFirma: TGroupBox;
    Label99: TLabel;
    Label101: TLabel;
    Label110: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label168: TLabel;
    ExcelDir: TEdit;
    excelAlias: TEdit;
    HTMLdir: TEdit;
    nrkBtxDir: TEdit;
    btxAlias: TEdit;
    macDir: TEdit;
    macAlias: TEdit;
    xyFileDir: TEdit;
    tsData: TTabSheet;
    pnlData1: TPanel;
    grpFilter: TGroupBox;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    LabelDefaultID: TLabel;
    Label151: TLabel;
    defaultSign: TEdit;
    defaultAvd: TEdit;
    defaultTurnusID: TEdit;
    defaultAvdID: TEdit;
    defaultResGrp: TEdit;
    pnlData2: TPanel;
    grpDataSort: TGroupBox;
    grpWildcards: TGroupBox;
    Label87: TLabel;
    Label88: TLabel;
    Label86: TLabel;
    qryBlock: TEdit;
    qryChar: TEdit;
    qryCmpCase: TEdit;
    tsSystem: TTabSheet;
    grpSysInf: TGroupBox;
    grpMemStat: TGroupBox;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    sysMemPhysical: TEdit;
    sysMemPhysAvail: TEdit;
    sysMemLoad: TEdit;
    sysMemVirtualAvail: TEdit;
    grpCpu: TGroupBox;
    Label132: TLabel;
    Label133: TLabel;
    sysCPU: TEdit;
    sysOpSys: TEdit;
    grpSysLogon: TGroupBox;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    sysLogonUser: TEdit;
    sysLogonName: TEdit;
    sysLogonCompany: TEdit;
    grpEvent: TGroupBox;
    Label21: TLabel;
    useEventLog: TCheckBox;
    chkStartDropDownCheck: TCheckBox;
    grpPrins: TGroupBox;
    pnlLogon1: TPanel;
    grpXnrkPrinsLogon: TGroupBox;
    Label116: TLabel;
    Label117: TLabel;
    chkXnrkLogon: TCheckBox;
    defUserName: TEdit;
    defPassWord: TEdit;
    grpMediaLogon: TGroupBox;
    Label20: TLabel;
    Label22: TLabel;
    chkMediaLogon: TCheckBox;
    mediaUserName: TEdit;
    mediaPassword: TEdit;
    pnlLogon2: TPanel;
    grpDbType: TGroupBox;
    chkDbOracle: TRadioButton;
    chkDbMSSQL: TRadioButton;
    chkDbMy: TRadioButton;
    tsPrint: TTabSheet;
    grpFonts: TGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label47: TLabel;
    Label51: TLabel;
    Label46: TLabel;
    btnGridFont: TButton;
    gridFontName: TEdit;
    gridFontStyle: TEdit;
    gridFontColor: TEdit;
    btnGridFontColor: TButton;
    titleFontColor: TEdit;
    btnTitleFontColor: TButton;
    gridTitleStyle: TCheckBox;
    gridColor: TEdit;
    btnGridColor: TButton;
    pnlListRep1: TPanel;
    grpPrintDiv: TGroupBox;
    listUseRecNo: TCheckBox;
    listUseSum: TCheckBox;
    listUseUnderLines: TCheckBox;
    listPortrait: TRadioButton;
    listLandscape: TRadioButton;
    grpPrintMargins: TGroupBox;
    Label28: TLabel;
    Label32: TLabel;
    Label30: TLabel;
    Label29: TLabel;
    label34: TLabel;
    grpScale: TGroupBox;
    Label35: TLabel;
    Label36: TLabel;
    Label104: TLabel;
    Label118: TLabel;
    refPixels: TCheckBox;
    init: TCheckBox;
    grpXprintColor: TGroupBox;
    xprintFerieColor: TEdit;
    xprintAvspColor: TEdit;
    xprintReiseColor: TEdit;
    grpListFonts: TGroupBox;
    Label24: TLabel;
    Label27: TLabel;
    Label60: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label61: TLabel;
    Label41: TLabel;
    Label31: TLabel;
    Label82: TLabel;
    titleFontName: TEdit;
    headFontName: TEdit;
    UpDownHeadSize: TUpDown;
    UpDownTitleSize: TUpDown;
    titleFontStyle: TEdit;
    headFontStyle: TEdit;
    btnTitleFonts: TButton;
    btnHeadFonts: TButton;
    dataFontName: TEdit;
    UpDownDataSize: TUpDown;
    dataFontStyle: TEdit;
    btnDataFonts: TButton;
    listBkgColor: TEdit;
    btnColor: TButton;
    grpIni: TGroupBox;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    initYear: TEdit;
    oraServerName: TEdit;
    mssqlServerName: TEdit;
    mysqlServerName: TEdit;
    pnlSysInfoRight: TPanel;
    pnlDataRight: TPanel;
    Label134: TLabel;
    Label135: TLabel;
    nlsDateFormat: TEdit;
    sqlDateFunk: TEdit;
    useSQLmode: TCheckBox;
    orderQuery: TCheckBox;
    useSqlLIKE: TCheckBox;
    useSQLprepare: TCheckBox;
    useStrictKey: TCheckBox;
    accessMode: TComboBox;
    oraCharSet: TEdit;
    Label11: TLabel;
    GroupBox3: TGroupBox;
    dbSchema: TEdit;
    Label12: TLabel;
    tsMail: TTabSheet;
    pnlMailSetupLeft: TPanel;
    grpServer: TGroupBox;
    Label14: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label23: TLabel;
    grpTrx: TGroupBox;
    Label33: TLabel;
    Label38: TLabel;
    Label44: TLabel;
    pnlMailSetupRight: TPanel;
    GroupBox4: TGroupBox;
    Label45: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    chkDeleteMail: TCheckBox;
    pollInterval: TEdit;
    Label54: TLabel;
    MailServerSMTP: TEdit;
    mailServerPOP3: TEdit;
    mailUsername: TEdit;
    mailPassword: TEdit;
    mailSender: TEdit;
    mailSource: TEdit;
    mailDestination: TEdit;
    Label55: TLabel;
    daysToKeepLog: TEdit;
    Label56: TLabel;
    Label57: TLabel;
    pnlMailSetupLeft2: TPanel;
    grpPersonDB: TGroupBox;
    Label17: TLabel;
    empTableName: TEdit;
    Label58: TLabel;
    mailSubject: TEdit;
    Label59: TLabel;
    empResGrp: TEdit;
    Label62: TLabel;
    todoDir: TJvDirectoryEdit;
    doneDir: TJvDirectoryEdit;
    logDir: TJvDirectoryEdit;
    xprintDir: TJvDirectoryEdit;
    Label63: TLabel;
    xprintExt: TEdit;
    Label64: TLabel;
    sendInterval: TEdit;
    Label65: TLabel;
    chkSimulate: TCheckBox;
    chkLoginSMTP: TCheckBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure accessModeChange(Sender: TObject);
    procedure chkLoginSMTPClick(Sender: TObject);
  private
    { Private declarations }
   procedure loadSectionNames;

  public
    { Public declarations }
    PUBiniFile,PUBsourceIniFile: String;      //Navn på gjeldende INI-fil
    PUBifs: iniFilesections;
    PUBints: ARFLDI;  //array med 32 Integer
   function  iniWinPos(frm: Tform; cmd: Integer): Integer;
   function  processIniFile(fileName: String;cmd: Integer): Integer;

  end;

var
  iniFrm: TiniFrm;

implementation

uses
mid_units;

{$R *.dfm}
function TiniFrm.iniWinPos(frm: Tform; cmd: Integer): Integer;
var
 inifil: TiniFile;
 defStr,str: String;
begin

Result :=ERROR_;


if (not assigned(frm)) OR
   (frm.name=NUL) OR
   (PUBiniFile=NUL) then
 exit;

iniFil :=TiniFile.create(PUBsourceiniFile);


if cmd = WRITE_ then
begin

if frm.windowState = wsMaximized then
 str :=format('%d,%d,%d,%d',[0,0,0,0])
else
if frm.windowState = wsMinimized then
 str :=format('%d,%d,%d,%d',[-1,-1,-1,-1])
else
 str :=format('%d,%d,%d,%d',[frm.top,frm.left,frm.height,frm.width]);

 try
  iniFil.writeString(PUBifs[SECT_MODULES],frm.name,str);
 except
  unitFrm.msgDlg(format('%s %s ',
  [NO_ACCESS_,PUBsourceiniFile]),ERROR_);
  //raise;
  Result :=ERROR_;
  exit;
 end;

end;


if cmd = READ_ then
begin
 defStr :='10,10,200,300';    //Default størrelse hvis INI-data mangler

 try
  str :=iniFil.readString(PUBifs[SECT_MODULES],frm.name,defstr);
 except
  unitFrm.msgDlg(format('%s %s ',
  [NO_ACCESS_,PUBiniFile]),ERROR_);
  //raise;
  Result :=ERROR_;
  exit;
 end;

 //Splitt komma-separert 'str' til 'ints[]'
 if unitFrm.breakStrToInts(str,',',@PUBints) <0 then
  exit;

  //Siste posisjon ved detach()
 if (PUBints[1]=0) AND
    (PUBints[2]=0) AND
    (PUBints[3]=0) AND
    (PUBints[4]=0) then
 frm.windowState :=wsMaximized
else
 if (PUBints[1]=(-1)) AND
    (PUBints[2]=(-1)) AND
    (PUBints[3]=(-1)) AND
    (PUBints[4]=(-1)) then
 frm.windowState :=wsMinimized
else
begin
 frm.top :=PUBints[1];
 frm.left :=PUBints[2];
 frm.height :=PUBints[3];
 frm.width :=PUBints[4];
end;


end;

 iniFil.free;

// if refPixels.checkedthen
//  frm.pixelsPerInch :=screen.pixelsPerInch;

 Result :=0;
end;

procedure TiniFrm.loadSectionNames;
begin

PUBifs[1] :='PATHS';
PUBifs[2] :='ALIAS';
PUBifs[3] :='DATABASE';
PUBifs[4] :='PROGRAM';
PUBifs[5] :='PACK';
PUBifs[6] :='DEFS';
PUBifs[7] :='PICTURE';
PUBifs[8] :='QUERY';
PUBifs[9] :='SQL';
PUBifs[10] :='ODBC';
PUBifs[11] :='BROWSER';
PUBifs[12] :='SYSTEM';
PUBifs[13] :='PRINT';
PUBifs[14] :='THREADS';
PUBifs[15] :='MODULES';
PUBifs[16] :='WIN95';
PUBifs[17] :='WINNT';
PUBifs[18] :='NETWORK';
PUBifs[19] :='USER';
PUBifs[20] :='EVENT';
PUBifs[21] :='MSG';
PUBifs[22] :='COLORS';

PUBifs[29] :='NRK';
PUBifs[30] :='PROD';
PUBifs[31] :='BOOKING';
PUBifs[32] :='ITEM';
PUBifs[33] :='ITEMGROUP';
PUBifs[34] :='SIGN';
PUBifs[35] :='CATEGORY';
PUBifs[36] :='VENUE';
PUBifs[37] :='OVRN';
PUBifs[38] :='TOUR';
PUBifs[39] :='INVOICE';
PUBifs[40] :='ARTIST';

PUBifs[41] :='MEDIA';

PUBifs[42] :='MAIL';

end;

function  TiniFrm.processIniFile(fileName: String;cmd: Integer): Integer;
var
 offtimeLimit: Integer;
 inifil: TiniFile;
begin

Result :=ERROR_;

 if fileName = NUL then
 exit;

screen.cursor :=crHourglass;

//unitFrm.msgDlg('ini create ready',INFO_);
loadSectionNames();

iniFil :=TiniFile.create(fileName);

if iniFil = nil then
 exit;

//unitFrm.msgDlg('ini create finished',INFO_);

if cmd =WRITE_ then
begin

 with iniFil do
 begin

 try
//  accessMode.text :=intToStr(typFrm.userMode);


  writeString(PUBifs[SECT_PATHS], 'mapTable',mapTable.text);

  writeString(PUBifs[SECT_PATHS], 'BDE',BDE_dir.text);
  writeString(PUBifs[SECT_PATHS], 'program',progrDir.text);

  writeString(PUBifs[SECT_PATHS], 'masterDb',masterDbDir.text);
  writeString(PUBifs[SECT_PATHS], 'matchDb',matchDbDir.text);
  writeString(PUBifs[SECT_PATHS], 'pack',packDir.text);
  writeString(PUBifs[SECT_PATHS], 'def',defDir.text);
  writeString(PUBifs[SECT_PATHS], 'picture',pictureDir.text);
  writeString(PUBifs[SECT_PATHS], 'paintProgr',paintProgrDir.text);

  writeString(PUBifs[SECT_PATHS], 'BDEcfgProgr',BDEcfgProgr.text);
  writeString(PUBifs[SECT_PATHS], 'networkShare',networkDir.text);
  writeString(PUBifs[SECT_PATHS], 'BDEprivate',BDEprivateDir.text);

  writeString(PUBifs[SECT_PATHS], 'NRKdbDir',nrkDbDir.text);
  writeString(PUBifs[SECT_PATHS], 'EXCELdir',ExcelDir.text);
  writeString(PUBifs[SECT_PATHS], 'NRKbtxDir',nrkBtxDir.text);
  writeString(PUBifs[SECT_PATHS], 'HTMLdir',HTMLdir.text);
  writeString(PUBifs[SECT_PATHS], 'MaconomyDir',macDir.text);
  writeString(PUBifs[SECT_PATHS], 'XytechDir',xyFileDir.text);

  writeString(PUBifs[SECT_ALIAS], 'masterDb',masterDbAlias.text);
  writeString(PUBifs[SECT_ALIAS], 'matchDb',matchDbAlias.text);
  writeString(PUBifs[SECT_ALIAS], 'pack',packAlias.text);
  writeString(PUBifs[SECT_ALIAS], 'def',defAlias.text);
  writeString(PUBifs[SECT_ALIAS], 'picture',pictureAlias.text);

  writeString(PUBifs[SECT_ALIAS], 'nrkAlias',nrkAlias.text);
  writeString(PUBifs[SECT_ALIAS], 'excelAlias',excelAlias.text);
  writeString(PUBifs[SECT_ALIAS], 'btxAlias',btxAlias.text);
  writeString(PUBifs[SECT_ALIAS], 'MaconomyAlias',macAlias.text);


  //writeBool(PUBifs[SECT_DATA],'orderQuery',orderQuery.checked);
  //writeBool(PUBifs[SECT_DATA],'useStrictKey',useStrictKey.checked);
  //writeBool(PUBifs[SECT_DATA],'useSqlLIKE',  useSqlLIKE.checked );
  //writeBool(PUBifs[SECT_DATA],'useSQLprepare',  useSqlprepare.checked );
  writeBool(PUBifs[SECT_DATA],'useSQLmode',  useSqlmode.checked );
  writeString(PUBifs[SECT_DATA],'qryCmpCase',qryCmpCase.text);
  writeString(PUBifs[SECT_DATA],'qryBlock',qryBlock.text);
 {
  writeString(PUBifs[SECT_PRINT],'dataFontName',dataFontName.text);
  writeString(PUBifs[SECT_PRINT],'dataFontSize',dataFontSize.text);
  writeString(PUBifs[SECT_PRINT],'dataFontStyle',dataFontStyle.text);

  writeString(PUBifs[SECT_PRINT],'titleFontName',titleFontName.text);
  writeString(PUBifs[SECT_PRINT],'titleFontSize',titleFontSize.text);
  writeString(PUBifs[SECT_PRINT],'titleFontStyle',titleFontStyle.text);

  writeString(PUBifs[SECT_PRINT],'headFontStyle',headFontStyle.text);
  writeString(PUBifs[SECT_PRINT],'headFontSize',headFontSize.text);
  writeString(PUBifs[SECT_PRINT],'headFontStyle',headFontStyle.text);



  writeString(PUBifs[SECT_PRINT],'listMaxWidth',listMaxWidth.text);
  writeString(PUBifs[SECT_PRINT],'listMaxHeight',listMaxHeight.text);

  writeString(PUBifs[SECT_PRINT],'listColSpace',listColSpace.text);
  writeString(PUBifs[SECT_PRINT],'listBkgColor',listBkgColor.text);


  writeString(PUBifs[SECT_PRINT],'listLineSpace',listLineSpace.text);

  writeString(PUBifs[SECT_PRINT],'listTopMargin',listTopMargin.text);
  writeString(PUBifs[SECT_PRINT],'listLeftMargin',listLeftMargin.text);
  writeString(PUBifs[SECT_PRINT],'listRightMargin',listRightMargin.text);

  writeBool(PUBifs[SECT_PRINT],'listLandscape',listLandscape.checked);
  writeBool(PUBifs[SECT_PRINT],'listPortrait',listPortrait.checked);
 }

  writeBool(PUBifs[SECT_PRINT],'listUseRecNo',listUseRecNo.checked);
  writeBool(PUBifs[SECT_PRINT],'listUseSum',listUseSum.checked);
  writeBool(PUBifs[SECT_PRINT],'listUseUnderLines',listUseUnderLines.checked);


  writeInteger(PUBifs[SECT_SYSTEM],'mode',typFrm.userMode);
 // writeInteger(PUBifs[SECT_SYSTEM],'mode', strToInt(accessMode.Text));

  //writeString(PUBifs[SECT_SYSTEM],'scaleM',scaleM.text);
  //writeString(PUBifs[SECT_SYSTEM],'scaleD',scaleD.text);
  //writeBool(PUBifs[SECT_SYSTEM],'refPixels',refPixels.checked);
  writeString(PUBifs[SECT_SYSTEM], 'dataBaseExtension',dbExt.text);
  writeBool(PUBifs[SECT_SYSTEM], 'init',init.checked);
  //writeString(PUBifs[SECT_SYSTEM],'repScale',repScale.text);
  //writeString(PUBifs[SECT_SYSTEM],'gridRowScale',gridRowScale.text);
  //writeBool(PUBifs[SECT_SYSTEM], 'autoUpdates',chkAutoUpdates.checked);
 // writeBool(PUBifs[SECT_SYSTEM], 'confirmModuleExit',chkConfirmExit.checked);

  writeString(PUBifs[SECT_SYSTEM],'nlsDateFormat',nlsDateFormat.text);
  writeString(PUBifs[SECT_SYSTEM],'sqlDateFunk',sqlDateFunk.text);

  writeBool(PUBifs[SECT_SYSTEM],'dbTypeOracle',chkDbOracle.checked);
  writeBool(PUBifs[SECT_SYSTEM],'dbTypeMSSQL',chkDbMSSQL.checked);
  writeBool(PUBifs[SECT_SYSTEM],'dbTypeMySQL',chkDbMY.checked);

  writeBool(PUBifs[SECT_SYSTEM],'OracleLogon',chkXnrkLogon.checked);
  writeString(PUBifs[SECT_SYSTEM],'defUserName',defUserName.text);
  writeString(PUBifs[SECT_SYSTEM],'defPassWord',defPassWord.text);

   writeString(PUBifs[SECT_SYSTEM],'oraServerName',oraServerName.text);
   writeString(PUBifs[SECT_SYSTEM],'mssqlServerName',mssqlServerName.text);
   writeString(PUBifs[SECT_SYSTEM],'mysqlServerName',mysqlServerName.text);

   writeString(PUBifs[SECT_SYSTEM],'oraCharSet',oraCharSet.text);


   writeString(PUBifs[SECT_SYSTEM],'dbSchema',dbSchema.text);

  //encrypt.mode :=MODE_ENCRYPT;
  //Må legge til en blank bakerst pgr bug i encrypt ...
  //encrypt.inString :=format('%s ',[defPassWord.text]);

  writeBool(PUBifs[SECT_SYSTEM],'MediaLogon',chkMediaLogon.checked);
  writeString(PUBifs[SECT_SYSTEM],'MediaUserName',mediaUserName.text);
  //encrypt.mode :=MODE_ENCRYPT;
  //Må legge til en blank bakerst pgr bug i encrypt ...
  //encrypt.inString :=format('%s ',[mediaPassWord.text]);
  writeString(PUBifs[SECT_SYSTEM],'MediaPassWord',mediaPassWord.text);

  {
  writeBool(PUBifs[SECT_SYSTEM],'MaconomyLogon',chkMacLogon.checked);
  writeString(PUBifs[SECT_SYSTEM],'MaconomyUserName',macUserName.text);
  encrypt.mode :=MODE_ENCRYPT;
  //Må legge til en blank bakerst pgr bug i encrypt ...
  encrypt.inString :=format('%s ',[macPassWord.text]);
  writeString(PUBifs[SECT_SYSTEM],'MaconomyPassWord',encrypt.outString);

  writeBool(PUBifs[SECT_SYSTEM],'FormulaLogon',chkFmLogon.checked);
  writeString(PUBifs[SECT_SYSTEM],'FormulaUserName',fmUserName.text);
  encrypt.mode :=MODE_ENCRYPT;
  //Må legge til en blank bakerst pgr bug i encrypt ...
  encrypt.inString :=format('%s ',[fmPassWord.text]);
  writeString(PUBifs[SECT_SYSTEM],'FormulaPassWord',encrypt.outString);


  writeBool(PUBifs[SECT_SYSTEM],'XytechLogon',chkXyLogon.checked);
  writeString(PUBifs[SECT_SYSTEM],'XytechUserName',xyUserName.text);
  encrypt.mode :=MODE_ENCRYPT;
  //Må legge til en blank bakerst pgr bug i encrypt ...
  encrypt.inString :=format('%s ',[xyPassWord.text]);
  writeString(PUBifs[SECT_SYSTEM],'XytechPassWord',encrypt.outString);

  writeBool(PUBifs[SECT_SYSTEM],'ROADlogon',chkRoadLogon.checked);
  writeString(PUBifs[SECT_SYSTEM],'ROADuserName',ROADuserName.text);
  encrypt.mode :=MODE_ENCRYPT;
  //Må legge til en blank bakerst pgr bug i encrypt ...
  encrypt.inString :=format('%s ',[ROADpassWord.text]);
  writeString(PUBifs[SECT_SYSTEM],'ROADpassword',encrypt.outString);

  writeBool(PUBifs[SECT_SYSTEM],'POBlogon',chkPobLogon.checked);
  writeString(PUBifs[SECT_SYSTEM],'POBuserName',POBuserName.text);
  encrypt.mode :=MODE_ENCRYPT;
  //Må legge til en blank bakerst pgr bug i encrypt ...
  encrypt.inString :=format('%s ',[POBpassWord.text]);
  writeString(PUBifs[SECT_SYSTEM],'POBpassword',encrypt.outString);


  writeBool(PUBifs[SECT_SYSTEM],'PRiNSprodOnly',chkVplonly.checked);
  }

  //Ny 24.12.2002
  writeString(PUBifs[SECT_SYSTEM],'initYear',initYear.text);


  //writeBool(PUBifs[SECT_SYSTEM],'startDrowpDownCheck',chkStartDropDownCheck.checked);

  {
  writeString(PUBifs[SECT_COLORS], 'tabPgColor',tabPgColor.text);
  writeString(PUBifs[SECT_COLORS], 'grpBoxColor',grpBoxColor.text);
  writeString(PUBifs[SECT_COLORS], 'pnlBtnColor',pnlBtnColor.text);
  }
 {
  writeString(PUBifs[SECT_COLORS], 'gridColor',gridColor.text);

  writeString(PUBifs[SECT_COLORS], 'gridFontName',gridFontName.text);
  writeString(PUBifs[SECT_COLORS], 'gridFontSize',gridFontSize.text);
  writeString(PUBifs[SECT_COLORS], 'gridFontStyle',gridFontStyle.text);
  writeString(PUBifs[SECT_COLORS], 'gridFontColor',gridFontColor.text);

  writeString(PUBifs[SECT_COLORS], 'gridTitleFontColor',titleFontColor.text);
  writeBool(PUBifs[SECT_COLORS], 'gridTitleStyle',gridTitleStyle.checked);
 }


   writeString(PUBifs[SECT_NRK],'defaultSign',defaultSign.text);
   writeString(PUBifs[SECT_NRK],'defaultAvd',defaultAvd.text);
   writeString(PUBifs[SECT_NRK],'defaultAvdID',defaultAvdID.text);
   writeString(PUBifs[SECT_NRK],'defaultTurnusID',defaultTurnusID.text);
   writeString(PUBifs[SECT_NRK],'defaultResGrp',defaultResGrp.text);

   writeString(PUBifs[SECT_MAIL],'todoDir',todoDir.text);
   writeString(PUBifs[SECT_MAIL],'doneDir',doneDir.text);
   writeString(PUBifs[SECT_MAIL],'logDir',logDir.text);
   writeString(PUBifs[SECT_MAIL],'xprintDir',xprintDir.text);
   writeString(PUBifs[SECT_MAIL],'xprintExt',xprintExt.text);

   writeString(PUBifs[SECT_MAIL],'pollInterval',pollInterval.text);
   writeString(PUBifs[SECT_MAIL],'sendInterval',sendInterval.text);

   writeBool(PUBifs[SECT_MAIL],'deleteMail',chkDeleteMail.checked);

   writeString(PUBifs[SECT_MAIL],'MailServerSMTP',MailServerSMTP.text);
   writeString(PUBifs[SECT_MAIL],'MailServerPOP3',MailServerPOP3.text);



   writeString(PUBifs[SECT_MAIL],'MailUser',MailUsername.text);
   writeString(PUBifs[SECT_MAIL],'MailPassword',MailPassword.text);


   writeString(PUBifs[SECT_MAIL],'sender',MailSender.text);
   writeString(PUBifs[SECT_MAIL],'source',MailSource.text);
   writeString(PUBifs[SECT_MAIL],'destination',MailDestination.text);

   writeString(PUBifs[SECT_MAIL],'subject',MailSubject.text);

   writeString(PUBifs[SECT_MAIL],'daysToKeepLog',daysToKeepLog.Text);

   writeString(PUBifs[SECT_MAIL],'PersonDB',empTableName.text);
   writeString(PUBifs[SECT_MAIL],'ResGrp',empResGrp.text);
   writeBool(PUBifs[SECT_MAIL],'simmuler',chkSimulate.checked);

   writeBool(PUBifs[SECT_MAIL],'SMTP_login',chkLoginSMTP.checked);

 except
  //raise;
 {
  iniFil.free;
  Result :=ERROR_;
  exit;
 }
 end;

 // setCurrentDir(iniFrm.progrDir.text);
 end;


end;


if cmd =READ_ then
begin

//if chkXnrkLogon.checked then
//begin

{
if copy(PUBiniFile,1,1)=PRIVATE_DRIVE then
begin
 progressFrm.pb.position :=0;
 progressFrm.pb.max :=234;
 progressFrm.setProgressText(NUL);

 progressFrm.show;
end;
}
//end;

 with iniFil do
 begin

try
 mapTable.text :=readString(PUBifs[SECT_PATHS], 'mapTable','TableMap');

 BDE_dir.text := readString(PUBifs[SECT_PATHS], 'BDE',X98_LOCAL_PATH+'\BDE');

 progrDir.text := readString(PUBifs[SECT_PATHS], 'program',X98_LOCAL_PATH);

 masterDbDir.text :=readString(PUBifs[SECT_PATHS],'masterDb', X98_LOCAL_PATH+'\DB');

 matchDbDir.text :=readString(PUBifs[SECT_PATHS],'matchDb', X98_LOCAL_PATH+'\MATCH');

 packDir.text :=readString(PUBifs[SECT_PATHS],'pack', X98_LOCAL_PATH+'\PACK');

 defDir.text :=readString(PUBifs[SECT_PATHS],'def', X98_LOCAL_PATH+'\DEFS');

 pictureDir.text :=readString(PUBifs[SECT_PATHS],'picture', X98_LOCAL_PATH+'\PICTURES');

 paintProgrDir.text := readString(PUBifs[SECT_PATHS], 'paintProgr','MSPAINT.EXE');


 BDEcfgProgr.text := readString(PUBifs[SECT_PATHS], 'BDEcfgProgr','BDECFG32.EXE');

 networkDir.text := readString(PUBifs[SECT_PATHS], 'networkShare',X98_LOCAL_PATH+'\NET');

 BDEprivateDir.text := readString(PUBifs[SECT_PATHS], 'BDEprivate',X98_LOCAL_PATH+'\TMP');

 nrkDbDir.text :=readString(PUBifs[SECT_PATHS], 'NRKdbDir',X98_LOCAL_PATH+'\NRKDB');

 ExcelDir.text :=readString(PUBifs[SECT_PATHS], 'EXCELdir',X98_LOCAL_PATH+'\XLS');

 nrkBtxDir.text :=readString(PUBifs[SECT_PATHS], 'NRKbtxDir',X98_LOCAL_PATH+'\BTX');

 HTMLdir.text :=readString(PUBifs[SECT_PATHS], 'HTMLdir',X98_LOCAL_PATH+'\HTML');

 macDir.text :=readString(PUBifs[SECT_PATHS], 'MaconomyDir',X98_LOCAL_PATH+'\MAC');

 xyFileDir.text :=readString(PUBifs[SECT_PATHS], 'XytechDir','Y:\EXP_X98');

 masterDbAlias.text :=readString(PUBifs[SECT_ALIAS],'masterDb', 'DB');

 matchDbAlias.text :=readString(PUBifs[SECT_ALIAS],'matchDb', 'MATCH');

 packAlias.text :=readString(PUBifs[SECT_ALIAS],'pack', 'PACK');

 defAlias.text :=readString(PUBifs[SECT_ALIAS],'def', 'DEFS');

 pictureAlias.text :=readString(PUBifs[SECT_ALIAS],'picture', 'PICTURES');

 nrkAlias.text :=  readString(PUBifs[SECT_ALIAS], 'nrkAlias','NRK');

 excelAlias.text := readString(PUBifs[SECT_ALIAS], 'excelAlias','XLS');

 btxAlias.text := readString(PUBifs[SECT_ALIAS], 'btxAlias','BTX');

 macAlias.text := readString(PUBifs[SECT_ALIAS], 'MaconomyAlias','MACONOMY');



 orderQuery.checked := TRUE; //readBool(PUBifs[SECT_DATA],'orderQuery',FALSE);
 //progressFrm.setProgressText('39');

 useStrictKey.checked := FALSE; //readBool(PUBifs[SECT_DATA],'useStrictKey',FALSE);
 //progressFrm.setProgressText('40');

 useSqlLIKE.checked :=TRUE; //readBool(PUBifs[SECT_DATA],'useSqlLIKE',TRUE);
 //progressFrm.setProgressText('41');

 useSqlPrepare.checked :=FALSE; //readBool(PUBifs[SECT_DATA],'useSQLprepare',TRUE);
 //progressFrm.setProgressText('42');

 useSqlmode.checked :=readBool(PUBifs[SECT_DATA],'useSQLmode', FALSE);

 qryCmpCase.text :=readString(PUBifs[SECT_DATA],'qryCmpCase','lower');

 qryBlock.text :=readString(PUBifs[SECT_DATA],'qryBlock','%');

 qryChar.text :=readString(PUBifs[SECT_DATA],'qryChar','_');



 useEventLog.checked := FALSE; //readBool(PUBifs[SECT_EVENT],'useEventLog',FALSE);
 //progressFrm.setProgressText('52');



 dataFontName.text := 'Arial'; //readString(PUBifs[SECT_PRINT],'dataFontName','Arial');
 //progressFrm.setProgressText('58');

 //dataFontSize.text := '9'; //readString(PUBifs[SECT_PRINT],'dataFontSize','9');
 //progressFrm.setProgressText('59');

 //dataFontStyle.text :='Normal';  //readString(PUBifs[SECT_PRINT],'dataFontStyle','Normal');
 //progressFrm.setProgressText('60');

 titleFontName.text := 'Arial'; //readString(PUBifs[SECT_PRINT],'titleFontName','Arial');
 //progressFrm.setProgressText('61');

 //titleFontSize.text := '12'; //readString(PUBifs[SECT_PRINT],'titleFontSize','12');
 //progressFrm.setProgressText('62');

 titleFontStyle.text := 'Bold'; //readString(PUBifs[SECT_PRINT],'titleFontStyle','Normal');
 //progressFrm.setProgressText('63');


 headFontName.text :='Arial'; // readString(PUBifs[SECT_PRINT],'headFontName','Arial');
// progressFrm.setProgressText('65');

 //headFontSize.text := '8'; //readString(PUBifs[SECT_PRINT],'headFontSize','8');
 //progressFrm.setProgressText('66');

 headFontStyle.text :='Bold'; // readString(PUBifs[SECT_PRINT],'headFontStyle','Normal');
// progressFrm.setProgressText('67');



 //listMaxWidth.text := '1024'; //readString(PUBifs[SECT_PRINT],'listMaxWidth','800');
 //progressFrm.setProgressText('72');

 //listMaxHeight.text := '1680'; //readString(PUBifs[SECT_PRINT],'listMaxHeight','1600');

 //listColSpace.text := '10'; //readString(PUBifs[SECT_PRINT],'listColSpace','10');

 listBkgColor.text := 'clWhite'; //readString(PUBifs[SECT_PRINT],'listBkgColor','clWhite');

 listLandscape.checked :=FALSE; //readBool(PUBifs[SECT_PRINT],'listLandscape',FALSE);

 listPortrait.checked := TRUE; //readBool(PUBifs[SECT_PRINT],'listPortrait',TRUE);

 //listTopMargin.text  :='10'; //readString(PUBifs[SECT_PRINT],'listTopMargin','10');

 //listLeftMargin.text  :='10'; //readString(PUBifs[SECT_PRINT],'listLeftMargin','10');

 //listRightMargin.text := '2'; //readString(PUBifs[SECT_PRINT],'listRightMargin','2');

 //listLineSpace.text :='6'; // readString(PUBifs[SECT_PRINT],'listLineSpace','6');

 //listUseRecNo.checked :=readBool(PUBifs[SECT_PRINT],'listUseRecNo',TRUE);

 //listUseSum.checked := readBool(PUBifs[SECT_PRINT],'listUseSum',FALSE);

 //listUseUnderLines.checked := readBool(PUBifs[SECT_PRINT],'listUseUnderLines',FALSE);

 //default mode
 typFrm.userMode :=readInteger(PUBifs[SECT_SYSTEM],'mode',ALL_ACCESS_);
 accessMode.text :=intToStr(typFrm.userMode);

 //scaleM.text := '1024'; //readString(PUBifs[SECT_SYSTEM],'scaleM','1024');
 //progressFrm.setProgressText('83');

 //scaleD.text := '1024'; //readString(PUBifs[SECT_SYSTEM],'scaleD','1024');
 //progressFrm.setProgressText('84');

 refPixels.checked :=FALSE; //readBool(PUBifs[SECT_SYSTEM],'refPixels',FALSE);
// progressFrm.setProgressText('85');

 dbExt.text := readString(PUBifs[SECT_SYSTEM], 'dataBaseExtension','DB');

 init.checked := readBool(PUBifs[SECT_SYSTEM], 'init',FALSE);


  chkDbOracle.checked :=readBool(PUBifs[SECT_SYSTEM],'dbTypeOracle',TRUE);

 chkDbMSSQL.checked :=readBool(PUBifs[SECT_SYSTEM],'dbTypeMSSQL',FALSE);

 chkDbMY.checked :=readBool(PUBifs[SECT_SYSTEM],'dbTypeMySQL',FALSE);

 chkXnrkLogon.checked :=readBool(PUBifs[SECT_SYSTEM],'OracleLogon',FALSE);

 defUserName.text := readString(PUBifs[SECT_SYSTEM],'defUserName',NUL);
 defpassword.text:= readString(PUBifs[SECT_SYSTEM],'defPassWord',NUL);

 oraServerName.text :=readString(PUBifs[SECT_SYSTEM],'oraServerName',NUL);
 mssqlServerName.text :=readString(PUBifs[SECT_SYSTEM],'mssqlServerName',LOCALHOST);
 mysqlServerName.text :=readString(PUBifs[SECT_SYSTEM],'mysqlServerName',LOCALHOST);

 oraCharSet.text :=readString(PUBifs[SECT_SYSTEM],'oraCharSet','0000');

 dbSchema.text :=readString(PUBifs[SECT_SYSTEM],'dbSchema','MEDIA');


 //encrypt.mode :=MODE_DECRYPT;
 //encrypt.inString:= readString(PUBifs[SECT_SYSTEM],'defPassWord',NUL);
 //defPassWord.text :=trim(encrypt.outString);


 chkMediaLogon.checked :=readBool(PUBifs[SECT_SYSTEM],'MediaLogon',FALSE);
 mediaUserName.text:= readString(PUBifs[SECT_SYSTEM],'MediaUserName',NUL);
 mediaPassWord.text:= readString(PUBifs[SECT_SYSTEM],'MediaPassWord',NUL);

 //encrypt.mode :=MODE_DECRYPT;

 {
 chkMacLogon.checked :=readBool(PUBifs[SECT_SYSTEM],'MaconomyLogon',FALSE);

 macUserName.text:= readString(PUBifs[SECT_SYSTEM],'MaconomyUserName',NUL);
 encrypt.mode :=MODE_DECRYPT;

 encrypt.inString:= readString(PUBifs[SECT_SYSTEM],'MaconomyPassWord',NUL);
 macPassWord.text :=trim(encrypt.outString);

 chkFmLogon.checked :=readBool(PUBifs[SECT_SYSTEM],'FormulaLogon',FALSE);

 fmUserName.text:= readString(PUBifs[SECT_SYSTEM],'FormulaUserName','MACONOMY_LINK');
 encrypt.mode :=MODE_DECRYPT;

 encrypt.inString:= readString(PUBifs[SECT_SYSTEM],'FormulaPassWord',NUL);
 fmPassWord.text :=trim(encrypt.outString);

 if fmPassWord.text=NUL then
  fmPassWord.text :='link';

 chkXyLogon.checked :=readBool(PUBifs[SECT_SYSTEM],'XytechLogon',FALSE);

 xyUserName.text:= readString(PUBifs[SECT_SYSTEM],'XytechUserName','xy');
 encrypt.mode :=MODE_DECRYPT;


 encrypt.inString:= readString(PUBifs[SECT_SYSTEM],'XytechPassWord','|''');
 xyPassWord.text :=trim(encrypt.outString);

 chkRoadLogon.checked :=readBool(PUBifs[SECT_SYSTEM],'ROADlogon',FALSE);

 RoadUserName.text:= readString(PUBifs[SECT_SYSTEM],'ROADuserName','rd');
 encrypt.mode :=MODE_DECRYPT;

 encrypt.inString:= readString(PUBifs[SECT_SYSTEM],'ROADpassword','vì»');
 roadPassWord.text :=trim(encrypt.outString);

 chkPOBLogon.checked :=readBool(PUBifs[SECT_SYSTEM],'POBlogon',FALSE);

 POBuserName.text:= readString(PUBifs[SECT_SYSTEM],'POBuserName','pob');
 encrypt.mode :=MODE_DECRYPT;

 encrypt.inString:= readString(PUBifs[SECT_SYSTEM],'POBpassword','');
 POBpassWord.text :=trim(encrypt.outString);
 }

 nlsDateFormat.text :=readString(PUBifs[SECT_SYSTEM],'nlsDateFormat','dd.mm.yy');

 sqlDateFunk.text := readString(PUBifs[SECT_SYSTEM],'sqlDateFunk',NUL);


   //Ny 24.12.2002
 initYear.text := readString(PUBifs[SECT_SYSTEM],'initYear',NUL);


 {
 tabPgColor.text :=  readString(PUBifs[SECT_COLORS], 'tabPgColor','clSilver');
 grpBoxColor.text := readString(PUBifs[SECT_COLORS], 'grpBoxColor','clSilver');
 pnlBtnColor.text := readString(PUBifs[SECT_COLORS], 'pnlBtnColor','clSilver');
}
 gridColor.text :='clSilver'; //   readString(PUBifs[SECT_COLORS], 'gridColor','clSilver');

 gridFontName.text := 'Arial'; // readString(PUBifs[SECT_COLORS], 'gridFontName','Arial');

 //gridFontSize.text :='8'; //  readString(PUBifs[SECT_COLORS], 'gridFontSize','8');

 gridFontStyle.text := 'Bold'; //readString(PUBifs[SECT_COLORS], 'gridFontStyle','Normal');

 gridFontColor.text := 'clBlack'; //readString(PUBifs[SECT_COLORS], 'gridFontColor','clNavy');

 titleFontColor.text := 'clNavy'; //readString(PUBifs[SECT_COLORS], 'gridTitleFontColor','clBlack');

 gridTitleStyle.checked := TRUE; // readBool(PUBifs[SECT_COLORS], 'gridTitleStyle',FALSE);


 todoDir.text  :=readString(PUBifs[SECT_MAIL],'todoDir','.\todo');

 doneDir.text :=readString(PUBifs[SECT_MAIL],'doneDir','.\done');

 logDir.text :=readString(PUBifs[SECT_MAIL],'logDir','.\log');

 xprintDir.text  :=readString(PUBifs[SECT_MAIL],'xprintDir','C:\XNRK\XMAIL\UT');
 xprintExt.text  :=readString(PUBifs[SECT_MAIL],'xprintExt','PDF');

 pollInterval.text :=readString(PUBifs[SECT_MAIL],'pollInterval','4');
 sendInterval.text :=readString(PUBifs[SECT_MAIL],'sendInterval','1000');

 chkDeleteMail.checked :=readBool(PUBifs[SECT_MAIL],'deleteMail',TRUE);

 MailServerSMTP.text := readString(PUBifs[SECT_MAIL],'MailServerSMTP','mamime03');
 MailServerPOP3.text :=readString(PUBifs[SECT_MAIL],'MailServerPOP3','');

 MailUsername.text := readString(PUBifs[SECT_MAIL],'MailUser','');
 MailPassword.text  :=readString(PUBifs[SECT_MAIL],'MailPassword','');

 MailSender.text := readString(PUBifs[SECT_MAIL],'sender','');

 MailSource.text :=readString(PUBifs[SECT_MAIL],'source','NRK');

 MailDestination.text := readString(PUBifs[SECT_MAIL],'destination','');

 MailSubject.text := readString(PUBifs[SECT_MAIL],'subject','Overtid/komp skjema');


 daysToKeepLog.Text :=readString(PUBifs[SECT_MAIL],'daysToKeepLog','14');

 empTableName.text := readString(PUBifs[SECT_MAIL],'PersonDB','');
 empResGrp.text := readString(PUBifs[SECT_MAIL],'ResGrp','');

 chkSimulate.checked :=readBool(PUBifs[SECT_MAIL],'simmuler',TRUE);

 chkLoginSMTP.checked :=readBool(PUBifs[SECT_MAIL],'SMTP_login',FALSE);

 {
 if listPortrait.checked =TRUE then
  QRprinter.orientation :=poPortrait
 else
  QRprinter.orientation :=poLandscape;
}

 except
  //raise;
  {
  iniFil.free;
  Result :=ERROR_;
  exit;
  }
 end;  //with iniFil

 //updateSysInfo();


  end;  //if cmd=READ_


end;

//Finn maxverdi for print.bredde iflg gjeldende printer
{
if unitFrm.atoi(listMaxWidth.text) > QRprinter.pageWidth then
 listMaxWidth.text := IntToStr(QRprinter.pageWidth);

if unitFrm.atoi(listMaxHeight.text) > QRprinter.pageHeight then
 listMaxHeight.text := IntToStr(QRprinter.pageHeight);
}

 iniFil.free;

 //unitFrm.msgDlg('ini read finished',INFO_);
 //progressFrm.hide;

 screen.cursor :=crDefault;

Result :=0;
end;

procedure TiniFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

case key of
 VK_RETURN:
 begin
  perform(WM_NEXTDLGCTL,0,0);
  lnk.keyMapped :=TRUE;
 end;

end;


if (shift = [ssCtrl]) then
begin

 case key of
  VK_T:
  begin
   pgCtrlIni.selectNextPage(TRUE);
   lnk.keyMapped :=TRUE;  end;

  VK_R:
  begin
   pgCtrlIni.selectNextPage(FALSE);
   lnk.keyMapped :=TRUE;
  end;

 end;
end;


end;

procedure TiniFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin

 if lnk.keyMapped then
 begin
  lnk.keyMapped :=FALSE;
  abort;
 end;

end;

procedure TiniFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   //Lagres siste posisjon/størrelse
  iniFrm.iniWinPos(inifrm,WRITE_);

end;

procedure TiniFrm.btnSaveClick(Sender: TObject);
begin

 iniFrm.processIniFile(iniFrm.PUBsourceiniFile,WRITE_);
 close;
 
end;

procedure TiniFrm.FormShow(Sender: TObject);
begin
 iniFrm.iniWinPos(inifrm,READ_);

  if PUBsourceIniFile<>PUBiniFile then
   iniFrm.caption :=format('%s  (cached: %s)',[PUBsourceIniFile,PUBiniFile])
  else
   iniFrm.caption :=PUBsourceIniFile;

 mailUserName.Enabled := chkLoginSMTP.Checked;
 mailPassword.Enabled := chkLoginSMTP.Checked;
   
end;

procedure TiniFrm.accessModeChange(Sender: TObject);
begin
  typFrm.userMode :=unitFrm.atoi(accessMode.text);

end;

procedure TiniFrm.chkLoginSMTPClick(Sender: TObject);
begin

 mailUserName.Enabled := chkLoginSMTP.Checked;
 mailPassword.Enabled := chkLoginSMTP.Checked;

end;

initialization
  iniFrm :=Tinifrm.create(iniFrm);
  if iniFrm =nil then
   halt;

end.
