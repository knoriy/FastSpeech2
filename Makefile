# outside container
## docker image and container details
Docker_name		= knoriy/fastspeech2
container_name	= fastspeech2

## forwards ports
# ports 			= -p 8888:8888

## set volume directory
volume_dir 		= $(shell pwd):/workspace
dataset_dir		= /home/knoriy/Documents/dataset/:/Datasets
emns_dataset_dir= /home/knoriy/Documents/phd/EMNS/data/:/emns-datasets

build:
	@docker build . -t $(Docker_name)

build_nocache:
	@docker build --no-cache . -t $(Docker_name)

run:
	@docker run -it -d --rm --gpus=all $(ports) -v $(volume_dir) -v $(dataset_dir) -v $(emns_dataset_dir) --name $(container_name) $(Docker_name)

lab:
	@docker run -it -d --rm --gpus=all $(ports) -e type=lab -v $(volume_dir) -v $(dataset_dir) -v $(emns_dataset_dir) --name $(container_name) $(Docker_name) || jupyter ${type} --ip 0.0.0.0 --no-browser --allow-root

bash:
	@docker run -it --rm --gpus=all $(ports) -v $(volume_dir) -v $(dataset_dir) -v $(emns_dataset_dir) --name $(container_name) $(Docker_name) bash || docker exec -it $(container_name) bash

# In container
## config Dirs
preprocess_config_path = /workspace/config/LJSpeech/preprocess.yaml
model_config_path = /workspace/config/LJSpeech/model.yaml
train_config_path = /workspace/config/LJSpeech/train.yaml

## sythesise variables
restore_step = 1000

train:
	@python train.py -p $(preprocess_config_path) -m $(model_config_path) -t  $(train_config_path)

single_synth:
	@python synthesize.py --restore_step $(restore_step) --mode single -p $(preprocess_config_path) -m $(model_config_path) -t $(train_config_path) --text 'Hello Deep Learning'