function Get-Difference {
    param (
        [int[]]$Measurements
    )
    for($i = 1; $i -lt $Measurements.Count; $i++)
    {
        $Measurements[$i] - $Measurements[$i-1]
    }
}

$data = Get-Content (Join-Path $PSScriptRoot Day9Input.txt)

$data | Foreach-Object {
    $measurements = $_ -split '\s'
    $rows = while(($measurements -eq 0).Count -ne $measurements.Count)
    {
        Write-OutPut -NoEnumerate $measurements
        $measurements = Get-Difference -Measurements $measurements
    }
    $result = 0
    for($i = $rows.Count - 1; $i -ge 0; $i--)
    {
        $result = $rows[$i][0] - $result
    }
    $result
} | Measure-Object -Sum

