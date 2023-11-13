(defpackage gresolver
  (:use #:cl)
  (:import-from #:glib
                #:glist-list
                #:variant-string
                #:variant-uint32
                #:variant-uint16
                #:variant-get-child-value
                #:variant-strv)
  (:export #:lookup-by-name
           #:lookup-by-address
           #:lookup-service
           #:lookup-records))
