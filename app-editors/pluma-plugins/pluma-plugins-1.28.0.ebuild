# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MATE_LA_PUNT="yes"

PYTHON_COMPAT=( python3_{9..13} )

inherit mate python-single-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="A set of plugins for Pluma, the MATE text editor."
LICENSE="FDL-1.1+ GPL-2+ LGPL-2+"
SLOT="0"

IUSE="+python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	>=dev-libs/libpeas-1.14.1:0[gtk]
	>=app-editors/pluma-1.28.0
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.9:3
	>=x11-libs/gtksourceview-4.0.2:4

	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			app-editors/pluma[${PYTHON_SINGLE_USEDEP}]
			dev-libs/libpeas:0[python,${PYTHON_SINGLE_USEDEP}]
			>=dev-python/dbus-python-0.82[${PYTHON_USEDEP}]
			dev-python/pycairo[${PYTHON_USEDEP}]
			dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
			>=dev-python/dbus-python-0.82[${PYTHON_USEDEP}]
			>=x11-libs/vte-0.52:2.91[introspection]
		')
		>=x11-libs/gtk+-3.9:3[introspection]
		>=x11-libs/gtksourceview-4.0.2:4[introspection]
		x11-libs/pango[introspection]
		x11-libs/gdk-pixbuf:2[introspection]

	)"

DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myeconfargs=(
		$(use_enable python)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	mate_src_install
	use python && python_optimize "${ED}/usr/$(get_libdir)/gedit/plugins/"
}
