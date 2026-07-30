# mikrotik-terraform

Full configuration of the home network's two MikroTik devices, managed with
[OpenTofu](https://opentofu.org/) and the
[terraform-routeros](https://registry.terraform.io/providers/terraform-routeros/routeros)
provider (pinned to **1.99.1** — see the quirk table in `MIGRATION-REPORT.md`
before upgrading it).

| Root module | Device | Mgmt address | State |
|---|---|---|---|
| `devices/router` | RB5009UG+S+ ("Router") | `https://192.168.0.1` | local, separate |
| `devices/switch` | CRS309-1G-8S+ ("EdgeSwitch") | `https://192.168.0.2` | local, separate |

**Everything is managed**: interfaces, bridge/VLANs, IP addressing, DHCP, DNS,
firewall (filter + NAT + rule ordering), BGP (Cilium peering), PPPoE,
certificates, services, system settings, users and groups. Deliberately *not*
managed: the 56 `Managed by ExternalDNS` DNS records (owned by the cluster's
external-dns — managing them here causes a reconciliation fight), dynamic
state (DHCP dynamic leases, dynamic bridge-VLAN rows), the `admin` account,
and all passwords (set out-of-band; the provider can't read them back).

## Day-to-day usage

The two modules are independent — separate directories, separate state files,
separate credentials. There is no "apply both at once"; `*-all` recipes just
run the devices sequentially (switch first, then router).

```sh
just              # list recipes
just plan router  # preview changes for one device
just apply router # plan → confirm → apply for one device
just plan-all     # preview both, sequentially
just drift        # quick clean/drift check for both modules
```

Raw commands, if you prefer: `tofu -chdir=devices/<device> plan|apply`.

Rules of the road:

- **The target after every change is an empty plan.** After `apply`, run
  `plan` again — it must say "No changes".
- **Firewall rules are ordinal.** The `routeros_move_items` resources in
  `firewall.tf`/`nat.tf` assert on-device order. Adding/removing/reordering a
  rule means updating the matching `sequence` list in the same change.
- After any router apply, check the switch still answers (it is managed
  in-band through the router): `just drift` or a quick
  `curl -k https://192.168.0.2`.
- Never add DNS records with comment `Managed by ExternalDNS` here, and never
  import them.
- `ether1` on each device is untagged VLAN 99 — the physical recovery port if
  an apply ever goes wrong.

## Credentials

Each module reads `terraform.tfvars` (gitignored — copy from
`example.tfvars`): `username`/`password` for the device's `terraform` user,
plus `pppoe_password` on the router. Alternatively export `ROS_USERNAME` /
`ROS_PASSWORD` and keep no tfvars. State files contain these secrets plus the
PPPoE password — treat `*.tfstate` accordingly (both are gitignored).

## User management and the `policy` right

Users and groups are in code (`users.tf` in each module), but the `terraform`
group deliberately lacks the RouterOS `policy` right, so Terraform can *read
and import* users but any *modification* fails with "not enough permissions".
To let Terraform manage users fully, run on the device as an admin user:

```
/user group set terraform policy=reboot,read,write,test,sensitive,api,romon,rest-api,policy
```

…and add `"policy"` to the `routeros_system_user_group.terraform` list in
that module's `users.tf` in the same change (otherwise the next plan shows
drift). Trade-off to be aware of: with `policy`, the terraform credential can
create users — i.e. it is admin-equivalent.

Gotcha learned the hard way: any group that uses the REST API needs **both**
`rest-api` *and* `api`. REST executes through the API subsystem internally;
without `api` every request fails with `login failure ... via api` even
though the binary API service is disabled.

## Bootstrapping

### A workstation (repo already live)

1. Install `tofu` (>= 1.12) and optionally `just`.
2. `just init-all`
3. Create `devices/*/terraform.tfvars` from the `example.tfvars` files.
4. `just plan-all` — both must show "No changes".

### A fresh/replacement device

This repo *adopts* live devices: `imports.tf` in each module pins RouterOS
internal ids from the current hardware. For a factory-fresh device:

1. Minimal manual bootstrap on the device console (see `MIGRATION-BRIEF.md`
   §3 for the full versions):

   ```
   /certificate add name=local-root-cert common-name=local-cert key-size=prime256v1 key-usage=key-cert-sign,crl-sign days-valid=3650
   /certificate sign local-root-cert
   /certificate set local-root-cert trusted=yes
   /certificate add name=webfig common-name=<mgmt-ip> days-valid=3650 key-size=prime256v1 key-usage=key-cert-sign,crl-sign,digital-signature,key-agreement,tls-server
   /certificate sign webfig ca=local-root-cert
   /certificate set webfig trusted=yes
   /ip service set www-ssl certificate=webfig disabled=no
   /user group add name=terraform policy=reboot,read,write,test,sensitive,api,romon,rest-api,policy
   /user add name=terraform group=terraform password="<strong password>" address=10.0.10.0/24,192.168.0.0/24
   ```

2. Regenerate the module's `imports.tf` ids: `scripts/dump-ids.sh` dumps every
   relevant menu with `.id`s over REST. Rows that don't exist yet on the fresh
   device need their import blocks removed (Terraform will create them); rows
   that ship with RouterOS (services, default routes, ethernet ports,
   singletons) need their new ids substituted.
3. Set passwords for any user resources out-of-band after the first apply.
4. Apply section by section (system → services → L2 → L3 → firewall → BGP),
   re-planning to empty after each — the order and blast-radius notes in
   `MIGRATION-BRIEF.md` §11 apply to a rebuild too.

## Other docs

- `MIGRATION-BRIEF.md` — the original migration plan; §5/§7 explain the
  singleton-overwrite trap and the lockout hazards. Still the best reference
  for *why* things are shaped this way.
- `MIGRATION-REPORT.md` — what was migrated, security findings and their
  resolutions, and the provider v1.99.1 quirk table.
- `JUMBO-FRAMES-BRIEF.md` — current jumbo-frame state and the task brief if
  full L3 jumbo is ever wanted.
