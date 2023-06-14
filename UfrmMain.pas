unit UfrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Buttons, ExtCtrls,IniFiles,StrUtils, Grids,
  DBGrids, StdCtrls, DB, MemDS, DBAccess, dbcgrids, Mask, DBCtrls,
  DosMove, Menus, Uni;

//==Ϊ��ͨ��������Ϣ����������״̬��������==//
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
    //==Ϊ��ͨ��������Ϣ����������״̬��������==//
    procedure WMUpdateTextStatus(var message:twmupdatetextstatus);  {WM_UPDATETEXTSTATUS��Ϣ������}
                                              message WM_UPDATETEXTSTATUS;
    procedure updatestatusBar(const text:string);//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
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

  LoadGroupName(ComboBox1,'select name from commcode where typename=''���'' ');
  LoadGroupName(ComboBox2,'select name from commcode where typename=''�ű�'' ');
  LoadGroupName(ComboBox3,'select concat(''['',unid,'']'',name) from commcode where typename=''����'' ');//���ز���
  LoadDocListName;

  UpdateMyQuery2;

  ReadConfig;
  UpdateStatusBar(#$2+'0:'+SYSNAME);
  UpdateStatusBar(#$2+'6:'+SCSYDW);
  UpdateStatusBar(#$2+'8:'+g_Server);
  UpdateStatusBar(#$2+'10:'+g_Database);

  TimerIdleTracker.Enabled:=true;//TimerIdleTrackerTimer�¼������õ������ļ�����LoginTime
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
  //��ϵͳ����
  SCSYDW:=ScalarSQLCmd(HisConn,'select Name from commcode where TypeName=''ϵͳ����'' and ReMark=''��Ȩʹ�õ�λ'' ');
  if SCSYDW='' then SCSYDW:='2F3A054F64394BBBE3D81033FDE12313';//'δ��Ȩ��λ'���ܺ���ַ���
  //======����SCSYDW
  pInStr:=pchar(SCSYDW);
  pDeStr:=DeCryptStr(pInStr,Pchar(CryptStr));
  setlength(SCSYDW,length(pDeStr));
  for i :=1  to length(pDeStr) do SCSYDW[i]:=pDeStr[i-1];
  //==========

  CONFIGINI:=TINIFILE.Create(ChangeFileExt(Application.ExeName,'.ini'));

  ifAutoCheck:=configini.ReadBool('ѡ��','��ӡ����ʱ�Զ����',false);
  LoginTime:=configini.ReadInteger('ѡ��','������¼���ڵ�ʱ��',30);

  configini.Free;
end;

procedure TfrmMain.updatestatusBar(const text: string);
//TextΪ�ø�ʽ#$2+'0:abc'+#$2+'1:def'��ʾ״̬����0����ʾabc,��1����ʾdef,��������
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
  if LabeledEdit8.Text='' then exit;//����Ψһ���Ϊ��
  if LabeledEdit1.Text='' then exit;//��������Ϊ��
  if ComboBox4.Text='' then exit;//��������Ϊ��

  Unid_TreatMaster:=InsertTreatMaster(PChar(HisConn),strtoint(LabeledEdit8.Text),PChar(ComboBox4.Text),PChar(copy(ComboBox3.Text,pos(']',ComboBox3.Text)+1,MaxInt)),'register',DateTimePicker1.DateTime,PChar(ComboBox1.Text),PChar(ComboBox2.Text),PChar(operator_name));

  MyQuery2.Refresh;
  MyQuery2.Locate('unid',Unid_TreatMaster,[loCaseInsensitive]);

  MESSAGEDLG('�Һ����!',mtInformation,[mbOK],0);
end;

procedure TfrmMain.UpdateMyQuery2;
begin
  MyQuery2.Close;
  MyQuery2.SQL.Clear;
  MyQuery2.SQL.Text:='select register_treat_date as ��������,operator as ҽ��,department as �Ʊ�,patient_name as ����,patient_sex as �Ա�,patient_age AS ����,'+
                     'register_morning_afternoon as ���,register_no_type as �ű�,'+
                     'certificate_type as ֤������,certificate_num as ֤������,'+
                     'clinic_card_num as ���ƿ���,health_care_num as ҽ������,address as סַ,work_company as ������λ,work_address as ������ַ,'+
                     'if_marry as ���,native_place as ����,telephone as ��ϵ�绰,remark as ��ע,patient_unid,unid,creat_date_time,register_operator,audit_doctor,audit_date '+
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

  if aJson.N['method'].AsString='selected' then//��ʾ˫������
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

  dbgrid2.Columns.Items[0].Width:=72;//��������
  dbgrid2.Columns.Items[1].Width:=42;//ҽ��
  dbgrid2.Columns.Items[2].Width:=42;//�Ʊ�
  dbgrid2.Columns.Items[3].Width:=42;//����
  dbgrid2.Columns.Items[4].Width:=30;//�Ա�
  dbgrid2.Columns.Items[5].Width:=30;//����
  dbgrid2.Columns.Items[6].Width:=30;//���
  dbgrid2.Columns.Items[7].Width:=42;//�ű�
  dbgrid2.Columns.Items[8].Width:=55;//֤������
  dbgrid2.Columns.Items[9].Width:=130;//֤������
  dbgrid2.Columns.Items[10].Width:=130;//���ƿ���
  dbgrid2.Columns.Items[11].Width:=130;//ҽ������
  dbgrid2.Columns.Items[12].Width:=120;//סַ
  dbgrid2.Columns.Items[13].Width:=120;//������λ
  dbgrid2.Columns.Items[14].Width:=120;//������ַ
  dbgrid2.Columns.Items[15].Width:=42;//���
  dbgrid2.Columns.Items[16].Width:=55;//����
  dbgrid2.Columns.Items[17].Width:=80;//��ϵ�绰
  dbgrid2.Columns.Items[18].Width:=100;//��ע
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
    LoadGroupName(ComboBox4,'select w.name from worker w LEFT join commcode cc on cc.TypeName=''����'' and cc.unid=w.dep_unid ');
    exit;
  end;

  i:=pos(']',s1);
  s2:=copy(s1,2,i-2);

  if not trystrtoint(s2,j) then
  begin
    MESSAGEDLG('���Ž�������!',mtError,[mbOK],0);
    exit;
  end;

  LoadGroupName(ComboBox4,'select w.name from worker w LEFT join commcode cc on cc.TypeName=''����'' and cc.unid=w.dep_unid where w.dep_unid='+s2);
end;

procedure TfrmMain.N1Click(Sender: TObject);
begin
  if not MyQuery2.Active then exit;
  if MyQuery2.RecordCount=0 then exit;

  if '1'=ScalarSQLCmd(HisConn,'select 1 from treat_slave where tm_unid='+MyQuery2.fieldbyname('unid').AsString+' limit 1') then
  begin
    MESSAGEDLG('�������Ƽ�¼,������ɾ��!',mtError,[mbOK],0);
    exit;
  end;

  if (MessageDlg('ȷʵҪɾ���ùҺż�¼��',mtWarning,[mbYes,mbNo],0)<>mrYes) then exit;

  MyQuery2.Delete;
end;

procedure TfrmMain.N3Click(Sender: TObject);
begin
  MyQuery2.Refresh;
end;

end.
