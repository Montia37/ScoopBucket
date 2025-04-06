> Modified from [🐟 dorado](https://github.com/chawyehsu/dorado)
>
> Some buckets from [🍨 Scoopet 🍨](https://github.com/ivaquero/scoopet) | [scoop-lemon](https://github.com/hoilc/scoop-lemon) | [rainte](https://github.com/rainte/scoop)

## :ledger:安装 Scoop

### :bookmark_tabs:1. 设置 PowerShell 执行策略

```powershell
Set-ExecutionPolicy RemoteSigned -scope CurrentUser
```

### :bookmark_tabs:2. 使用脚本安装 Scoop

#### :page_facing_up:2.1 官方

-   下载脚本

    ```powershell
    irm get.scoop.sh -outfile 'install.ps1'
    ```

-   使用自定义路径安装 Scoop
    ```powershell
    .\install.ps1 -ScoopDir ['Scoop_Path'] -ScoopGlobalDir ['GlobalScoopApps_Path'] -NoProxy
    ```

#### :page_facing_up:2.2 自动安装

-   下载脚本

    ```powershell
    irm https://raw.githubusercontent.com/Montia37/ScoopBucket/main/install.ps1 -outfile 'install.ps1'
    ```

-   调整部分配置
    https://github.com/Montia37/ScoopBucket/blob/6d83b8db6ed55fd8d8ade36bc63a044e7118a935/install.ps1#L7-L10

-   直接执行脚本

## :ledger:添加 bucket

```powershell
scoop bucket add montia37 https://github.com/montia37/ScoopBucket
```

## :ledger:推荐安装 App

<details>

### :bookmark_tabs:安装 sudo 直接使用管理员运行命令

```powershell
scoop install sudo
```

### :bookmark_tabs:安装 Aria2 来加速下载

```powershell
scoop install aria2
```

-   如果使用 VPN，需要通过如下命令关闭 aria2

    ```powershell
    scoop config aria2-enabled false
    ```

-   Aria2 的参数自定义

    ```powershell
    # aria2 在 Scoop 中默认开启
    scoop config aria2-enabled true
    # 关于以下参数的作用，详见 aria2 的相关资料
    scoop config aria2-retry-wait 4  # 重试等待秒数
    scoop config aria2-split 16  # 单任务最大连接数
    scoop config aria2-max-connection-per-server 16  # 单服务器最大连接数
    scoop config aria2-min-split-size 4M  # 最小文件分片大小
    ```

### :bookmark_tabs:安装 Git 来添加新仓库

```powershell
scoop install git
```

</details>

## :ledger:备份恢复

<details>

### :bookmark_tabs:导入导出法(全部重新安装，可保留持久化数据)

-   导出软件清单

    ```powershell
    scoop export > scoopfile.json

    # 同时导出 Scoop 配置文件
    -c, --config
    ```

-   (可选) 备份持久化数据

    -   复制压缩备份 `['Scoop_Path']\persist` 文件夹

    -   复制压缩备份 `['GlobalScoopApps_Path']\persist` 文件夹

-   导入

    ```powershell
    scoop import <path/url to scoopfile.json>
    ```

-   (可选) 恢复持久化数据

### :bookmark_tabs:完整备份法(迁移全部文件)

-   将整个 Scoop 安装文件夹复制迁移到新系统

-   用户环境变量 path 中添加 `['Scoop_Path']\shims`

-   系统环境变量 path 中添加 `['GlobalScoopApps_Path']\shims`

-   设置 PowerShell 执行策略

    ```powershell
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser
    ```

-   执行 `['Scoop_Path']\apps\scoop\current\bin` 里面的 `refresh.ps1` 和 `scoop.ps1` 脚本

-   重置版本依赖，恢复环境变量

    ```powershell
    scoop reset *
    ```

    </details>

## :ledger:常用命令

<details>

-   搜索

    ```powershell
    scoop search <app>
    ```

-   安装

    ```powershell
    scoop install <app> [options]
    ```

    ```powershell
    # 安装应用程序的常用方法（使用本地 bucket）:
    scoop install git
    # 安装不同版本的应用程序（请注意，这将使用当前版本自动生成清单）:
    scoop install gh@2.7.0
    # 从 URL 处的清单安装应用程序:
    scoop install https://raw.githubusercontent.com/ScoopInstaller/Main/master/bucket/runat.json
    # 从计算机上的清单安装应用程序
    scoop install \path\to\app.json
    ```

    ```
    -g, --global                    全局安装应用程序
    -i, --independent               不要自动安装依赖项
    -k, --no-cache                  不要使用下载缓存
    -u, --no-update-scoop           如果 Scoop 已经过时，请不要在安装前更新它
    -s, --skip                      跳过哈希验证（谨慎使用！）
    -a, --arch <32bit|64bit|arm64>  如果应用程序支持，请使用指定的架构
    ```

-   bucket 仓库操作

    ```powershell
    # 使用命令:
    scoop bucket add [<args>]  # 添加 bucket
    scoop bucket list  # 列出已安装 bucket
    scoop bucket rm [<args>]  # 删除 bucket
    scoop bucket known  # 列出官方推荐 bucket 仓库

    # Buckets 是可安装的应用程序的存储库。 Scoop 附带一个默认 bucket(main)，也可以添加您或其他人已发布的 bucket。
    # 添加 extras bucket:
    scoop bucket add extras https://github.com/ScoopInstaller/Extras.git
    # 由于 Scoop 已知 'extras' 这个 bucket，因此可以将其缩短为:
    scoop bucket add extras
    ```

-   更新

    ```powershell
    scoop update <app> [options]

    # 将 Scoop 更新到最新版本。
    scoop update
    # 安装指定应用程序的新版本（如果有）
    scoop update <app>
    # 您可以使用以下命令来更新所有应用程序
    scoop update *

    # 可使用hold来禁止更新，unhold取消禁止
    scoop hold|unhold [-g] <app>
    ```

    ```
    -f, --force               即使没有新版本也强制更新
    -g, --global              更新全局安装的应用程序
    -i, --independent         不要自动安装依赖项
    -k, --no-cache            不要使用下载缓存
    -s, --skip                跳过哈希验证（谨慎使用！）
    -q, --quiet               隐藏无关消息
    -a, --all                 更新所有应用程序（替代“*”）
    ```

-   查看软件状态

    ```powershell
    scoop status

    # 仅检查本地安装的应用程序的状态，并禁用 Scoop 和 bucket 的远程获取/检查
    -l, --local
    ```

-   卸载

    ```powershell
    scoop uninstall <app> [options]

    # 卸载全局安装的应用程序
    -g, --global
    # 删除所有持久数据
    -p, --purge
    ```

-   查看软件详情

    ```powershell
    scoop info <app> [--verbose]
    ```

-   打开软件主页

    ```powershell
    scoop home <app>
    ```

-   查看软件安装清单 json

    ```powershell
    scoop cat <app>
    ```

-   shim

    ```powershell
    Usage: scoop shim <subcommand> [<shim_name>...] [options] [other_args]

    # 可用的子命令: add, rm, list, info, alter

    # 要添加自定义填充程序，请使用 'add' 子命令:
    scoop shim add <shim_name> <command_path> [<args>...]

    # 要删除 shims，请使用 'rm' 子命令：（注意：这可能会删除应用程序清单添加的 shims）
    scoop shim rm <shim_name> [<shim_name>...]

    # 要列出所有 shims 或匹配的 shims，请使用 'list' 子命令:
    scoop shim list [<shim_name>/<pattern>...]

    # 要显示填充程序的信息，请使用 'info' 子命令:
    scoop shim info <shim_name>

    # 要更改 shim 的目标源，请使用 'alter' 子命令:
    scoop shim alter <shim_name>

    # 操纵全局 shim(s)
      -g, --global

    # 提示：第一个双连字符“--”（如果有）将被视为 POSIX 样式命令选项终止符并且不会包含在参数中，因此如果您想将“-g”或“--global”等参数传递给 shim ，将它们放在 '--' 之后。请注意，在 PowerShell 中，您必须使用引号 '--'，例如，
    scoop shim add myapp 'D:\path\myapp.exe' '--' myapp_args --global
    ```

-   其他命令

    ```powershell
    scoop cache show|rm [app(s)]  # 显示|清除下载缓存
    scoop checkup  # 检查潜在问题
    scoop cleanup  # 删除旧版本，清理 Scoop 应用程序
    scoop cleanup [-a|-g|-k] <app>  # 如果该应用程序的旧版本存在，则清理该版本。
    scoop depends <app>  # 按安装顺序列出应用程序的依赖项
    scoop alias add|list|rm [<args>]  # 添加、删除或列出 Scoop 别名(别名是自定义的 Scoop 子命令，可用于简化常见任务。)详情见scoop help alias
    ```

</details>
