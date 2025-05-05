# Log técnico del proyecto

Este archivo documenta comandos clave, decisiones técnicas y observaciones importantes durante el desarrollo de la aplicación.

---

## 📅 2025-05-04

### ✅ Decisiones de la jornada
- Se eligió TypeScript como lenguaje base.
- Se usará ESM (`"type": "module"`) para mantener consistencia con JS moderno.
- Se mantendrá la base de datos PostgreSQL ya creada en Heroku.

### 🛠️ Configuraciones en la jornada
- `tsconfig.json`:
   - Se realizaron los siguientes cambios de sus valores por defecto:

      - `"target": "es2016" -> "ES2020"`  
        ‣ Establece que el código compilado use características modernas de JavaScript  
        ‣ Compatible con Node.js >= 14 y necesarias para usar sintaxis como `??` o `?.`.

      - `"module": "commonjs" -> "ES2022"`  
        ‣ Cambia el sistema de módulos a ECMAScript Modules (`import`/`export`)  
        ‣ Requerido para que Node entienda `import` directamente con `"type": "module"`.

      - `"moduleResolution": "node10" -> "node"`  
        ‣ Actualiza el algoritmo de resolución de módulos al más moderno compatible con `"module": "ES2022"`  
        ‣ Mejora compatibilidad con librerías actuales que usan `exports` en `package.json`.

      - `"outDir": "./" -> "./dist"`  
        ‣ Separa los archivos compilados `.js` en una carpeta dedicada (`dist`)  
        ‣ Evita mezclar código fuente y salida compilada.

      - `"rootDir": "./" -> "./src"`  
        ‣ Declara explícitamente que el código fuente vive en `src/`  
        ‣ Mejora organización del proyecto al separar entrada (`src`) y salida (`dist`).

   - Se validaron los siguientes parámetros:

      - `"esModuleInterop": true`  
        ‣ Permite usar `import x from 'modulo'` incluso si `modulo` usa `module.exports = ...`  
        ‣ Evita errores al importar librerías escritas con CommonJS.

      - `"forceConsistentCasingInFileNames": true`  
        ‣ Previene errores sutiles por diferencias de mayúsculas/minúsculas entre plataformas (ej. `utils.ts` vs `Utils.ts`).

      - `"strict": true`  
        ‣ Activa todas las comprobaciones estrictas de tipos de TypeScript  
        ‣ Fomenta código más seguro y preciso.

      - `"skipLibCheck": true`  
        ‣ Omite validación de archivos `.d.ts` en `node_modules`  
        ‣ Acelera compilación y evita errores por definiciones externas incorrectas o incompletas.
- `Procfile`:
   - Se creó en la raíz del proyecto con el siguiente contenido:
     ```procfile
     web: node dist/index.js
     ```
   - Propósito:
      ‣ `web:` indica que este proceso acepta tráfico HTTP (Heroku lo enrutará automáticamente).  
      ‣ `node dist/index.js` especifica que debe ejecutarse el archivo JavaScript generado por el compilador TypeScript (`npm run build`), que se encuentra en la carpeta `dist`.  
      ‣ Es esencial para que Heroku sepa cómo iniciar la aplicación en producción, ya que no compila automáticamente TypeScript ni infiere el comando a ejecutar en apps personalizadas.
- `package.json`:
   - Se agregaron los siguientes scripts personalizados para el ciclo de desarrollo, compilación y despliegue:

     ```json
     "scripts": {
       "dev": "ts-node-dev src/index.ts",
       "build": "tsc",
       "start": "node dist/index.js"
     }
     ```

   - Propósito de cada script:

     - `"dev": "ts-node-dev src/index.ts"`  
       ‣ Ejecuta la aplicación directamente desde el código fuente TypeScript (`src/index.ts`)  
       ‣ Usa `ts-node-dev` para recarga automática en desarrollo (hot reload)  
       ‣ Ideal para desarrollo local, no requiere compilación previa.

     - `"build": "tsc"`  
       ‣ Ejecuta el compilador TypeScript (`tsc`) usando `tsconfig.json`  
       ‣ Transpila todo el contenido de `src/` a JavaScript en la carpeta `dist/`  
       ‣ Este paso debe ejecutarse antes de desplegar a Heroku.

     - `"start": "node dist/index.js"`  
       ‣ Comando de arranque de la aplicación ya compilada, usado por Heroku en producción  
       ‣ Debe apuntar al archivo principal JavaScript generado en `dist/`.

   - Comentarios adicionales:
     ‣ Estos scripts permiten un flujo de trabajo claro:  
     &nbsp;&nbsp;&nbsp;&nbsp;`npm run dev` para desarrollo local,  
     &nbsp;&nbsp;&nbsp;&nbsp;`npm run build` para preparación de despliegue,  
     &nbsp;&nbsp;&nbsp;&nbsp;`npm start` es usado automáticamente por Heroku al hacer deploy.
- `.gitignore`:
   - Se configuró el archivo `.gitignore` en la raíz del proyecto para excluir archivos y carpetas que no deben ser incluidos en el control de versiones (`git`).

     Contenido inicial:

     ```
     node_modules
     dist
     .env
     ```

   - Propósito de cada línea:

     - `node_modules`  
       ‣ Carpeta donde se instalan las dependencias del proyecto mediante `npm install`.  
       ‣ No debe subirse al repositorio ya que puede regenerarse desde `package.json` y `package-lock.json`.

     - `dist`  
       ‣ Carpeta que contiene los archivos JavaScript generados automáticamente por TypeScript (`tsc`).  
       ‣ Al ser archivos derivados, no deben ser versionados; se recrean con `npm run build`.

     - `.env`  
       ‣ Archivo utilizado para definir variables de entorno sensibles (como `DATABASE_URL`).  
       ‣ No debe subirse al repositorio por seguridad, ya que podría contener credenciales o información confidencial.

   - Comentario adicional:
     ‣ Esta configuración ayuda a mantener el repositorio limpio, seguro y portátil entre entornos de desarrollo y producción.


### 🛠️ Comandos ejecutados en la jornada
```bash
mkdir palms-web
cd palms-web
npm init -y
npm install express pg
npm install -D typescript ts-node-dev @types/node @types/express @types/pg
npx tsc --init
npm run build
