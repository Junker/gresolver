# GResolver

DNS client (resolver) for Common Lisp.

## Requirements

- [GLib](https://gitlab.gnome.org/GNOME/glib) installed

## Installation

This system can be installed from [UltraLisp](https://ultralisp.org/) like this:

```common-lisp
(ql-dist:install-dist "http://dist.ultralisp.org/"
                      :prompt nil)
(ql:quickload "gresolver")
```

## Usage

```common-lisp
(gresolver:lookup-by-address "8.8.8.8")
;; "dns.google"
(gresolver:lookup-by-address "1.1.1.1")
;; "one.one.one.one"
(gresolver:lookup-by-name "one.one.one.one")
;; ("2606:4700:4700::1001" "2606:4700:4700::1111" "1.1.1.1" "1.0.0.1")
(gresolver:lookup-by-name "one.one.one.one" :family :ipv4)
;; ("1.0.0.1" "1.1.1.1")
(gresolver:lookup-records "example.org" :txt)
;; (("6r4wtj10lt2hw0zhyhk7cgzzffhjp7fl") ("v=spf1 -all"))
(gresolver:lookup-service "ldap" "tcp" "google.com")
;; ((:HOSTNAME "ldap.google.com" :PORT 389 :WEIGHT 0 :PRIORITY 5))
```
