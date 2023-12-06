function Get-DistanceTraveled {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$TotalTime,
        # Parameter help description
        [Parameter(Mandatory)]
        [int]$Charge
    )
    ($TotalTime * $Charge) - ($Charge * $Charge)
}

$data = Get-Content (Join-Path $PSScriptRoot Day6Input.txt)

$time = [regex]::matches($data[0], "\d+")
$distance = [regex]::matches($data[1], "\d+")

$values = for($i = 0; $i -lt $time.Count; $i++)
{
    $current = [Math]::Floor(($time[$i].Value -as [int]) / 2)
    $count = 0
    while((Get-DistanceTraveled -TotalTime $time[$i].Value -Charge $current) -gt $distance[$i].Value)
    {
        $count += 2
        $current++
    }
    if(($time[$i].Value -as [int]) % 2)
    {
        $count -= 1
    }
    $count
}

$values | ForEach-Object -Begin {$product = 1} -Process {
    $product = $product * ($_ - 1)
} -End {$product}