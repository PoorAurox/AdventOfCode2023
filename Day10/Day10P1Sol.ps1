function Test-InMap {
    param (
        [int]$XPos,
        [int]$YPos
    )
    ($YPos -ge 0 -and $YPos -lt $map.Count) -and ($XPos -ge 0 -and $XPos -lt $map[0].Length)
}
function Get-Moves {
    param (
        [int]$XPos,
        [int]$YPos
    )
    #S
    if($map[$YPos][$XPos] -eq 'S')
    {
        
            #north
            if((Test-InMap -XPos $XPos -YPos ($YPos - 1)) -and $map[$YPos - 1][$XPos] -in '|','7','F') {[System.ValueTuple[int,int]]::new($YPos - 1, $XPos)}
            #south
            if((Test-InMap -XPos $XPos -YPos ($YPos + 1)) -and $map[$YPos + 1][$XPos] -in '|','J','L') {[System.ValueTuple[int,int]]::new($YPos + 1, $XPos)}
            #west
            if((Test-InMap -XPos ($XPos - 1) -YPos $YPos) -and $map[$YPos][($XPos - 1)] -in '-','L','F') {[System.ValueTuple[int,int]]::new($YPos, $XPos - 1)}
            #east
            if((Test-InMap -XPos ($XPos + 1) -YPos $YPos) -and $map[$YPos][$XPos + 1] -in '-','7','J') {[System.ValueTuple[int,int]]::new($YPos, $XPos + 1)}
    }
    else {
        switch($map[$YPos][$XPos])
        {
            #north
            {$_ -in '|', 'J', 'L'}{[System.ValueTuple[int,int]]::new($YPos - 1, $XPos)}
            #south
            {$_ -in '|', '7', 'F'}{[System.ValueTuple[int,int]]::new($YPos + 1, $XPos)}
            #east
            {$_ -in '-', 'L', 'F'}{[System.ValueTuple[int,int]]::new($YPos, $XPos + 1)}
            #west
            {$_ -in '-', 'J', '7'}{[System.ValueTuple[int,int]]::new($YPos, $XPos - 1)}
        }
    }
}

function Traverse-Map {
    param (
        [Parameter(ValueFromPipeline)]
        [System.ValueTuple[int,int]]$position,
        [Parameter()]
        [int]$CurrentSteps = 0
    )
    Process
    {
        #Base Case
        if($null -ne $steps[$position] -and $steps[$position] -le $CurrentSteps)
        {
            return
        }

        $steps[$position] = $CurrentSteps
        $moves = Get-Moves -XPos $position[1] -YPos $position[0]
        $moves | Traverse-Map -CurrentSteps ($CurrentSteps + 1)
    }
}
$map = Get-Content (Join-Path $PSScriptRoot Day10Input.txt)

$steps = @{}

$map |
 Where-Object {$_.Contains('S')} |
  Foreach-Object {[System.ValueTuple[int,int]]::new($map.IndexOf($_), $_.IndexOf('S'))} |
   Traverse-Map

$steps.Values | Measure-Object -Maximum

