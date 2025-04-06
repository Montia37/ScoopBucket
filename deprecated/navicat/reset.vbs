' 清理Navicat升级和注册信息
Set oShell = WScript.CreateObject("WScript.Shell")
sDeleteKey = "HKEY_CURRENT_USER\Software\PremiumSoft\NavicatPremium\Update"
oShell.Run "reg delete """ & sDeleteKey & """ /f", 0, True
' 删除Navicat注册信息
sDeleteKey = "HKEY_CURRENT_USER\Software\PremiumSoft\NavicatPremium\Registration"
oShell.Run "reg delete """ & sDeleteKey & """ /f", 0, True

sDeleteKey = "HKEY_CURRENT_USER\Software\Classes\CLSID"
sFilter = "Info|ShellFolder"
set oReg = GetObject("winmgmts:\\.\root\default:StdRegProv")
oReg.EnumKey HKEY_CURRENT_USER, sDeleteKey, arrSubkeys
If Not IsNull(arrSubkeys) Then
    For Each subkey In arrSubkeys
        oReg.EnumKey sDeleteKey & "\" & subkey, "", arrSubkeys2
        If Not IsNull(arrSubkeys2) Then
            For Each subkey2 In arrSubkeys2
                If InStr(subkey2, sFilter) > 0 Then
                    ' 删除Navicat文件夹与Windows资源管理器的关联
                    sDeleteKey2 = sDeleteKey & "\" & subkey & "\" & subkey2
                    oShell.Run "reg delete """ & sDeleteKey2 & """ /f", 0, True
                End If
            Next
        End If
    Next
End If
