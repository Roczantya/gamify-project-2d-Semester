FROM nginx:alpine

# Copy 'isi' dari folder html ke folder tujuan Nginx
FROM nginx:alpine

# 1. Copy folder-folder pendukung (css, js, images) ke root nginx
COPY ./css /usr/share/nginx/html/css
COPY ./js /usr/share/nginx/html/js
COPY ./images /usr/share/nginx/html/images

# 2. Copy ISI dari folder html langsung ke root nginx (bukan foldernya)
# Perhatikan tanda "/." di akhir, itu artinya copy isinya saja
COPY ./html/. /usr/share/nginx/html/

EXPOSE 80