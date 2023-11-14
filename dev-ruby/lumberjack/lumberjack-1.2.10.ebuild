# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="lumberjack.gemspec"

inherit ruby-fakegem

DESCRIPTION="A simple, powerful, and very fast logging utility"
HOMEPAGE="https://github.com/bdurand/lumberjack"
SRC_URI="https://github.com/bdurand/lumberjack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/timecop-0.8 )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' -e 's/__dir__/"."/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
