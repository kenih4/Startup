Add-Type @"
using System;
using System.Runtime.InteropServices;

public class WinAPI {
    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@

# Teamsのプロセス取得
$proc = Get-Process -Name "ms-teams" -ErrorAction SilentlyContinue

if (-not $proc) {
    Write-Output "ms-teams.exe が起動していないので、起動します..."
    Start-Process "ms-teams:"
    Start-Sleep -Seconds 10  # 起動に時間がかかるため待機（必要に応じて調整）
    # 再取得
    $proc = Get-Process -Name "ms-teams" -ErrorAction SilentlyContinue
}else {
    Write-Output "ms-teams.exe はすでに起動しています。"
}   




$proc = Get-Process -Name "ms-teams" -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 }

if ($proc) {
    foreach ($p in $proc) {
        Write-Output "Debug $p"

        $hwnd = $p.MainWindowHandle

        # ウィンドウを表示（SW_RESTORE = 9）
        [WinAPI]::ShowWindowAsync($hwnd, 3) #最大化して表示

        # 最前面に持ってくる
        [WinAPI]::SetForegroundWindow($hwnd)

        Write-Output "ms-teams ウィンドウを前面に表示しました。"
    }
} else {
    Write-Output "ms-teams.exe はウィンドウを持っていません。"
    Start-Process "ms-teams"
}

# Open Channel [朝ミーティング]
Start-Process "https://teams.microsoft.com/l/channel/19%3Ab75283a8ac374119b1507a1e076cc817%40thread.tacv2/%E6%9C%9D%E3%83%9F%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%EF%BC%88%E5%8A%A0%E9%80%9F%E5%99%A8%EF%BC%89?groupId=5dbfd7f4-6b93-4638-b960-fec23213fc2a&tenantId=b1ce6928-6dd8-436d-9cc8-427132b02adf"





<#
# メインウィンドウを持っているプロセスだけに絞る
$visibleProc = $proc | Where-Object { $_.MainWindowHandle -ne 0 }
if ($visibleProc) {
    foreach ($p in $visibleProc) {
        $hwnd = $p.MainWindowHandle
        # ウィンドウ復元（最小化されている場合）
        [WinAPI]::ShowWindowAsync($hwnd, 9)
        # 最前面に表示
        [WinAPI]::SetForegroundWindow($hwnd)
        Write-Output "ms-teams のウィンドウを最前面に表示しました。"
    }
} else {
    Write-Output "ms-teams.exe はまだウィンドウを表示していないようです。"
}#>