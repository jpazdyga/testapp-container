FROM jpazdyga/centos7-base
MAINTAINER Jakub Pazdyga <admin@lascalia.com>

ENV container docker
ENV DATE_TIMEZONE UTC

RUN rpmdb --rebuilddb && \ 
    rpmdb --initdb && \
    yum clean all && \
    yum -y update && \
    yum -y install wget \ 
		   curl \
		   bind-utils \
		   screen \
		   openssl-devel \
		   gcc \
		   openssh \
                   openssl \ 
                   openssl-libs \
                   psmisc \
                   openssh-server \
                   git \
		   httpd \
                   php \
                   php-mysqlnd

RUN useradd -d /home/jakub.pazdyga -G wheel -m -s /bin/bash jakub.pazdyga && \
	su jakub.pazdyga -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa" && \
	ssh-keygen -A && \
	echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8+v7JcUd7/phb2r9zF1zL8JbGHryykOgGBoZ9G+ducLFW5LbSasQocR1M104ucPCxKZ3PFnSM4araXp8nfP7Apw+YUwN9MVOL4A8cWqrpW/mO1roZF+g7GTyRW2V8NoJTm9iCO4tffYjk2euHYm8yVfeN+wUGOs1CU1ce1r2PyIyCEId3L7JVHsfWsPfgbirAzax/XqEiuwINWgTOv8830cMVKT35HiMUiVb6/TXtPIhLU7t67CRkPSmORiC7EadCpEU0ZNME/g2qWb/3wbMSacuA0U8i5K4Kodv8KsnSg3mrMktNpozkEdf69gEciixBw7SpeiNXaedXs6DrFc+B" > /home/jakub.pazdyga/.ssh/authorized_keys && \
	echo "jakub.pazdyga ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN sed -i \
	-e 's/^PasswordAuthentication yes/PasswordAuthentication no/g' \
	-e 's/^#PermitRootLogin yes/PermitRootLogin no/g' \
	-e 's/^#UseDNS yes/UseDNS no/g' \
	/etc/ssh/sshd_config

ADD gitsetup.sh /usr/local/bin/gitsetup.sh

RUN chmod 755 /usr/local/bin/gitsetup.sh && \
    /usr/local/bin/gitsetup.sh


COPY supervisord.conf /etc/supervisor.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-n", "-c/etc/supervisor.d/supervisord.conf"]

ENV container docker
ENV DATE_TIMEZONE UTC
VOLUME /var/log /etc
EXPOSE 22 80
USER root
