# Day 75: Expanding and Managing Disk Storage

## Project Description

As the Nautilus project scales, the initial storage allocations have reached their limits. To prevent service disruption and accommodate larger datasets, the DevOps team must perform both **Vertical Scaling** of existing storage and **Storage Expansion** via a secondary volume. This task involves resizing the OS disk of the `xfusion-vm` and provisioning a new managed HDD disk to be mounted as a persistent data tier.

**The Goal:**

1. Resize the `xfusion-vm` OS disk from 32 GiB to 64 GiB.
2. Provision and mount a new 64 GiB Standard HDD named `xfusion-disk` to `/mnt/xfusion-disk`.

## Technical Specifications

| Requirement | Specification |
| :--- | :--- |
| **VM Name** | `xfusion-vm` |
| **OS Disk Change** | 32 GiB ➡️ 64 GiB |
| **New Data Disk** | `xfusion-disk` |
| **Disk Type** | Standard HDD |
| **New Disk Size** | 64 GiB |
| **Mount Point** | `/mnt/xfusion-disk` |

---

## Steps & Configuration

### 1. Expand the Existing OS Disk

*Note: Azure requires the VM to be **Deallocated** before resizing the OS disk.*

1. Navigate to **Virtual Machines** > `xfusion-vm`.
2. Click **Stop** to deallocate the VM and wait for the status to show "Stopped (deallocated)".
3. In the sidebar, select **Disks**.
4. Click on the name of the **OS Disk**.
5. Under **Settings**, select **Size + performance**.
6. Change the size to **64 GiB** and click **Resize**.

### 2. Create and Attach the New Data Disk

1. Navigate back to the **Disks** blade of `xfusion-vm`.
2. Under **Data disks**, select **Create and attach a new disk**.
3. **Disk name:** `xfusion-disk`.
4. **Storage type:** `Standard HDD`.
5. **Size (GiB):** `64`.
6. Click **Save** at the top of the page.

### 3. Start the VM and Initialize Storage

1. **Start** the `xfusion-vm`.
2. SSH into the VM from the `azure-client`.
3. Identify the new disk (usually `/dev/sdc`):

    ```bash
    lsblk
    ```

4. Format the disk and create the mount point:

    ```bash
    sudo mkfs -t ext4 /dev/sdc
    sudo mkdir -p /mnt/xfusion-disk
    sudo mount /dev/sdc /mnt/xfusion-disk
    ```

5. **Persist the mount:** Add the UUID to `/etc/fstab` to ensure it survives reboots.
6. **Resize Partition:** For the OS disk, use `sudo resize2fs /dev/sda1` (or the appropriate partition) to ensure the OS sees the new 64 GiB.

---

## Verification

1. **Disk Size:** Confirmed `df -h` shows the expanded OS partition and the new 64 GiB mount at `/mnt/xfusion-disk`.
2. **Portal Check:** Verified both disks show a state of "Attached" and the correct 64 GiB sizes in the Azure Portal.

## 🧠 Theory: Vertical vs. Horizontal Storage Scaling

* **Vertical Scaling (OS Disk Resize):** This involves increasing the capacity of an existing volume. While the Portal handles the physical resize, the Linux kernel requires a command like `resize2fs` to expand the filesystem into the newly available space.
* **Horizontal Scaling (Adding Data Disks):** Attaching a new LUN (Logical Unit Number) is the preferred way to scale storage for applications. It isolates app data from system files, simplifying backups.
* **Standard HDD (LRS):** We selected Standard HDD to optimize costs for bulk storage in the East US region while maintaining triple replication for durability.
![alt text](image.png)
![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)
![alt text](image-4.png)
![alt text](image-5.png)
![alt text](image-6.png)
![alt text](image-7.png)
![alt text](image-8.png)
![alt text](image-9.png)
![alt text](image-10.png)
![alt text](image-11.png)
sudo mkdir -p /mnt/devops-disk
azureuser@devops-vm:~$ sudo mount /dev/sdc /mnt/devops-disk
azureuser@devops-vm:~$ sudo blkid /dev/sdc
/dev/sdc: UUID="46adfc25-b298-432a-bf97-2a849e4c05f9" BLOCK_SIZE="4096" TYPE="ext4"

![alt text](image-12.png)

![alt text](image-13.png)
![alt text](image-14.png)
![alt text](image-15.png)
![alt text](image-16.png)
![alt text](image-17.png)
![alt text](image-18.png)

azureuser@xfusion-vm:~$ lsblk
NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0     7:0    0 63.8M  1 loop /snap/core20/2717
loop1     7:1    0 91.4M  1 loop /snap/lxd/36918
loop2     7:2    0 48.1M  1 loop /snap/snapd/25935
sda       8:0    0   64G  0 disk
sdb       8:16   0   64G  0 disk
├─sdb1    8:17   0 63.9G  0 part /
├─sdb14   8:30   0    4M  0 part
└─sdb15   8:31   0  106M  0 part /boot/efi
sdc       8:32   0    4G  0 disk
└─sdc1    8:33   0    4G  0 part /mnt

![alt text](image-19.png)
sudo mkfs -t ext4 /dev/sda
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done
Creating filesystem with 16777216 4k blocks and 4194304 inodes
Filesystem UUID: 6fb92d94-cf49-4ba8-9265-61b6801c9219
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424

Allocating group tables: done
Writing inode tables: done
Creating journal (131072 blocks): done
Writing superblocks and filesystem accounting information: done

![alt text](image-20.png)

sudo mkfs -t ext4 /dev/sda
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done
Creating filesystem with 16777216 4k blocks and 4194304 inodes
Filesystem UUID: 6fb92d94-cf49-4ba8-9265-61b6801c9219
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424

Allocating group tables: done
Writing inode tables: done
Creating journal (131072 blocks): done
Writing superblocks and filesystem accounting information: done

azureuser@xfusion-vm:~$ sudo mkdir -p /mnt/xfusion-disk
azureuser@xfusion-vm:~$ sudo mount /dev/sda /mnt/xfusion-disk
azureuser@xfusion-vm:~$ sudo blkid /dev/sda
/dev/sda: UUID="6fb92d94-cf49-4ba8-9265-61b6801c9219" BLOCK_SIZE="4096" TYPE="ext4"

![alt text](image-21.png)
![alt text](image-22.png)

![alt text](image-23.png)
![alt text](image-24.png)

![alt text](image-25.png)
