param($rootPath, $toolsPath, $package, $project)

$rakeDotNetFrom = $toolsPath + "\..\src\RakeDotNet"
$rakeDotNetTo = "RakeDotNet"

$rakeFileFrom = $toolsPath + "\..\src\Rakefile.rb"
$rakeFileTo = "Rakefile.rb"

if(!(Test-Path $rakeFileTo))
{
  Copy-Item $rakeDotNetFrom $rakeDotNetTo -recurse
  Copy-Item $rakeFileFrom $rakeFileTo
}
