FROM node:lts-alpine

WORKDIR /usr/src/app

# ติดตั้ง pnpm
RUN npm install -g pnpm

# คัดลอกไฟล์จัดการ Dependencies ก่อนเพื่อประหยัดเวลาทำ Layer Cache
COPY package.json pnpm-lock.yaml ./

# ติดตั้ง dependencies ทั้งหมด (รวม devDependencies ที่ใช้ build)
RUN pnpm install --frozen-lockfile

# คัดลอกซอร์สโค้ดทั้งหมด
COPY . .

# แก้ไขสิทธิ์ไฟล์ (บางครั้ง Alpine มีปัญหาสิทธิ์การรัน)
RUN chmod -R 755 /usr/src/app

# รัน Build (เพิ่มคำสั่งข้าม Error ถ้าจำเป็นในขั้นตอนที่ 2)
RUN pnpm build

EXPOSE 3000

# แนะนำให้รันด้วย node โดยตรงถ้าเป็น API เพื่อประหยัด Memory
CMD ["pnpm", "start"]