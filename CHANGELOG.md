# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to the Standard Textus Versioning Protocol (STVP@24.2.4).

## [24.0.1] - 2024-10-01

### Added

- The changelog for v24.0.0.
- A README file for the project.
- Verbose output to `Get-String`.
- The `Get-Int16` function and multiple parameters to get a random 16-bytes integer.
- Unit tests for `Get-Int16`.

### Changed

- Set "string" as the expected ouput type of `Get-String`. 
- `Get-String` now takes the probability that an optional string will be present in the output as an integer between 0 and 100, instead of a float between 0 and 1.

## [24.0.0] - 2024-09-18

### Added

- The function `Get-String` with multiple parameters to generate a random string with different conditions.
- The function `Get-RandomElement`, used internally to pick random elements from arrays or to generate random numbers.
- Unit tests for `Get-String`.