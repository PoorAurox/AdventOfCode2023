$data = (Get-Content (Join-Path $PSScriptRoot Day15Input.txt)) -split ','

$hashmap = @{}

#Create lists to insert into
0..255 | % { $hashmap[$_] = [System.Collections.Generic.List[string]]::new()}

$data | Foreach-Object {
    $current = $_.split('=-'.ToCharArray(), [System.StringSplitOptions]::RemoveEmptyEntries)
    #hash algorithm
    $curSum = 0
    foreach($char in $current[0].ToCharArray())
    {
        $curSum += [int]$char
        $curSum *= 17
        $curSum = $curSum % 256
    }
    #remove lens
    if($current.Count -eq 1)
    {
        $hashmap[$curSum] | Where-Object {$_ -like "$current*"} | % {$hashmap[$curSum].Remove($_)}
    }
    #insert lens
    else {
        $insert = "{0} {1}" -f $current[0], $current[1]
        $index = $hashmap[$curSum] | Where-Object {$_ -like "$($current[0])*"} | % {$hashmap[$curSum].indexof($_)}
        if($null -ne $index -and $index -ne -1)
        {
            $hashmap[$curSum].RemoveAt($index)
            $hashmap[$curSum].Insert($index, $insert)
        }
        else {
            $hashmap[$curSum].Add($insert)
        }
    }
}

#calculate focusing power
$focusingPower = foreach($hashIndex in 0..255)
{
    if($hashmap[$hashIndex])
    {
        foreach($boxIndex in 0..($hashmap[$hashIndex].Count - 1))
        {
            $focus = [regex]::Match($hashmap[$hashIndex][$boxIndex], '\d').Value -as [int]
            ($hashIndex + 1) * ($boxIndex + 1) * $focus
        }
    }
}

$focusingPower | Measure-Object -Sum