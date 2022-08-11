{
  Installer(product, version):: {
    MinimumOSVersion: '10.0.0.0',
    Scope: std.get(version, 'Scope', std.get(product, 'Scope', 'user')),
    InstallModes: [
      'silent',
      'silentWithProgress',
    ],
    UpgradeBehavior: 'install',
    PackageIdentifier: product.PackageIdentifier,
    PackageVersion: version.PackageVersion,
    InstallerLocale: product.PackageLocale,
    Installers: [
      {
        Architecture: 'x64',
        InstallerType: 'wix',
        InstallerUrl: version.InstallerUrl,
        InstallerSha256: version.InstallerSha256,
        ProductCode: version.ProductCode,
      },
    ],
    ManifestType: 'installer',
    ManifestVersion: '1.1.0',
  },

  Locale(product, version):: {
      PackageIdentifier: product.PackageIdentifier,
      PackageVersion: version.PackageVersion,
      PackageLocale: product.PackageLocale,
      Publisher: product.Publisher,
      PublisherUrl: product.PublisherUrl,
      PublisherSupportUrl: product.PublisherSupportUrl,
      Author: product.Author,
      PackageName: product.PackageName,
      PackageUrl: product.PackageUrl,
      License: product.License,
      Copyright: product.Copyright ,
      ShortDescription: product.ShortDescription,
      Moniker: product.Moniker,
      Tags: product.Tags,
      ManifestType: 'defaultLocale',
      ManifestVersion: '1.1.0',
  },

  Version(product, version):: {
      PackageIdentifier: product.PackageIdentifier,
      PackageVersion: version.PackageVersion,
      DefaultLocale: product.PackageLocale,
      ManifestType: 'version',
      ManifestVersion: '1.1.0',
  },

  Merged(product, version):: 
    $.Installer(product, version) + $.Locale(product, version) + $.Version(product, version) + {
    ManifestType: 'merged'
  },

  Release(product, version)::
    local packageIdentifierParts = std.split(product.PackageIdentifier, '.');
    local basePath = std.asciiLower(product.PackageIdentifier[0]) + '/' + packageIdentifierParts[0] + '/' + packageIdentifierParts[1];
    local packageIdentifierHash = std.substr(std.md5(product.PackageIdentifier),0,4);
    {
        [basePath + '/' + version.PackageVersion + '/' + product.PackageIdentifier + '.installer.json']: $.Installer(product, version),
        [basePath + '/' + version.PackageVersion + '/' + product.PackageIdentifier + '.locale.en-US.json']: $.Locale(product, version),
        [basePath + '/' + version.PackageVersion + '/' + product.PackageIdentifier + '.json']: $.Version(product, version),
        [basePath + '/' + version.PackageVersion + '/' + packageIdentifierHash + "-" + product.PackageIdentifier + '.json']: $.Merged(product, version),
    },

  Files(product, releases)::
    std.foldl(function(x, y) x + y, 
    [
        $.Release(product, x) 
        for x in releases
    ], {})
  
}