# Log técnico del proyecto

Este archivo documenta comandos clave, decisiones técnicas y observaciones importantes durante el desarrollo de la aplicación.

---

## 📅 2025-05-04

### ✅ Decisiones de la jornada
- [001] Se eligió TypeScript como lenguaje base.
- [002] Se usará ESM (`"type": "module"`) para mantener consistencia con JS moderno.
- [003] Se mantendrá la base de datos PostgreSQL ya creada en Heroku.
- [012] Se da forma un contenido basico inicial de index.ts para lanzar un servidor http usando express y ante un llamado get a la raiz retorne el valor de la hora actual segun el motor de base de datos.
- [015] En el sitio web de github se creo el repositorio palms-web (vacio) para la aplicacion y se genero un token de autenticacion con acceso de lectura y escritura, especificamente al repositorio, para ser usado como password al momento de sincronizar el proyecto desde el pc hacia github o al reves

### 🛠️ Configuraciones en la jornada
- [011] `tsconfig.json`:
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
- [014] `Procfile`:
   - Se creó en la raíz del proyecto con el siguiente contenido:
     ```procfile
     web: node dist/index.js
     ```
   - Propósito:
      ‣ `web:` indica que este proceso acepta tráfico HTTP (Heroku lo enrutará automáticamente).  
      ‣ `node dist/index.js` especifica que debe ejecutarse el archivo JavaScript generado por el compilador TypeScript (`npm run build`), que se encuentra en la carpeta `dist`.  
      ‣ Es esencial para que Heroku sepa cómo iniciar la aplicación en producción, ya que no compila automáticamente TypeScript ni infiere el comando a ejecutar en apps personalizadas.
- [007] `package.json`:
   - Se agregaron los siguientes scripts personalizados para el ciclo de desarrollo, compilación y despliegue:

     ```json
     ...
     "type": "module",
     ...
     "scripts": {
       "dev": "ts-node-dev src/index.ts",
       "build": "tsc",
       "start": "node dist/index.js"
     }
     ```
   - proposito de "type": "module":
     - `"type": "module"` 
       ‣ Indica a node que los archivos *.js son ES Modules (ESM), lo que habilita el uso directo de import … from './archivo.js' en cualquier *.js, sin embargo require ya no funcionara en *.js; si se requiere CommonJS es necesario usar *.cjs.
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
- [016] `.gitignore`:
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
- [023] En la configuracion de deploy (pestaña deploy) en la app en heroku se configuro el Deploy method con la opcion github apuntando al repositorio helidrag13/palms-web en github, adicionalmente se activo la opcion inplantacion automatica desde el branch main "Automatic deploys from main", esta opcion hace que al subir desde el pc un nuevo commit al branch main heroku lo detecta, lo compila y de compilar exitosamente la ejecuta  


### 🛠️ Comandos ejecutados en la jornada
```bash
[004] mkdir palms-web           # crea directorio de la aplicacion
[005] cd palms-web
[006] npm init -y               # genera package.json inicial de configuracion de node.js para el proyecto
[008] npm install express pg    # instalacion de dependencias runtime en el proyecto
[009] npm install -D typescript ts-node-dev @types/node @types/express @types/pg # dependencias dev + tipados
[010] npx tsc --init            # genera tsconfig.json inicial de configuracion de typescript para el proyecto
[013] npm run build             # genera el codigo final de la aplicacion en ./dist al ejecutar el script indicado por el atributo build dentro de scripts en package.json, que resulta ser simplemente el comando tsc, sin embargo ya que la invocacion del comando la hara npm este precarga las definiciones de contexto propias de la aplicacion, por ejemplo antepone ./node_modules/.bin al PATH del proceso; así el comando tsc se resuelve a la versión local instalada en el proyecto, y no a la global del sistema, de existir en package.json definiciones para scripts asociados (hooks) en "prebuild" o "postbuild" los ejecutara en su momento adecuado, todo construyendo las lineas de comando adecuadas segun el sistema operativo, Entonces aunque el script "build": "tsc" solo declara el comando principal; la “magia” (hooks, PATH local, variables) viene de NPM al procesar cualquier npm run <script>. Por eso en entornos CI/Heroku se prefiere npm run build: pues garantiza la versión correcta de TypeScript y permite orquestar pasos adicionales sin cambiar un solo comando en el pipeline.
[017] git init                              # inicia repositorio Git local
[018] git checkout -b main                  # crea rama principal
[019] git remote add origin https://github.com/helidrag13/palms-web.git     # vincula el local con el de GitHub
[020] git add .                             # indexa todo (sin dist/, está ignorado)
[021] git commit -m "Primer commit"         # guarda estado inicial
[022] git push -u origin main               # sube a GitHub (autenticado con PAT)
```

## 📅 2025-05-07

### ✅ Decisiones de la jornada
- [001] Se eligió implementar la autenticacion utilizando el servicio de la plataforma Auth0, en el siitio web de auth0 se ha creado una configuracion de gestion de autenticacion para una aplicacoin (aunque alli dice crear aplicacion), eso genera valores de la siguientes variables de entorno especificos para la aplicacion: ISSUER_BASE_URL, CLIENT_ID, y CLIENT_SECRET

### 🛠️ Configuraciones en la jornada
- [002] En el dashboard de Auth0 para la aplicacion se establecieron los valores de los campos:
  + URLs a las que se redirecionara al usuario despues del login exitoso, Allowed Callback URLs: http://localhost:3000/callback, https://palms-aacab9433060.herokuapp.com/callback
  + URLs a las que se redirecionara al usuario despues del cierre de sesion, Allowed Logout URLs: http://localhost:3000/, https://palms-aacab9433060.herokuapp.com/
  + URLs de los origenes validos, Allowed Web Origins: http://localhost:3000, https://palms-aacab9433060.herokuapp.com

### 🛠️ Comandos ejecutados en la jornada
```bash
[003] npm install express-openid-connect dotenv #instala el middleware del servicio de https://auth0.com/
[004] npm install winston #instala la libreria winston de registro de eventos (logging)

```
