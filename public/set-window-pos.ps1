# 从命令行获取参数
param (
    [string]$myAppHwnd
)

# 引入必要的WinForms程序集
Add-Type -AssemblyName System.Windows.Forms

# 定义必要的Win32 API函数
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class User32 {
    [DllImport("user32.dll")]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll")]
    public static extern IntPtr FindWindowEx(IntPtr hWndParent, IntPtr hWndChildAfter, string lpszClass, string lpszWindow);

    [DllImport("user32.dll")]
    public static extern int SendMessageTimeout(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam, uint fuFlags, uint uTimeout, out IntPtr lpdwResult);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern IntPtr SetParent(IntPtr hWndChild, IntPtr hWndNewParent);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll")]
    public static extern int GetClassName(IntPtr hWnd, System.Text.StringBuilder lpClassName, int nMaxCount);
}
"@

# Progman窗口句柄
$progmanHandle = [IntPtr]::Zero
# WorkerW窗口句柄
$workerw = [IntPtr]::Zero

# 定义窗口枚举回调函数
function EnumWindowsProc {
    param (
        [IntPtr]$hWnd,
        [IntPtr]$lParam
    )

    # 获取窗口标题
    $title = New-Object System.Text.StringBuilder 256
    [User32]::GetWindowText($hWnd, $title, $title.Capacity)

    # 获取窗口类名
    $className = New-Object System.Text.StringBuilder 256
    [User32]::GetClassName($hWnd, $className, $className.Capacity)

    # 输出窗口句柄、类名和标题
#     Write-Host "窗口句柄: $hWnd, 类名: $($className), 标题: $($title)"

    # 查找Progman窗口
    if ($className.ToString() -eq "Progman") {
        $global:progmanHandle = $hWnd
        Write-Host "找到Progman窗口句柄: $hWnd"
        # 发送消息或执行其他操作
        $sendResult = [IntPtr]::Zero
        $timeoutResult = [User32]::SendMessageTimeout($hWnd, 0x052C, [IntPtr]::Zero, [IntPtr]::Zero, 0x0002, 1000, [ref]$sendResult)
        Write-Host "SendMessageTimeout返回值: $timeoutResult, 发送结果: $sendResult"
    }

    # 查找WorkerW窗口
    if ($className.ToString() -eq "WorkerW") {
        $global:workerw = $hWnd
    }

    return $true
}

# 设置桌面函数
function Set-Desktop {
    param (
        [IntPtr]$myAppHwnd
    )

    # 枚举所有窗口
    [User32]::EnumWindows([User32+EnumWindowsProc] { param($hWnd, $lParam) EnumWindowsProc $hWnd $lParam }, [IntPtr]::Zero)

    # 隐藏第二个WorkerW窗口
    if ($workerw -ne [IntPtr]::Zero) {
        [User32]::ShowWindow($workerw, 0) # 0为SW_HIDE
        Write-Host "隐藏WorkerW窗口"
    } else {
        Write-Host "未找到WorkerW窗口"
    }

    # 设置父窗口为Progman
    if ($progmanHandle -ne [IntPtr]::Zero) {
        $setParentResult = [User32]::SetParent($myAppHwnd, $progmanHandle)
        Write-Host "设置父窗口结果: $($setParentResult.ToString())"
    } else {
        Write-Host "未找到Progman窗口，无法设置父窗口"
    }
}

# 将参数转换为 IntPtr
$myAppHwndPtr = [IntPtr]::new([int]::Parse($myAppHwnd))

# 调用设置函数
Set-Desktop -myAppHwnd $myAppHwndPtr
