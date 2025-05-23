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

    [DllImport("user32.dll")]
    public static extern bool EnumChildWindows(IntPtr hWndParent, EnumChildProc lpEnumFunc, IntPtr lParam);

    public delegate bool EnumChildProc(IntPtr hWnd, IntPtr lParam);

     [DllImport("user32.dll")]
    public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

    [DllImport("user32.dll")]
    public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
}
"@
# 定义常量
$GWL_EXSTYLE = -20
$WS_EX_TRANSPARENT = 0x20
$HWND_BOTTOM = [IntPtr]::Zero  # HWND_BOTTOM

# Progman窗口句柄
$progmanHandle = [IntPtr]::Zero
# WorkerW窗口句柄
$workerw = [IntPtr]::Zero
# 定义全局变量存储SHELLDLL_DefView的句柄
$global:shellDllDefViewHandle = [IntPtr]::Zero
# 定义窗口枚举回调函数
function EnumWindowsProc {
    param (
        [IntPtr]$hWnd,
        [IntPtr]$lParam
    )

    # 获取窗口类名
    $className = New-Object System.Text.StringBuilder 256
    [User32]::GetClassName($hWnd, $className, $className.Capacity)

    # 查找Progman窗口
    if ($className.ToString() -eq "Progman") {
        $global:progmanHandle = $hWnd
        Write-Host "找到Progman窗口句柄： $hWnd"
        # 发送消息或执行其他操作
        $sendResult = [IntPtr]::Zero
        $timeoutResult = [User32]::SendMessageTimeout($hWnd, 0x052C, [IntPtr]::Zero, [IntPtr]::Zero, 0x0002, 1000, [ref]$sendResult)
        Write-Host "SendMessageTimeout返回值: $timeoutResult, 发送结果: $sendResult"
    }

    # 查找WorkerW窗口
    if ($className.ToString() -eq "WorkerW") {
        # 尝试查找其下的SHELLDLL_DefView窗口
        $defViewFound = $false

        [User32]::EnumChildWindows($hWnd, {
            param($childHWnd, $lParam)

            # 获取子窗口类名
            $childClassName = New-Object System.Text.StringBuilder 256
            [User32]::GetClassName($childHWnd, $childClassName, $childClassName.Capacity)

            if ($childClassName.ToString() -eq "SHELLDLL_DefView") {
                $global:workerw = $hWnd  # 将WorkerW赋值
                $global:shellDllDefViewHandle = $childHWnd
                $defViewFound = $true
                Write-Host "找到包含SHELLDLL_DefView的WorkerW窗口：$hWnd"
                return $false  # 找到后停止枚举
            }
            return $true  # 继续枚举
        }, [IntPtr]::Zero)

        if (-not $defViewFound) {
            Write-Host "未在WorkerW窗口下找到SHELLDLL_DefView，继续查找其他WorkerW窗口"
        }
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
    #     if ($workerw -ne [IntPtr]::Zero) {
    #         [User32]::ShowWindow($workerw, 0) # 0为SW_HIDE
    #         Write-Host "隐藏WorkerW窗口"
    #     } else {
    #         Write-Host "未找到WorkerW窗口"
    #     }

    # 设置父窗口为Progman
    if ($progmanHandle -ne [IntPtr]::Zero) {
        $setParentResult = [User32]::SetParent($myAppHwnd, $shellDllDefViewHandle)
        Write-Host "设置父窗口结果： $($setParentResult.ToString())"
        # 将窗口放到所有子窗口后面
#        $setWindowPosResult = [User32]::SetWindowPos($myAppHwnd, $shellDllDefViewHandle, 0, 0, 0, 0, 0x0001)  # 0x0001 = SWP_NOMOVE | SWP_NOSIZE
#        Write-Host "设置窗口位置结果： $($setWindowPosResult.ToString())"
    } else {
        Write-Host "未找到Progman窗口，无法设置父窗口"
    }
}

# 将参数转换为 IntPtr
$myAppHwndPtr = [IntPtr]::new([int]::Parse($myAppHwnd))

# 调用设置函数
Set-Desktop -myAppHwnd $myAppHwndPtr