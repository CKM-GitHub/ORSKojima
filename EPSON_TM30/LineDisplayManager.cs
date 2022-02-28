using System;
using System.Text;
using Microsoft.PointOfService;
using System.Management;

namespace EPSON_TM30
{
    public class LineDisplayManager : IDisposable
    {
        private static LineDisplay m_Display = null;
        private bool disposedValue = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                }

                ClearDisplay(false);
                Close();
                disposedValue = true;
            }
        }

        ~LineDisplayManager()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            // TODO: If the finalizer above is to be overridden, uncomment the following line.
            // GC.SuppressFinalize(this);
        }



        public LineDisplayManager()
        {
        }

        public bool Open(out string errorMsg)
        {
            errorMsg = "";

            string strLogicalName = "LineDisplay";
            PosExplorer posExplorer = new PosExplorer();
            DeviceInfo deviceInfo = null;
            try
            {
                deviceInfo = posExplorer.GetDevice(DeviceType.LineDisplay, strLogicalName);
            }
            catch (Exception)
            {
                errorMsg = string.Format("デバイス情報の取得に失敗しました。使用できる{0}がありません。", strLogicalName);
                return false;
            }

            try
            {
                m_Display = (LineDisplay)posExplorer.CreateInstance(deviceInfo);
            }
            catch (Exception)
            {
                errorMsg = string.Format("{0}のインスタンス生成に失敗しました。", strLogicalName);
                return false;
            }

            try
            {
                //デバイスを オープンします。
                m_Display.Open();

                //オープンしたデバイスの排他権を得ます。
                //これにより他のアプリケーションからこのデバイスは使用できなくなります。
                m_Display.Claim(1000);

                //電源監視をサポートしていれば、電源通知機能を有効にします。
                if (m_Display.CapPowerReporting != PowerReporting.None)
                {
                    m_Display.PowerNotify = PowerNotification.Enabled;
                }

                //デバイスを使用可能（動作できる状態）にします。
                m_Display.DeviceEnabled = true;

                //半角カナを表示する為に、ページコードを932（日本語）に設定します。
                m_Display.CharacterSet = 932;

                return true;
            }
            catch (PosControlException ex)
            {
                errorMsg = string.Format("{0}に接続できません。", strLogicalName);
                return false;
            }
        }

        public void DisplayMarquee(string text)
        {
            if (!EnablingDevice()) return;
            if (!ClearDisplay(false)) return;

            try
            {
                int width = Encoding.GetEncoding(932).GetByteCount(text);
                m_Display.CreateWindow(1, 0, 1, 20, 1, width);

                //MarqueeFormatがDisplayMarqueeFormat.Walkの時、選択したMarquee方向の逆側から、一文字ずつ文字を表示させます。
                //Marqueeの方向はMarqueeTypeで設定されます。
                m_Display.MarqueeFormat = DisplayMarqueeFormat.Walk;

                //MarqueeTypeがDisplayMarqueeType.Initの時、DisplayTextで指定された表示データはマーキー文字列として保存されます。
                m_Display.MarqueeType = DisplayMarqueeType.Init;

                //最後の文字データを表示してから、次の最初の文字データが表示されるまで１秒かかります。
                m_Display.MarqueeRepeatWait = 1000;

                //文字の表示間隔を0.1秒に設定します。
                m_Display.MarqueeUnitWait = 100;

                m_Display.DisplayText(text, DisplayTextMode.Normal);

                //MarqueeTypeの方向を設定します。例えば、左・右・下・上などです。
                m_Display.MarqueeType = DisplayMarqueeType.Left;
            }
            catch (PosControlException)
            {
            }
        }

        public void DisplayText(string upperRowText, string lowerRowText, bool isHoldDevice = true)
        {
            if (!EnablingDevice()) return;
            if (!ClearDisplay(false)) return;

            try
            {
                int len1 = Encoding.GetEncoding(932).GetByteCount(upperRowText);
                int len2 = Encoding.GetEncoding(932).GetByteCount(lowerRowText);
                m_Display.DisplayTextAt(0, (m_Display.Columns - len1), upperRowText, DisplayTextMode.Normal);
                m_Display.DisplayTextAt(1, (m_Display.Columns - len2), lowerRowText, DisplayTextMode.Normal);

                if (!isHoldDevice)
                {
                    m_Display.Release();
                }
            }
            catch (PosControlException)
            {
            }
        }

        public void ClearDisplay()
        {
            ClearDisplay(true);
        }



        private bool EnablingDevice()
        {
            if (m_Display == null) return false;

            if (!m_Display.Claimed)
            {
                try
                {
                    m_Display.Claim(1000);
                    m_Display.DeviceEnabled = true;
                }
                catch (PosControlException)
                {
                    return false;
                }
            }
            return true;
        }

        private bool ClearDisplay(bool isForce)
        {
            if (m_Display == null) return false;

            if (isForce)
            {
                EnablingDevice();
            }

            if (m_Display.Claimed)
            {
                try
                {
                    if (m_Display.MarqueeType != DisplayMarqueeType.None)
                    {
                        m_Display.MarqueeType = DisplayMarqueeType.None;
                        m_Display.DestroyWindow();
                    }
                    m_Display.ClearText();
                }
                catch (PosControlException)
                {
                    return false;
                }
            }
            return true;
        }

        private void Close()
        {
            if (m_Display != null)
            {
                try
                {
                    //デバイスを停止します。
                    m_Display.DeviceEnabled = false;

                    //デバイスの使用権を解除します。
                    m_Display.Release();
                }
                catch (PosControlException)
                {
                }
                finally
                {
                    //デバイスの使用を終了します。
                    m_Display.Close();
                    m_Display = null;
                }
            }
        }
    }
}
