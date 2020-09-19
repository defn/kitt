SHELL := /bin/bash

menu:
	@perl -ne 'printf("%10s: %s\n","$$1","$$2") if m{^([\w+-]+):[^#]+#\s(.+)$$}' Makefile

clean:
	docker network rm kitt || true
	sudo ip link del dummy0 || true

setup:
	$(MAKE) clean
	$(MAKE) network || true
	$(MAKE) dummy

kitt:
	docker-compose rm -f -s
	docker-compose up -d --remove-orphans

restore:
	set -a; source .env; set +a; $(MAKE) restore-inner

restore-inner:
	mkdir -p etc/traefik/acme
	pass kitt/$(KITT_DOMAIN)/acme.json | base64 -d > etc/traefik/acme/acme.json
	chmod 0600 etc/traefik/acme/acme.json
	pass kitt/$(KITT_DOMAIN)/authtoken.secret | perl -pe 's{\s*$$}{}'  > etc/zerotier/zerotier-one/authtoken.secret
	pass kitt/$(KITT_DOMAIN)/identity.public | perl -pe 's{\s*$$}{}' > etc/zerotier/zerotier-one/identity.public
	pass kitt/$(KITT_DOMAIN)/identity.secret | perl -pe 's{\s*$$}{}' > etc/zerotier/zerotier-one/identity.secret
	pass kitt/$(KITT_DOMAIN)/hook-start | base64 -d > etc/zerotier/hooks/hook-start

network:
	docker network create kitt

dummy:
	sudo ip link add dummy0 type dummy || true
	sudo ip addr add 169.254.32.1/32 dev dummy0 || true
	sudo ip link set dev dummy0 up
