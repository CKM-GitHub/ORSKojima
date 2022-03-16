using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Base.Client;
namespace MasterTouroku_Henkan
{
    public partial class MasterTouroku_Henkan : Base.Client.FrmMainForm
    {
        //MasterTouroku_Hanyou_BL mthbl;
        //M_Hanyou_Entity mhe;
        int type = 0; //1 = ID & Key, 2 = ID & CopyKey (for f11)
        public MasterTouroku_Henkan()
        {
            InitializeComponent();
        }

        private void MasterTouroku_Henkan_Load(object sender, EventArgs e)
        {
            InProgramID = "MasterTouroku_Henkan";

            SetFunctionLabel(EProMode.MENTE);
            StartProgram();

            //mthbl = new MasterTouroku_Hanyou_BL();

            //ScID.Focus();
            ChangeMode(EOperationMode.INSERT);
        }
        private void ChangeMode(EOperationMode OperationMode)
        {
            base.OperationMode = OperationMode;
            switch (OperationMode)
            {
                //case EOperationMode.INSERT:
                //    Clear(panel3);
                //    Clear(panelDetail);
                //    EnablePanel(panel3);
                //    DisablePanel(panelDetail);
                //    ScKey.SearchEnable = false;
                //    ScCopyKey.SearchEnable = false;
                //    F9Visible = false;
                //    F12Enable = true;
                //    BtnF11Show.Enabled = F11Enable = true;
                //    break;
                //case EOperationMode.UPDATE:
                //case EOperationMode.DELETE:
                //case EOperationMode.SHOW:
                //    Clear(panel3);
                //    Clear(panelDetail);
                //    EnablePanel(panel3);
                //    DisablePanel(panelDetail);
                //    ScKey.SearchEnable = true;
                //    ScCopyKey.Enabled = false;
                //    F12Enable = false;
                //    BtnF11Show.Enabled = F11Enable = true;
                //    break;
            }
            //ScID.SetFocus(1);
        }
    }
}
