foreach($line in Get-Content $args[0]) {
  $envSplit = $line.Split("="); if (!$envSplit[0].startsWith("#")) {
    [System.Environment]::SetEnvironmentVariable($envSplit[0], $envSplit[1], [EnvironmentVariableTarget]::Process)
  }
}
