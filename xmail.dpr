program xmail;

uses
  Forms,
  unProcs in 'unProcs.pas',
  unMailClient in 'unMailClient.pas' {MainForm},
  mid_typs in 'mid_typs.pas' {typFrm},
  mid_units in 'mid_units.pas' {unitFrm},
  mid_date in 'mid_date.pas' {dateFrm},
  mail_ini in 'mail_ini.pas' {iniFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
