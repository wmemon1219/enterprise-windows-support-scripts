# 🛠️ Enterprise Windows Support Scripts

A curated collection of enterprise-grade support and automation scripts designed for use by system engineers, IT support, and managed service providers. These scripts were developed across large-scale environments including Amazon and MSP clients, and cover diagnostics, security, system repair, provisioning, automation, and remediation.

> 🔐 Built by: [Wahaj Memon](https://linkedin.com/in/wahaj-m-3b3555108) – Systems & Cloud Engineer | PowerShell | Intune | Networking | Automation

---

## 📂 Script Categories

### 🔐 Security & Access
- **RotateAdminPassword.cmd** – Rotates local admin credentials securely.
- **ManageBitlocker.cmd** – Multifunctional BitLocker status checker and encryption enforcer.
- **CreateDeletemeAccount.cmd** – Generates temporary local user account for troubleshooting.
- **CreateLocalAccount.cmd** – Secure creation of local user accounts.
- **CertFix.cmd** – Repairs broken or untrusted certificate chains.

---

### 🌐 Network & Connectivity
- **ResetIPStack.cmd** – Resets Windows TCP/IP stack and DNS resolver cache.
- **RefreshNetwork.bat** – Renews DHCP lease, reinitializes IP config.
- **HostPinging.cmd** – Pings a list of predefined internal/external hosts for reachability.
- **MakePeaceyourDNSWifi.cmd** – Changes DNS settings on Wi-Fi adapters.
- **GPUpdate.cmd** – Forces immediate Group Policy refresh with optional reboot.

---

### 🧰 System Diagnostics & Repair
- **SFC_and_DISM_Checks.cmd** – Runs `sfc /scannow` and DISM restore health scans.
- **TrustRelationshipFix.cmd** – Rejoins a domain-trusted system experiencing login errors.
- **ITACInstall.cmd** – Automates installation of internal IT tools (e.g., remote agents).
- **Install-3.5-Framework.cmd** – Installs .NET Framework 3.5 for legacy compatibility.
- **GetWinVer.cmd** – Retrieves and displays OS version info in clean format.
- **Eject-All-Drives.cmd** – Safely ejects all removable media (USB, drives, etc.).

---

### 🖼️ User Interface & Experience
- **Fix_Excessive_Blank_Icons_by_the_time.cmd** – Fixes missing system tray icons and UI lag.
- **Elevated_DeviceManager.cmd** – Opens Device Manager with elevation.
- **ToggleWifi.cmd** – Enables/disables Wi-Fi adapter (useful in kiosk setups).
- **Chinese_Traditional_Taiwan_Keyboard.cmd** – Installs traditional Chinese (Taiwan) keyboard layout.

---

### 📧 Outlook & Office Fixes
- **CleanOutlookRules.cmd** – Deletes all Outlook inbox rules for profile repair.
- **Outlook-Hyperlink-Fix.cmd** – Restores default browser link associations in Outlook.
- **Outlook_Policies_Fix.reg** – Applies registry-based Outlook policy repairs.

---

### ☁️ Cloud & App Cleanup
- **Remove_MS_Onedrive.cmd** – Uninstalls Microsoft OneDrive for specific environments.
- **WorkDocs_Filling_up_Your_Hard_Drive.cmd** – Addresses AWS WorkDocs sync/storage bloat.

---

### 🛠️ Administrative Tools & Automation
- **Elevate.cmd / Elevated_CMD.cmd** – Runs CMD with admin rights automatically.
- **Add_FollowYou_Printers_Deprecated.cmd** – Installs legacy “Follow-Me” print queues.
- **EnrollInBraveHearts.cmd** – Custom enrollment script (placeholder – update for internal tool).

---

## 🚀 Getting Started

1. Clone or download this repository.
2. Review each script's purpose before executing.
3. For scripts requiring admin rights, run using **Run as Administrator** or `elevate.cmd`.
4. Use caution on production devices. Test in lab environments when possible.

```bash
git clone https://github.com/YOURUSERNAME/enterprise-windows-support-scripts.git
