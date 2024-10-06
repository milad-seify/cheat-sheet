# Adding a New OSD Server to Ceph Cluster

This guide provides step-by-step instructions to add a new OSD server to your Ceph cluster using `cephadm` and related commands.

## Requirements

Before starting, ensure that:
- Docker is installed on the new OSD server.
- SSH access is configured from the Ceph cluster's admin node to the new server.

## Steps

### Step 1: Download and Install `cephadm`

Download and set executable permissions for `cephadm`:

```bash
curl --silent --remote-name --location https://github.com/ceph/ceph/raw/pacific/src/cephadm/cephadm
chmod +x cephadm

### Step 2: Add Ceph Repository and Install Packages

sudo ./cephadm add-repo --release pacific
sudo ./cephadm install
cephadm install ceph-common

### Step 3: List Current Hosts (Run this on You monitor Server)

ceph orch host ls --detail

### Step 4: Set Up SSH Access to the New OSD Host

ssh-copy-id -f -i /etc/ceph/ceph.pub root@<new-host>

### Step 5: Add the New OSD Host to the Cluster

ceph orch host add <newhost> [<ip>] [<label1> ...]
Exmaple: ceph orch host add host4 10.10.0.104 --labels _admin

### Step 6: Apply OSDs to All Available Devices

cephadm shell -- ceph orch apply osd --all-available-devices

### Step 7: Verify OSD Status and List Devices

ceph-volume lvm list
ceph orch device ls --wide --refresh
```

