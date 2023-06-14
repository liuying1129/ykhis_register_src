unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Buttons, ExtCtrls,IniFiles,StrUtils, Grids,
  DBGrids, StdCtrls, DB, MemDS, DBAccess, dbcgrids, Mask, DBCtrls,
  DosMove, Menus, Uni;

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
    TimerIdleTracker: TTimer;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    BitBtn1: TBitBtn;
    DataSource2: TDataSource;
    MyQuery2: TUniQuery;
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    BitBtn2: TBitBtn;
    DosMove1: TDosMove;
    ComboBox1: TComboBox;
    Label2: TLabel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    ComboBox3: TComboBox;
    Label4: TLabel;
    ComboBox4: TComboBox;
    Label5: TLabel;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure MyQuery2AfterOpen(DataSet: TDataSet);
    procedure ComboBox3Change(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
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
    procedure LoadDocListName;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses UfrmLogin, UDM, superobject;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  MyQuery2.Connection:=DM.MyConnection1;

  DateTimePicker1.MinDate:=date();
  DateTimePicker1.Date:=date();
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  frmLogin.ShowModal;

  LoadGroupName(ComboBox1,'select name from commcode where typename=''午别'' ');
  LoadGroupName(ComboBox2,'select name from commcode where typename=''号别'' ');
  LoadGroupName(ComboBox3,'select concat(''['',unid,'']'',name) from commcode where typename=''部门'' ');//加载部门
  LoadDocListName;

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
  SCSYDW:=ScalarSQLCmd(HisConn,'select Name from commcode where TypeName=''系统代码'' and ReMark=''授权使用单位'' ');
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

procedure TfrmMain.BitBtn1Click(Sender: TObject);
var
  Unid_TreatMaster:integer;
begin
  if LabeledEdit8.Text='' then exit;//患者唯一编号为空
  if LabeledEdit1.Text='' then exit;//患者姓名为空
  if ComboBox4.Text='' then exit;//患者姓名为空

  Unid_TreatMaster:=InsertTreatMaster(PChar(HisConn),strtoint(LabeledEdit8.Text),PChar(ComboBox4.Text),PChar(copy(ComboBox3.Text,pos(']',ComboBox3.Text)+1,MaxInt)),'register',DateTimePicker1.DateTime,PChar(ComboBox1.Text),PChar(ComboBox2.Text),PChar(operator_name));

  MyQuery2.Refresh;
  MyQuery2.Locate('unid',Unid_TreatMaster,[loCaseInsensitive]);

  MESSAGEDLG('挂号完成!',mtInformation,[mbOK],0);
end;

procedure TfrmMain.UpdateMyQuery2;
begin
  MyQuery2.Close;
  MyQuery2.SQL.Clear;
  MyQuery2.SQL.Text:='select register_treat_date as 看诊日期,operator as 医生,department as 科别,patient_name as 姓名,patient_sex as 性别,patient_age AS 年龄,'+
                     'register_morning_afternoon as 午别,register_no_type as 号别,'+
                     'certificate_type as 证件类型,certificate_num as 证件号码,'+
                     'clinic_card_num as 诊疗卡号,health_care_num as 医保卡号,address as 住址,work_company as 工作单位,work_address as 工作地址,'+
                     'if_marry as 婚否,native_place as 籍贯,telephone as 联系电话,remark as 备注,patient_unid,unid,creat_date_time,register_operator,audit_doctor,audit_date '+
                     ' from treat_master '+
                     ' where register_src=''register'' and register_treat_date>=curdate() order by register_treat_date,operator,register_morning_afternoon';
  MyQuery2.Open;
end;

procedure TfrmMain.BitBtn2Click(Sender: TObject);
var
  p1:PChar;
  s1:String;
  aJson:ISuperObject;
  patient_unid:String;
  adotemp11:TUniQuery;
begin
  p1:=ShowPatientForm(Application.Handle,PChar(HisConn),PChar(operator_name),PChar(operator_dep_name));
  s1:=StrPas(p1);

  aJson:=SO(s1);

  if not aJson.N['success'].AsBoolean then exit;

  if aJson.N['method'].AsString='selected' then//表示双击病人
  begin
    patient_unid:=aJson.N['patient_unid'].AsString;

    adotemp11:=TUniQuery.Create(nil);
    adotemp11.Connection:=DM.MyConnection1;
    adotemp11.Close;
    adotemp11.SQL.Clear;
    adotemp11.SQL.Text:='select * from patient_info '+
                       ' where unid='+patient_unid;
    adotemp11.Open;

    LabeledEdit1.Text:=adotemp11.fieldbyname('patient_name').AsString;
    LabeledEdit6.Text:=adotemp11.fieldbyname('patient_sex').AsString;
    LabeledEdit7.Text:=adotemp11.fieldbyname('patient_birthday').AsString;
    LabeledEdit8.Text:=adotemp11.fieldbyname('unid').AsString;
    adotemp11.Free;
  end;
end;

procedure TfrmMain.MyQuery2AfterOpen(DataSet: TDataSet);
begin
  if not DataSet.Active then exit;

  dbgrid2.Columns.Items[0].Width:=72;//看诊日期
  dbgrid2.Columns.Items[1].Width:=42;//医生
  dbgrid2.Columns.Items[2].Width:=42;//科别
  dbgrid2.Columns.Items[3].Width:=42;//姓名
  dbgrid2.Columns.Items[4].Width:=30;//性别
  dbgrid2.Columns.Items[5].Width:=30;//年龄
  dbgrid2.Columns.Items[6].Width:=30;//午别
  dbgrid2.Columns.Items[7].Width:=42;//号别
  dbgrid2.Columns.Items[8].Width:=55;//证件类型
  dbgrid2.Columns.Items[9].Width:=130;//证件号码
  dbgrid2.Columns.Items[10].Width:=130;//诊疗卡号
  dbgrid2.Columns.Items[11].Width:=130;//医保卡号
  dbgrid2.Columns.Items[12].Width:=120;//住址
  dbgrid2.Columns.Items[13].Width:=120;//工作单位
  dbgrid2.Columns.Items[14].Width:=120;//工作地址
  dbgrid2.Columns.Items[15].Width:=42;//婚否
  dbgrid2.Columns.Items[16].Width:=55;//籍贯
  dbgrid2.Columns.Items[17].Width:=80;//联系电话
  dbgrid2.Columns.Items[18].Width:=100;//备注
end;

procedure TfrmMain.ComboBox3Change(Sender: TObject);
begin
  LoadDocListName;
end;

procedure TfrmMain.LoadDocListName;
var
  s1,s2:string;
  i,j:integer;
begin
  s1:=ComboBox3.Text;

  if trim(s1)='' then
  begin
    LoadGroupName(ComboBox4,'select w.name from worker w LEFT join commcode cc on cc.TypeName=''部门'' and cc.unid=w.dep_unid ');
    exit;
  end;

  i:=pos(']',s1);
  s2:=copy(s1,2,i-2);

  if not trystrtoint(s2,j) then
  begin
    MESSAGEDLG('部门解析出错!',mtError,[mbOK],0);
    exit;
  end;

  LoadGroupName(ComboBox4,'select w.name from worker w LEFT join commcode cc on cc.TypeName=''部门'' and cc.unid=w.dep_unid where w.dep_unid='+s2);
end;

procedure TfrmMain.N1Click(Sender: TObject);
begin
  if not MyQuery2.Active then exit;
  if MyQuery2.RecordCount=0 then exit;

  if '1'=ScalarSQLCmd(HisConn,'select 1 from treat_slave where tm_unid='+MyQuery2.fieldbyname('unid').AsString+' limit 1') then
  begin
    MESSAGEDLG('存在诊疗记录,不允许删号!',mtError,[mbOK],0);
    exit;
  end;

  if (MessageDlg('确实要删除该挂号记录吗？',mtWarning,[mbYes,mbNo],0)<>mrYes) then exit;

  MyQuery2.Delete;
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
  MyQuery2.Refresh;
end;

end.
