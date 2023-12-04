$data = Get-Content (Join-Path $PSScriptRoot Day4Input.txt)

$data | ForEach-Object {
    $winningNums = [regex]::Matches(($_ -split '[:\|]')[1], "\d+")
    $cardNums = [regex]::Matches(($_ -split '[:\|]')[2], "\d+")

    $power = $winningNums.Value | Where-Object {$_ -in $cardNums.Value} | Measure-Object

    if($power.Count)
    {
        [Math]::Pow(2, $power.Count - 1)
    }
} | Measure-Object -Sum