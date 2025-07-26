pitillo's ports for CRUX Linux

To use these ports, download the pitillo.httpup file to /etc/ports
```
$ sudo wget -P /etc/ports https://raw.githubusercontent.com/pitill0/crux-ports-pitillo/main/pitillo.httpup
$ sudo ports -u pitillo
```
You may want to list it in /etc/prt-get.conf
```
###
### prt-get conf
###

# note: the order matters: the package found first is used
prtdir /usr/ports/core
prtdir /usr/ports/opt
prtdir /usr/ports/xorg
# prtdir /usr/ports/contrib
prtdir /usr/ports/pitillo
```
