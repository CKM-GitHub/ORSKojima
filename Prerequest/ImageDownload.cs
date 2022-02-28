using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Prerequest {
    public class ImageDownload {

        public void ImageDown()
        {
            string path = "http://localhost/Image/flag.txt";
            string contents = "";
            string url1 = "http://localhost/Image/H_Logo.png";
            string url2 = "http://localhost/Image/S_Logo.png";
            string url3 = "http://localhost/Image/T_Logo.png";
            string url4 = "http://localhost/Image/C_Logo.png";


            bool fExists = Directory.Exists(@"C:\SMS\AppData\Portfolio\");
            if (!fExists)
                Directory.CreateDirectory(@"C:\SMS\AppData\Portfolio\");          

            using (WebClient webClient = new WebClient())
            {
                using (Stream stream = webClient.OpenRead(path))
                {
                    using (StreamReader sr = new StreamReader(stream, Encoding.UTF8))
                    {
                        contents = sr.ReadToEnd();
                        if (contents == "1")
                        {
                            if (CheckUrlExists(url1))
                            {
                                string path1 = @"C:\SMS\AppData\Portfolio\" + "H_Logo.png";
                                webClient.DownloadFile(url1, path1);
                            }
                            if (CheckUrlExists(url2))
                            {
                                string path2 = @"C:\SMS\AppData\Portfolio\" + "S_Logo.png";
                                webClient.DownloadFile(url1, path2);
                            }
                            if (CheckUrlExists(url3))
                            {
                                string path3 = @"C:\SMS\AppData\Portfolio\" + "T_Logo.png";
                                webClient.DownloadFile(url1, path3);
                            }
                            if (CheckUrlExists(url4))
                            {
                                string path4 = @"C:\SMS\AppData\Portfolio\" + "C_Logo.png";
                                webClient.DownloadFile(url1, path4);
                            }
                        }                   
                    }
                }
                
            }
        }
        protected bool CheckUrlExists(string url)
        {
            try
            {
                var request = WebRequest.Create(url) as HttpWebRequest;
                request.Method = "HEAD";
                using (var response = (HttpWebResponse)request.GetResponse())
                {
                    return response.StatusCode == HttpStatusCode.OK;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}
