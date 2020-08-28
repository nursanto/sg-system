### note bonding

```
network:
    bonds:
        bond0:
            addresses:
            - 10.10.10.10/24
            interfaces:
            - ens192
            - ens224
            nameservers: {}
            parameters:
                lacp-rate: slow
                mode: 802.3ad
                transmit-hash-policy: layer2
    ethernets:
        ens160:
            addresses:
            - 192.168.26.45/24
            gateway4: 192.168.26.1
            nameservers:
                addresses:
                - 8.8.8.8
        ens192: {}
        ens224: {}
    version: 2
    vlans:
        bond0.20:
            addresses:
            - 20.20.20.20/24
            id: 20
            link: bond0
            nameservers: {}
```




```
network:
    version: 2
    renderer: networkd
    bonds:
        bond0:
            interfaces: [ix0, ix1]
            dhcp4: false
            parameters:
                mode: 802.3ad
            nameservers:
                search: [google.com]
                addresses: [1.1.1.1, 8.8.8.8]
            dhcp4: false
            optional: true
vlans:
    vlan.11:
        id: 11
        link: bond0
        addresses: [10.19.7.5/26]
        gateway4: 10.19.7.1
```