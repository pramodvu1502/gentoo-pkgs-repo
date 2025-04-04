# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake flag-o-matic python-any-r1

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="https://www.flintlib.org/"

MY_PV="${PV/_/-}"
SRC_URI="https://github.com/flintlib/flint/archive/refs/tags/v${MY_PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"
LICENSE="LGPL-2.1+"

# Based off the soname, e.g. /usr/lib64/libflint.so -> libflint.so.15
SLOT="0/19"

KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc ntl test"

RESTRICT="!test? ( test )"

BDEPEND="${PYTHON_DEPS}
	doc? (
		app-text/texlive-core
		dev-python/sphinx
		dev-tex/latexmk
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"
DEPEND="dev-libs/gmp:=
	dev-libs/mpfr:=
	ntl? ( dev-libs/ntl:= )
	virtual/cblas"
# flint 3 includes arb and arb cannot use flint 3.
RDEPEND="${DEPEND}
	!sci-mathematics/arb"

# The rst files are API docs, but they're very low-effort compared to
# the PDF and HTML docs, so we ship them unconditionally and hide only
# the painful parts behind USE=doc.
DOCS="AUTHORS README.md doc/source/*.rst"

PATCHES=(
	"${FILESDIR}/flint-3.0.1-find-cblas.patch"
	"${FILESDIR}/flint-3.1.3_p1-c99-I.patch"
	"${FILESDIR}/flint-3.1.3_p1-fix-pc-location.patch"
)

src_configure() {
	# Test failures:
	# * https://bugs.gentoo.org/934463
	# * https://github.com/flintlib/flint/issues/2029
	filter-flags -floop-nest-optimize \
				 -ftree-loop-linear \
				 -floop-strip-mine \
				 -floop-block \
				 -fgraphite-identity

	local mycmakeargs=(
		-DWITH_NTL="$(usex ntl)"
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_DOCS="$(usex doc)"
	)

	cmake_src_configure

	if use doc; then
		# Avoid the "html/_source" directory that will contain a copy of
		# the rst sources we've already installed, and also avoid
		# installing html/objects.inv.
		HTML_DOCS="${BUILD_DIR}/html/*.html
			${BUILD_DIR}/html/*.js
			${BUILD_DIR}/html/_static"
		DOCS+=" ${BUILD_DIR}/latex/Flint.pdf"
	fi
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_build html
		cmake_build pdf
	fi
}
