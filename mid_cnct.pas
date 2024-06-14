unit mid_cnct;

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
  StdCtrls,
  ExtCtrls;

type
  TcnctFrm = class(TForm)
    pnlCnct: TPanel;
    srvinfo: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  cnctFrm: TcnctFrm;

implementation

{$R *.dfm}

end.
