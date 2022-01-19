# winget-pkgs

Self-hosted packages for the [Windows Package Manager](https://github.com/microsoft/winget-cli), a.k.a. "winget".

Replicates the layout of [Microsoft's community repository](https://github.com/microsoft/winget-pkgs/).

## Usage

For now you can use either a local or legacy source approach. A self-hosted v1.0 REST API repository might follow at a later point in time. Some Packages might be released to the official community source, but this is currently out of scope.

### Custom Remote Source

> Use this if you want do not want to install any additional software (like git) or enable some dev-featues. Is it the recommended way to use this repo (for now) because it supports automatic updates and is very easy to use. 

First open a Powershell as Administrator and run the following command to trust our certificate. 

> :warning: A real, globally trusted cert will follow. Please stop here if you are not comfortable to trust this self-signed certificate. Using this is at your own risk!

```powershell
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/cloudflightio/winget-pkgs/main/cloudflight-code-signing-test.cer' -OutFile $env:temp\cloudflight-code-signing-test.cer; Import-Certificate -FilePath $env:temp\cloudflight-code-signing-test.cer  -CertStoreLocation 'Cert:\LocalMachine\Root' -Verbose
```

After that add our repository as new source.

```powershell
winget source add --name cloudflight https://cloudflightio.github.io/winget-pkgs
```

If you want to update it later run this:

```powershell
winget source update --name cloudflight
```

Now you can install packages hosted in this repository, for example "DockerInWSL":

```powershell
winget install dockerinwsl
```

Just run `winget search -s cloudflight` to get a complete list of packages available from this repo.

### Local

> Use this approach if you do not want to trust our certificate or want to be in full controll over the installed manifests. This does not support automatic updates.

First, you have to enable local WinGet Repositories. Open a new Powershell windows "As Administrator" and type the following command:

```bat
winget settings --enable LocalManifestFiles
``` 

After that you can install local manifest files. Clone or download this Repo, unpack and manually install a package like this:

```bat
winget install -m .\manifests\c\Cloudflight\DockerInWSL\1.0.2.1\264a-Cloudflight.DockerInWSL.yaml
```
