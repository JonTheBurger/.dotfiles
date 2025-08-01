sudo dnf install \
  ShellCheck \
  nodejs-bash-language-server \
  shfmt

sudo dnf install \
  hatch \
  ruff \

sudo dnf install \
  ccache \
  clang \
  clang-tools-extra \
  cmake \
  cppcheck \
  doxygen \
  iwyu \
  mold \
  ninja-build \
  srecord \
  valgrind \

sudo dnf install \
  thunderbird \

uv tool install konsave --with setuptools
git clone https://github.com/vinceliuice/Layan-kde.git ~/.local/src/Layan-kde
sudo dnf install \
  kio-gdrive \
  kvantum \
  kcron \
  kfind \
  kde-gtk-config \

sudo dnf install rustup
rustup-init
rustup component add rust-analyzer
sudo dnf install lldb

sudo dnf install \
  steam-devices

flatpak install flathub app/com.spotify.Client/x86_64/stable

# Davinci Resolve
export SKIP_PACKAGE_CHECK=1
sudo dnf install \
  apr \
  apr-util \
  libcurl \
  libcurl-devel \
  libxcrypt-compat \
  mesa-libGLU \
  rocm-opencl-devel \
  rocm-runtime-devel \
  zlib
# install
sudo mkdir -p /opt/resolve/libs/disabled-libraries
sudo mv libglib* disabled-libraries
sudo mv libgio* disabled-libraries
sudo mv libgmodule* disabled-libraries

# https://docs.fedoraproject.org/en-US/quick-docs/virtualization-getting-started/
sudo dnf install \
  @virtualization \
  libvirt \
  libvirt-daemon-driver-network \
  libvirt-daemon-driver-nodedev \
  libvirt-daemon-driver-qemu \
  libvirt-daemon-driver-storage-core \
  qemu-audio-spice \
  qemu-char-spice \
  qemu-device-display-qxl \
  qemu-device-display-virtio-gpu \
  qemu-device-display-virtio-vga \
  qemu-device-usb-redirect \
  qemu-system-x86-core \
  virt-install \
  virt-manager \
  virt-top
sudo systemctl enable libvirtd

# sudo dnf install obs-studio xdg-desktop-portal xdg-desktop-portal-gtk pipewire
sudo dnf install obs-studio obs-studio-plugin-vaapi gstreamer1-vaapi
# https://rpmfusion.org/Howto/Multimedia
sudo dnf install libavcodec-freeworld h264enc x264 x265 --allowerasing
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

git https://github.com/Deathbyteacup/fluentbird.git ~/.local/src/fluentbird

# steam
flatpak permission-set kde-authorized remote-desktop "" yes
flatpak permission-set kde-authorized remote-desktop com.valvesoftware.Steam yes
flatpak override com.valvesoftware.Steam --talk-name=org.kde.KWin
# to undo: flatpak override --reset com.valvesoftware.Steam
