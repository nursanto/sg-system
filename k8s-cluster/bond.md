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
