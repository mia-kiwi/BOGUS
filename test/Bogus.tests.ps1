$VerbosePreference = 'Continue'

Remove-Module "Bogus" -ErrorAction SilentlyContinue -Force
Import-Module "$(($PSScriptRoot -split "\\" | Select-Object -SkipLast 1) -join "\")\src\Bogus.psd1" -Force -Prefix "Bogus"

$VerbosePreference = 'SilentlyContinue'

Describe "BOGUS" {
    Context "Get-BogusString" {
        It "Should return a bogus string with a set length" {
            $RandomLength = Get-Random -Minimum 1 -Maximum 10
            (Get-BogusString -Length $RandomLength).Length | Should Be $RandomLength
        }
        It "Should return a bogus string with a length in a specified range" {
            $RandomLowerBound = Get-Random -Minimum 1 -Maximum 10
            $RandomUpperBound = Get-Random -Minimum 11 -Maximum 20
            (Get-BogusString -Between $RandomLowerBound -And $RandomUpperBound).Length -in @($RandomLowerBound..$RandomUpperBound) | Should Be $true
        }
        It "Should return a bogus string that starts with a specified string" {
            $StartsWith = Get-BogusString -StartsWith "Hello"
            $StartsWith.StartsWith("Hello") | Should Be $true
        }
        It "Should return a bogus string that ends with a specified string" {
            $EndsWith = Get-BogusString -EndsWith "World"
            $EndsWith.EndsWith("World") | Should Be $true
        }
        It "Should return a bogus string that contains a specified string" {
            $MayContain = Get-BogusString -MustContain "Hello"
            $MayContain.Contains("Hello") | Should Be $true
        }
        It "Should return a bogus string that does not contain a specified string" {
            $MustNotContain = Get-BogusString -MustNotContain "Hello"
            $MustNotContain.Contains("Hello") | Should Be $false
        }
        It "Should return a bogus string that may contain a specified string" {
            $MayContain = Get-BogusString -MayContain "Hello" -ChanceMayContain 100
            $MayContain.Contains("Hello") | Should Be $true
        }
        It "Should return a bogus string that may not contain a specified string" {
            $MayNotContain = Get-BogusString -MayContain "Hello" -ChanceMayContain 0
            $MayNotContain.Contains("Hello") | Should Be $false
        }
        It "Should return a bogus string that contains a specified character set" {
            $Charset = "ABC"
            $String = Get-BogusString -Charset $Charset.ToCharArray()
            $String -match "[^$Charset]" | Should Be $false
        }
    }
    Context "Get-BogusInt16" {
        It "Should return a bogus integer between set bounds" {
            $RandomLowerBound = Get-Random -Minimum 1 -Maximum 10
            $RandomUpperBound = Get-Random -Minimum 11 -Maximum 20
            (Get-BogusInt16 -Between $RandomLowerBound -And $RandomUpperBound) -in @($RandomLowerBound..$RandomUpperBound) | Should Be $true
        }
        It "Should swap the upper and lower bounds if the user inverts them" {
            $RandomLowerBound = Get-Random -Minimum 1 -Maximum 10
            $RandomUpperBound = Get-Random -Minimum 11 -Maximum 20
            (Get-BogusInt16 -Between $RandomUpperBound -And $RandomLowerBound) -in @($RandomLowerBound..$RandomUpperBound) | Should Be $true
        }
        It "Should return the lower bound if the upper bound is the same" {
            $RandomLowerBound = Get-Random -Minimum 1 -Maximum 10
            (Get-BogusInt16 -Between $RandomLowerBound -And $RandomLowerBound) | Should Be $RandomLowerBound
        }
        It "Should return a bogus that excludes specified values" {
            $MustExclude = "1"
            Get-BogusInt16 -Between 1 -And 100 -MustExclude $MustExclude | Should Not Be $MustExclude
        }
        It "Should return a bogus integer that does not match a specified pattern" {
            $MustExclude = "1??"
            Get-BogusInt16 -Between 99 -And 100 -MustExclude $MustExclude | Should Be 99
        }
    }
}