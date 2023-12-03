$games = Get-Content (Join-Path $psscriptroot day2Input.txt)

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
    Foreach-Object {
        $maxes = @{
            Red = 0
            Green = 0
            Blue = 0
        }
        $_.Rounds | Foreach-Object {
            foreach($singleGroup in $_)
            {
                if($maxes[$singleGroup.Groups["color"].value] -lt $singleGroup.Groups["count"].value)
                {
                    $maxes[$singleGroup.Groups["color"].value] = $singleGroup.Groups["count"].value -as [int]
                }
            }
        }
        $maxes['Red'] * $maxes['Green'] * $maxes['Blue']
    } |
    Measure-Object -Sum