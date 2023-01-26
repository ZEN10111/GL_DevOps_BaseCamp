FROM nginx
RUN rm -rf /usr/share/nginx/html/index.html
ADD . /usr/share/nginx/html/
RUN sed -i "s/%%hostname%%/$(hostname)/" /usr/share/nginx/html/index.html