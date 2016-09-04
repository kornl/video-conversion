
# This script is mostly a summary with checks of the commands from 
# https://trac.ffmpeg.org/wiki/UbuntuCompilationGuide
# The following directories are created/must exist:
# ~/ffmpeg_sources - could be deleted afterwards
# ~/ffmpeg_build
# ffmpeg, ffplay, ffprobe, ffserver and x264 are added to ~/bin/

sudo apt-get update

sudo apt-get -y install autoconf automake build-essential git libass-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libx11-dev \
  libxext-dev libxfixes-dev pkg-config texi2html zlib1g-dev libopus-dev git yasm \
  libmp3lame-dev libvpx-dev libfaac-dev

mkdir ~/ffmpeg_sources

# x264

cd ~/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264.git
cd x264
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install
make distclean

# ffmpeg

cd ~/ffmpeg_sources
git clone --depth 1 git://source.ffmpeg.org/ffmpeg
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig"
export PKG_CONFIG_PATH
./configure --prefix="$HOME/ffmpeg_build" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --bindir="$HOME/bin" --extra-libs="-ldl" --enable-gpl --enable-libass --enable-libfdk-aac \
  --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx \
  --enable-libx264 --enable-nonfree --enable-x11grab --enable-libfaac
make
make install
make distclean
hash -r
