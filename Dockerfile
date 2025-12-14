FROM node:18-alpine

WORKDIR /app

COPY package.json ./
# COPY package-lock.json ./ 

# RUN npm install --production
# Since we have no dependencies yet, we can skip install for speed, 
# but usually you would uncomment the above.

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
