{ self, inputs, ... }: {
  flake.nixosModules.myMachineHardware = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [
      "vmd"
      "xhci_pci"
      "ahci"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];

    boot.initrd.kernelModules = [ ];

    boot.kernelModules = [
      "kvm-intel"
    ];

    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/b528a1ea-c2f0-4fed-a83e-c951f083996f";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/E54A-077F";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    swapDevices = [
      {
        device = "/dev/disk/by-uuid/3058ed2d-a6f9-46d8-8dad-7fa7d62f6297";
      }
    ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    hardware.cpu.intel.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
