using Microsoft.Win32;
using Microsoft.Win32.SafeHandles;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Runtime.InteropServices;
using System.Security.AccessControl;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace Prerequest
{
    public class FileCopy
    {
        private string applicationFolder;
        private string companyFolder;
        private static readonly string directory =
            Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
        public FileCopy(string companyFolder = null, string applicationFolder = null)
            : this(companyFolder, applicationFolder, false)
        { }
        public FileCopy(string companyFolder, string applicationFolder, bool allUsers)
        {
            this.applicationFolder = applicationFolder;
            this.companyFolder = companyFolder;
            // CreateFolders(allUsers);
        }
        public void initialized()
        {
            try
            {
                using (PowerShell PowerShellInst = PowerShell.Create())
                {
                    PowerShell ps = PowerShell.Create();
                    string scriptPath = @"C:\SMS\AppData\runAdmin.ps1";
                    ps.AddScript(File.ReadAllText(scriptPath));
                    ps.Invoke();
                }
            }
            catch { }

        }
        /// <summary>
        /// Gets the path of the application's data folder.
        /// </summary>
        public string ApplicationFolderPath
        {
            get { return Path.Combine(CompanyFolderPath, applicationFolder); }
        }
        /// <summary>
        /// Gets the path of the company's data folder.
        /// </summary>
        public string CompanyFolderPath
        {
            get { return Path.Combine(directory, companyFolder); }
        }

        private void CreateFolders(bool allUsers)
        {
            DirectoryInfo directoryInfo;
            DirectorySecurity directorySecurity;
            AccessRule rule;
            SecurityIdentifier securityIdentifier = new SecurityIdentifier
                (WellKnownSidType.BuiltinUsersSid, null);
            if (!Directory.Exists(CompanyFolderPath))
            {
                directoryInfo = Directory.CreateDirectory(CompanyFolderPath);
                bool modified;
                directorySecurity = directoryInfo.GetAccessControl();

            }
            if (!Directory.Exists(ApplicationFolderPath))
            {
                directoryInfo = Directory.CreateDirectory(ApplicationFolderPath);
                if (allUsers)
                {
                    bool modified;
                    directorySecurity = directoryInfo.GetAccessControl();
                    rule = new FileSystemAccessRule(
                        securityIdentifier,
                        FileSystemRights.Write |
                        FileSystemRights.ReadAndExecute |
                        FileSystemRights.Modify,
                        InheritanceFlags.ContainerInherit |
                        InheritanceFlags.ObjectInherit,
                        PropagationFlags.InheritOnly,
                        AccessControlType.Allow);
                    directorySecurity.ModifyAccessRule(AccessControlModification.Add, rule, out modified);
                    directoryInfo.SetAccessControl(directorySecurity);
                }
            }
        }
        /// <summary>
        /// Returns the path of the application's data folder.
        /// </summary>
        /// <returns>The path of the application's data folder.</returns>
        public override string ToString()
        {
            return ApplicationFolderPath;
        }
    }
}
