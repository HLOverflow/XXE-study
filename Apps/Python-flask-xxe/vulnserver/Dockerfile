FROM python:2.7
COPY ./src /app
WORKDIR /app
RUN pip install -r requirements.txt

# To demonstrate SSRF AWS, comment the following out if not required.
RUN apt-get update && apt-get install -y iptables
COPY ./setup-aws-simulator.sh /
RUN chmod +x /setup-aws-simulator.sh
ENTRYPOINT /setup-aws-simulator.sh && python app.py
#ENTRYPOINT python app.py
