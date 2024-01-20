.PHONY: checkout-config

checkout-config:
	git clone https://github.com/pauldotknopf/3dprinter config


.PHONY: publish
publish:
	rsync -avh --delete --exclude '.git' --exclude '*.bpk' ./config/ pknopf@3dprinter.local:printer_data/config
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/firmware_restart"

.PHONY: restart
restart:
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/restart"

.PHONY: reboot
reboot:
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/machine/reboot"