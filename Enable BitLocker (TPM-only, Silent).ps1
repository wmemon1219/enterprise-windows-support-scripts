# Enable BitLocker (if TPM is present)
$secure = ConvertTo-SecureString -String "YourRecoveryKeyPassword123!" -AsPlainText -Force
Enable-BitLocker -MountPoint "C:" -UsedSpaceOnly -TpmProtector -RecoveryPasswordProtector -RecoveryKeyPath "C:\BitLockerKeys\" -EncryptionMethod XtsAes256
