(defsystem "gresolver"
  :version "0.1.0"
  :author "Dmitrii Kosenkov"
  :license "MIT"
  :depends-on ("cl-gio" "cl-glib")
  :description "DNS client"
  :homepage "https://github.com/Junker/gresolver"
  :source-control (:git "https://github.com/Junker/gresolver.git")
  :components ((:file "package")
               (:file "gresolver")))
