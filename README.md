# winget-pkgs

Self-hosted packages for the [Windows Package Manager](https://github.com/microsoft/winget-cli), a.k.a. "winget".

Replicates the layout of [Microsoft's community repository](https://github.com/microsoft/winget-pkgs/).

## Usage

WinGet v1 is using a new REST API and the old Sources.msix Catalog-Format is quite complicated, therefore we are using a local approach for now.

First, you have to enable local WinGet Repositories. Open a new Powershell windows "As Administrator" and type the following command:

```bat
winget settings --enable LocalManifestFiles
``` 

After that you can install local manifest files. Clone or download this Repo, unpack and manually install a package like this:

```bat
winget install -m .\manifests\c\Cloudflight\DockerInWSL\1.0.0.0\
```
