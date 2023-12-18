enum Direction {
    left
    down
    right
    up
}
function Next-Position {
    param(
        [int]$posY,
        [int]$posX,
        [Direction]$Direction
    )
    switch ($Direction) {
        ([Direction]::left) { return @($posY, ($posX - 1)) }
        ([Direction]::right) { return @($posY, ($posX + 1)) }
        ([Direction]::up) { return @(($posY - 1), $posX) }
        ([Direction]::down) { return @(($posY + 1), $posX)}
    }
}
function Test-InMap {
    param(
        [int]$posY,
        [int]$posX
    )
    [bool]($posY -ge 0 -and $posY -lt $map.Count -and $posX -ge 0 -and $posX -lt $map[0].Length)
}
function Update-HashMap
 {
    param (
        [int]$posY,
        [int]$posX,
        [Direction]$Direction
    )
    $tuple = [System.ValueTuple[int,int]]::new($posY, $posX)
    if($lightPath[$tuple])
    {
        if($lightPath[$tuple].Contains($Direction))
        {
            $false
        }
        else {
            $lightPath[$tuple].Add($Direction)
            $true
        }
    }
    else {
        $lightPath[$tuple] = [System.Collections.Generic.List[Direction]]::new()
        $lightPath[$tuple].Add($Direction)
        $true
    }
}
function Travel-Map {
    param (
        [int]$posY,
        [int]$posX,
        [Direction]$Direction
    )
    if(Test-InMap -posY $posY -posX $posX)
    {
        if(Update-HashMap @PSBoundParameters)
        {
            switch($map[$posY][$posX])
            {
                '.' { 
                    $tempPosY, $tempPosX = Next-Position @PSBoundParameters
                    Travel-Map -posY $tempPosY -posX $tempPosX -Direction $Direction
                }
                '/' {
                    [Direction]$newDirection = $Direction -in ([Direction]::up), ([Direction]::down) ? [int]$Direction - 1 : [int]$Direction + 1
                    $tempPosY, $tempPosX = Next-Position -posY $posY -posX $posX -Direction $newDirection
                    Travel-Map -posY $tempPosY -posX $tempPosX -Direction $newDirection
                }
                '\' {
                    [Direction]$newDirection = $Direction -in ([Direction]::up), ([Direction]::down) ? ([int]$Direction + 1) % [Direction].GetEnumValues().Count : ([int]$Direction - 1 + [Direction].GetEnumValues().Count) % [Direction].GetEnumValues().Count
                    $tempPosY, $tempPosX = Next-Position -posY $posY -posX $posX -Direction $newDirection
                    Travel-Map -posY $tempPosY -posX $tempPosX -Direction $newDirection
                }
                '|' {
                    if($direction -in ([Direction]::up), ([Direction]::down))
                    {
                        $tempPosY, $tempPosX = Next-Position @PSBoundParameters
                        Travel-Map -posY $tempPosY -posX $tempPosX -Direction $Direction
                    }
                    else 
                    {
                        $tempPosY, $tempPosX = Next-Position -posY $posY -posX $posX -Direction ([Direction]::down)
                        Travel-Map -posY $tempPosY -posX $tempPosX -Direction ([Direction]::down)

                        $tempPosY, $tempPosX = Next-Position -posY $posY -posX $posX -Direction ([Direction]::up)
                        Travel-Map -posY $tempPosY -posX $tempPosX -Direction ([Direction]::up)
                    }
                }
                '-' {
                    if($direction -in ([Direction]::up), ([Direction]::down))
                    {
                        $tempPosY, $tempPosX = Next-Position -posY $posY -posX $posX -Direction ([Direction]::right)
                        Travel-Map -posY $tempPosY -posX $tempPosX -Direction ([Direction]::right)

                        $tempPosY, $tempPosX = Next-Position -posY $posY -posX $posX -Direction ([Direction]::left)
                        Travel-Map -posY $tempPosY -posX $tempPosX -Direction ([Direction]::left)
                    }
                    else 
                    {
                        $tempPosY, $tempPosX = Next-Position @PSBoundParameters
                        Travel-Map -posY $tempPosY -posX $tempPosX -Direction $Direction
                    }
                }
            }
        }
    }
}

$map = Get-Content (Join-Path $PSScriptRoot Day16Input.txt)

$lightPath = @{}

Travel-Map -posX 0 -posY 0 -Direction ([Direction]::right)
