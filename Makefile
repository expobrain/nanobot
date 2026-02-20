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

up:
	doppler run -- docker compose up -d --build --remove-orphans

down:
	doppler run -- docker compose down

make restart:
	doppler run -- docker compose restart