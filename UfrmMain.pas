unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Buttons, ExtCtrls,IniFiles,StrUtils, Grids,
  DBGrids, StdCtrls, DB, MemDS, DBAccess, MyAccess, dbcgrids, Mask, DBCtrls;

//==为了通过发送消息更新主窗体状态栏而增加==//
const
  WM_UPDATETEXTSTATUS=WM_USER+1;
TYPE
  TWMUpdateTextStatus=TWMSetText;
//=========================================//

type
  TfrmMain = class(TForm)
    StatusBar1: TStatusBar;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    SpeedButton1: TSpeedButton;
    ToolButton1: TToolButton;
    TimerIdleTracker: TTimer;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    DBGrid1: TDBGrid;
    MyQuery1: TMyQuery;
    DataSource1: TDataSource;
    BitBtn1: TBitBtn;
    DataSource2: TDataSource;
    MyQuery2: TMyQuery;
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    //==为了通过发送消息更新主窗体状态栏而增加==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS消息处理函数}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
    //==========================================//
    procedure ReadIni;
    procedure ReadConfig;
    procedure UpdateMyQuery2;
    function InsertTreatMaster(const APatient_Unid:integer):integer;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses UfrmLogin, UDM, superobject;

{$R *.dfm}

procedure TfrmMain.FormShow(Sender: TObject);
begin
  frmLogin.ShowModal;

  UpdateMyQuery2;

  ReadConfig;
  UpdateStatusBar(#$2+'0:'+SYSNAME);
  UpdateStatusBar(#$2+'6:'+SCSYDW);
  UpdateStatusBar(#$2+'8:'+g_Server);
  UpdateStatusBar(#$2+'10:'+g_Database);

  TimerIdleTracker.Enabled:=true;//TimerIdleTrackerTimer事件中需用到配置文件变量LoginTime
end;

procedure TfrmMain.ReadConfig;
begin
  ReadIni();
end;

procedure TfrmMain.ReadIni;
var
  configini:tinifile;

  pInStr,pDeStr:Pchar;
  i:integer;
begin
  //读系统代码
  SCSYDW:=ScalarSQLCmd(g_Server,g_Port,g_Database,g_Username,g_Password,'select Name from commcode where TypeName=''系统代码'' and ReMark=''授权使用单位'' ');
  if SCSYDW='' then SCSYDW:='2F3A054F64394BBBE3D81033FDE12313';//'未授权单位'加密后的字符串
  //======解密SCSYDW
  pInStr:=pchar(SCSYDW);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(SCSYDW,length(pDeStr));
  for i :=1  to length(pDeStr) do SCSYDW[i]:=pDeStr[i-1];
  //==========

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  ifAutoCheck:=configini.ReadBool('选项','打印处方时自动审核',false);
  LoginTime:=configini.ReadInteger('选项','弹出登录窗口的时间',30);

  configini.Free;
end;

procedure TfrmMain.updatestatusBar(const text: string);
//Text为该格式#$2+'0:abc'+#$2+'1:def'表示状态栏第0格显示abc,第1格显示def,依此类推
var
  i,J2Pos,J2Len,TextLen,j:integer;
  tmpText:string;
begin
  TextLen:=length(text);
  for i :=0 to StatusBar1.Panels.Count-1 do
  begin
    J2Pos:=pos(#$2+inttostr(i)+':',text);
    J2Len:=length(#$2+inttostr(i)+':');
    if J2Pos<>0 then
    begin
      tmpText:=text;
      tmpText:=copy(tmpText,J2Pos+J2Len,TextLen-J2Pos-J2Len+1);
      j:=pos(#$2,tmpText);
      if j<>0 then tmpText:=leftstr(tmpText,j-1);
      StatusBar1.Panels[i].Text:=tmpText;
    end;
  end;
end;

procedure TfrmMain.WMUpdateTextStatus(var message: twmupdatetextstatus);
begin
  UpdateStatusBar(pchar(message.Text));
  message.Result:=-1;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
var
  p1:PChar;
  s1:String;
  aJson:ISuperObject;
  Unid_TreatMaster:integer;
  patient_unid:String;
begin
  p1:=ShowPatientForm(Application.Handle,PChar(g_Server),g_Port,PChar(g_Database),PChar(g_Username),PChar(g_Password),PChar(operator_name),PChar(operator_dep_name));
  s1:=StrPas(p1);

  aJson:=SO(s1);

  if not aJson.N['success'].AsBoolean then exit;

  if aJson.N['method'].AsString='selected' then//表示双击病人
  begin
    patient_unid:=aJson.N['patient_unid'].AsString;

    MyQuery1.Close;
    MyQuery1.SQL.Clear;
    MyQuery1.SQL.Text:='select * from patient_info '+
                       ' where unid='+patient_unid;
    MyQuery1.Open;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MyQuery1.Connection:=DM.MyConnection1;
  MyQuery2.Connection:=DM.MyConnection1;
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
  if not MyQuery1.Active then exit;
  if MyQuery1.RecordCount<>1 then exit;
  
  InsertTreatMaster(MyQuery1.fieldbyname('unid').AsInteger);

  MyQuery2.Refresh;
end;

procedure TfrmMain.UpdateMyQuery2;
begin
  MyQuery2.Close;
  MyQuery2.SQL.Clear;
  MyQuery2.SQL.Text:='select * from treat_master '+
                     ' where register_src=''register'' and creat_date_time>curdate() order by creat_date_time';
  MyQuery2.Open;
end;

function TfrmMain.InsertTreatMaster(const APatient_Unid: integer): integer;
var
  adotemp11,adotemp22:TMyQuery;
  sqlstr:string;
begin
  Result:=-1;
  
  adotemp22:=TMyQuery.Create(nil);
  adotemp22.Connection:=DM.MyConnection1;
  adotemp22.Close;
  adotemp22.SQL.Clear;
  adotemp22.SQL.Text:='select TIMESTAMPDIFF(YEAR,patient_birthday,CURDATE()) as patient_age,pi.* from patient_info pi where unid='+inttostr(APatient_Unid);
  adotemp22.Open;
  if adotemp22.RecordCount<>1 then begin adotemp22.Free;exit;end;

  adotemp11:=TMyQuery.Create(nil);
  adotemp11.Connection:=DM.MyConnection1;

  sqlstr:='Insert into treat_master ('+
                      ' patient_unid, patient_name, patient_sex, patient_age, certificate_type, certificate_num, clinic_card_num, health_care_num, address, work_company, work_address, if_marry, native_place, telephone, operator, department,'+
                      ' register_src, register_treat_date, register_morning_afternoon, register_no_type, register_operator) values ('+
                      ':patient_unid,:patient_name,:patient_sex,:patient_age,:certificate_type,:certificate_num,:clinic_card_num,:health_care_num,:address,:work_company,:work_address,:if_marry,:native_place,:telephone,:operator,:department,'+
                      ':register_src,:register_treat_date,:register_morning_afternoon,:register_no_type,:register_operator) ';
  adotemp11.Close;
  adotemp11.SQL.Clear;
  adotemp11.SQL.Add(sqlstr);
  //执行多条MySQL语句，要用分号分隔
  adotemp11.SQL.Add('; SELECT LAST_INSERT_ID() AS Insert_Identity ');
  adotemp11.ParamByName('patient_unid').Value:=APatient_Unid;
  adotemp11.ParamByName('patient_name').Value:=adotemp22.fieldbyname('patient_name').AsString;
  adotemp11.ParamByName('patient_sex').Value:=adotemp22.fieldbyname('patient_sex').AsString;
  adotemp11.ParamByName('patient_age').Value:=adotemp22.fieldbyname('patient_age').AsString;
  adotemp11.ParamByName('certificate_type').Value:=adotemp22.fieldbyname('certificate_type').AsString;
  adotemp11.ParamByName('certificate_num').Value:=adotemp22.fieldbyname('certificate_num').AsString;
  adotemp11.ParamByName('clinic_card_num').Value:=adotemp22.fieldbyname('clinic_card_num').AsString;
  adotemp11.ParamByName('health_care_num').Value:=adotemp22.fieldbyname('health_care_num').AsString;
  adotemp11.ParamByName('address').Value:=adotemp22.fieldbyname('address').AsString;
  adotemp11.ParamByName('work_company').Value:=adotemp22.fieldbyname('work_company').AsString;
  adotemp11.ParamByName('work_address').Value:=adotemp22.fieldbyname('work_address').AsString;
  adotemp11.ParamByName('if_marry').Value:=adotemp22.fieldbyname('if_marry').AsString;
  adotemp11.ParamByName('native_place').Value:=adotemp22.fieldbyname('native_place').AsString;
  adotemp11.ParamByName('telephone').Value:=adotemp22.fieldbyname('telephone').AsString;
  adotemp11.ParamByName('operator').Value:=LabeledEdit5.Text;
  adotemp11.ParamByName('department').Value:=LabeledEdit4.Text;
  adotemp11.ParamByName('register_src').Value:='register';
  adotemp11.ParamByName('register_treat_date').Value:=DateTimePicker1.Date;
  adotemp11.ParamByName('register_morning_afternoon').Value:=LabeledEdit2.Text;
  adotemp11.ParamByName('register_no_type').Value:=LabeledEdit3.Text;
  adotemp11.ParamByName('register_operator').Value:=operator_name;
  try
    adotemp11.ExecSQL;
  except
    on E:Exception do
    begin
      adotemp11.Free;
      adotemp22.Free;
      MESSAGEDLG('挂号失败!'+E.Message,mtError,[mbOK],0);
      exit;
    end;
  end;

  Result:=adotemp11.fieldbyname('Insert_Identity').AsInteger;
  adotemp11.Free;

  adotemp22.Free;
end;

end.
