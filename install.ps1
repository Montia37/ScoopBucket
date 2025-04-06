# 开启调试
# Set-PSDebug -Trace 1

# 需先以管理员权限打开系统自带的 Powershell，设置脚本运行权限
# Set-Executionpolicy -ExecutionPolicy RemoteSigned -Scope Currentuser

# 调整安装位置
$InstallDir = "D:\Apps"
$ScoopDir = "$InstallDir\Scoop"
$ScoopGlobalDir = "$InstallDir\ScoopGlobal"


# 安装 Scoop
New-Item -ItemType "directory" -Path "$InstallDir" -Force | Out-Null
Invoke-RestMethod -Uri "https://raw.githubusercontent.com/scoopinstaller/install/master/install.ps1" -OutFile "$InstallDir\install.ps1"
& $InstallDir\install.ps1 -ScoopDir "$ScoopDir" -ScoopGlobalDir "$ScoopGlobalDir" -NoProxy

# 安装时注意顺序是 7-Zip, Git, Aria2
scoop install 7zip
scoop install git
scoop install aria2

# 修改 aria2 默认参数
scoop config aria2-retry-wait 4  # 重试等待秒数
scoop config aria2-split 8  # 单任务最大连接数
scoop config aria2-max-connection-per-server 8  # 单服务器最大连接数
scoop config aria2-min-split-size 4M  # 最小文件分片大小
Write-Host "7-Zip, Git and Aria2 was installed successfully!" -ForegroundColor green

Write-Host "Adding extras and montia37 bucket..." -ForegroundColor green
scoop bucket add extras
scoop bucket add montia37 "https://github.com/Montia37/ScoopBucket"

Write-Host "scoop and scoop-cn was installed successfully!" -ForegroundColor green
