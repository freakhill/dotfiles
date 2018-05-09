{:user {:dependencies [[org.clojure/clojure "1.9.0"]
                       #_[im.chit/lucid.git "1.3.13"]
                       #_[im.chit/lucid.graph "1.3.13"]
                       [im.chit/lucid.mind "1.3.13"]
                       #_[im.chit/lucid.query "1.3.13"]
                       #_[im.chit/lucid.system "1.3.13"]
                       #_[im.chit/lucid.package "1.3.13"]
                       #_[org.clojure/core.typed "0.5.2"]]
        :plugins      [[lein-ancient "0.6.15"]
                       [org.sonatype.aether/aether-util "1.13.1"]
                       [lein-voom "0.1.0-20170920_222746-ga58a315"]
                       [cider/cider-nrepl "0.17.0"]
                       #_[refactor-nrepl "2.3.1"]
                       #_[lein-typed "0.4.3"]
                       [lein-pprint "1.2.0"]]
        :injections   [#_(require '[lucid.git :as lgit])
                       #_(require '[lucid.graph :as lgraph])
                       (require '[lucid.mind :as lm])
                       #_(require '[lucid.package :as lpkg])
                       #_(require '[lucid.query :as lq])
                       #_(require '[lucid.system :as lsys])]}}