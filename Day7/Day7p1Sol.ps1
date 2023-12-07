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
        J = 68
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
            $temp = $_
            switch (@(, ($temp.Hand.Tochararray() | Group-Object | Sort-Object -Property Count | Select-Object -ExpandProperty Count)))
            {
                @(5) {[Hand]::FiveOfaKind}
                @(1,4) {[Hand]::FourOfaKind}
                @(2,3) {[Hand]::FullHouse}
                @(1,1,3) {[Hand]::ThreeOfaKind}
                @(1,2,2) {[Hand]::TwoPair}
                @(1,1,1,2) {[Hand]::Pair}
                @(1,1,1,1,1) {[Hand]::HighCard}
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