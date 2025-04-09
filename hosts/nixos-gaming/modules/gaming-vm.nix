let
  # RTX 3070 Ti
  gpuIDs = [
    "10de:1f02" # Graphics
    "10de:10f9" # Audio
  ];
in
{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
        # Don't isolate GPU at boot time for single GPU passthrough
        # "vfio-pci.ids=${lib.concatStringsSep "," gpuIDs}"
      ];
    };

    # Enable virtualization features
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };

    # Create hook scripts for GPU binding/unbinding
    environment.etc = {
      "libvirt/hooks/qemu" = {
        text = ''
          #!/run/current-system/sw/bin/bash

          GUEST_NAME="$1"
          HOOK_NAME="$2"
          STATE_NAME="$3"
          MISC="$4"

          BASEDIR="$(dirname $0)"

          # Only execute for your Windows VM
          if [ "$GUEST_NAME" = "windows" ]; then
            hook="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"
            if [ -f "$hook" ]; then
              "$hook" "$@"
            fi
          fi
        '';
        mode = "0755";
      };

      "libvirt/hooks/qemu.d/windows/prepare/begin/start.sh" = {
        text = ''
          #!/run/current-system/sw/bin/bash

          # Stop display manager
          systemctl stop display-manager

          # Unbind GPU and bind to VFIO
          /run/current-system/sw/bin/bash /etc/libvirt/hooks/vfio-startup.sh
        '';
        mode = "0755";
      };

      "libvirt/hooks/qemu.d/windows/release/end/stop.sh" = {
        text = ''
          #!/run/current-system/sw/bin/bash

          # Unbind from VFIO and rebind to original drivers
          /run/current-system/sw/bin/bash /etc/libvirt/hooks/vfio-teardown.sh

          # Restart display manager
          systemctl start display-manager
        '';
        mode = "0755";
      };

      "libvirt/hooks/vfio-startup.sh" = {
        text = ''
          #!/run/current-system/sw/bin/bash

          # Unbind VTconsoles
          echo 0 > /sys/class/vtconsole/vtcon0/bind
          echo 0 > /sys/class/vtconsole/vtcon1/bind 2>/dev/null

          # Unbind EFI Framebuffer
          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

          # Unload NVIDIA drivers
          modprobe -r nvidia_drm
          modprobe -r nvidia_modeset
          modprobe -r nvidia_uvm
          modprobe -r nvidia

          # Load VFIO driver
          modprobe vfio
          modprobe vfio_pci
          modprobe vfio_iommu_type1

          # Bind GPU to VFIO
          for dev in ${lib.concatStringsSep " " gpuIDs}; do
            vendor=$(echo $dev | cut -d':' -f1)
            device=$(echo $dev | cut -d':' -f2)
            if [ -e /sys/bus/pci/devices/*:*:*.0/vendor ]; then
              dev_path=$(grep -l "$vendor" /sys/bus/pci/devices/*:*:*.0/vendor | sed 's/vendor//')
              if grep -q "$device" $dev_path/device; then
                dev_id=$(basename $(dirname $dev_path))
                echo "vfio-pci" > $dev_path/driver_override
                echo "$dev_id" > /sys/bus/pci/drivers/vfio-pci/bind
              fi
            fi
          done
        '';
        mode = "0755";
      };

      "libvirt/hooks/vfio-teardown.sh" = {
        text = ''
          #!/run/current-system/sw/bin/bash

          # Unload VFIO driver
          modprobe -r vfio_pci
          modprobe -r vfio_iommu_type1
          modprobe -r vfio

          # Load NVIDIA drivers
          modprobe nvidia
          modprobe nvidia_modeset
          modprobe nvidia_uvm
          modprobe nvidia_drm

          # Rebind VTconsoles
          echo 1 > /sys/class/vtconsole/vtcon0/bind
          echo 1 > /sys/class/vtconsole/vtcon1/bind 2>/dev/null

          # Rebind EFI Framebuffer
          echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind
        '';
        mode = "0755";
      };
    };

    hardware.opengl.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    # Make sure directory structure exists
    system.activationScripts.libvirtHooks = ''
      mkdir -p /etc/libvirt/hooks/qemu.d/windows/{prepare/begin,release/end}
    '';

    # Install required tools
    environment.systemPackages = with pkgs; [
      virt-manager
      OVMF
      pciutils
      usbutils
    ];
  };
}
