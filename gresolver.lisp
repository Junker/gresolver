(in-package #:gresolver)

(defvar *resolver* (gio:resolver-default))

(defun lookup-by-name (hostname &key family)
  "resolves hostname to determine its associated IP address(es).
   key :FAMILY can be :IPV4 or :IPV6.
   e.g.: (lookup-by-name \"example.org\" :family :ipv4)"
  (check-type hostname string)
  (let ((flags (ecase family
                 (:ipv4 gio:+resolver-name-lookup-flags-ipv4-only+)
                 (:ipv6 gio:+resolver-name-lookup-flags-ipv6-only+)
                 ((nil) gio:+resolver-name-lookup-flags-default+))))
    (mapcar (lambda (ptr)
              (gio:inet-address-to-string (gir-wrapper:pointer-object ptr 'gio:inet-address)))
            (glist-list (gio:resolver-lookup-by-name-with-flags *resolver* hostname flags nil)))))

(defun lookup-by-address (address)
  "reverse-resolves address to determine its associated hostname."
  (check-type address string)
  (gio:resolver-lookup-by-address *resolver* (gio:make-inet-address :string address) nil))

(defun lookup-service (service protocol domain)
  "performs a DNS SRV lookup for the given service and protocol in the given domain and returns a list of records
   e.g.: (lookup-service \"ldap\" \"tcp\" \"example.org\")"
  (check-type service string)
  (check-type protocol string)
  (mapcar (lambda (ptr)
            (let ((srv (gir-wrapper:pointer-object ptr 'gio:srv-target)))
              (list :hostname (gio:srv-target-hostname srv)
                    :port (gio:srv-target-port srv)
                    :weight (gio:srv-target-weight srv)
                    :priority (gio:srv-target-priority srv))))
          (glist-list (gio:resolver-lookup-service *resolver* service protocol domain nil))))


(defun lookup-records (rrname record-type)
  "performs a DNS record lookup for the given rrname and returns a list of records
   record-type can be one of (:SRV :MX :TXT :SOA :NS).
   e.g.: (lookup-records \"example.org\" :txt)"
  (check-type rrname string)
  (let ((grectype (ecase record-type
                    (:srv gio:+resolver-record-type-srv+)
                    (:mx gio:+resolver-record-type-mx+)
                    (:txt gio:+resolver-record-type-txt+)
                    (:soa gio:+resolver-record-type-soa+)
                    (:ns gio:+resolver-record-type-ns+))))
    (mapcar (lambda (ptr)
              (let ((srv (gir-wrapper:pointer-object ptr 'glib:variant)))
                (case record-type
                  (:srv (list :priority (variant-uint16 (variant-get-child-value srv 0))
                              :weight (variant-uint16 (variant-get-child-value srv 1))
                              :port (variant-uint16 (variant-get-child-value srv 2))
                              :hostname (variant-string (variant-get-child-value srv 3))))
                  (:mx (list :preference (variant-uint16 (variant-get-child-value srv 0))
                             :hostname (variant-string (variant-get-child-value srv 1))))
                  (:txt (variant-strv (variant-get-child-value srv 0)))
                  (:soa (list :name-server (variant-string (variant-get-child-value srv 0))
                              :administrator (variant-string (variant-get-child-value srv 1))
                              :serial (variant-uint32 (variant-get-child-value srv 2))
                              :refresh-interval (variant-uint32 (variant-get-child-value srv 3))
                              :retry-interval (variant-uint32 (variant-get-child-value srv 4))
                              :expire-timeout (variant-uint32 (variant-get-child-value srv 5))
                              :ttl (variant-uint32 (variant-get-child-value srv 6))))
                  (:ns (variant-string (variant-get-child-value srv 0))))))
            (glist-list (gio:resolver-lookup-records *resolver* rrname grectype nil)))))
