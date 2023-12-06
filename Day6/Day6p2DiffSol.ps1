function Get-DistanceTraveled {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$TotalTime,
        [Parameter(Mandatory)]
        [int]$Charge
    )
    ($TotalTime * $Charge) - ($Charge * $Charge)
}

$data = Get-Content (Join-Path $PSScriptRoot Day6Input.txt)

$time = [regex]::matches($data[0], "\d+").Value -join ''
$distance = [regex]::matches($data[1], "\d+") -join ''


$min = 0
$max = [Math]::Floor(($time -as [int]) / 2)
$current = [Math]::Floor(($min + $max) / 2)

while($max - $min -gt 1)
{

    if($oldCurrent -eq $current)
    {
        break;
    }
    $oldCurrent = $current
    #if distance is farther than current distance decrease max
    switch (Get-DistanceTraveled -TotalTime $time -Charge $current)
    {
        {$_ -lt $distance} {
            $min = $current
            $current = (($min + $max) / 2) -as [int]
            break
        }
        {$_ -gt $distance} {
            $max = $current
            $current = (($min + $max) / 2) -as [int]
            break
        }
    }
}
[int]$time - $current - $current - 1