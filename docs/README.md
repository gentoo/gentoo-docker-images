# Supported tags and respective `Dockerfile` links

-	[`amd64`, `latest`, `stage3` (*amd64/Dockerfile*)](https://raw.githubusercontent.com/ChaosEngine/gentoo-docker-images/master/amd64/Dockerfile)
-	[`amd64`, `stable`, `stage3` (*amd64/Dockerfile*)](https://raw.githubusercontent.com/ChaosEngine/gentoo-docker-images/450207321dc96a90f23df5346ee5ff817e3bc6a1/amd64/Dockerfile)
-	[`amd64-hardened`, `latest`, `stage3` (*amd64-hardened/Dockerfile*)](https://raw.githubusercontent.com/ChaosEngine/gentoo-docker-images/master/amd64-hardened/Dockerfile)
-	[`amd64-hardened`, `stable`, `stage3` (*amd64-hardened/Dockerfile*)](https://raw.githubusercontent.com/ChaosEngine/gentoo-docker-images/450207321dc96a90f23df5346ee5ff817e3bc6a1/amd64-hardened/Dockerfile)



For more information about this image and its history, please see the [relevant manifest file (`gentoo/gentoo-docker-images`)](https://github.com/ChaosEngine/gentoo-docker-images) or in official, the [`gentoo/gentoo-docker-images` GitHub repo](https://github.com/gentoo/gentoo-docker-images).

![logo](https://raw.githubusercontent.com/ChaosEngine/gentoo-docker-images/master/docs/logo.png)

# What is [Gentoo](http://www.gentoo.org/)?

Gentoo is a free operating system based on either Linux or FreeBSD that can be automatically optimized and customized for just about any application or need. Extreme configurability, performance and a top-notch user and developer community are all hallmarks of the Gentoo experience.

Thanks to a technology called Portage, Gentoo can become an ideal secure server, development workstation, professional desktop, gaming system, embedded solution or something else -- whatever you need it to be. Because of its near-unlimited adaptability, we call Gentoo a metadistribution.

Of course, Gentoo is more than just the software it provides. It is a community built around a distribution which is driven by more than 300 developers and thousands of users. The distribution project provides the means for the users to enjoy Gentoo: documentation, infrastructure (mailinglists, site, forums ...), release engineering, software porting, quality assurance, security followup, hardening and more.

To advise on and help with Gentoo's global development, a 7-member council is elected on a yearly basis which decides on global issues, policies and advancements in the Gentoo project.

# What is Portage?

Portage is the heart of Gentoo, and performs many key functions. For one, Portage is the software distribution system for Gentoo. To get the latest software for Gentoo, you type one command: emerge --sync. This command tells Portage to update your local "Portage tree" over the Internet. Your local Portage tree contains a complete collection of scripts that can be used by Portage to create and install the latest Gentoo packages. Currently, we have more than 10000 packages in our Portage tree, with updates and new ones being added all the time.

Portage is also a package building and installation system. When you want to install a package, you type emerge packagename, at which point Portage automatically builds a custom version of the package to your exact specifications, optimizing it for your hardware and ensuring that the optional features in the package that you want are enabled -- and those you don't want aren't.

Portage also keeps your system up-to-date. Typing emerge -uD world -- one command -- will ensure that all the packages that you want on your system are updated automatically.

> [http://en.wikipedia.org/wiki/Gentoo_Linux](http://en.wikipedia.org/wiki/Gentoo_Linux)


# About this image

The `amd64:latest` tag will always point the latest built release (which is, at the time of this writing, `amd64:stage3`). Stable releases are also tagged with their version (ie, `amd64:latest` is currently also the same as `amd64:stable`).

The same applies to amd64-hardened images.

## stage3 source

The mirror of choice for these images is [http://distfiles.gentoo.org/releases/amd64/autobuilds/](http://distfiles.gentoo.org/releases/amd64/autobuilds/) so that it's as close to optimal for everyone as possible, regardless of location.

[amd64](http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64/)

[amd64-hardened](http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/)

# Supported Docker versions

This image is officially supported on Docker version 1.5.0.

Support for older versions (down to 1.0) is provided on a best-effort basis.

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/gentoo/gentoo-docker-images/issues).

You can also reach many of the official image maintainers via the `#gentoo-containers` IRC channel on [Freenode](https://freenode.net).

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/gentoo/gentoo-docker-images/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
