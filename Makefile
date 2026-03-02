image:
	docker build -t nanobot:latest .

deploy-image:
	DOCKER_HOST=ssh://pi@expobrain.hopto.org docker build \
		--platform linux/arm64 \
		-t nanobot .

deploy: deploy-image
	ansible-galaxy collection install "community.docker:>=3.10"
	ansible-galaxy collection install "ansible.posix:>=1.5"
	doppler run -- ansible-playbook -v -i ansible/hosts ansible/site.yml

up: image
	doppler run -- docker compose up -d

down:
	doppler run -- docker compose down

restart: image
	doppler run -- docker compose restart

logs:
	docker logs -f nanobot-gateway