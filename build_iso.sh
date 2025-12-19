#!/usr/bin/env bash
set -e

# -------- Configuration --------
PROJECT_DIR="$HOME/capbox-custom-os"
KERNEL_NAME="capbox"
TOOLCHAIN_PREFIX="x86_64-linux-gnu-"
ISO_NAME="capbox.iso"

# -------- Enter project --------
cd "$PROJECT_DIR"

echo "==> Cleaning old build..."
make clean

echo "==> Building kernel..."
make TOOLCHAIN_PREFIX="${TOOLCHAIN_PREFIX}"

echo "==> Preparing ISO directory..."
rm -rf iso_root "$ISO_NAME"
mkdir -p iso_root/boot iso_root/boot/limine iso_root/EFI/BOOT

echo "==> Copying kernel..."
cp -v "bin/${KERNEL_NAME}" iso_root/boot/

echo "==> Copying Limine config and boot files..."
cp -v limine.conf \
  limine/limine-bios.sys \
  limine/limine-bios-cd.bin \
  limine/limine-uefi-cd.bin \
  iso_root/boot/limine/

echo "==> Copying EFI loaders..."
cp -v limine/BOOTX64.EFI iso_root/EFI/BOOT/
cp -v limine/BOOTIA32.EFI iso_root/EFI/BOOT/

echo "==> Creating bootable ISO..."
xorriso -as mkisofs -R -r -J \
  -b boot/limine/limine-bios-cd.bin \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -hfsplus -apm-block-size 2048 \
  --efi-boot boot/limine/limine-uefi-cd.bin \
  -efi-boot-part --efi-boot-image --protective-msdos-label \
  iso_root -o "$ISO_NAME"

echo "==> Installing Limine BIOS stages..."
./limine/limine bios-install "$ISO_NAME"


echo "Moving ISO to shared location..."
sudo cp -v "$ISO_NAME" /mnt/utm


echo "==> Done!"
echo "ISO created: $ISO_NAME"
