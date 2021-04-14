# Copyright (c) STÜBER SYSTEMS GmbH. All rights reserved.
# Licensed under the MIT License.

BeforeAll {
	# Get the path of our module 
	$modulePath = $PSCommandPath.Replace('.tests.ps1','.psm1')
	# Import the module for testing
	Import-Module $modulePath -Force
}

Describe -name "Tests" {
	Context "Module interface" {
		It "Module should export 4 commands in alphabetical order." {
			$commands = Get-Command -Module PsDaVinci
			$commands.Count | Should -BeExactly 4
			$commands[0].Name | Should -Be "Initialize-DaVinciExport"
			$commands[1].Name | Should -Be "Initialize-DaVinciImport"
			$commands[2].Name | Should -Be "Start-DaVinciExport"
			$commands[3].Name | Should -Be "Start-DaVinciImport"
		}
	}
	Context "GetFullConfigPath" {
		It "[.\config] should return [.\config.json]" {
			InModuleScope PsDaVinci {
				$fileName = GetFullConfigPath .\config
				$fileName | Should -Be '.\config.json'
			}
		}
		It "[.\config.json] should return [.\config.json]" {
			InModuleScope PsDaVinci {
				$fileName = GetFullConfigPath .\config.json
				$fileName | Should -Be '.\config.json'
			}
		}
		It "[.\config.txt] should return [.\config.txt]" {
			InModuleScope PsDaVinci {
				$fileName = GetFullConfigPath .\config.txt
				$fileName | Should -Be '.\config.txt'
			}
		}
		It "[config] should return [($location)\config.json]" {
			InModuleScope PsDaVinci {
				$location = Get-Location
				$fileName = GetFullConfigPath config
				$fileName | Should -Be "$($location)\config.json"
			}
		}
		It "[config.json] should return [($location)\config.json]" {
			InModuleScope PsDaVinci {
				$location = Get-Location
				$fileName = GetFullConfigPath config.json
				$fileName | Should -Be "$($location)\config.json"
			}
		}
		It "[config.txt] should return [($location)\config.txt]" {
			InModuleScope PsDaVinci {
				$location = Get-Location
				$fileName = GetFullConfigPath config.txt
				$fileName | Should -Be "$($location)\config.txt"
			}
		}
	}
}