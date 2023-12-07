enum Hand {
    FiveOfaKind
    FourOfaKind
    FullHouse
    ThreeOfaKind
    TwoPair
    Pair
    HighCard
}
$cards = @{
    A = 65
    K = 66
    Q = 67
    J = 78
    T = 69
    '9' = 70
    '8' = 71
    '7' = 72
    '6' = 73
    '5' = 74
    '4' = 75
    '3' = 76
    '2' = 77
}

$data = Get-Content (Join-Path $PSScriptRoot Day7Input)

$hands = $data | ForEach-Object {
    $temp = $_ -split '\s'
    [pscustomobject]@{
        Hand = $temp[0]
        Score = [int]$temp[1]
    }
}


$sortHand = @{
    expr = {
        $temp = $_.Hand
        switch (@(, ($temp.Tochararray() | Group-Object | Sort-Object -Property Count | Select-Object -ExpandProperty Count)))
        {
            @(5) {[int][Hand]::FiveOfaKind}
            @(1,4) {
                if($temp.Contains('J'))
                {
                    [Hand]::FiveOfaKind
                }
                else {
                    [Hand]::FourOfaKind
                }
            }                  
            @(2,3) {
                if($temp.Contains('J'))
                {
                    [Hand]::FiveOfaKind
                }
                else {
                    [Hand]::FullHouse
                }
            }
            @(1,1,3) {
                if($temp.Contains('J'))
                {
                    [Hand]::FourOfaKind
                }
                else {
                    [Hand]::ThreeOfaKind
                }
            }
            @(1,2,2) {
                if($temp.Contains('J'))
                {
                    if(($temp.ToCharArray() | Where-object {$_ -eq 'J'}).Count -eq 2)
                    {
                        [Hand]::FourOfaKind
                    }
                    else 
                    {
                        [Hand]::FullHouse
                    }
                }
                else 
                {
                    [Hand]::TwoPair
                }
            }
            @(1,1,1,2) {
                if($temp.Contains('J'))
                {
                    [Hand]::ThreeOfaKind
                }
                else {
                    [Hand]::Pair
                }
            }
            @(1,1,1,1,1) {
                if($temp.Contains('J'))
                {
                    [Hand]::Pair
                }
                else {
                    [Hand]::HighCard
                }
            }
        }
    }
    desc = $true
}

$sortEqual = @{
    expr = {($_.Hand.Tochararray() | ForEach-Object {[char]$cards[[string]$_]}) -join ''}
    desc=$true
}

$hands |
 Sort-Object -Property $sortHand, $sortEqual |
  Foreach-Object -Begin {$count = 1} -Process {$_.Score * $count; $count++} |
   Measure-Object -Sum