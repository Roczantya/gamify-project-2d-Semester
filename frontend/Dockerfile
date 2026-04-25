FROM nginx:alpine

# Copy 'isi' dari folder html ke folder tujuan Nginx
FROM nginx:alpine

# 1. Copy folder-folder pendukung (css, js, images) ke root nginx
COPY ./frontend/css /usr/share/nginx/html/css
COPY ./frontend/js /usr/share/nginx/html/js
COPY ./frontend/images /usr/share/nginx/html/images

# 2. Copy ISI dari folder html langsung ke root nginx (bukan foldernya)
# Perhatikan tanda "/." di akhir, itu artinya copy isinya saja
COPY ./frontend/html/. /usr/share/nginx/html/

EXPOSE 80