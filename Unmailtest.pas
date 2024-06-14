unit Unmailtest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdSMTP, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdPOP3, Buttons, StdCtrls, IdMessage,
  IdCoder, IdCoder3To4;

type
  TForm1 = class(TForm)
    IdPOP31: TIdPOP3;
    IdSMTP1: TIdSMTP;
    Memo1: TMemo;
    SpeedButton1: TSpeedButton;
    IdMessage1: TIdMessage;
    procedure SpeedButton1Click(Sender: TObject);
    procedure IdSMTP1Connected(Sender: TObject);
    procedure IdSMTP1Disconnected(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SpeedButton1Click(Sender: TObject);
  var
    atm : TIdAttachment;
  begin
  IdMessage1.Body.clear;
  IdMessage1.Body.add('Test fra Kjells program den: '+datetimetostr(now));
{  IdMessage1.Recipients[0].Address:='NordiskTeksttv@nrk.no';
  IdMessage1.Recipients.Add;
  IdMessage1.Recipients[1].Address:='kjell.norberg@nrk.no';
  IdMessage1.Recipients.Add;}
  IdMessage1.Recipients[0].Address:='kjnorb@frisurf.no';
  IdMessage1.Recipients[0].Address:='NordiskTeksttv@nrk.no';
  with IdMessage1.MessageParts do
    begin
    atm:=TidAttachment.Create(IdMessage1.MessageParts);
    atm.FileName:='NRKDR1.ttv';
    atm.ContentTransfer :='base64';
    end;
  IdSMTP1.Connect;
  IdSMTP1.send(IdMessage1);
  IdSMTP1.DisConnect;
  with IdMessage1.MessageParts do
    begin
    atm.Free;
    end;
  end;

procedure TForm1.IdSMTP1Connected(Sender: TObject);
  begin
  memo1.lines.add(timetostr(time)+' Connected');
  end;

procedure TForm1.IdSMTP1Disconnected(Sender: TObject);
  begin
  memo1.lines.add(timetostr(time)+' DisConnect');
  end;

end.
