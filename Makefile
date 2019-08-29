#CONFIGURABLES
project := storj-bill
region := us-east1
zone := us-east1-c

#MAKE CRUFT
.DEFAULT_GOAL := run
.PHONY : install run clean gcloud
OK := 1>/dev/null 2>&1 && echo true || echo false

#DOCKER BUILD AND CONFIG CREATION
SETUP := winpty docker run -it --mount type=bind,source="$(CURDIR)/config",target=/home/storj/.local/share/storj --rm storjlabs/kub/setup
install :
	docker build -f gcloud/Dockerfile --tag=storjlabs/kub/gcloud .
	docker build -f setup/Dockerfile --tag=storjlabs/kub/setup .
	docker build -f satellite/Dockerfile --tag=storjlabs/kub/satellite .
	$(eval IF = $$(shell ls "$(CURDIR)/config/satellite" $(OK)))
	$(IF) || $(SETUP) //satellite setup
	$(eval IF = $$(shell ls "$(CURDIR)/config/identity/satellite" $(OK)))
	$(IF) || $(SETUP) //identity create satellite --difficulty 0

#--user storj:storj
SATELLITE := winpty docker run -it --mount type=bind,source="$(CURDIR)/config",target=/home/storj/.local/share/storj --rm storjlabs/kub/satellite
run : install	
	 $(SATELLITE) //satellite run

clean :
	docker rmi storjlabs/kub/gcloud
	docker rmi storjlabs/kub/buildbase
	docker rmi storjlabs/kub/satellite

gcloud :
	# -e GOOGLE_APPLICATION_CREDENTIALS CLOUDSDK_CORE_PROJECT
	$(eval IF = $$(shell gcloud auth print-access-token $(OK)))
	$(IF) || gcloud auth login
	gcloud config set project ${project}
	gcloud config set compute/region ${region}
	gcloud config set compute/zone ${zone}
	gcloud services enable deploymentmanager.googleapis.com

