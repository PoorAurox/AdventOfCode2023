$games = Get-Content (Join-Path $psscriptroot day2Input.txt)
$rules = @{
    Red = 12
    Green = 13
    Blue = 14
}
$sum = $red + $green + $blue

$drip = $games | Foreach-Object {
    $id = [regex]::match($_, "\d+").value
    $rounds = (($_ -split ":")[-1] -split ';').trim()

    [pscustomobject]@{
        Id = $id -as [int]
        Rounds = $rounds | Foreach-Object {
            Write-Output -NoEnumerate ([regex]::Matches($_, "(?<count>\d+) (?<color>red|green|blue)"))
        }
    }
}

$drip |
    Where-Object {
        -not($_.Rounds | Where-Object {
            $sumRound = 0
            foreach($singleGroup in $_)
            {
                if($rules[$singleGroup.Groups["color"].value] -lt $singleGroup.Groups["count"].value)
                {
                    $true
                    break
                }
                $sumRound += $singleGroup.Groups["count"].value
            }
            if($sumRound -gt $sum)
            {
                $true
            }
        })
    } |
    Measure-Object -Property Id -Sum