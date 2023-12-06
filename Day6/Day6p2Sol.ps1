    $data = Get-Content (Join-Path $PSScriptRoot Day6Input.txt)

    $time = [regex]::matches($data[0], "\d+").Value -join '' -as [int64]
    $distance = [regex]::matches($data[1], "\d+") -join '' -as [int64]

    for([int64]$current = 0;($current * ($time - $current)) -le $distance; $current++)
    {
    }
    $time - ($current * 2) + 1
