using System;
using System.Text;
using Microsoft.PointOfService;
using System.Management;

namespace EPSON_TM30
{
    public class CashDrawerManager : IDisposable
    {
        private static CashDrawer m_Drawer = null;
        private bool disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }

                Close();
                disposedValue = true;
            }
        }

        ~CashDrawerManager()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            // TODO: If the finalizer above is to be overridden, uncomment the following line.
            // GC.SuppressFinalize(this);
        }




        public CashDrawerManager()
        {
        }

        public bool Open(out string errorMsg, bool isWaited = false)
        {
            errorMsg = "";

            string strLogicalName = "CashDrawer";
            PosExplorer posExplorer = new PosExplorer();
            DeviceInfo deviceInfo = null;
            try
            {
                deviceInfo = posExplorer.GetDevice(DeviceType.CashDrawer, strLogicalName);
            }
            catch (Exception)
            {
                errorMsg = string.Format("デバイス情報の取得に失敗しました。使用できる{0}がありません。", strLogicalName);
                return false;
            }

            try
            {
                m_Drawer = (CashDrawer)posExplorer.CreateInstance(deviceInfo);
            }
            catch (Exception)
            {
                errorMsg = string.Format("{0}のインスタンス生成に失敗しました。", strLogicalName);
                return false;
            }

            try
            {
                //デバイスをオープンします。
                m_Drawer.Open();

                //オープンしたデバイスの排他権を得ます。
                //これにより他のアプリケーションからこのデバイスは使用できなくなります。
                m_Drawer.Claim(1000);

                //デバイスを使用可能（動作できる状態）にします。
                m_Drawer.DeviceEnabled = true;

                //OpenDrawerメソッドを使用して、ドロワーを開きます。
                m_Drawer.OpenDrawer();

                //ドロワーが開いている間、待ちます。
                while (m_Drawer.DrawerOpened == false)
                {
                    System.Threading.Thread.Sleep(100);
                }

                if (isWaited)
                {
                    m_Drawer.WaitForDrawerClose(10000, 2000, 100, 1000);
                }

                return true;
            }
            catch (PosControlException)
            {
                errorMsg = string.Format("{0}に接続できません。", strLogicalName);
                return false;
            }
        }



        private void Close()
        {
            if (m_Drawer != null)
            {
                try
                {
                    //デバイスを停止します。
                    m_Drawer.DeviceEnabled = false;

                    //デバイスの使用権を解除します。
                    m_Drawer.Release();
                }
                catch (PosControlException)
                {
                }
                finally
                {
                    //デバイスの使用を終了します。
                    m_Drawer.Close();
                    m_Drawer = null;
                }
            }
        }
    }
}
