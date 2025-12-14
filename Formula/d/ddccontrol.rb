class Ddccontrol < Formula
  desc "Control monitor parameters like brightness, contrast and others, on Linux"
  homepage "https://github.com/ddccontrol/ddccontrol"
  url "https://github.com/ddccontrol/ddccontrol/archive/refs/tags/1.0.3.tar.gz"
  sha256 "4f3a3d9a00e09b07423d2aed308b21dccfe57642f5d9bbf79802a0656dd11d1e"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pciutils" => :build
  depends_on "pkg-config" => :build
  depends_on "xz" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "i2c-tools"
  depends_on "intltool"
  depends_on "libxml2"

  def install
    # libxml2 has a quirky structure for its include headers. See:
    #  https://github.com/Homebrew/homebrew-core/issues/56402#issuecomment-644854718
    cflags_libxml2 = `pkgconf --cflags --libs pkgconf --cflags --libs libxml-2.0`.chomp
    ENV.append_to_cflags(cflags_libxml2)
    args = ["--with-libxml2=#{Formula["libxml2"].opt_prefix}"]
    system "./autogen.sh"
    system "./configure", "--disable-gnome", "--libexecdir=#{libexec}", "--sysconfdir=#{etc}", *std_configure_args, *args
    system "make"
    system "make", "install"
  end

  test do
    system "bin/ddccontrol", "-p"
  end
end
