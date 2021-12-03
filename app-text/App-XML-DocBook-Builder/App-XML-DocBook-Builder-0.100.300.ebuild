# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="SHLOMIF"
DIST_VERSION="0.1003"
inherit perl-module

DESCRIPTION="A Perl-based tool to Render DocBook/XML"
HOMEPAGE="https://www.shlomifish.org/open-source/projects/docmake/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Class-XSAccessor
	virtual/perl-Getopt-Long
	virtual/perl-File-Path
	dev-perl/Test-Trap"
BDEPEND="dev-perl/Module-Build
	test? (
		virtual/perl-File-Spec
	)"
