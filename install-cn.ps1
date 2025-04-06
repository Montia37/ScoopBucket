# 开启调试
# Set-PSDebug -Trace 1

# 需先以管理员权限打开系统自带的 Powershell，设置脚本运行权限
# Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope Currentuser

# 调整安装位置和国内 Github 镜像
$InstallDir = "D:\Apps"
$ScoopDir = "$InstallDir\Scoop"
$ScoopGlobalDir = "$InstallDir\ScoopGlobal"
$MirrorUrl = "https://mirror.ghproxy.com"


# 安装 Scoop
New-Item -ItemType "directory" -Path "$InstallDir" -Force | Out-Null
Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1" -OutFile "$InstallDir\install.ps1"
(Get-Content "$InstallDir\install.ps1" -Raw) -replace "`"https://github.com", "`"$MirrorUrl/https://github.com" | Set-Content "$InstallDir\install.ps1"
& $InstallDir\install.ps1 -ScoopDir "$ScoopDir" -ScoopGlobalDir "$ScoopGlobalDir" -NoProxy

# 将 Scoop 的仓库源替换为代理的
scoop config scoop_repo "$MirrorUrl/https://github.com/ScoopInstaller/Scoop"

# 目前没有安装 Git，所以先下载几个必需的软件的 JSON，组成一个临时的应用仓库
New-Item -ItemType "directory" -Path "$ScoopDir\buckets\scoop-cn\bucket" -Force | Out-Null
New-Item -ItemType "directory" -Path "$ScoopDir\buckets\scoop-cn\scripts\7-zip" -Force | Out-Null
New-Item -ItemType "directory" -Path "$ScoopDir\buckets\scoop-cn\scripts\git" -Force | Out-Null

Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/7zip.json" -OutFile "$ScoopDir\buckets\scoop-cn\bucket\7zip.json"
Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/install-context.reg" -OutFile "$ScoopDir\buckets\scoop-cn\scripts\7-zip\install-context.reg"
Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/7-zip/uninstall-context.reg" -OutFile "$ScoopDir\buckets\scoop-cn\scripts\7-zip\uninstall-context.reg"

Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/git.json" -OutFile "$ScoopDir\buckets\scoop-cn\bucket\git.json"
Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-context.reg" -OutFile "$ScoopDir\buckets\scoop-cn\scripts\git\install-context.reg"
Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-context.reg" -OutFile "$ScoopDir\buckets\scoop-cn\scripts\git\uninstall-context.reg"
Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/install-file-associations.reg" -OutFile "$ScoopDir\buckets\scoop-cn\scripts\git\install-file-associations.reg"
Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/scripts/git/uninstall-file-associations.reg" -OutFile "$ScoopDir\buckets\scoop-cn\scripts\git\uninstall-file-associations.reg"

# Invoke-RestMethod -Uri "$MirrorUrl/https://raw.githubusercontent.com/duzyn/scoop-cn/master/bucket/aria2.json" -OutFile "$ScoopDir\buckets\scoop-cn\bucket\aria2.json"

# 安装时注意顺序是 7-Zip, Git, Aria2
scoop install scoop-cn/7zip
scoop install scoop-cn/git
scoop install scoop-cn/aria2

# 修改 aria2 默认参数
scoop config aria2-retry-wait 4  # 重试等待秒数
scoop config aria2-split 8  # 单任务最大连接数
scoop config aria2-max-connection-per-server 8  # 单服务器最大连接数
scoop config aria2-min-split-size 4M  # 最小文件分片大小
Write-Host "7-Zip, Git and Aria2 was installed successfully!" -ForegroundColor green

# scoop-cn 库还不是 Git 仓库，删掉后，重新添加 Git 仓库
if (Test-Path -Path "$ScoopDir\buckets\scoop-cn") {
    scoop bucket rm scoop-cn
}
Write-Host "Adding scoop-cn bucket..." -ForegroundColor green
scoop bucket add scoop-cn "$MirrorUrl/https://github.com/duzyn/scoop-cn"

# 删除 Scoop 的 main 仓库
if (Test-Path -Path "$ScoopDir\buckets\main") {
    scoop bucket rm main
}

# Set-Location "$ScoopDir\buckets\scoop-cn"
# git config pull.rebase true

Write-Host "scoop and scoop-cn was installed successfully!" -ForegroundColor green
