# Ceph Cluster OSD and Monitor Node Removal

## Introduction

This document outlines the step-by-step process for removing OSDs and a monitor node from a Ceph cluster. The process includes reweighting and removing OSDs, stopping services, and cleaning up the cluster configuration. Additionally, it covers removing a monitor and associated manager daemon.

## OSD Removal Process

Follow these steps to safely remove OSDs from the Ceph cluster.

### Step 1: Check the OSD Tree

Run the following command to check the OSD tree and identify the OSDs you want to remove:
```bash
ceph osd tree
### Step 2: Reweight the OSDs
ceph osd reweight osd.3 0.8
ceph osd reweight osd.3 0.5
ceph osd reweight osd.3 0.2
ceph osd reweight osd.3 0
### Step 3: Mark OSDs as Down
ceph osd down osd.1 osd.3 osd.6 osd.9
### Step 4: Stop the OSD Services
systemctl stop ceph-osd@1
systemctl stop ceph-osd@3
systemctl stop ceph-osd@6
systemctl stop ceph-osd@9
### Step 5: Mark OSDs as Out
ceph osd out osd.1
ceph osd out osd.3
ceph osd out osd.6
ceph osd out osd.9
### Step 6: Remove OSDs from the Cluster
ceph osd rm osd.1
ceph osd rm osd.3
ceph osd rm osd.6
ceph osd rm osd.9
### Step 7: Remove OSDs from the CRUSH Map
ceph osd crush remove osd.1
ceph osd crush remove osd.3
ceph osd crush remove osd.6
ceph osd crush remove osd.9
```

## Monitor Node Removal Process
Here’s how to remove a monitor node from the Ceph cluster.

```bash
### Step 1: Drain the Monitor Node
ceph orch host drain mon3
### Step 2: Remove the Monitor Node
ceph orch host rm mon3
### Step 3: Reapply the Manager Daemon (If necessary, reapply the manager daemon to another node)
ceph orch apply mgr ceph4
### Step 4: Verify Daemon Status
ceph orch ps
### Step 5: Remove the Old Manager Daemon
ceph orch daemon rm mgr.mon3.tmsvmk
```
