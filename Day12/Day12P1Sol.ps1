function Get-PossibleChoices {
    [OutputType([System.Collections.Generic.IEnumerable[int][]])]
    param (
        [System.Collections.Generic.SortedSet[int]]$Set,
        [int]$Depth
    )
    if(0 -eq $Depth)
    {
        Write-OutPut -NoEnumerate (,[System.Collections.Generic.List[int]]::new())
    }
    else 
    {
        $array = [int[]]::new($Set.Count)
        $Set.CopyTo($array)    
        foreach($value in $array)
        {
            [void]$set.Remove($value)
            $collections = [System.Collections.Generic.IEnumerable[int][]](Get-PossibleChoices -Set $Set -Depth ($Depth - 1))
            foreach($singleCollection in $collections)
            {
                [void]$singleCollection.Add($value)
                Write-Output -NoEnumerate $singleCollection
            }
            [void]$Set.Add($value)
        }
    }
}
function Get-ErrorList {
    [OutputType([int[]])]
    param(
        [System.Collections.Generic.IEnumerable[int]]$collections
    )

    $last = [int]::MinValue
    $currentTally = 0

    $retVals = foreach($element in $collections)
    {
        if($element -ne ($last + 1))
        {
            $currentTally
            $currentTally = 0
        }
        $currentTally++
        $last = $element
    }
    $retVals += $currentTally
    $retVals | Select-Object -Skip 1
}
$data = Get-Content (Join-Path $PSScriptRoot Day12Input.txt)

$data | ForEach-Object {
    $setPositions = [System.Collections.Generic.SortedSet[int]]::new()
    $possiblePositions = [System.Collections.Generic.SortedSet[int]]::new()
    $map,$check = $_ -split ' '
    [int[]]$errorCheck = $check -split ','
    0..($map.length - 1) | Where-Object {$map[$_] -eq '#'} | ForEach-Object {[void]$setPositions.Add($_)}
    0..($map.length - 1) | Where-Object {$map[$_] -eq '?'} | ForEach-Object {[void]$possiblePositions.Add($_)}
    $depth = ($errorCheck | Measure-Object -Sum | Select-Object -ExpandProperty Sum) - $setPositions.Count

    $possibilities = Get-PossibleChoices -Set $possiblePositions -Depth $depth

    $count = 0
    foreach($poss in $possibilities)
    {
        $current = [System.Collections.Generic.SortedSet[int]]::new($setPositions)
        $poss | % {[void]$current.Add($_)}
        if((Get-ErrorList -collections $current) -eq $errorCheck)
        {
            $count++
        }
    }
    $count
} | Measure-Object -Sum