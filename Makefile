build:
	docker build -t simplestatapp .

run:
	docker run -d -p 8080:8080 simplestatapp

# Other useful commands
# docker ps
# docker kill <image_name>
# docker image ls simplestatapp
