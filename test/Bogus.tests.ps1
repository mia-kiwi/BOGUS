$VerbosePreference = 'Continue'

Remove-Module "Bogus" -ErrorAction SilentlyContinue -Force
Import-Module "$(($PSScriptRoot -split "\\" | Select-Object -SkipLast 1) -join "\")\src\Bogus.psd1" -Force -Prefix "Bogus"

Describe "BOGUS" {
    Context "Get-BogusString" {
        It "Should return a bogus string with a set length" {
            $RandomLength = Get-Random -Minimum 1 -Maximum 10
            (Get-BogusString -Length $RandomLength).Length | Should Be $RandomLength
        }
        It "Should retrun a bogus string with a length in a specified range" {
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
            $MayContain = Get-BogusString -MayContain "Hello" -ChanceMayContain 1
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
}