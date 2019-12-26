FROM alpine:3.7
MAINTAINER xieyingbiao xieyingbiao@yungengxin.com
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories
RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash python \
    && python -m ensurepip \
    && rm -rf /usr/lib/python*/ensurepip \
    && apk add python python-dev py-pip build-base libffi-dev openssl-dev libgcc
RUN apk add py-paramiko
# py-cffi    
RUN pip install --upgrade -i https://pypi.tuna.tsinghua.edu.cn/simple pip setuptools
COPY requirements.txt .
RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple robotframework-redislibrary 
WORKDIR /home
COPY . ./
RUN cp -rf /home/retry/unic.py /usr/lib/python2.7/site-packages/robot/utils/unic.py
RUN cp -rf /home/retry/RequestsKeywords.py /usr/lib/python2.7/site-packages/RequestsLibrary/RequestsKeywords.py
RUN mkdir /home/auto-test
RUN cp -rf /home/retry/application.py /usr/lib/python2.7/site-packages/robot/utils/application.py
WORKDIR /home/Robotframework-MongoDB-Library-master
RUN python setup.py install
WORKDIR /home
RUN rm -rf /Robotframework-MongoDB-Library-master

