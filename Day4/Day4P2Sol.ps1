$data = Get-Content (Join-Path $PSScriptRoot Day4Input.txt)
$repetitions = [int[]]::CreateInstance([int], $data.Count)
[array]::Fill($repetitions, 1)
$data | ForEach-Object {
    $card = [regex]::Match($_, '\d+').Value -as [int]
    $winningNums = [regex]::Matches(($_ -split '[:\|]')[1], "\d+")
    $cardNums = [regex]::Matches(($_ -split '[:\|]')[2], "\d+")

    $power = $winningNums.Value | Where-Object {$_ -in $cardNums.Value} | Measure-Object

    if($power.Count)
    {
        $end = $card + $power.Count -lt $data.Count ? $card + $power.Count - 1 : $data.Count - 1
        $card..$end | Foreach-Object {$repetitions[$_] += $repetitions[$card - 1]}
    }
} 

$repetitions | Measure-Object -Sum