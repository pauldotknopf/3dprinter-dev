
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

.PHONY: home_and_level
home_and_level:
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G28"
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=QUAD_GANTRY_LEVEL"

.PHONU: prep_for_z_calib
prep_for_z_calib:
	make home_and_level
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=CENTER_XY"
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G90"
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G0%20Z10"

.PHONU: z_calib_free
z_calib_free:
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G0%20Z10"
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G0%20Z0.2"

.PHONU: z_calib_scuffing
z_calib_scuffing:
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G0%20Z10"
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G0%20Z0.1"

.PHONU: z_calib_touching
z_calib_touching:
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G0%20Z10"
	ssh pknopf@3dprinter.local "curl -s -X POST localhost:7125/printer/gcode/script?script=G0%20Z0.0"
